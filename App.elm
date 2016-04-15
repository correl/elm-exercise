module App (main) where

import StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)
import Html exposing (Html)
import Http
import Json.Decode
import Demo.Connection as Connection
import Demo.Button as Button
import Demo.User as User


type alias Model =
  { connection : Connection.State
  , users : List User.Model
  }


type Action
  = UpdateConnection Connection.Action
  | FetchUsers
  | UpdateUsers (Result Http.Error (List User.Model))


model : Model
model =
  { connection = Connection.Offline
  , users = []
  }


init : ( Model, Effects Action )
init =
  ( model, Effects.none )


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    UpdateConnection action' ->
      let
        model' =
          { model | connection = Connection.update action' model.connection }
      in
        case action' of
          Connection.Connect ->
            ( model', getUsers )

          Connection.Disconnect ->
            ( { model' | users = [] }, Effects.none )

          Connection.Connected ->
            ( model', Effects.none )

    UpdateUsers (Result.Ok users') ->
      ( { model
          | users = users'
          , connection = Connection.update Connection.Connected model.connection
        }
      , Effects.none
      )

    _ ->
      ( model, Effects.none )


getUsers : Effects.Effects Action
getUsers =
  Http.get (Json.Decode.list User.decode) "json/users.json"
    |> Task.toResult
    |> Task.map UpdateUsers
    |> Effects.task


view : Signal.Address Action -> Model -> Html
view address model =
  Html.div
    []
    [ Button.view (Signal.forwardTo address UpdateConnection) model.connection
    , User.list model.users
    ]


app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , inputs = []
    , update = update
    , view = view
    }


main : Signal Html.Html
main =
  app.html


port runner : Signal (Task Never ())
port runner =
  app.tasks
