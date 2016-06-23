module Players.Messages exposing (..)

import Http
import Players.Models exposing (PlayerId, Player)



-- FetchAllDone will be called when we get the response from the server
-- FetchAllFail will be called if there is a problem fetching the data.
type Msg
  = FetchAllDone (List Player)
  | FetchAllFail Http.Error
  | ShowPlayers
  | ShowPlayer PlayerId
