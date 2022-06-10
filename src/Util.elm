module Util exposing
    ( black
    , coloredSprite
    , image
    , pink
    , rect
    , white
    )

import Asset exposing (Asset)
import Math.Vector2 exposing (Vec2, vec2)
import Math.Vector3 exposing (Vec3)
import Math.Vector4 exposing (Vec4)
import WebGL exposing (Shader)
import WebGL.Shape2d as S
import WebGL.Shape2d.Render as SR
import WebGL.Shape2d.Shader as SS
import WebGL.Shape2d.TexturedShape as TS
import WebGL.Texture exposing (Texture)


pink : Vec3
pink =
    S.rgb 200 90 120


black : Vec3
black =
    S.rgb 0 0 0


white : Vec3
white =
    S.rgb 255 255 255


rect : Vec3 -> Float -> Float -> TS.TexturedShape String
rect color w h =
    SR.rect color
        |> TS.shape w h


image : Asset -> TS.TexturedShape String
image asset =
    asset.data
        |> TS.textured
            (\t ->
                let
                    size : Vec2
                    size =
                        vec2 asset.width asset.height
                in
                SR.tile t size size 0
                    |> TS.shape asset.width asset.height
            )


coloredSprite : Texture -> Vec2 -> Vec3 -> Vec4 -> SR.Render
coloredSprite image_ imageSize color uv translate scaleRotateSkew z opacity =
    WebGL.entityWith
        SR.defaultEntitySettings
        SS.vertSprite
        fragColoredImage
        SS.mesh
        { uP = translate
        , uT = scaleRotateSkew
        , uImg = image_
        , uImgSize = imageSize
        , uUV = uv
        , color = setAlpha color opacity
        , z = z
        }


fragColoredImage : Shader a { b | color : Vec4, uImg : Texture, uImgSize : Vec2 } { uv : Vec2 }
fragColoredImage =
    [glsl|
        precision highp float;
        varying vec2 uv;
        uniform vec2 uImgSize;
        uniform sampler2D uImg;
        uniform vec4 color;
        void main () {
            vec2 pixel = (floor(uv * uImgSize) + 0.5) / uImgSize;
            gl_FragColor = texture2D(uImg, pixel) * color;
            if(gl_FragColor.a <= 0.025) discard;
        }
    |]


setAlpha : Vec3 -> Float -> Vec4
setAlpha color alpha =
    let
        { x, y, z } =
            Math.Vector3.toRecord color
    in
    Math.Vector4.vec4 x y z alpha
