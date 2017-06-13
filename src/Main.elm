import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

-- MAIN --
main : Program Never Model Msg
main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }

-- MODEL --
type alias Model = Int

model : Model
model =
  0

-- UPDATE --
type Msg = Increment | Decrement

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1 

-- VIEW --
view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Increment ] [ text "+" ]
    , div [] [ text (toString model) ]
    , button [ onClick Decrement ] [ text "-" ]
    ]
