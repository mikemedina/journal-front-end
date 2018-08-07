module Main exposing (..)

import Dom exposing (Error, focus)
import Html exposing (program)
import Http exposing (get, send)
import Json.Encode exposing (Value, object, string)
import Keyboard
import Marshallers exposing (..)
import Messages exposing (..)
import Models exposing (..)
import Task exposing (attempt)
import Views exposing (view)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- INIT


init : ( Model, Cmd Messages.Msg )
init =
    ( Model [] (Models.Post Nothing "") Nothing, Cmd.none )



-- UPDATE


update : Messages.Msg -> Model -> ( Model, Cmd Messages.Msg )
update msg model =
    case msg of
        Messages.AddPost newPost ->
            ( { model
                | posts = model.posts ++ [ newPost ]
                , newPost = Models.Post Nothing ""
              }
            , Dom.focus "new-post" |> Task.attempt FocusResult
            )

        Messages.AddingPost newPost ->
            ( { model
                | newPost = Models.Post Nothing newPost
              }
            , Cmd.none
            )

        Messages.FocusResult result ->
            case result of
                Err (Dom.NotFound id) ->
                    ( model, Cmd.none )

                Ok () ->
                    ( model, Cmd.none )

        Messages.PostsResult (Ok hateoas) ->
            let
                uniquePosts =
                    List.filter (\post -> not (List.member post.id (List.map (\post -> post.id) model.posts))) hateoas.embedded.posts
            in
            ( { model | posts = model.posts ++ uniquePosts }, Cmd.none )

        Messages.PostsResult (Err err) ->
            ( { model | getPostsMessage = Just <| toString err }, Cmd.none )

        Messages.GetPosts ->
            let
                cmd =
                    Http.get "http://localhost:8080/posts/" Marshallers.hateoas
                        |> Http.send PostsResult
            in
            ( model, cmd )

        Messages.SubmitPost post ->
            ( model, createPostCommand post )

        Messages.PostCreated result ->
            ( model, Cmd.none )

        KeyPressed 13 ->
            {- TODO: Check that either the input or the submit button is focused
               Preliminary research suggests this requires using ports to talk to JS
            -}
            ( model, createPostCommand model.newPost )

        KeyPressed keyCode ->
            ( model, Cmd.none )


createPostCommand : Models.Post -> Cmd Msg
createPostCommand post =
    createPostRequest post
        |> Http.send Messages.PostCreated


createPostRequest : Models.Post -> Http.Request Models.Post
createPostRequest post =
    Http.request
        { method = "POST"
        , headers = []
        , url = "http://localhost:8080/posts"
        , body = Http.jsonBody (newPostEncoder post)
        , expect = Http.expectJson Marshallers.post
        , timeout = Nothing
        , withCredentials = False
        }


newPostEncoder : Models.Post -> Json.Encode.Value
newPostEncoder post =
    case post.id of
        Just id ->
            Json.Encode.object
                [ ( "id", Json.Encode.int id )
                , ( "content", Json.Encode.string post.content )
                ]

        Nothing ->
            Json.Encode.object
                [ ( "content", Json.Encode.string post.content )
                ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Messages.Msg
subscriptions _ =
    Keyboard.presses KeyPressed
