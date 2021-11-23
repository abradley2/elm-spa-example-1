module Document.Profile exposing (main)

import Document exposing (document)
import Json.Decode exposing (Value)
import Page exposing (Page(..), view)
import Page.NotFound as NotFound
import Page.Profile as Profile
import Platform exposing (Program)
import Route exposing (Route(..))
import Session exposing (NavKey(..))
import Username exposing (Username)


type Model
    = Model Username Profile.Model


main : Program Value (Result () Model) Profile.Msg
main =
    document
        { init =
            \route ->
                case route of
                    Just (Route.Profile username) ->
                        Ok <|
                            \maybeViewer ->
                                Profile.init (Session.fromViewer MPA maybeViewer) username
                                    |> Tuple.mapFirst (Model username)

                    _ ->
                        Err ()
        , subscriptions = \(Model _ model) -> Profile.subscriptions model
        , update = \msg (Model username model) -> Profile.update msg model |> Tuple.mapFirst (Model username)
        , view =
            \(Model username model) ->
                view
                    (Profile.toSession model |> Session.viewer)
                    (Page.Profile username)
                    (Profile.view model)
        , errorView = always (view Nothing Other NotFound.view)
        }
