module Messages exposing (..)

import Dom exposing (Error, focus)
import Http exposing (Error)
import Keyboard
import Models exposing (Hateoas, Post)


type Msg
    = AddPost Models.Post
    | AddingPost String
    | FocusResult (Result Dom.Error ())
    | GetPosts
    | PostsResult (Result Http.Error Models.Hateoas)
    | SubmitPost Models.Post
    | PostCreated (Result Http.Error Models.Post)
    | KeyPressed Keyboard.KeyCode
