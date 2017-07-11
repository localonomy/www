module Data.Country exposing (Country, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Json exposing (required)

-- TYPE --
type alias Country = 
  { id: String
  , code: String
  , name: String
  }

-- DECODER --
decoder : Decoder (List Country)
decoder = 
  Decode.list 
    ( Json.decode Country
        |> required "id" Decode.string
        |> required "code" Decode.string
        |> required "name" Decode.string
    )
