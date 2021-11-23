module Document.Home exposing (main)

import Document exposing (document)
import Json.Decode exposing (Value)
import Page exposing (Page(..), view)
import Page.Home as Home
import Page.Blank as Blank
import Platform exposing (Program)
import Session exposing (NavKey(..))


main : Program Value (Result Never Home.Model) Home.Msg
main =
    document
        { init = always <| Ok <| Session.fromViewer MPA >> Home.init
        , subscriptions = Home.subscriptions
        , update = Home.update
        , view =
            \model ->
                view
                    (Home.toSession model |> Session.viewer)
                    Home
                    (Home.view model)
        , errorView = always (view Nothing Other Blank.view)
        }
