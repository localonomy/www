module Request.Dish exposing (get)

import Http

import Data.Dish exposing (decoder)
import Msg exposing (Msg)

import Request.API exposing (baseUrl)

-- GET --
get : String -> (Cmd Msg)
get dish =
  let
    url = 
      baseUrl ++ "/dish/" ++ dish

    request = 
      Http.get url decoder
  in
    Http.send Msg.DishDetails request
