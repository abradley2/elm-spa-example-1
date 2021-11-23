module Document.Register exposing (..)

import Document exposing (document)
import Json.Decode exposing (Value)
import Page exposing (Page(..), view)
import Page.NotFound as NotFound
import Page.Register as Register
import Session exposing (NavKey(..))
import Viewer


main : Program Value (Result Never Register.Model) Register.Msg
main =
    document
        Viewer.decoder
        { init = always <| Ok <| \maybeViewer -> Register.init (Session.fromViewer MPA maybeViewer)
        , errorView =
            always <|
                view
                    Nothing
                    Other
                    NotFound.view
        , subscriptions = Register.subscriptions
        , update = Register.update
        , view =
            \model ->
                view
                    (Register.toSession model |> Session.viewer)
                    Register
                    (Register.view model)
        }
