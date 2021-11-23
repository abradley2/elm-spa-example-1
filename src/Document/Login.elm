module Document.Login exposing (..)

import Document exposing (document)
import Json.Decode exposing (Value)
import Page exposing (Page(..), view)
import Page.Blank as Blank
import Page.Login as Login
import Session exposing (NavKey(..))
import Viewer


main : Program Value (Result Never Login.Model) Login.Msg
main =
    document
        Viewer.decoder
        { errorView = always <| view Nothing Other Blank.view
        , init = always <| Ok <| Session.fromViewer MPA >> Login.init
        , subscriptions = Login.subscriptions
        , update = Login.update
        , view =
            \model ->
                view
                    (Login.toSession model |> Session.viewer)
                    Login
                    (Login.view model)
        }
