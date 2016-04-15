module Demo.User (..) where

import Html exposing (Html)
import Html.Attributes exposing (class)
import Json.Decode exposing (Decoder, (:=))


type alias Model =
  { id : Int
  , name : String
  }


view : Model -> Html
view user =
  Html.li
    []
    [ Html.text user.name ]


list : List Model -> Html
list users =
  Html.ul
    [ class "users" ]
    <| List.map view users


decode : Decoder Model
decode =
  Json.Decode.object2
    Model
    ("id" := Json.Decode.int)
    ("name" := Json.Decode.string)
