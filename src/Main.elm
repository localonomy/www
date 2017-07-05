import Html exposing (Html, div, ul, li, text)
import Http
import Json.Decode exposing (Decoder, string, list)
import Json.Decode.Pipeline exposing (decode, required)
import List exposing (map)

-- MAIN --
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL --
type alias Country = 
  { id: String
  , code: String
  , name: String
  }

type alias Dish =
  { id : String
  , name : String
  }

type alias Model = 
  { countries : (List Country)
  , dishes : (List Dish)
  }

init : (Model, Cmd Msg)
init =
  let
    model =
      { countries = []
      , dishes = []
      }
  in
    model ! [fetchCountries, fetchDishes]

-- UPDATE --
type Msg = Countries (Result Http.Error (List Country))
  | Dishes (Result Http.Error (List Dish))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Countries (Ok data) ->
      ({ model | countries = data }, Cmd.none)

    Countries (Err _) ->
      (model, Cmd.none)

    Dishes (Ok data) ->
      ({ model | dishes = data }, Cmd.none)

    Dishes (Err _) ->
      (model, Cmd.none)

-- VIEW --
view : Model -> Html Msg
view model =
  div []
    [ ul []
        (map (\l -> li [] [ text l.name ]) model.countries)
    , ul []
        (map (\l -> li [] [ text l.name ]) model.dishes)
    ]

-- SUBSCRIPTIONS --
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- HTTP --
fetchCountries : Cmd Msg
fetchCountries =
  let
    url = 
      "http://localhost:3000/api/countries"

    request = 
      Http.get url countryListDecoder
  in
    Http.send Countries request

countryDecoder : Decoder Country
countryDecoder =
  decode Country
    |> required "id" string
    |> required "code" string
    |> required "name" string

countryListDecoder : Decoder (List Country)
countryListDecoder = 
  list countryDecoder

fetchDishes : Cmd Msg
fetchDishes =
  let
    url = 
      "http://localhost:3000/api/dishes"

    request = 
      Http.get url dishListDecoder
  in
    Http.send Dishes request

dishDecoder : Decoder Dish
dishDecoder =
  decode Dish
    |> required "id" string
    |> required "name" string

dishListDecoder : Decoder (List Dish)
dishListDecoder = 
  list dishDecoder
