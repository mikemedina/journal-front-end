module Models exposing (..)


type alias Model =
    { posts : List Post
    , newPost : Post
    , getPostsMessage : Maybe String
    }


type alias Embedded =
    { posts : List Post }


type alias Post =
    { id : Maybe Int
    , content : String
    }


type alias Link =
    { href : String }


type alias Links =
    { self : Link
    , post : Maybe Link
    , profile : Maybe Link
    }


type alias Page =
    { size : Int
    , totalElements : Int
    , totalPages : Int
    , number : Int
    }


type alias Hateoas =
    { embedded : Embedded
    , links : Links
    , page : Page
    }
