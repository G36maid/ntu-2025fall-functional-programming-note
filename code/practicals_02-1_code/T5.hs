-- module Main where
import Prelude ()
import MiniPrelude
import M5
import Test.QuickCheck

{- Your code here -}

{- Test your code using quickCheck -}

correct0 :: (List Int -> List (List Int)) -> List Int -> Bool
correct0 f xs = f xs == f0 xs

correct1 :: (List Int -> List Int) -> List Int -> Bool
correct1 f xs = f xs == f1 xs
