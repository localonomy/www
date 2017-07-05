import Html exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Json exposing (required)
import List

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

type alias Filter = String

type alias Model = 
  { countries : (List Country)
  , dishes : (List Dish)
  , filters : (List Filter)
  }

init : (Model, Cmd Msg)
init =
  let
    model =
      { countries = []
      , dishes = []
      , filters = []
      }
  in
    model ! [fetchCountries, fetchDishes, fetchFilters]

-- UPDATE --
type Msg = Countries (Result Http.Error (List Country))
  | Dishes (Result Http.Error (List Dish))
  | Filters (Result Http.Error (List String))

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

    Filters (Ok data) ->
      ({ model | filters = data }, Cmd.none)

    Filters (Err _) ->
      (model, Cmd.none)

-- VIEW --
view : Model -> Html Msg
view model =
  div []
    [ ul []
        (List.map (\l -> li [] [ text l.name ]) model.countries)
    , ul []
        (List.map (\l -> li [] [ text l.name ]) model.dishes)
    , ul []
        (List.map (\l -> li [] [ text l ]) model.filters)
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
  Json.decode Country
    |> required "id" Decode.string
    |> required "code" Decode.string
    |> required "name" Decode.string

countryListDecoder : Decoder (List Country)
countryListDecoder = 
  Decode.list countryDecoder

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
  Json.decode Dish
    |> required "id" Decode.string
    |> required "name" Decode.string

dishListDecoder : Decoder (List Dish)
dishListDecoder = 
  Decode.list dishDecoder

fetchFilters : Cmd Msg
fetchFilters =
  let
    url = 
      "http://localhost:3000/api/filters"

    request = 
      Http.get url filterListDecoder
  in
    Http.send Filters request

filterListDecoder : Decoder (List Filter)
filterListDecoder =
  Decode.list Decode.string
