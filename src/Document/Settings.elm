module Document.Settings exposing (..)

import Document exposing (document)
import Json.Decode exposing (Value)
import Page exposing (Page(..), view)
import Page.Blank as Blank
import Page.Settings as Settings
import Session exposing (NavKey(..))
import Viewer


main : Program Value (Result Never Settings.Model) Settings.Msg
main =
    document
        Viewer.decoder
        { init = always <| Ok <| Session.fromViewer MPA >> Settings.init
        , errorView = always <| view Nothing Other Blank.view
        , subscriptions = Settings.subscriptions
        , update = Settings.update
        , view =
            \model ->
                view
                    (Settings.toSession model |> Session.viewer)
                    Settings
                    (Settings.view model)
        }
