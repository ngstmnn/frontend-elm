module Main exposing (main)

import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Html exposing (Html, div, text)
import Html.Attributes exposing (href)
import Pages.Accounts as AccountsPage
import Pages.NotFound as NotFoundPage
import Route exposing (Route(..), parseUrl)
import Url exposing (Url)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    , navState : Navbar.State
    }


type Msg
    = LinkClicked UrlRequest
    | UrlChanged Url
    | NavMsg Navbar.State


type Page
    = NotFoundPage
    | AccountsPage


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navState NavMsg


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navKey =
    let
        ( navState, navCmd ) =
            Navbar.initialState NavMsg

        model =
            { route = parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            , navState = navState
            }
    in
    initCurrentPage ( model, Cmd.none )


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
        ( currentPage, mappedPageCmds ) =
            case model.route of
                NotFound ->
                    ( NotFoundPage, Cmd.none )

                Accounts ->
                    ( AccountsPage, Cmd.none )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )


view : Model -> Document Msg
view model =
    { title = "eCCspensemanager Elm"
    , body =
        [ div []
            [ menu model
            , currentView model
            ]
        ]
    }


menu : Model -> Html Msg
menu model =
    Navbar.config NavMsg
        |> Navbar.withAnimation
        |> Navbar.container
        |> Navbar.brand [ href "#" ] [ text "eCCspensemanager" ]
        |> Navbar.items
            [ Navbar.itemLink [ href "#accounts" ] [ text "Accounts" ]
            ]
        |> Navbar.view model.navState


currentView : Model -> Html Msg
currentView model =
    Grid.container [] <|
        case model.page of
            NotFoundPage ->
                NotFoundPage.view

            AccountsPage ->
                AccountsPage.view


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        ( UrlChanged url, _ ) ->
            let
                newRoute =
                    Route.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> initCurrentPage

        ( NavMsg state, _ ) ->
            ( { model | navState = state }, Cmd.none )
