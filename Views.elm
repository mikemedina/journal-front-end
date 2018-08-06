module Views exposing (view)

import Dom exposing (Error, focus)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Messages exposing (..)
import Models exposing (Model)


view : Model -> Html Messages.Msg
view model =
    div []
        [ newPostTextArea model
        , newPostSubmitButton model
        , postsList model
        , loadPostsButton
        , loadedPostsStatusMessage model
        ]


newPostTextArea : Model -> Html Messages.Msg
newPostTextArea model =
    textarea [ id "new-post", Html.Attributes.value model.newPost.content, onInput Messages.AddingPost ] []


newPostSubmitButton : Model -> Html Messages.Msg
newPostSubmitButton model =
    button [ onClick (AddPost model.newPost) ] [ text "Submit" ]


postsList : Model -> Html Messages.Msg
postsList model =
    ul [] (listPosts model)


loadPostsButton : Html Messages.Msg
loadPostsButton =
    button [ onClick GetPosts ] [ text "Load Posts" ]


loadedPostsStatusMessage : Model -> Html Messages.Msg
loadedPostsStatusMessage model =
    div [] [ text (Maybe.withDefault "" model.getPostsMessage) ]


listPosts : Model -> List (Html msg)
listPosts model =
    model.posts
        |> List.filter (\post -> not (String.isEmpty post.content))
        |> List.map (\post -> li [] [ text post.content ])
