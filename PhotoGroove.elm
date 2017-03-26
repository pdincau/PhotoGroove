module PhotoGroove exposing (..)

import Html exposing  (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)
import Array exposing(..)

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
    , thumbnailSize : ThumbnailSize
    }

type alias Msg =
    { operation : String, data : String
    }

initialModel : Model
initialModel =
    { photos =
        [ { url = "1.jpeg" }
        , { url = "2.jpeg" }
        , { url = "3.jpeg" }
        ]
    , selectedUrl = "1.jpeg"
    , thumbnailSize = Medium
    }

photoArray : Array Photo
photoArray = Array.fromList initialModel.photos

view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ h1 [] [ text "Photo Groove" ]
        , button [
            onClick { operation = "SURPRISE_ME", data = "" } ]
            [ text "Surprise me!" ]
        , h3 [] [ text "Thumbnail Size:" ]
        , div [ id "choose-size" ]
              ( List.map viewSizeChooser [ Small, Medium, Large ] )
        , div [ id "thumbnails", class (sizeToString model.thumbnailSize) ] ( List.map (viewThumbnail model.selectedUrl) model.photos )
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
    , onClick { operation = "SELECT_PHOTO", data = thumbnail.url }
    ]
    []

viewSizeChooser : ThumbnailSize -> Html Msg
viewSizeChooser size =
    label []
        [ input [ type_ "radio", name "size" ] []
        , text (sizeToString size)
        ]

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
    case msg.operation of
        "SELECT_PHOTO" ->
            { model | selectedUrl = msg.data }
        "SURPRISE_ME" ->
            { model | selectedUrl = "2.jpeg" }
        _ ->
            model

main =
    Html.beginnerProgram
    { model = initialModel
    , view = view
    , update = update
    }
