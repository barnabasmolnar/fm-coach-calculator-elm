module Main exposing (..)

import AllDict exposing (Dict, empty, get, insert)
import Browser
import Html exposing (Html, div, fieldset, form, i, input, label, legend, span, text)
import Html.Attributes exposing (class, for, id, type_, value)
import Html.Events exposing (onInput)


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


getAttrVal : Attribute -> Model -> Int
getAttrVal attr model =
    get attr model |> Maybe.withDefault 1



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    Dict Attribute Int


init : Model
init =
    empty



-- UPDATE


type Msg
    = Update Attribute Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        Update attr val ->
            insert attr (clamp 1 20 val) model



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "md:grid grid-cols-2 gap-x-4 space-y-16 md:space-y-0 h-full" ]
        [ div []
            [ form [ class "space-y-12 p-6 max-w-md mx-auto md:ml-auto md:mr-0" ]
                [ viewAttrInputGroup "Mental" mental model
                , viewAttrInputGroup "Coaching" general model
                , viewAttrInputGroup "Goalkeeping" gk model
                ]
            ]
        , div [ class "md:!-mt-8 md:min-w-[320px] bg-sky-900 text-slate-200 p-6 lg:px-12" ]
            [ div [ class "max-w-md mx-auto md:mr-auto md:ml-0 divide-y-4 divide-dashed divide-slate-200/25" ]
                [ viewRatingGroup "fa-shield-alt" "Defending" [ ( "Tactical", defendingTacticalFormula ), ( "Technical", defendingTechnicalFormula ) ] model
                , viewRatingGroup "fa-fighter-jet" "Attacking" [ ( "Tactical", attackingTacticalFormula ), ( "Technical", attackingTechnicalFormula ) ] model
                , viewRatingGroup "fa-futbol" "Possession" [ ( "Tactical", possessionTacticalFormula ), ( "Technical", possessionTechnicalFormula ) ] model
                , viewRatingGroup "fa-dumbbell" "Fitness" [ ( "Strength", fitnessFormula ), ( "Quickness", fitnessFormula ) ] model
                , viewRatingGroup "fa-mitten" "Goalkeeping" [ ( "Shot Stopping", gkShotStoppingFormula ), ( "Handling", gkHandlingFormula ) ] model
                ]
            ]
        ]


inputClasses : String
inputClasses =
    "block w-24 rounded-md border-gray-300 shadow-sm "
        ++ "focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"


viewAttrInput : Model -> Attribute -> Html Msg
viewAttrInput model attr =
    let
        attrName =
            getAttrName attr

        attrVal =
            getAttrVal attr model
    in
    div [ class "flex gap-x-4" ]
        [ label [ class "my-auto w-2/3", for attrName ] [ text attrName ]
        , input
            [ class inputClasses
            , id attrName
            , Html.Attributes.max "20"
            , Html.Attributes.min "1"
            , type_ "number"
            , value <| String.fromInt attrVal
            , onInput <| Update attr << Maybe.withDefault 1 << String.toInt
            ]
            []
        ]


viewAttrInputGroup : String -> List Attribute -> Model -> Html Msg
viewAttrInputGroup groupLabel attrs model =
    fieldset [ class "border rounded-md" ]
        [ legend [ class "font-bold text-sm uppercase m-4 px-2 tracking-wider" ]
            [ text groupLabel ]
        , div [ class "space-y-4 px-6 pb-4" ] <|
            List.map (viewAttrInput model) attrs
        ]


viewDefendingTactical : Model -> Html msg
viewDefendingTactical model =
    div []
        [ text <| String.fromInt <| defendingTacticalFormula model ]


baseFormula : List ( Attribute, Int ) -> Model -> Int
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


fitnessFormula : Model -> Int
fitnessFormula =
    baseFormula [ ( Fitness, 9 ) ]


defendingTacticalFormula : Model -> Int
defendingTacticalFormula =
    baseFormula [ ( Defending, 6 ), ( Tactical, 3 ) ]


defendingTechnicalFormula : Model -> Int
defendingTechnicalFormula =
    baseFormula [ ( Defending, 6 ), ( Technical, 3 ) ]


