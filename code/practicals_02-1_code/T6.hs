-- module Main where
import Prelude ()
import MiniPrelude
import M6
import Test.QuickCheck

{- Your code here -}

{- Test your code using quickCheck -}

correct0 :: (Int -> List Int -> Int) -> Int -> List Int -> Bool
correct0 f x xs = f x xs == f0 x xs

correct1 :: (Int -> List Int -> List Int) -> Int -> List Int -> Bool
correct1 f x xs = f x xs == f1 x xs
