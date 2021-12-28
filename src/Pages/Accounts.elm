module Pages.Accounts exposing (view)

import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Html exposing (Html, text)


view : List (Html msg)
view =
    [ Card.config [ Card.outlineSecondary ]
        |> Card.headerH1 [] [ text "Accounts" ]
        |> Card.block []
            [ Block.text [] [ text "This Page has no content yet." ]
            ]
        |> Card.view
    ]
