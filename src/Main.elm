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

type alias Model = (List Country)

init : (Model, Cmd Msg)
init =
  let
    model =
      []
  in
    model ! [fetchData]

-- UPDATE --
type Msg = Data (Result Http.Error Model)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Data (Ok data) ->
      (data, Cmd.none)

    Data (Err _) ->
      (model, Cmd.none)

-- VIEW --
view : Model -> Html Msg
view model =
  div []
    [ ul []
      (map (\l -> li [] [ text l.name ]) model)
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
    Http.send Data request

countryDecoder : Decoder Country
countryDecoder =
  decode Country
    |> required "id" string
    |> required "code" string
    |> required "name" string

countryListDecoder : Decoder (List Country)
countryListDecoder = 
  list countryDecoder
