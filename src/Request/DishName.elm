module Request.DishName exposing (get)

import Http

import Data.DishName exposing (decoder)
import Msg exposing (Msg)

import Request.API exposing (baseUrl)

-- GET --
get : Cmd Msg
get =
  let
    url = 
      baseUrl ++ "/dishes"

    request = 
      Http.get url decoder
  in
    Http.send Msg.DishNames request
