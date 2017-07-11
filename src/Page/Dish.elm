module Page.Dish exposing (view)

import Html exposing (..)

import Data.Country exposing (Country)
import Data.Dish exposing (Dish)

import Msg exposing (Msg (..))

-- VIEW --
view : Country -> Dish -> Html Msg
view country dish =
  div []
    [ text country.name 
    , text dish.name
    ]
