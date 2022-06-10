module Asset exposing (Asset, introBg)


type alias Asset =
    { data : String
    , width : Float
    , height : Float
    }


introBg : Asset
introBg =
    { data = "data:image/png;base64,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"
    , width = 480
    , height = 464
    }