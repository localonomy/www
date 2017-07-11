import Html exposing (..)
import Html.Events exposing (..)
import List
import Navigation
import UrlParser exposing((</>))

import Data.Country as Country exposing (Country)
import Data.CountryDish as CountryDish exposing (CountryDish)
import Data.Dish as Dish exposing (Dish)

import Request.Country
import Request.CountryDish
import Request.Dish
import Request.DishName
import Request.Filter

import Model exposing (Model, initialModel)
import Msg exposing (Msg (..))

import Route exposing (Route (..), route)

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
initialCmd : Cmd Msg
initialCmd = 
  Cmd.batch 
    [ Request.Country.get
    , Request.DishName.get
    , Request.Filter.get
    ]

init : Navigation.Location -> (Model, Cmd Msg)
init location =
  ( initialModel (UrlParser.parsePath route location)
  , initialCmd
  )

-- UPDATE --
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
                Route.Home ->
                  Cmd.none
                Route.Country id ->
                  Request.CountryDish.get id
                Route.Dish id ->
                  Request.Dish.get id
            Nothing ->
              Cmd.none
      in
        ({ model | currentLocation = newLocation }, command)

    ShowTab tab ->
      ({ model | tab = tab }, Cmd.none)

    ToggleFilter filter ->
      let
        filters = 
          if List.member filter model.filtersDisabled then
            List.filter 
              (not << (\f -> f == filter)) 
              model.filtersDisabled
          else
            model.filtersDisabled ++ [filter]
      in
        ({ model | filtersDisabled = filters }, Cmd.none)

    Countries (Ok data) ->
      ({ model | countries = data }, Cmd.none)
    Countries (Err _) ->
      (model, Cmd.none)

    CountryDishes (Ok data) ->
      let
        dishes =
          if List.isEmpty model.filtersDisabled then
            data
          else
            List.filterMap 
            (\dish -> 
              if List.any (\filter -> List.member filter dish.contains) model.filtersDisabled then
                Nothing
              else
                Just dish
            )
            data
      in
        ({ model | countryDishes = dishes }, Cmd.none)

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
        Route.Home ->
          viewHome model
        Route.Country id ->
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
        Route.Dish id ->
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
            [ text filter
            , if List.member filter model.filtersDisabled then 
                text " - disabled" 
              else 
                text "" 
            ]
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
