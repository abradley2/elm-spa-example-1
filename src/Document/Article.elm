module Document.Article exposing (..)

import Article.Slug exposing (Slug)
import Document exposing (document)
import Json.Decode exposing (Value)
import Page exposing (Page(..), view)
import Page.Article as Article
import Page.NotFound as NotFound
import Platform exposing (Program)
import Route exposing (Route(..))
import Session exposing (NavKey(..))


main : Program Value (Result () Article.Model) Article.Msg
main =
    document
        { init =
            Maybe.andThen Route.fromUrl
                >> (\route ->
                        case route of
                            Just (Article slug) ->
                                Ok <|
                                    \maybeViewer ->
                                        Article.init (Session.fromViewer MPA maybeViewer) slug

                            _ ->
                                Err ()
                   )
        , subscriptions = Article.subscriptions
        , update = Article.update
        , view =
            \model ->
                view
                    (Article.toSession model |> Session.viewer)
                    Other
                    (Article.view model)
        , errorView = always (view Nothing Other NotFound.view)
        }
