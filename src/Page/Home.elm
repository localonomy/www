module Page.Home exposing (view)

import Html exposing (..)
import Html.Events exposing (..)

import Model exposing (Model)
import Msg exposing (Msg (..))

-- VIEW --
view : Model -> Html Msg
view model =
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
