module Data.DishName exposing (DishName, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Json exposing (required)

-- TYPE --
type alias DishName =
  { id : String
  , name : String
  }

-- DECODER --
decoder : Decoder (List DishName)
decoder = 
  Decode.list 
  ( Json.decode DishName
      |> required "id" Decode.string
      |> required "name" Decode.string
  )
