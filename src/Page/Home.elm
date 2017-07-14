module Page.Home exposing (view)

import Array
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model exposing (Model)
import Msg exposing (Msg (..))

import Config exposing (baseUrl)

-- VIEW --
view : Model -> Html Msg
view model =
  div [ styleMain ]
    [ div [ styleHeader ]
      [ text "Localonomy" ]
    , div [ styleSlogan ]
      [ text "Discover Local Delicacies!" ]
    , div [ styleSelect ]
      [ div [ styleTabs ]
        [ span
          [ onClick (ShowTab "country")
          , styleTabLeft
          , if model.tab == "country" then
              styleTabSelected 
            else 
              styleTab
          ]
          [ text "By Country" ]
        , span
          [ onClick (ShowTab "dish")
          , styleTabRight
          , if model.tab == "dish" then
              styleTabSelected 
            else 
              styleTab
          ]
          [ text "By Dish Name" ]
        ]
      , div [ styleSelectors ] 
        [ if model.tab == "country" then
            select [ onInput (onSelect), styleSelectorsSelect ]
            ( List.append 
              [ option
                [] [ text "Select a country" ]
              ]
              ( List.map 
                (\country -> 
                  option 
                  [ value ("country-" ++ country.id) ] 
                  [ text country.name ]
                ) 
                model.countries
              )
            )
          else
            select [ onInput (onSelect), styleSelectorsSelect ]
            ( List.append
              [ option
                [] [ text "Select a dish" ]
              ]
              ( List.map 
                (\dish -> 
                  option 
                  [ value ("dish-" ++ dish.id) ] 
                  [ text dish.name ]
                ) 
                model.dishNames
              )
            )
        ]
      ]
    , div [ styleFilters ]
      [ ul 
        [ styleFiltersList ]
        ( List.map 
          (\filter -> 
            li 
            [ onClick (ToggleFilter filter)
            , styleFilter
            ]
            [ img 
              [ src (baseUrl ++ "/img/filter/" ++ filter ++ ".png")
              , alt (filter)
              , if List.member filter model.filtersDisabled then
                  styleFilterImageDisabled
                else
                  styleFilterImage
              ] [] ]
          )
          model.filters
        )
      ]
    ]

onSelect : String -> Msg
onSelect element =
  let
    elementSplit = Array.fromList (String.split "-" element)
    
    path = Array.get 0 elementSplit
    id = Array.get 1 elementSplit
  in
    case path of
      Just path ->
        case id of
          Just id -> 
            NewUrl ("/" ++ path ++ "/" ++ id)
          Nothing ->
            NoOp
      Nothing ->
        NoOp

-- STYLES --
styleMain : Attribute Msg
styleMain = 
  Html.Attributes.style
    [ ("height", "100%")
    ]

styleHeader : Attribute Msg
styleHeader =
  Html.Attributes.style
    [ ("padding", "12px")
    , ("background-color", "chocolate")
    , ("color", "white")
    ]

styleSlogan : Attribute Msg
styleSlogan = 
  Html.Attributes.style
    [ ("text-align", "center")
    , ("margin-top", "64px")
    , ("margin-bottom", "32px")
    , ("font-size", "20px")
    ]

styleSelect : Attribute Msg
styleSelect = 
  Html.Attributes.style
    [ ("display", "flex")
    , ("flex-direction", "column")
    ]

styleTabs : Attribute Msg
styleTabs = 
  Html.Attributes.style
    [ ("padding", "12px")
    , ("padding-bottom", "0px")
    , ("display", "flex")
    ]
styleTab : Attribute Msg
styleTab = 
  Html.Attributes.style
    [ ("background-color", "peachpuff")
    , ("padding", "12px")
    , ("flex-grow", "1")
    , ("text-align", "center")
    ]
styleTabLeft : Attribute Msg
styleTabLeft = 
  Html.Attributes.style
   [ ("border-top-left-radius", "12px")
   ]
styleTabRight : Attribute Msg
styleTabRight = 
  Html.Attributes.style
   [ ("border-top-right-radius", "12px")
   ]
styleTabSelected : Attribute Msg
styleTabSelected = 
  Html.Attributes.style
    [ ("background-color", "chocolate")
    , ("padding", "12px")
    , ("flex-grow", "1")
    , ("text-align", "center")
    ]

styleSelectors : Attribute Msg
styleSelectors = 
  Html.Attributes.style
    [ ("padding-left", "12px")
    , ("padding-right", "12px")
    ]
styleSelectorsSelect : Attribute Msg
styleSelectorsSelect =
  Html.Attributes.style
    [ ("width", "100%")
    , ("height", "42px")
    , ("font-size", "20px")
    , ("border", "1px solid lightgrey")
    , ("border-radius", "0px")
    , ("padding-left", "12px")
    , ("-webkit-appearance", "none")
    ]

styleFilters : Attribute Msg
styleFilters = 
  Html.Attributes.style
    [ ("height", "calc(100% - 275px)")
    , ("padding-left", "12px")
    , ("padding-right", "12px")
    ]
styleFiltersList : Attribute Msg
styleFiltersList = 
  Html.Attributes.style
    [ ("list-style", "none")
    , ("margin", "0px")
    , ("margin-top", "12px")
    , ("padding", "0px")
    , ("display", "flex")
    , ("flex-direction", "row")
    , ("flex-wrap", "wrap")
    , ("justify-content", "space-between")
    , ("align-content", "space-around")
    , ("align-items", "center")
    , ("height", "100%")
    ]
styleFilter : Attribute Msg
styleFilter = 
  Html.Attributes.style
    [ ("width", "calc(33% - 12px)")
    , ("text-align", "center")
    ]
styleFilterImage : Attribute Msg
styleFilterImage = 
  Html.Attributes.style
    [ ("opacity", "1")
    , ("height", "100px")
    ]
styleFilterImageDisabled : Attribute Msg
styleFilterImageDisabled = 
  Html.Attributes.style
    [ ("opacity", "0.3")
    , ("height", "100px")
    ]
