import Html exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Json exposing (required)
import List
import Navigation
import UrlParser exposing((</>))

-- MAIN --
main : Program Never Model Msg
main =
  Navigation.program UrlChange
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- INIT --
type alias Country = 
  { id: String
  , code: String
  , name: String
  }

type alias Dish =
  { id : String
  , name : String
  , localName : String
  , picture : String
  , description : String
  , ingredients : (List String)
  , contains : (List String)
  }

type alias DishName =
  { id : String
  , name : String
  }

type alias CountryDish =
  { id : String
  , name : String
  , localName : String
  , ingredients : (List String)
  , contains : (List String)
  }

type alias Filter = String

type Route
  = HomeRoute
  | CountryRoute String
  | DishRoute String

type alias Model = 
  { currentLocation : Maybe Route
  , countries : (List Country)
  , currentCountry : Maybe Country
  , countryDishes : (List CountryDish)
  , dishNames : (List DishName)
  , currentDish : Maybe Dish
  , filters : (List Filter)
  , filtersDisabled : (List Filter)
  , tab : String
  }

init : Navigation.Location -> (Model, Cmd Msg)
init location =
  ( { currentLocation = UrlParser.parsePath route location
    , countries = []
    , currentCountry = Nothing
    , countryDishes = []
    , dishNames = []
    , currentDish = Nothing
    , filters = []
    , filtersDisabled = []
    , tab = "country"
    }
  , Cmd.batch 
    [ fetchCountries
    , fetchDishes
    , fetchFilters
    ]
  )

route : UrlParser.Parser (Route -> a) a
route =
  UrlParser.oneOf
    [ UrlParser.map HomeRoute UrlParser.top
    , UrlParser.map CountryRoute (UrlParser.s "country" </> UrlParser.string)
    , UrlParser.map DishRoute (UrlParser.s "dish" </> UrlParser.string)
    ]

-- UPDATE --
type Msg 
  = NewUrl String
  | UrlChange Navigation.Location
  | ShowTab String
  | ToggleFilter String
  | Countries (Result Http.Error (List Country))
  | CountryDishes (Result Http.Error (List CountryDish))
  | DishNames (Result Http.Error (List DishName))
  | DishDetails (Result Http.Error Dish)
  | Filters (Result Http.Error (List String))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NewUrl url ->
      ( model, Navigation.newUrl url )
    
    UrlChange location ->
      let
        newLocation =
          UrlParser.parsePath route location
        
        command =
          case newLocation of
            Just route ->
              case route of
                HomeRoute ->
                  Cmd.none
                CountryRoute id ->
                  fetchCountryDishes id
                DishRoute id ->
                  fetchDishDetails id
            Nothing ->
              Cmd.none
      in
        ({ model | currentLocation = newLocation }, command)

    ShowTab tab ->
      ({ model | tab = tab }, Cmd.none)

    ToggleFilter filter ->
      if List.member filter model.filtersDisabled then
        -- Remove from list
        ({ model | filtersDisabled = List.filter (not << (\f -> f == filter)) model.filtersDisabled }, Cmd.none)

      else
        -- Add to list
        ({ model | filtersDisabled = model.filtersDisabled ++ [filter] }, Cmd.none)

    Countries (Ok data) ->
      ({ model | countries = data }, Cmd.none)
    Countries (Err _) ->
      (model, Cmd.none)

    CountryDishes (Ok data) ->
      ({ model | countryDishes = data }, Cmd.none)
    CountryDishes (Err _) ->
      (model, Cmd.none)

    DishNames (Ok data) ->
      ({ model | dishNames = data }, Cmd.none)
    DishNames (Err _) ->
      (model, Cmd.none)

    DishDetails (Ok data) ->
      ({ model | currentDish = Just data }, Cmd.none)
    DishDetails (Err _) ->
      (model, Cmd.none)

    Filters (Ok data) ->
      ({ model | filters = data }, Cmd.none)
    Filters (Err _) ->
      (model, Cmd.none)

