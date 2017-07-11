module Data.Filter exposing (Filter, decoder)

import Json.Decode as Decode exposing (Decoder)

-- TYPE --
type alias Filter = String

-- DECODER --
decoder : Decoder (List Filter)
decoder =
  Decode.list Decode.string
