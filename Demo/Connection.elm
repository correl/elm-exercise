module Demo.Connection (..) where


type State
  = Online
  | Connecting
  | Offline

type Action
  = Connect
  | Connected
  | Disconnect


update : Action -> State -> State
update action state =
  case (state, action) of
    (Offline, Connect) ->
      Connecting
    (Connecting, Connected) ->
      Online
    (Online, Disconnect) ->
      Offline
    _ ->
      state
        
