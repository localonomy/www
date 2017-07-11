module Route exposing (Route(..), route)

import UrlParser exposing (..)

type Route
  = Home
  | Country String
  | Dish String

route : Parser (Route -> a) a
route =
  oneOf
    [ map Home top
    , map Country (s "country" </> string)
    , map Dish (s "dish" </> string)
    ]
