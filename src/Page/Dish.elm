module Page.Dish exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Regex exposing (..)

import Config exposing (baseUrl)

import Data.Country exposing (Country)
import Data.Dish exposing (Dish)

import Msg exposing (Msg (..))

-- VIEW --
view : Country -> Dish -> Html Msg
view country dish =
  div [ styleMain ]
    [ div [ styleHeader]
      [ text "Localonomy" ]
    , div [ styleSubHeader ] 
      [ div [ styleSubHeaderLeft ] 
        [ div [] 
          [ span [ styleDishName ] 
            [ text dish.name ]
          , if dish.localName == dish.name then
              span [ styleDishLocalName ] 
              [ text "" ]
            else
              span [ styleDishLocalName ] 
              [ text (" - " ++ dish.localName) ]
          ]
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
      , div [] 
        [ img 
          [ src(baseUrl ++ "/img/flag/" ++ country.code ++ ".png")
          , alt(country.name)
          , styleFlag
          ] [] 
        ]
      ]
    , div []
      [ div [ styleDescription ]
        [ text dish.description]
      , div []
        [ img 
          [ src(baseUrl ++ "/img/dish/" ++ String.toLower (toKebabCase dish.name) ++ ".jpg")
          , alt(country.name)
          , styleDishImage
          ] [] 
        ]
      ]
    ]

toKebabCase : String -> String
toKebabCase =
  Regex.replace All (regex " ") (\_ -> "-")

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
    ]
styleSubHeaderLeft : Attribute Msg
styleSubHeaderLeft =
  Html.Attributes.style
    [ ("flex-grow", "1")
    , ("display", "flex")
    , ("flex-direction", "column")
    ]
styleDishName : Attribute Msg
styleDishName =
  Html.Attributes.style
    [ ("font-size", "20px")
    , ("font-weight", "bold")
    ]
styleDishLocalName : Attribute Msg
styleDishLocalName =
  Html.Attributes.style
    [ ("font-size", "12px")
    ]
styleIngredient : Attribute Msg
styleIngredient =
  Html.Attributes.style
    [ ("height", "16px")
    , ("margin-right", "6px")
    ]
styleFlag : Attribute Msg
styleFlag =
  Html.Attributes.style
    [ ("height", "36px")
    , ("border", "1px solid black")
    ]

styleDescription : Attribute Msg
styleDescription =
  Html.Attributes.style
    [ ("padding", "12px")
    , ("text-align", "justify")
    ]

styleDishImage : Attribute Msg
styleDishImage  =
  Html.Attributes.style
    [ ("padding", "12px")
    , ("width", "calc(100% - 24px)")
    ]
