module Html.Internal where

import Data.List

newtype Html      = Html      String
newtype Structure = Structure String

type    Title     =           String

append_ :: Structure -> Structure -> Structure
append_ (Structure a) (Structure b) = Structure (a <> b)

getStructureStr :: Structure -> String
getStructureStr (Structure content) = content 

render :: Html -> String
render (Html content) = content 

escape :: String -> String
escape =
  let 
    escapeChar c =
      case c of
        '<'  -> "&lt;"
        '>'  -> "&gt;"
        '&'  -> "&amp;"
        '"'  -> "&quot;"
        '\'' -> "&#39;"
        _    -> [c]
  in
    concat . map escapeChar

tag_  :: String -> String -> String
tag_  tag content = 
  "<" <> tag <> ">" <> content <> "</" <> tag <> ">" 

html_ :: Title -> Structure -> Html
html_ title content =
  Html
    ( tag_ "html"
      ( tag_ "head" (tag_ "title" $ escape title)
        <> tag_ "body" (getStructureStr content)
      )
    )

body_ :: String -> Structure
body_ = Structure . tag_ "body"

head_ :: String -> String
head_ = tag_ "head"

title_ :: String -> String
title_ = tag_ "title"

h1_ :: String -> Structure
h1_ = Structure . tag_ "h1" . escape

ul_ :: [Structure] -> Structure 
ul_ = Structure . tag_ "ul" . concat . map (tag_ "li" . getStructureStr)

ol_ :: [Structure] -> Structure 
ol_ = Structure . tag_ "ol" . concat . map (tag_ "li" . getStructureStr)

pre_ :: String -> Structure
pre_ = Structure . tag_ "pre" . escape

p_ :: String -> Structure
p_ = Structure . tag_ "p" . escape

