module Main exposing (main)

import Browser
import Html exposing (Html)
import Scene exposing (Scene)
import WebGL.Shape2d as S
import WebGL.Shape2d.TexturedShape as TS


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = S.view
        , update = update
        , subscriptions = subscriptions
        }


type alias Flags =
    ()


type alias OurModel =
    { scene : Scene }


type alias Model =
    S.Model S.Screen OurModel


type Msg
    = Shape2dMsg (Model -> Model)
    | SetShape2dScreen S.Screen


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        ( model, cmd ) =
            S.update
                viewShapes
                identity
                { textures = S.textureManager
                , entities = []
                , screen = S.toScreen 300 400
                , scene = Scene.Intro
                }
    in
    ( model
    , Cmd.batch
        [ Cmd.map Shape2dMsg cmd
        , Cmd.map Shape2dMsg S.requestScreen
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map SetShape2dScreen S.resize


updateShape2d : (Model -> Model) -> Model -> ( Model, Cmd Msg )
updateShape2d fn model =
    S.update viewShapes fn model
        |> Tuple.mapSecond (Cmd.map Shape2dMsg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Shape2dMsg subMsg ->
            model
                |> updateShape2d subMsg

        SetShape2dScreen screen ->
            { model | screen = screen }
                |> updateShape2d identity


viewShapes : Model -> List (TS.TexturedShape String)
viewShapes model =
    Scene.view model.scene model.screen
