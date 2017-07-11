module Request.Filter exposing (get)

import Http

import Data.Filter exposing (decoder)
import Msg exposing (Msg)

import Request.API exposing (baseUrl)

-- GET --
get : Cmd Msg
get =
  let
    url = 
      baseUrl ++ "/filters"

    request = 
      Http.get url decoder
  in
    Http.send Msg.Filters request
