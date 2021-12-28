module Route exposing (..)

import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = NotFound
    | Accounts


parseUrl : Url -> Route
parseUrl url =
    let
        decodedUrl =
            { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
    in
    case parse matchRoute decodedUrl of
        Just route ->
            route

        Nothing ->
            NotFound


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Accounts top
        , map Accounts (s "accounts")
        ]
