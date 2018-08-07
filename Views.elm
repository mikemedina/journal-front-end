module Views exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Messages exposing (..)
import Models exposing (Model, Post)
import Date exposing (Date)
import Date.Format exposing (format)


view : Model -> Html Messages.Msg
view model =
    div [ class "content" ]
        [ h1 [] [ text "Journal" ]
        , newPostForm model
        , postsList model
        , loadPostsButton
        , loadedPostsStatusMessage model
        ]


newPostForm : Model -> Html Messages.Msg
newPostForm model =
    div [ class "my-form card" ]
        [ newPostTextArea model
        , newPostButtons model
        ]


newPostTextArea : Model -> Html Messages.Msg
newPostTextArea model =
    textarea [ id "new-post", rows 5, Html.Attributes.value model.newPost.content, onInput Messages.AddingPost ] []


newPostButtons : Model -> Html Messages.Msg
newPostButtons model =
    div [] [ button [ class "btn btn-primary", onClick (AddPost model.newPost) ] [ text "Submit" ] ]


postsList : Model -> Html Messages.Msg
postsList model =
    div [ class "posts" ] (listPosts model)


loadPostsButton : Html Messages.Msg
loadPostsButton =
    button [ class "btn btn-primary", onClick GetPosts ] [ text "Load Posts" ]


loadedPostsStatusMessage : Model -> Html Messages.Msg
loadedPostsStatusMessage model =
    div [] [ text (Maybe.withDefault "" model.getPostsMessage) ]


listPosts : Model -> List (Html msg)
listPosts model =
    model.posts
        |> List.filter (\post -> not (String.isEmpty post.content))
        |> List.map journalPost


journalPost : Post -> Html msg
journalPost post =
    div [ class "card" ]
        [ text post.content
        , hr [] []
        , div [ class "post-info" ]
            [ span [ class "post-author" ] [ text (Maybe.withDefault "anonymous" post.author) ]
            , span [ class "post-date" ] [ text (prettyDate post.date) ]
            ]
        ]


prettyDate : Maybe Date -> String
prettyDate date =
    case date of
        Just date ->
            format "%B %e, %Y" date

        Nothing ->
            "Febtober 51th, 2088"
