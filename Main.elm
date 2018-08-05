module Main exposing (..)

import Decoders exposing (..)
import Dom exposing (Error, focus)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http exposing (get, send)
import Models exposing (..)
import Task exposing (attempt)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { posts : List Models.Post
    , newPost : Models.Post
    , getPostsMessage : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( Model [] (Models.Post Nothing "") Nothing, Cmd.none )



-- UPDATE


type Msg
    = AddPost Models.Post
    | AddingPost String
    | FocusResult (Result Dom.Error ())
    | GetPosts
    | PostsResult (Result Http.Error Models.Hateoas)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddPost newPost ->
            ( { model
                | posts = model.posts ++ [ newPost ]
                , newPost = Models.Post Nothing ""
              }
            , Dom.focus "new-post" |> Task.attempt FocusResult
            )

        AddingPost newPost ->
            ( { model
                | newPost = Models.Post Nothing newPost
              }
            , Cmd.none
            )

        FocusResult result ->
            case result of
                Err (Dom.NotFound id) ->
                    ( model, Cmd.none )

                Ok () ->
                    ( model, Cmd.none )

        PostsResult (Ok hateoas) ->
            let
                uniquePosts =
                    List.filter (\post -> not (List.member post.id (List.map (\post -> post.id) model.posts))) hateoas.embedded.posts
            in
            ( { model | posts = model.posts ++ uniquePosts }, Cmd.none )

        PostsResult (Err err) ->
            ( { model | getPostsMessage = Just <| toString err }, Cmd.none )

        GetPosts ->
            let
                cmd =
                    Http.send PostsResult <|
                        Http.get "http://localhost:8080/posts/" Decoders.hateoas
            in
            ( model, cmd )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ textarea [ id "new-post", Html.Attributes.value model.newPost.content, onInput AddingPost ] []
        , button [ onClick (AddPost model.newPost) ] [ text "Submit" ]
        , ul [] (listPosts model)
        , button [ onClick GetPosts ] [ text "Load Posts" ]
        , div [] [ text (Maybe.withDefault "" model.getPostsMessage) ]
        ]


listPosts : Model -> List (Html msg)
listPosts model =
    model.posts
        |> List.filter (\post -> not (String.isEmpty post.content))
        |> List.map (\post -> li [] [ text post.content ])



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
