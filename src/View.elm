module View exposing (view)

import Html exposing (..)

import Model exposing (Model)
import Msg exposing (Msg)

import Page.Country
import Page.Dish
import Page.Home

import Route exposing (Route (..))

-- VIEW --
view : Model -> Html Msg
view model =
  div [] [ page model ]

-- PAGE --
page : Model -> Html Msg
page model =
  case model.currentLocation of
    Just route ->
      case route of
        Route.Home ->
          Page.Home.view model
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
                Page.Country.view country dishes
              Nothing ->
                div [] [ text "" ]
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
                    Page.Dish.view country dish
                  Nothing ->
                    div [] [ text "" ]
              Nothing ->
                div [] [ text "" ]
    Nothing ->
      Page.Home.view model
