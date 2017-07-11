module Page.Country exposing (view)

import Html exposing (..)
import Html.Events exposing (..)

import Data.Country exposing (Country)
import Data.CountryDish exposing (CountryDish)

import Msg exposing (Msg (..))

-- VIEW --
view : Country -> (List CountryDish) -> Html Msg
view country dishes =
  div []
    [ text country.name
    , ul []
      ( List.map 
        (\dish -> 
          li 
          [ onClick (NewUrl ("/dish/" ++ dish.id)) ] 
          [ text dish.name ]
        ) 
        dishes
      )
    ]