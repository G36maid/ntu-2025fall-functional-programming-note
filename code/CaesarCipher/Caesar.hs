{-
   Programming Languages
   Introduction to Haskell: Simple Datatypes and Functions on Lists

   Caesar Cipher

   Autumn 2025
-}

import Prelude ()
import MiniPrelude
import Data.Char

   -- The module Data.Char includes some utility functions related to Char.
   -- Among them we will need:
   --    ord :: Char -> Int
   --    chr :: Int -> Char
   --    isLower :: Char -> Bool

let2int :: Char -> Int
let2int c = ord c - ord 'a'

int2let :: Int -> Char
int2let n = chr (ord 'a' + n)

shift :: Int -> Char -> Char
shift n c = undefined
   -- hint: use isLower.

-- ** Task 1 ** Define
--  encode :: Int -> String -> String
-- that performs Ceaser ciphering.

encode :: Int -> String -> String
encode k = undefined

-- A frequency table of English alphabets.

table :: List Float
table = [8.2, 1.5, 2.8, 4.3, 12.7, 2.2, 2.0, 6.1, 7.0, 0.2, 0.8, 4.0, 2.4,
         6.7, 7.5, 1.9, 0.1, 6.0, 6.3, 9.1, 2.8, 1.0, 2.4, 0.2, 2.0, 0.1]

  -- number of occurrence of a character in a string

count :: Eq a => a -> List a -> Int
count x = undefined

  -- number of lower case letters in a string.

lowers :: String -> Int
lowers = undefined

  -- the function 'histogram' computes the frequency of each
  -- lower case English alphabet in the given string, in percentage.
  -- The denominator should be the *lower case alphabets*.

  -- We will need a function that converts an Int to a Float
  --    fromIntegral :: Int -> Float
  -- so it can be passed to floating point division
  --    (/) :: Float -> Float -> Float

   -- The real type of (/) is actually more general than
   -- the type above, but that does not matter for now.

histogram :: String -> List Float
histogram = undefined

-- The function call
---   chisqr es os
-- computes the similarity between es and os (es is the "model", while
-- os is a particular table to compare against es).
-- The smaller the outcome, the more similar os is to es.

chisqr :: List Float -> List Float -> Float
chisqr es os = sum (zipWith (\e o -> (o - e)^2 / e) es os)

-- ** Task 2 **  Define
--   decode :: String -> String
-- that deciphers a string, without the key.

  -- rotate n xs: rotates xs to the left by n position.
  --  e.g. rotate 3 [1,2,3,4,5] = [4,5,1,2,3]

rotate :: Int -> List a -> List a
rotate n xs = undefined

  -- positions where a character appears.

positions :: Eq a => a -> List a -> List Int
positions x = undefined

  -- the first position where a character appears.

pos :: Eq a => a -> List a -> Int
pos x = undefined

  -- find the key!

   -- It might help to use a function that computes the minimum
   -- element of a list (of numbers)
   --    minimum :: List Float -> Float

   -- Again, the real type of minimum is more general.

crack :: String -> Int
crack xs = undefined

  -- and decode the input string.

decode :: String -> String
decode xs = undefined
