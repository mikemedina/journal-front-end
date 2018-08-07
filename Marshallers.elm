module Marshallers exposing (hateoas, post, posts)

import Json.Decode exposing (..)
import Json.Decode.Pipeline as Pipeline exposing (decode, optional, required)
import Json.Decode.Extra exposing (date)
import Models exposing (Post)


link : Decoder Models.Link
link =
    Pipeline.decode Models.Link
        |> Pipeline.required "href" string


links : Decoder Models.Links
links =
    Pipeline.decode Models.Links
        |> Pipeline.required "self" link
        |> Pipeline.optional "post" (maybe link) Nothing
        |> Pipeline.optional "profile" (maybe link) Nothing


post : Decoder Models.Post
post =
    Pipeline.decode Models.Post
        |> Pipeline.optional "id" (maybe int) Nothing
        |> Pipeline.required "content" string
        |> Pipeline.optional "author" (maybe string) Nothing
        |> Pipeline.optional "date" (maybe date) Nothing


posts : Decoder (List Models.Post)
posts =
    list post


page : Decoder Models.Page
page =
    Pipeline.decode Models.Page
        |> Pipeline.required "size" int
        |> Pipeline.required "totalElements" int
        |> Pipeline.required "totalPages" int
        |> Pipeline.required "number" int


embedded : Decoder Models.Embedded
embedded =
    Pipeline.decode Models.Embedded
        |> Pipeline.required "posts" posts


hateoas : Decoder Models.Hateoas
hateoas =
    Pipeline.decode Models.Hateoas
        |> Pipeline.required "_embedded" embedded
        |> Pipeline.required "_links" links
        |> Pipeline.required "page" page
