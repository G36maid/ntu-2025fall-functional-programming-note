-- module Main where
import Prelude()
import MiniPrelude
import M1
import Test.QuickCheck

{- Your code here -}


{- Test your code using quickCheck -}

correct0 :: (List Integer -> List (List Integer)) -> List Integer -> Bool
correct0 f xs = f xs == f0 xs

correct1 :: (Int -> List Integer -> List Integer) -> Int -> List Integer -> Bool
correct1 f n xs = f n xs == f1 n xs
