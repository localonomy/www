module Msg exposing (..)

import Http
import Navigation

import Data.Country exposing (Country)
import Data.CountryDish exposing (CountryDish)
import Data.Dish exposing (Dish)
import Data.DishName exposing (DishName)

-- MSG --
type Msg 
  = NewUrl String
  | UrlChange Navigation.Location
  | ShowTab String
  | ToggleFilter String
  | Countries (Result Http.Error (List Country))
  | CountryDishes (Result Http.Error (List CountryDish))
  | DishNames (Result Http.Error (List DishName))
  | DishDetails (Result Http.Error Dish)
  | Filters (Result Http.Error (List String))
