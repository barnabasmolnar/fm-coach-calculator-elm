module Attribute exposing (..)

import AllDict exposing (Dict, get)


type alias Model =
    Dict Attribute Int


type Attribute
    = Determination
    | Discipline
    | Motivating
    | Fitness
    | Attacking
    | Defending
    | Tactical
    | Technical
    | Mental
    | Distribution
    | Handling
    | ShotStopping


getAttrVal : Attribute -> Model -> Int
getAttrVal attr model =
    get attr model |> Maybe.withDefault 1


getAttrName : Attribute -> String
getAttrName attr =
    case attr of
        Determination ->
            "Determination"

        Discipline ->
            "Level of Discipline"

        Motivating ->
            "Motivating"

        Fitness ->
            "Fitness"

        Attacking ->
            "Attacking"

        Defending ->
            "Defending"

        Tactical ->
            "Tactical"

        Technical ->
            "Technical"

        Mental ->
            "Mental"

        Distribution ->
            "Distribution"

        Handling ->
            "Handling"

        ShotStopping ->
            "Shot Stopping"


mental : List Attribute
mental =
    [ Determination
    , Discipline
    , Motivating
    ]


general : List Attribute
general =
    [ Fitness
    , Attacking
    , Defending
    , Tactical
    , Technical
    , Mental
    ]


gk : List Attribute
gk =
    [ Distribution
    , Handling
    , ShotStopping
    ]
