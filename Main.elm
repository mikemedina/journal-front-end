module Main exposing (..)

import Decoders exposing (..)
import Dom exposing (Error, focus)
import Html exposing (program)
import Http exposing (get, send)
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
                    Http.send PostsResult <|
                        Http.get "http://localhost:8080/posts/" Decoders.hateoas
            in
            ( model, cmd )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Messages.Msg
subscriptions model =
    Sub.none
