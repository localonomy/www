module Data.CountryDish exposing (CountryDish, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Json exposing (required)

-- TYPE --
type alias CountryDish =
  { id : String
  , name : String
  , localName : String
  , ingredients : (List String)
  , contains : (List String)
  }

-- DECODER --
decoder : Decoder (List CountryDish)
decoder = 
  Decode.list 
  ( Json.decode CountryDish
      |> required "id" Decode.string
      |> required "name" Decode.string
      |> required "localName" Decode.string
      |> required "ingredients" (Decode.list Decode.string)
      |> required "contains" (Decode.list Decode.string)
  )
