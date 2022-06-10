module Text exposing (PngFont, falloutFont, view)

import Dict exposing (Dict)
import Math.Vector2 exposing (Vec2, vec2)
import Math.Vector3 exposing (Vec3)
import Math.Vector4 exposing (vec4)
import Util
import WebGL.Shape2d as S
import WebGL.Shape2d.Render as SR
import WebGL.Shape2d.TexturedShape as TS
import WebGL.Shape2d.Util as SU
import WebGL.Texture


falloutFont : PngFont
falloutFont =
    PngFont
        "data:image/png;base64,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"
        (Dict.map (always addSize) <|
            Dict.fromList
                [ ( ' ', Sprite 94 97 33 42 )
                , ( '!', Sprite 130 132 33 42 )
                , ( '"', Sprite 249 254 11 20 )
                , ( '#', Sprite 60 67 0 9 )
                , ( '$', Sprite 184 190 22 31 )
                , ( '%', Sprite 204 211 0 9 )
                , ( '&', Sprite 78 85 0 9 )
                , ( '(', Sprite 71 75 33 42 )
                , ( ')', Sprite 65 69 33 42 )
                , ( '*', Sprite 105 112 0 9 )
                , ( '+', Sprite 192 198 22 31 )
                , ( ',', Sprite 89 92 33 42 )
                , ( '-', Sprite 200 206 22 31 )
                , ( '.', Sprite 114 116 33 42 )
                , ( '/', Sprite 141 148 0 9 )
                , ( '0', Sprite 216 222 22 31 )
                , ( '1', Sprite 59 63 33 42 )
                , ( '2', Sprite 153 159 11 20 )
                , ( '3', Sprite 161 167 11 20 )
                , ( '4', Sprite 169 175 11 20 )
                , ( '5', Sprite 177 183 11 20 )
                , ( '6', Sprite 185 191 11 20 )
                , ( '7', Sprite 193 199 11 20 )
                , ( '8', Sprite 201 207 11 20 )
                , ( '9', Sprite 209 215 11 20 )
                , ( ':', Sprite 142 144 33 42 )
                , ( ';', Sprite 104 107 33 42 )
                , ( '<', Sprite 24 29 33 42 )
                , ( '=', Sprite 217 223 11 20 )
                , ( '>', Sprite 31 36 33 42 )
                , ( '?', Sprite 225 231 11 20 )
                , ( '@', Sprite 45 52 11 20 )
                , ( 'A', Sprite 40 48 0 9 )
                , ( 'B', Sprite 63 70 11 20 )
                , ( 'C', Sprite 233 239 11 20 )
                , ( 'D', Sprite 81 88 11 20 )
                , ( 'E', Sprite 241 247 11 20 )
                , ( 'F', Sprite 0 6 22 31 )
                , ( 'G', Sprite 69 76 0 9 )
                , ( 'H', Sprite 114 121 0 9 )
                , ( 'I', Sprite 134 136 33 42 )
                , ( 'J', Sprite 132 139 0 9 )
                , ( 'K', Sprite 150 157 0 9 )
                , ( 'L', Sprite 208 214 22 31 )
                , ( 'M', Sprite 177 184 0 9 )
                , ( 'N', Sprite 186 193 0 9 )
                , ( 'O', Sprite 195 202 0 9 )
                , ( 'P', Sprite 99 106 11 20 )
                , ( 'Q', Sprite 213 220 0 9 )
                , ( 'R', Sprite 222 229 0 9 )
                , ( 'S', Sprite 231 238 0 9 )
                , ( 'T', Sprite 8 14 22 31 )
                , ( 'U', Sprite 36 43 11 20 )
                , ( 'V', Sprite 50 58 0 9 )
                , ( 'W', Sprite 90 97 11 20 )
                , ( 'X', Sprite 20 28 0 9 )
                , ( 'Y', Sprite 30 38 0 9 )
                , ( 'Z', Sprite 168 175 0 9 )
                , ( '[', Sprite 77 81 33 42 )
                , ( '\'', Sprite 126 128 33 42 )
                , ( '\\', Sprite 123 130 0 9 )
                , ( ']', Sprite 83 87 33 42 )
                , ( '^', Sprite 27 34 11 20 )
                , ( '_', Sprite 24 30 22 31 )
                , ( '`', Sprite 99 102 33 42 )
                , ( 'a', Sprite 32 38 22 31 )
                , ( 'b', Sprite 40 46 22 31 )
                , ( 'c', Sprite 249 255 0 9 )
                , ( 'd', Sprite 48 54 22 31 )
                , ( 'e', Sprite 56 62 22 31 )
                , ( 'f', Sprite 38 43 33 42 )
                , ( 'g', Sprite 64 70 22 31 )
                , ( 'h', Sprite 72 78 22 31 )
                , ( 'i', Sprite 138 140 33 42 )
                , ( 'j', Sprite 52 57 33 42 )
                , ( 'k', Sprite 80 86 22 31 )
                , ( 'l', Sprite 146 148 33 42 )
                , ( 'm', Sprite 9 16 11 20 )
                , ( 'n', Sprite 88 94 22 31 )
                , ( 'o', Sprite 96 102 22 31 )
                , ( 'p', Sprite 104 110 22 31 )
                , ( 'q', Sprite 112 118 22 31 )
                , ( 'r', Sprite 45 50 33 42 )
                , ( 's', Sprite 120 126 22 31 )
                , ( 't', Sprite 128 134 22 31 )
                , ( 'u', Sprite 136 142 22 31 )
                , ( 'v', Sprite 144 150 22 31 )
                , ( 'w', Sprite 0 7 11 20 )
                , ( 'x', Sprite 16 22 22 31 )
                , ( 'y', Sprite 152 158 22 31 )
                , ( 'z', Sprite 160 166 22 31 )
                , ( '{', Sprite 168 174 22 31 )
                , ( '}', Sprite 176 182 22 31 )
                , ( '©', Sprite 0 8 0 9 )
                , ( '®', Sprite 10 18 0 9 )
                ]
        )


