module Decoders exposing (decodePost, decodePosts)

import Json.Decode exposing (..)
import Json.Decode.Pipeline as Pipeline exposing (decode, optional, required)
import Models exposing (Post)


decodePost : Json.Decode.Decoder Post
decodePost =
    Pipeline.decode Post
        |> Pipeline.optional "id" (nullable int) Nothing
        |> Pipeline.required "content" string


decodePosts : Json.Decode.Decoder (List Post)
decodePosts =
    Json.Decode.list decodePost
