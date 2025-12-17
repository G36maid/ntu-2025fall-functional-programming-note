import Prelude hiding (repeat, map, zipWith, (^))
import qualified Prelude

-- The Stream type

type Stream a = [a]

-- Combinators and Instances defined in the handouts

repeat :: a -> Stream a
repeat x = x : repeat x

map f xs = f (head xs) : map f (tail xs)

zipWith f xs ys = f (head xs) (head ys) : zipWith f (tail xs) (tail ys)


instance Num a => Num (Stream a) where
  (+) = zipWith (+)
  (-) = zipWith (-)
  (*) = zipWith (*)
  negate = map negate
  abs = map abs
  signum = map signum
  fromInteger n = repeat (fromInteger n)

infixr 5 \/

(\/) :: Stream a -> Stream a -> Stream a
xs \/ ys = head xs : ys \/ tail xs




--

infixr 8 ^

(^) :: Stream Int -> Stream Int -> Stream Int
xs ^ ys = head xs Prelude.^  head ys : tail xs ^ tail ys
