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
      [ div [] [ text dish.name ]
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
      , div [] 
        [ img 
          [ src(baseUrl ++ "/img/flag/" ++ country.code ++ ".png")
          , alt(country.name)
          , styleFlag
          ] [] 
        ]
      ]
    , div []
      [ div []
        [ text dish.description]
      , div []
        [ img 
          [ src(baseUrl ++ "/img/dish/" ++ String.toLower (toKebabCase dish.name) ++ ".jpg")
          , alt(country.name)
          , styleFlag
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
    , ("background-color", "peachpuff")
    , ("color", "black")
    , ("border-bottom", "1px solid lightgrey")
    ]
styleIngredient : Attribute Msg
styleIngredient =
  Html.Attributes.style
    [ ("height", "24px")
    , ("margin-right", "6px")
    ]
styleFlag : Attribute Msg
styleFlag =
  Html.Attributes.style
    [ ("height", "32px")
    ]
