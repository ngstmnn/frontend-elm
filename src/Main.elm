module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Html exposing (Html, div, text)
import Material.IconButton as IconButton
import Material.TopAppBar as TopAppBar
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
    }


type Msg
    = LinkClicked UrlRequest
    | UrlChanged Url


type Page
    = NotFoundPage
    | AccountsPage


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navKey =
    let
        model =
            { route = parseUrl url
            , page = NotFoundPage
            , navKey = navKey
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
    { title = "Expensemanager Elm"
    , body =
        [ TopAppBar.regular TopAppBar.config
                  [ TopAppBar.row []
                      [ TopAppBar.section [ TopAppBar.alignStart ]
                          [ IconButton.iconButton
                              (IconButton.config
                                  |> IconButton.setAttributes
                                      [ TopAppBar.navigationIcon ]
                              )
                              (IconButton.icon "menu")
                          , Html.span [ TopAppBar.title ]
                              [ text "Title" ]
                          ]
                      ]
                  ]
            ]

    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            let
                newRoute =
                    Route.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> initCurrentPage
