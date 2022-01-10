module Formula exposing (..)

import Attribute exposing (Attribute(..), Model, getAttrVal)


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
