import Prelude ()
import MiniPrelude
import MChallenge
import Test.QuickCheck

{- Your code here -}

{- Test your code using quickCheck -}

correct0 :: (List Int -> List Int -> List (List Int)) -> List Int -> List Int -> Bool
correct0 f xs ys = f xs ys == find xs ys
