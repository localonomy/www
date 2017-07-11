module Model exposing (Model, initialModel)

import Data.Country exposing (Country)
import Data.CountryDish exposing (CountryDish)
import Data.Dish exposing (Dish)
import Data.DishName exposing (DishName)
import Data.Filter exposing (Filter)

import Route exposing (Route)

-- MODEL --
type alias Model = 
  { currentLocation : Maybe Route
  , countries : (List Country)
  , countryDishes : (List CountryDish)
  , dishNames : (List DishName)
  , currentDish : Maybe Dish
  , filters : (List Filter)
  , filtersDisabled : (List Filter)
  , tab : String
  }

-- INITIAL MODEL --
initialModel : Maybe Route -> Model
initialModel location =
  { currentLocation = location
  , countries = []
  , countryDishes = []
  , dishNames = []
  , currentDish = Nothing
  , filters = []
  , filtersDisabled = []
  , tab = "country"
  }
