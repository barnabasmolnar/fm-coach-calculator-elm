module Main exposing (..)

import AllDict exposing (empty, insert, withPredicate)
import Attribute exposing (Attribute(..), Model, general, getAttrName, getAttrVal, gk, mental)
import Browser
import Formula exposing (..)
import Html exposing (Html, button, div, fieldset, form, i, input, label, legend, span, text)
import Html.Attributes exposing (class, for, id, type_, value)
import Html.Events exposing (onClick, onInput)



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


init : Model
init =
    empty



-- UPDATE


type Msg
    = Update Attribute Int
    | Reset
    | ResetGroup (List Attribute)


update : Msg -> Model -> Model
update msg model =
    case msg of
        Update attr val ->
            insert attr (clamp 1 20 val) model

        Reset ->
            empty

        ResetGroup group ->
            withPredicate (\x -> List.member x group) 1 model



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "md:grid grid-cols-2 gap-x-4 space-y-16 md:space-y-0 h-full" ]
        [ div []
            [ form [ class "p-6 max-w-md mx-auto md:ml-auto md:mr-0" ]
                [ button
                    [ class "block ml-auto p-2 text-sm"
                    , onClick Reset
                    , type_ "button"
                    ]
                    [ text "Reset all attributes" ]
                , div [ class "space-y-12" ]
                    [ viewAttrInputGroup "Mental" mental model
                    , viewAttrInputGroup "Coaching" general model
                    , viewAttrInputGroup "Goalkeeping" gk model
                    ]
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
            [ class <|
                String.join
                    " "
                    [ "block w-24 rounded-md border-gray-300 shadow-sm"
                    , "focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
                    ]
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
        , button
            [ class "flex items-center justify-center w-6 h-6 p-4 ml-auto -mt-6 mb-2"
            , onClick (ResetGroup attrs)
            , type_ "button"
            ]
            [ span [ class "text-sm text-sky-800 block" ] [ i [ class "fas fa-sync-alt" ] [] ] ]
        , div [ class "space-y-4 px-6 pb-4" ] <|
            List.map (viewAttrInput model) attrs
        ]


viewStarRating : Int -> List (Html msg)
viewStarRating x =
    toFloat (x // 30 + 1) / 2 |> clamp 0.5 5.0 |> makeStars


baseIcon : String -> Html msg
baseIcon fasClass =
    span [ class "mt-1.5 text-lg bg-orange-600 border-2 border-orange-300 shadow shadow-orange-400 text-slate-100 w-12 h-12 p-4 flex items-center justify-center rounded-md" ] [ i [ class <| "fas " ++ fasClass ] [] ]


viewRatingGroup : String -> String -> List ( String, Formula ) -> Model -> Html msg
viewRatingGroup fasId groupLabel labelFormulaPairs model =
    div [ class "py-10" ]
        [ div [ class "flex gap-x-4 w-full" ]
            [ div [] [ baseIcon fasId ]
            , div [ class "space-y-1 w-full" ]
                [ div [ class "font-bold text-lg text-slate-100" ] [ text groupLabel ]
                , div [ class "space-y-4 sm:space-y-0" ] <|
                    List.map (viewRating model) labelFormulaPairs
                ]
            ]
        ]


viewRating : Model -> ( String, Formula ) -> Html msg
viewRating model ( label, formula ) =
    div [ class "sm:grid grid-cols-2 max-w-full overflow-hidden" ]
        [ div [ class "my-auto" ]
            [ text (label ++ " (" ++ String.fromInt (formula model) ++ ")") ]
        , div
            [ class "ml-auto inline-flex gap-x-2" ]
          <|
            viewStarRating <|
                formula model
        ]