type alias PngFont =
    { data : String
    , glyphs : Dict Char SpriteWithSize
    }


type alias Sprite =
    { xmin : Float
    , xmax : Float
    , ymin : Float
    , ymax : Float
    }


type alias SpriteWithSize =
    { xmin : Float
    , xmax : Float
    , ymin : Float
    , ymax : Float
    , width : Float
    , height : Float
    }


addSize : Sprite -> SpriteWithSize
addSize sprite =
    { xmin = sprite.xmin
    , xmax = sprite.xmax
    , ymin = sprite.ymin
    , ymax = sprite.ymax
    , width = abs (sprite.xmax - sprite.xmin) + 1
    , height = abs (sprite.ymax - sprite.ymin) + 1
    }


{-| Adapted from

    * Playground.words
    * Playground.Extra.sprite
    * WebGL.Shape2d.Util.tileFont

Allows for non-monospace, arbitrary-PNG character glyphs.

-}
view : PngFont -> Vec3 -> String -> TS.TexturedShape String
view font color string =
    let
        totalWidth : Float
        totalWidth =
            string
                |> String.toList
                |> List.filterMap (\c -> Dict.get c font.glyphs |> Maybe.map .width)
                |> List.sum
    in
    font.data
        |> TS.textured
            (\texture ->
                let
                    render : SpriteWithSize -> TS.TexturedShape String
                    render glyph =
                        let
                            ( tW_, tH_ ) =
                                WebGL.Texture.size texture

                            tW =
                                toFloat tW_

                            tH =
                                toFloat tH_

                            uv =
                                vec4
                                    (glyph.xmin / tW)
                                    (1 - glyph.ymin / tH - (glyph.height / tH))
                                    (glyph.width / tW)
                                    (glyph.height / tH)
                        in
                        Util.coloredSprite texture (vec2 tW tH) color uv
                            |> TS.shape glyph.width glyph.height
                in
                string
                    |> String.toList
                    |> List.foldl
                        (\char ( acc, dx ) ->
                            let
                                glyph =
                                    Dict.get char font.glyphs
                                        |> Maybe.withDefault (SpriteWithSize 0 0 0 0 1 1)
                            in
                            ( (render glyph
                                |> S.move (dx + 0.5 * glyph.width) 0
                              )
                                :: acc
                            , dx + glyph.width
                            )
                        )
                        ( [], 0 )
                    |> Tuple.first
                    |> TS.group
            )
        |> S.move (totalWidth * -0.5) 0
        -- This has reasons. This law doesn't hold: `group [shape] == shape`
        |> List.singleton
        |> TS.group
