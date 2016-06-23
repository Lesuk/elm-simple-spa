module Players.Commands exposing (..)

import Http
import Json.Decode as Decode exposing ((:=))
import Task
import Players.Models exposing (PlayerId, Player)
import Players.Messages exposing (..)



-- Create a command for our app
-- Http.get creates a task
-- then we send this task to Task.perform which wraps it in a command
fetchAll : Cmd Msg
fetchAll =
  Http.get collectionDecoder fetchAllUrl
    |> Task.perform FetchAllFail FetchAllDone


fetchAllUrl : String
fetchAllUrl =
  "http://localhost:4000/players"


-- This decoder delegates the decoding of each member of a list to memberDecoder
collectionDecoder : Decode.Decoder (List Player)
collectionDecoder =
  Decode.list memberDecoder


-- create a JSON decoder that returns a Player record
memberDecoder : Decode.Decoder Player
memberDecoder =
  Decode.object3 Player
    ("id" := Decode.int)
    ("name" := Decode.string)
    ("level" := Decode.int)
