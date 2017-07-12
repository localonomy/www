import Html exposing (..)
import List
import Navigation
import UrlParser exposing((</>))

import Page.Country
import Page.Dish
import Page.Home


import Model exposing (Model, initialModel)
import Msg exposing (Msg (..))
import Update exposing (update, initialCmd)

import Route exposing (Route (..), route, initialRoute)

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
init : Navigation.Location -> (Model, Cmd Msg)
init location =
  ( initialModel (initialRoute location)
  , initialCmd (initialRoute location)
  )

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
                    Page.Dish.view country dish
                  Nothing ->
                    div [] [ text "404 - Not Found" ]
              Nothing ->
                div [] [ text "404 - Not Found" ]
    Nothing ->
      Page.Home.view model

-- SUBSCRIPTIONS --
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
