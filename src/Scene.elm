module Scene exposing (Scene(..), view)

import Asset
import Scene.Intro
import Util
import WebGL.Shape2d as S
import WebGL.Shape2d.TexturedShape as TS


type Scene
    = Intro


view : Scene -> S.Screen -> List (TS.TexturedShape String)
view scene screen =
    case scene of
        Intro ->
            Scene.Intro.view screen
