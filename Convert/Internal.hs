module Covert where

import qualified Markup
import qualified Html

convertStructure :: Markup.Structure -> Html.Structure
convertStructure s =
  case s of
    Markup.Heading 1 txt      -> Html.h1_ txt
    Markup.Paragraph p        -> Html.p_ p
    Markup.UnorderedList list -> Html.li_ $ map Html.p_ list
    Markup.OrderedList list   -> Html.ol_ $ map Html.p_ list
    Markup.CodeBlock pre      -> Html.pre_ $ unlines pre
