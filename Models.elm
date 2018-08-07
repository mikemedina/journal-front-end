module Models exposing (..)

import Date exposing (Date)

type alias Model =
    { posts : List Post
    , newPost : Post
    , getPostsMessage : Maybe String
    , date : Maybe Date
    }


type alias Embedded =
    { posts : List Post }


type alias Post =
    { id : Maybe Int
    , content : String
    , author : Maybe String
    , date : Maybe Date
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



{-
   {
     "_embedded" : {
       "posts" : [ ]
     },
     "_links" : {
       "self" : {
         "href" : "http://localhost:8080/posts{?page,size,sort}",
         "templated" : true
       },
       "profile" : {
         "href" : "http://localhost:8080/profile/posts"
       }
     },
     "page" : {
       "size" : 20,
       "totalElements" : 0,
       "totalPages" : 0,
       "number" : 0
     }
   }
-}
