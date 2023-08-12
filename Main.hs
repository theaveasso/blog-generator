module Main where

import Html
import Markup

txt1 :: Document
txt1 = 
  [ Paragraph "Hello, world!"
  ]

txt2 :: Document
txt2 = 
  [ Heading 1 "Welcome"
  , Paragraph "To this tutorial about Haskell."
  ]

txt3 :: Document
txt3 =
  [ Paragraph "Remember that multiple lines with no separation are grouped together into a single paragraph but list items remain separate."
  , OrderedList 
    [ "Item 1 of a list"
    , "Item 2 of the same list"
    ]
  ]

txt4 :: Document
txt4 = 
  [ Heading 1 "Compiling programs with ghc"
  , Paragraph "Running ghc invokes the Glasgow Haskell Compiler (GHC), and can be used to compile Haskell modules and programs into native executables and libraries."
  , Paragraph "Create a new Haskell source file named hello.hs, and write the following code in it:"
  , CodeBlock 
    [ "main = putStrLn \"Hello, Haskell!\"" 
    ]
  , Paragraph "Now, we can compile the program by invoking ghc with the file name:"
  , CodeBlock
    [ "➜ ghc hello.hs"
    , "[1 of 1] Compiling Main             ( hello.hs, hello.o )"
    , "Linking hello ..."
    ]
  , Paragraph "GHC created the following files:"
  , UnorderedList 
    [ "hello.hi - Haskell interface file"
    , "hello.o - Object file, the output of the compiler before linking"
    , "hello (or hello.exe on Microsoft Windows) - A native runnable executable."
    ]
  , Paragraph "GHC will produce an executable when the source file satisfies both conditions:"
  , OrderedList 
    [ "Defines the main function in the source file"
    , "Defines the module name to be Main or does not have a module declaration"
    ]
  , Paragraph "Otherwise, it will only produce the .o and .hi files."
  ]

htmlToRender :: Html
htmlToRender = 
  html_ "t80" $ 
      h1_ "This is heading" <>
      p_ "This is paragraph #1" <>
      p_ "This is paragraph #2" <> 
      p_ "This is paragraph #3" <>
      p_ "This is paragraph #4" <>
      p_ "$ % & * ' \" !" <>
      ul_ 
        [ p_ "item 1"
        , p_ "item 2"
        , p_ "item 3"
      ]

main :: IO ()
main = do
  putStrLn $ render htmlToRender
