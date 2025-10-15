-- module Main where
import Prelude()
import MiniPrelude
import M0
import Test.QuickCheck

{- Your code here -}

{- Test your code using quickCheck -}

correct0 :: (List Int -> List Int) -> List Int -> Bool
correct0 f xs = f xs == f0 xs

correct1 :: ((Int, Int) -> List Int) -> (Int, Int) -> Bool
correct1 f (x,y) = f (x,y) == f1 (x,y)

correct2 :: (List Int -> List (Int, Int)) -> List Int -> Bool
correct2 g xs = g xs == f2 xs
