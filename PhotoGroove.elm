module PhotoGroove exposing (..)

import Html exposing  (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)
import Array exposing(..)
import Random

urlPrefix : String
urlPrefix = "http://elm-in-action.com/"

type ThumbnailSize
    = Small
    | Medium
    | Large

type alias Photo =
    { url : String }

type alias Model =
    { photos : List Photo
    , selectedUrl : String
    , chosenSize : ThumbnailSize
    }

type Msg
    = SelectByUrl String
    | SurpriseMe
    | SetSize ThumbnailSize

initialModel : Model
initialModel =
    { photos =
        [ { url = "1.jpeg" }
        , { url = "2.jpeg" }
        , { url = "3.jpeg" }
        ]
    , selectedUrl = "1.jpeg"
    , chosenSize = Medium
    }

photoArray : Array Photo
photoArray = Array.fromList initialModel.photos

randomPhotoPicker : Random.Generator Int
randomPhotoPicker =
    Random.int 0 (Array.length photoArray - 1)

view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ h1 [] [ text "Photo Groove" ]
        , button [
            onClick SurpriseMe ]
            [ text "Surprise me!" ]
        , h3 [] [ text "Thumbnail Size:" ]
        , div [ id "choose-size" ]
              ( List.map viewSizeChooser [ Small, Medium, Large ] )
        , div [ id "thumbnails", class (sizeToString model.chosenSize) ] ( List.map (viewThumbnail model.selectedUrl) model.photos )
        , img [
            class "large"
            , src (urlPrefix ++ "large/" ++ model.selectedUrl)
            ]
            []
        ]

viewThumbnail : String -> Photo -> Html Msg
viewThumbnail selectedUrl thumbnail =
    img [ src (urlPrefix ++ thumbnail.url)
    , classList [ ("selected", selectedUrl == thumbnail.url ) ]
    , onClick ( SelectByUrl thumbnail.url )
    ]
    []

viewSizeChooser : ThumbnailSize -> Html Msg
viewSizeChooser size =
    label []
        [ input [ type_ "radio", name "size",  onClick (SetSize size) ] []
        , text (sizeToString size)
        ]

getPhotoUrl : Int -> String
getPhotoUrl index =
    case Array.get index photoArray of
        Just photo ->
            photo.url
        Nothing ->
            ""


sizeToString: ThumbnailSize -> String
sizeToString size =
    case size of
        Small ->
            "small"
        Medium ->
            "med"
        Large ->
            "large"

update: Msg -> Model -> Model
update msg model =
    case msg of
        SelectByUrl url ->
            { model | selectedUrl = url }
        SurpriseMe ->
            { model | selectedUrl = "2.jpeg" }
        SetSize size ->
            { model | chosenSize = size }

main =
    Html.beginnerProgram
    { model = initialModel
    , view = view
    , update = update
    }
