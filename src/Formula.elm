module Formula exposing (..)

import Attribute exposing (Attribute(..), Model, getAttrVal)
import Html exposing (Html, i, span)
import Html.Attributes exposing (class)


type alias Formula =
    Model -> Int


baseFormula : List ( Attribute, Int ) -> Formula
baseFormula attrs model =
    let
        ddm =
            [ ( Determination, 2 ), ( Discipline, 2 ), ( Motivating, 2 ) ]

        allAttrs =
            attrs ++ ddm
    in
    List.foldl (\( attr, weight ) acc -> getAttrVal attr model * weight + acc)
        0
        allAttrs


fitnessFormula : Formula
fitnessFormula =
    baseFormula [ ( Fitness, 9 ) ]


defendingTacticalFormula : Formula
defendingTacticalFormula =
    baseFormula [ ( Defending, 6 ), ( Tactical, 3 ) ]


defendingTechnicalFormula : Formula
defendingTechnicalFormula =
    baseFormula [ ( Defending, 6 ), ( Technical, 3 ) ]


attackingTacticalFormula : Formula
attackingTacticalFormula =
    baseFormula [ ( Attacking, 6 ), ( Tactical, 3 ) ]


attackingTechnicalFormula : Formula
attackingTechnicalFormula =
    baseFormula [ ( Attacking, 6 ), ( Technical, 3 ) ]


possessionTacticalFormula : Formula
possessionTacticalFormula =
    baseFormula [ ( Tactical, 6 ), ( Mental, 3 ) ]


possessionTechnicalFormula : Formula
possessionTechnicalFormula =
    baseFormula [ ( Technical, 6 ), ( Mental, 3 ) ]


gkShotStoppingFormula : Formula
gkShotStoppingFormula =
    baseFormula [ ( ShotStopping, 9 ) ]


gkHandlingFormula : Formula
gkHandlingFormula =
    baseFormula [ ( Handling, 6 ), ( Distribution, 3 ) ]


makeStars : Float -> List (Html msg)
makeStars x =
    let
        full =
            floor x

        empty =
            5 - round x

        half =
            5 - full - empty
    in
    List.repeat full fasFullFilledStar
        ++ List.repeat half fasHalfStar
        ++ List.repeat empty fasFullEmptyStar


fasFullFilledStar : Html msg
fasFullFilledStar =
    span [ class "text-lg text-yellow-500" ] [ i [ class "fas fa-star" ] [] ]


fasFullEmptyStar : Html msg
fasFullEmptyStar =
    span [ class "text-lg text-slate-200" ] [ i [ class "fas fa-star" ] [] ]


fasHalfStar : Html msg
fasHalfStar =
    span [ class "text-lg text-yellow-500" ] [ i [ class "fas fa-star-half half-star relative z-0" ] [] ]
