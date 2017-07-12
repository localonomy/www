module Update exposing (update, initialCmd)

import Navigation
import UrlParser

import Model exposing (Model)
import Msg exposing (Msg (..))
import Route exposing (Route, route)

import Request.Country
import Request.CountryDish
import Request.Dish
import Request.DishName
import Request.Filter

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

-- INITIAL COMMAND --
initialCmd : Maybe Route -> Cmd Msg
initialCmd newLocation =
  case newLocation of
    Just route ->
      case route of
        Route.Home ->
          Cmd.batch 
            [ Request.Country.get
            , Request.DishName.get
            , Request.Filter.get
            ]
        Route.Country id ->
          Request.CountryDish.get id
        Route.Dish id ->
          Request.Dish.get id
    Nothing ->
      Cmd.batch 
        [ Request.Country.get
        , Request.DishName.get
        , Request.Filter.get
        ]
