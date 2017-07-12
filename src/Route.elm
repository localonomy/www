module Route exposing (Route(..), route, initialRoute)

import Navigation exposing (Location)
import UrlParser exposing (..)

-- TYPE --
type Route
  = Home
  | Country String
  | Dish String

-- ROUTE --
route : Parser (Route -> a) a
route =
  oneOf
    [ map Home top
    , map Country (s "country" </> string)
    , map Dish (s "dish" </> string)
    ]

-- INITIAL ROUTE --
initialRoute : Location -> Maybe Route
initialRoute location =
  UrlParser.parsePath route location
