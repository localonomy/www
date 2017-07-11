module Route exposing (Route(..), route)

import UrlParser exposing (..)

type Route
  = HomeRoute
  | CountryRoute String
  | DishRoute String

route : Parser (Route -> a) a
route =
  oneOf
    [ map HomeRoute top
    , map CountryRoute (s "country" </> string)
    , map DishRoute (s "dish" </> string)
    ]
