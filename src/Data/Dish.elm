module Data.Dish exposing (Dish, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Json exposing (required)

-- TYPE --
type alias Dish =
  { id : String
  , name : String
  , localName : String
  , picture : String
  , description : String
  , ingredients : (List String)
  , contains : (List String)
  }

-- DECODER --
decoder : Decoder Dish
decoder =
  Json.decode Dish
    |> required "id" Decode.string
    |> required "name" Decode.string
    |> required "localName" Decode.string
    |> required "picture" Decode.string
    |> required "description" Decode.string
    |> required "ingredients" (Decode.list Decode.string)
    |> required "contains" (Decode.list Decode.string)
