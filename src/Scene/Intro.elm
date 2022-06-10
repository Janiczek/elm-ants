module Scene.Intro exposing (view)

import Asset
import Text
import Util
import WebGL.Shape2d as S
import WebGL.Shape2d.TexturedShape as TS


view : S.Screen -> List (TS.TexturedShape String)
view screen =
    [ Util.image Asset.introBg
    , Util.rect Util.pink 100 50
        |> S.move 0 0
    , Util.rect Util.black 10 20
        |> S.move -10 0
    , Util.rect Util.black 10 20
        |> S.move 10 0
    , Text.view Text.falloutFont Util.white "Hello there"
        |> S.scale 2 2
    , Text.view Text.falloutFont Util.pink "Hello there yayyyy"
        |> S.move screen.left (screen.top - 50)
    ]
