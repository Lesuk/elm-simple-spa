-- Here we define:
-- routes for our application
-- how to match browser path to routes using path matchers
-- how to react to routing messages
module Routing exposing (..)


import String
import Navigation
import UrlParser exposing (..)
import Players.Models exposing (PlayerId)



-- Available routes in our application
type Route
  = PlayersRoute
  | PlayerRoute PlayerId
  | NotFoundRoute



-- Route matchers. These parsers are provided by the url-parser library
matchers : Parser (Route -> a) a
matchers =
  oneOf
    [ format PlayersRoute (s "")
    , format PlayerRoute (s "players" </> int)
    , format PlayersRoute (s "players")
    ]


-- Each time the browser location changes, Navigation lib. will give us a Navigation.Location record
hashParser : Navigation.Location -> Result String Route
hashParser location =
  -- extract the .hash part of it
  location.hash
    -- remove the first char. (#)
    |> String.dropLeft 1
    -- send this string to parse with our defined matchers
    |> parse identity matchers


-- Navig. lib. expects a parser for the current location
parser : Navigation.Parser (Result String Route)
parser =
  Navigation.makeParser hashParser


-- When we get a result from the parser we want to extract the route
routeFromResult : Result String Route -> Route
routeFromResult result =
  case result of
    Ok route ->
      route

    Err string ->
      NotFoundRoute
