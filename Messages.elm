module Messages exposing (..)

import Dom exposing (Error, focus)
import Http exposing (Error)
import Models exposing (Hateoas, Post)
import Date exposing (..)


type Msg
    = AddPost Models.Post
    | AddingPost String
    | FocusResult (Result Dom.Error ())
    | GetPosts
    | PostsResult (Result Http.Error Models.Hateoas)
    | ReceiveDate Date
