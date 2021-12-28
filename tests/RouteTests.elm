module RouteTests exposing (..)

import Expect exposing (Expectation)
import Route exposing (..)
import Test exposing (..)
import Url exposing (fromString)


routeTests =
    describe "Route Tests"
        [ test "An unknown URL leads to the NotFound page" <|
            \_ -> expectRouteFromPath "unknown" Route.NotFound
        , test "A URL without path leads to the Accounts page" <|
            \_ -> expectRouteFromPath "" Route.Accounts
        , test "A URL with a path of accounts leads to the Accounts page" <|
            \_ -> expectRouteFromPath "accounts" Route.Accounts
        ]


expectRouteFromPath : String -> Route -> Expectation
expectRouteFromPath path route =
    let
        maybeUrl =
            fromString ("https://localhost/#" ++ path)
    in
    case maybeUrl of
        Just url ->
            parseUrl url |> Expect.equal route

        Nothing ->
            Expect.false "Error creating a URL from the given string" True
