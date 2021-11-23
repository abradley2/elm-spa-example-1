module Document exposing (..)

import Api exposing (Cred, storageDecoder)
import Browser
import Json.Decode as Decode exposing (Decoder, Value)
import Result.Extra as ResultX
import Url exposing (Url)
import Viewer exposing (Viewer)
import Route exposing (Route)


document :
    { init : Maybe Route -> Result initError (Maybe Viewer -> ( model, Cmd msg ))
    , subscriptions : model -> Sub msg
    , update : msg -> model -> ( model, Cmd msg )
    , view : model -> Browser.Document msg
    , errorView : initError -> Browser.Document msg
    }
    -> Program Value (Result initError model) msg
document config =
    let
        init flags =
            let
                maybeViewer =
                    Decode.decodeValue Decode.string flags
                        |> Result.andThen (Decode.decodeString (storageDecoder Viewer.decoder))
                        |> Result.toMaybe

                url =
                    Decode.decodeValue (Decode.at [ "url" ] Decode.string) flags
                        |> Result.toMaybe
                        |> Maybe.andThen Url.fromString
                        |> Maybe.andThen Route.fromUrl
            in
            config.init url
                |> Result.map (\pageInit -> pageInit maybeViewer)
                |> Result.map (Tuple.mapFirst Ok)
                |> ResultX.extract (\initErr -> ( Err initErr, Cmd.none ))
    in
    Browser.document
        { init = init
        , subscriptions =
            Result.map config.subscriptions >> Result.withDefault Sub.none
        , update =
            \msg ->
                Result.map (config.update msg)
                    >> Result.map (Tuple.mapFirst Ok)
                    >> ResultX.extract (\err -> ( Err err, Cmd.none ))
        , view = Result.map config.view >> ResultX.extract config.errorView
        }
