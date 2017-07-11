module Request.CountryDish exposing (get)

import Http

import Data.CountryDish exposing (decoder)
import Msg exposing (Msg)

import Request.API exposing (baseUrl)

-- GET --
get : String -> (Cmd Msg)
get country =
  let
    url = 
      baseUrl ++ "/dishes/" ++ country

    request = 
      Http.get url decoder
  in
    Http.send Msg.CountryDishes request
