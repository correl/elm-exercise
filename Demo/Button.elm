module Demo.Button (..) where

import Html exposing (Html)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Demo.Connection as Connection


view : Signal.Address Connection.Action -> Connection.State -> Html
view address state =
  case state of
    Connection.Offline ->
      Html.a
        [ class "button connect"
        , href "#"
        , onClick address Connection.Connect
        ]
        [ Html.text "Connect" ]

    Connection.Connecting ->
      Html.a
        [ class "button connecting"
        , href "#"
        ]
        [ Html.text "Connecting" ]

    Connection.Online ->
      Html.a
        [ class "button disconnect"
        , href "#"
        , onClick address Connection.Disconnect
        ]
        [ Html.text "Disconnect" ]
