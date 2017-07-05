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

type alias Model = 
  { countries: (List Country)
  }

init : (Model, Cmd Msg)
init =
  let
    model =
      { countries = []
      }
  in
    model ! [fetchData]

-- UPDATE --
type Msg = Countries (Result Http.Error (List Country))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Countries (Ok data) ->
      ({ model | countries = data }, Cmd.none)

    Countries (Err _) ->
      (model, Cmd.none)

-- VIEW --
view : Model -> Html Msg
view model =
  div []
    [ ul []
        (map (\l -> li [] [ text l.name ]) model.countries)
    ]

-- SUBSCRIPTIONS --
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- HTTP --
fetchData : Cmd Msg
fetchData =
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