-- VIEW --
view : Model -> Html Msg
view model =
  div [] [ page model ]

page : Model -> Html Msg
page model =
  case model.currentLocation of
    Just route ->
      case route of
        HomeRoute ->
          viewHome model
        CountryRoute id ->
          let
            country = 
              List.head 
                (List.filter 
                  (\c -> c.id == id) 
                  model.countries
                )

            dishes = model.countryDishes
          in
            case country of
              Just country ->
                viewCountry country dishes
              Nothing ->
                div [] [ text "404 - Not Found" ]
        DishRoute id ->
          let
            country =
              List.head 
                (List.filter 
                  (\c -> c.id == String.left 2 id)
                  model.countries
                )
            dish = model.currentDish
          in
            case country of
              Just country ->
                case dish of
                  Just dish ->
                    viewDish country dish
                  Nothing ->
                    div [] [ text "404 - Not Found" ]
              Nothing ->
                div [] [ text "404 - Not Found" ]
    Nothing ->
      viewHome model

viewHome : Model -> Html Msg
viewHome model =
  div []
    [ div []
      [ div []
        [ span
          [ onClick (ShowTab "country") ]
          [ text "By Country" ]
        , span
          [ onClick (ShowTab "dish") ]
          [ text "By Dish Name" ]
        ]
      , div [] 
        [ if model.tab == "country" then
            ul []
            (List.map 
              (\country -> 
                li 
                [ onClick (NewUrl ("/country/" ++ country.id)) ] 
                [ text country.name ]
              ) 
              model.countries
            )
          else
            ul []
            (List.map 
              (\dish -> 
                li 
                [ onClick (NewUrl ("/dish/" ++ dish.id)) ] 
                [ text dish.name ]
              ) 
              model.dishNames
            )
        ]
      ]
    , ul []
        (List.map 
          (\filter -> 
            li 
            [ onClick (ToggleFilter filter)]
            [ text filter ]
          ) 
          model.filters
        )
    ]

viewCountry : Country -> (List CountryDish) -> Html Msg
viewCountry country dishes =
  div []
    [ text country.name
    , ul []
      ( List.map 
        (\dish -> 
          li 
          [ onClick (NewUrl ("/dish/" ++ dish.id)) ] 
          [ text dish.name ]
        ) 
        dishes
      )
    ]

viewDish : Country -> Dish -> Html Msg
viewDish country dish =
  div []
    [ text country.name 
    , text dish.name
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
    Http.send DishNames request

dishNameDecoder : Decoder DishName
dishNameDecoder =
  Json.decode DishName
    |> required "id" Decode.string
    |> required "name" Decode.string

dishListDecoder : Decoder (List DishName)
dishListDecoder = 
  Decode.list dishNameDecoder

fetchDishDetails : String -> (Cmd Msg)
fetchDishDetails dish =
  let
    url = 
      "http://localhost:3000/api/dish/" ++ dish

    request = 
      Http.get url dishDecoder
  in
    Http.send DishDetails request

dishDecoder : Decoder Dish
dishDecoder =
  Json.decode Dish
    |> required "id" Decode.string
    |> required "name" Decode.string
    |> required "localName" Decode.string
    |> required "picture" Decode.string
    |> required "description" Decode.string
    |> required "ingredients" (Decode.list Decode.string)
    |> required "contains" (Decode.list Decode.string)

fetchCountryDishes : String -> (Cmd Msg)
fetchCountryDishes country =
  let
    url = 
      "http://localhost:3000/api/dishes/" ++ country

    request = 
      Http.get url countryDishesDecoder
  in
    Http.send CountryDishes request

countryDishDecoder : Decoder CountryDish
countryDishDecoder =
  Json.decode CountryDish
    |> required "id" Decode.string
    |> required "name" Decode.string
    |> required "localName" Decode.string
    |> required "ingredients" (Decode.list Decode.string)
    |> required "contains" (Decode.list Decode.string)

countryDishesDecoder : Decoder (List CountryDish)
countryDishesDecoder = 
  Decode.list countryDishDecoder

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
