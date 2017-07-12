import Navigation

import Model exposing (Model, initialModel)
import Msg exposing (Msg (..))
import Update exposing (update, initialCmd)
import View exposing (view)

import Route exposing (initialRoute)

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

-- SUBSCRIPTIONS --
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
