module Players.Update exposing (..)


import Navigation
import Players.Messages exposing (Msg(..))
import Players.Models exposing (Player, PlayerId)
import Players.Commands exposing (save)



update : Msg -> List Player -> (List Player, Cmd Msg)
update msg players =
  case msg of
    FetchAllDone newPlayers ->
      (newPlayers, Cmd.none)

    FetchAllFail error ->
      (players, Cmd.none)

    ShowPlayers ->
      ( players, Navigation.modifyUrl "#players" )

    ShowPlayer id ->
      ( players, Navigation.modifyUrl ("#players/" ++ (toString id)) )

    ChangeLevel id howMuch ->
      -- function return a list of commands to run, so we then batch them into one command using Cmd.batch
      ( players, changeLevelCommands id howMuch players |> Cmd.batch )

    SaveSuccess updatedPlayer ->
      ( updatePlayer updatedPlayer players, Cmd.none )

    SaveFail error ->
      ( players, Cmd.none )


changeLevelCommands : PlayerId -> Int -> List Player -> List (Cmd Msg)
changeLevelCommands playerId howMuch =
  let
    cmdForPlayer existingPlayer =
      if existingPlayer.id == playerId then
        save { existingPlayer | level = existingPlayer.level + howMuch }
      else
        Cmd.none
  in
    List.map cmdForPlayer


updatePlayer : Player -> List Player -> List Player
updatePlayer updatedPlayer =
  let
    select existingPlayer =
      if existingPlayer.id == updatedPlayer.id then
        updatedPlayer
      else
        existingPlayer
  in
    List.map select
