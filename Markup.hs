module Markup (
    Document
  , Structure(..)
) where

import GHC.Natural (Natural)

type Document = [Structure]

data Structure
  = Heading       Natural String
  | Paragraph             String
  | CodeBlock             [String]
  | OrderedList           [String]
  | UnorderedList         [String]
  deriving (Show)


