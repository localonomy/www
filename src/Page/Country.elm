module Page.Country exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Config exposing (baseUrl)

import Data.Country exposing (Country)
import Data.CountryDish exposing (CountryDish)

import Msg exposing (Msg (..))

-- VIEW --
view : Country -> (List CountryDish) -> Html Msg
view country dishes =
  div [ styleMain ]
    [ div [ styleHeader]
      [ text "Localonomy" ]
    , div [ styleSubHeader]
      [ div [ styleSubHeaderText ] 
        [ div [ styleSubHeaderSmallText ] [ text "Local dishes from" ]
        , div [ styleSubHeaderCountryName ] [ text country.name ]
        ]
      , div [] 
        [ img 
          [ src(baseUrl ++ "/img/flag/" ++ country.code ++ ".png")
          , alt(country.name)
          , styleSubHeaderFlag
          ] [] 
        ]
      ]
    , ul [ styleDishList ]
      ( List.map 
        (\dish -> 
          li 
          [ onClick (NewUrl ("/dish/" ++ dish.id))
          , styleDishElement
          ] 
          [ span 
            [ styleDishName ] 
            [ text dish.name ]
          , div []
            ( List.map 
              (\ingredient ->
                img 
                [ src(baseUrl ++ "/img/ingredient/" ++ ingredient ++ ".png")
                , alt(ingredient)
                , styleIngredient
                ] []
              )
              dish.ingredients
            )
          ]
        ) 
        dishes
      )
    ]

-- STYLES --
styleMain : Attribute Msg
styleMain = 
  Html.Attributes.style
    [ ("height", "100%")
    ]

styleHeader : Attribute Msg
styleHeader =
  Html.Attributes.style
    [ ("padding", "12px")
    , ("background-color", "chocolate")
    , ("color", "white")
    ]

styleSubHeader : Attribute Msg
styleSubHeader =
  Html.Attributes.style
    [ ("display", "flex")
    , ("padding", "12px")
    , ("background-color", "peachpuff")
    , ("color", "black")
    , ("border-bottom", "1px solid lightgrey")
    ]
styleSubHeaderText : Attribute Msg
styleSubHeaderText =
  Html.Attributes.style
    [ ("flex-grow", "1")
    ]
styleSubHeaderSmallText : Attribute Msg
styleSubHeaderSmallText =
  Html.Attributes.style
    [ ("font-size", "10px")
    ]
styleSubHeaderCountryName : Attribute Msg
styleSubHeaderCountryName =
  Html.Attributes.style
    [ ("font-size", "20px")
    , ("font-weight", "bold")
    ]
styleSubHeaderFlag : Attribute Msg
styleSubHeaderFlag =
  Html.Attributes.style
    [ ("height", "32px")
    , ("border", "1px solid black")
    ]

styleDishList : Attribute Msg
styleDishList =
  Html.Attributes.style
    [ ("list-style", "none")
    , ("padding-top", "12px")
    , ("padding-left", "12px")
    , ("padding-right", "12px")
    , ("margin", "0px")
    , ("overflow", "scroll")
    ]
styleDishElement : Attribute Msg
styleDishElement =
  Html.Attributes.style
    [ ("padding-top", "12px")
    , ("padding-bottom", "12px")
    , ("border-bottom", "1px solid lightgrey")
    ]
styleDishName : Attribute Msg
styleDishName =
  Html.Attributes.style
    [ ("font-size", "20px")
    , ("display", "inline-block")
    , ("margin-bottom", "6px")
    ]
styleIngredient : Attribute Msg
styleIngredient =
  Html.Attributes.style
    [ ("height", "24px")
    , ("margin-right", "6px")
    ]
