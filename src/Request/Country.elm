module Request.Country exposing (get)

import Http

import Data.Country exposing (decoder)
import Msg exposing (Msg)

import Request.API exposing (baseUrl)

-- GET --
get : Cmd Msg
get =
  let
    url = 
      baseUrl ++ "/countries"

    request = 
      Http.get url decoder
  in
    Http.send Msg.Countries request
