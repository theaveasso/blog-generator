module Markup.Internal where

import GHC.Natural (Natural)
import Data.Maybe
import Data.Char

type Document = [Structure]

data Structure
  = Heading       Natural String
  | Paragraph             String
  | CodeBlock             [String]
  | OrderedList           [String]
  | UnorderedList         [String]
  deriving (Show)


parse :: String -> Document
parse = parseLines Nothing . lines 

trim :: String -> String
trim = unwords . words

isEmptyLine :: String -> Bool
isEmptyLine = null . trim

createParagraph :: [String] -> String
createParagraph = unlines . reverse

parseLines :: Maybe Structure -> [String] -> Document
parseLines context [] = maybeToList context
parseLines context (line:rest)
  | isEmptyLine line    = parseLines context rest
  | isHeading line      = maybe id (:) context (parseHeading line : parseLines Nothing rest)
  | isUnorderdList line = 
    case context of
      Just(UnorderedList li) -> parseLines (Just (UnorderedList (li <> [trim line]))) rest
      _                      -> maybe id (:) context (parseLines (Just (UnorderedList [trim line])) rest)
  | isOrderdList line = 
    case context of
      Just(OrderedList li)   -> parseLines (Just (OrderedList (li <> [trim line]))) rest
      _                      -> maybe id (:) context (parseLines (Just (OrderedList [trim line])) rest)
  | otherwise           = 
    case context of
      Just(Paragraph p) -> parseLines (Just (Paragraph (unwords [p, line]))) rest
      _                 -> maybe id (:) context (parseLines (Just $ parseParagraph line) rest)


-- Heading
isHeading :: String -> Bool
isHeading str = 
  numHashes > 0 && numHashes <= 7
  where numHashes = countHashes str

-- UnorderedList
isUnorderdList :: String -> Bool
isUnorderdList ('-' : ' ' : _) = True
isUnorderdList _               = False

-- OrderedList
isOrderdList :: String -> Bool
isOrderdList str =
  case dropWhile (\c -> isDigit c || c == ' ') str of
    (')' : ' ' : _) -> True
    ('.' : ' ' : _) -> True
    _               -> False
    

countHashes :: String -> Int
countHashes = length . takeWhile (== '#')

dropHashes :: String -> String
dropHashes = dropWhile (== '#')

parseHeading :: String -> Structure
parseHeading = Heading <$> fromIntegral . countHashes <*> id (trim . dropHashes)

parseParagraph :: String -> Structure
parseParagraph = Paragraph

addHeading :: Maybe Structure -> Structure -> Maybe Structure
addHeading Nothing heading            = Just heading
addHeading (Just currrentStructure) _ = Just currrentStructure

addToStructure :: Maybe Structure -> String -> Maybe Structure
addToStructure (Just (Paragraph existingParagraph)) newLine = Just (Paragraph (unlines [existingParagraph, newLine]))
addToStructure currrentStructure _ = currrentStructure