attackingTacticalFormula : Model -> Int
attackingTacticalFormula =
    baseFormula [ ( Attacking, 6 ), ( Tactical, 3 ) ]


attackingTechnicalFormula : Model -> Int
attackingTechnicalFormula =
    baseFormula [ ( Attacking, 6 ), ( Technical, 3 ) ]


possessionTacticalFormula : Model -> Int
possessionTacticalFormula =
    baseFormula [ ( Tactical, 6 ), ( Mental, 3 ) ]


possessionTechnicalFormula : Model -> Int
possessionTechnicalFormula =
    baseFormula [ ( Technical, 6 ), ( Mental, 3 ) ]


gkShotStoppingFormula : Model -> Int
gkShotStoppingFormula =
    baseFormula [ ( ShotStopping, 9 ) ]


gkHandlingFormula : Model -> Int
gkHandlingFormula =
    baseFormula [ ( Handling, 6 ), ( Distribution, 3 ) ]


fasFullFilledStar : Html msg
fasFullFilledStar =
    span [ class "text-lg text-yellow-500" ] [ i [ class "fas fa-star" ] [] ]


fasFullEmptyStar : Html msg
fasFullEmptyStar =
    span [ class "text-lg text-slate-200" ] [ i [ class "fas fa-star" ] [] ]


fasHalfStar : Html msg
fasHalfStar =
    span [ class "text-lg text-yellow-500" ] [ i [ class "fas fa-star-half half-star relative z-0" ] [] ]


viewStarRating : number -> List (Html msg)
viewStarRating x =
    if x >= 270 then
        List.repeat 5 fasFullFilledStar

    else if x >= 240 then
        List.repeat 4 fasFullFilledStar ++ [ fasHalfStar ]

    else if x >= 210 then
        List.repeat 4 fasFullFilledStar ++ [ fasFullEmptyStar ]

    else if x >= 180 then
        List.repeat 3 fasFullFilledStar ++ [ fasHalfStar, fasFullEmptyStar ]

    else if x >= 150 then
        List.repeat 3 fasFullFilledStar ++ List.repeat 2 fasFullEmptyStar

    else if x >= 120 then
        List.repeat 2 fasFullFilledStar ++ fasHalfStar :: List.repeat 2 fasFullEmptyStar

    else if x >= 90 then
        List.repeat 2 fasFullFilledStar ++ List.repeat 3 fasFullEmptyStar

    else if x >= 60 then
        [ fasFullFilledStar, fasHalfStar ] ++ List.repeat 3 fasFullEmptyStar

    else if x >= 30 then
        fasFullFilledStar :: List.repeat 4 fasFullEmptyStar

    else if x >= 0 then
        fasHalfStar :: List.repeat 4 fasFullEmptyStar

    else
        []


baseIcon : String -> Html msg
baseIcon fasClass =
    span [ class "mt-1.5 text-lg bg-orange-600 border-2 border-orange-300 shadow shadow-orange-400 text-slate-100 w-12 h-12 p-4 flex items-center justify-center rounded-md" ] [ i [ class <| "fas " ++ fasClass ] [] ]


viewRatingGroup : String -> String -> List ( String, Model -> Int ) -> Model -> Html msg
viewRatingGroup fasId groupLabel formulas model =
    div [ class "py-10" ]
        [ div [ class "flex gap-x-4 w-full" ]
            [ div [] [ baseIcon fasId ]
            , div [ class "space-y-1 w-full" ]
                [ div [ class "font-bold text-lg text-slate-100" ] [ text groupLabel ]
                , div [ class "space-y-4 sm:space-y-0" ] <|
                    List.map (\( label, formula ) -> viewRating label formula model) formulas
                ]
            ]
        ]


viewRating : String -> (Model -> Int) -> Model -> Html msg
viewRating label formula model =
    div [ class "sm:grid grid-cols-2 max-w-full overflow-hidden" ]
        [ div [ class "my-auto" ]
            [ text (label ++ " (" ++ String.fromInt (formula model) ++ ")") ]
        , div
            [ class "ml-auto inline-flex gap-x-2" ]
          <|
            viewStarRating <|
                formula model
        ]
