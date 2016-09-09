module Forms exposing (validateStatementDate
                     , validatePublicServant
                     , validateLand)

import Date exposing (Date)
import Dict exposing (Dict)
import Regex
import String

import Form exposing (Form)
import Form.Error exposing (Error(InvalidDate))
import Form.Validate as Validate exposing (..)
import Form.Input as Input

import Models exposing (..)


validateStatementDate : Validation () StatementDate
validateStatementDate =
  form1 StatementDate
    (get "date" <| customValidation string validDate)


validatePublicServant : Validation () PublicServant
validatePublicServant =
  form4 PublicServant
    (get "first_name" string)
    (get "last_name" string)
    (get "position" string)
    (get "position_location" string)


validateLand : Validation () Land
validateLand =
  form7 Land
    (get "location" (string `andThen` maxLength 255))
    (get "category" int)
    (get "year_acquired" int)
    (get "area" float)
    (get "share" int)
    (get "method_acquired" (string `andThen` maxLength 255))
    (get "owner" (string `andThen` maxLength 255))


validDate : String -> Result (Error e) Date
validDate s =
  let
    validFormat s =
      if (Regex.contains (Regex.regex "\\d{2}-\\d{2}-\\d{4}") s) then
        Ok s
      else
        Err Form.Error.InvalidDate
    validValue s =
      case String.split "-" s of
        (day::month::year::[]) ->
          case Date.fromString <| year ++ "-" ++ month ++ "-" ++ day of
            Ok d ->
              Ok d
            Err _ ->
              Err Form.Error.InvalidDate
        _ ->
          Err Form.Error.InvalidDate
  in
    validFormat s `Result.andThen` validValue
