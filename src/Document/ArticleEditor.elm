module Document.ArticleEditor exposing (..)

import Article.Slug exposing (Slug)
import Document exposing (document)
import Json.Decode exposing (Value)
import Page exposing (Page(..), view)
import Page.Article.Editor as ArticleEditor
import Page.Blank as Blank
import Route exposing (Route(..))
import Session exposing (NavKey(..))


type Model
    = Model (Maybe Slug) ArticleEditor.Model


main : Program Value (Result () Model) ArticleEditor.Msg
main =
    document
        { errorView = always <| view Nothing Other Blank.view
        , init =
            Maybe.andThen Route.fromUrl
                >> (\route ->
                        case route of
                            Just (Route.EditArticle slug) ->
                                Ok
                                    (\maybeViewer ->
                                        ArticleEditor.initEdit (Session.fromViewer MPA maybeViewer) slug
                                            |> Tuple.mapFirst (Model (Just slug))
                                    )

                            Just Route.NewArticle ->
                                Ok
                                    (\maybeViewer ->
                                        ArticleEditor.initNew (Session.fromViewer MPA maybeViewer)
                                            |> Tuple.mapFirst (Model Nothing)
                                    )

                            _ ->
                                Err ()
                   )
        , subscriptions = \(Model _ model) -> ArticleEditor.subscriptions model
        , update =
            \msg (Model maybeSlug model) ->
                ArticleEditor.update msg model
                    |> Tuple.mapFirst (Model maybeSlug)
        , view =
            \(Model maybeSlug model) ->
                view
                    (ArticleEditor.toSession model |> Session.viewer)
                    (maybeSlug |> Maybe.map (always Other) |> Maybe.withDefault Page.NewArticle)
                    (ArticleEditor.view model)
        }
