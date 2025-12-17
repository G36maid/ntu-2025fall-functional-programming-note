import Prelude ()
import MiniPrelude
   hiding ( all, elem, concat, filter, takeWhile
          , reverse)

all :: (a -> Bool) -> List a -> Bool
all p = foldr undefined undefined

elem :: Eq a => a -> List a -> Bool
elem z = foldr undefined undefined

concat :: List (List a) -> List a
concat = foldr undefined undefined

filter :: (a -> Bool) -> List a -> List a
filter p = foldr undefined undefined

takeWhile :: (a -> Bool) -> List a -> List a
takeWhile p = foldr undefined undefined

idL :: List a -> List a
idL = foldr undefined undefined

inits :: List a -> List (List a)
inits = foldr undefined undefined

tails :: List a -> List (List a)
tails = foldr undefined undefined

perms :: List a -> List (List a)
perms = foldr undefined undefined

sublists :: List a -> List (List a)
sublists = foldr undefined undefined

splits :: List a -> List (List a, List a)
splits = foldr undefined undefined

-- scanr f e - map (foldr f e) . tails
scanr :: (a -> b -> b) -> b -> List a -> List b
scanr = undefined

binary :: Nat -> List Nat
binary 0 = []
binary n = n `mod` 2 : binary (n `div` 2)

  -- decimal . binary = id

decimal :: List Nat -> Nat
decimal = foldr undefined undefined

  -- wish: exp m . decimal = foldr step base

fastexp :: Nat -> Nat -> Nat
fastexp m = foldr step base . binary
   where step = undefined
         base = undefined

reverse :: List a -> List a
reverse = foldr undefined undefined

  -- revcat = (++) . reverse
revcat :: List a -> List a -> List a
revcat = foldr undefined undefined

foldN :: (a -> a) -> a -> Nat -> a
foldN = undefined

even' :: Nat -> Bool
even' = foldN undefined undefined

idN :: Nat -> Nat
idN = foldN undefined undefined

  -- plus n = (+n)

plus :: Nat -> Nat -> Nat
plus n = foldN undefined undefined

  -- evenPlus n = even . (+n)

evenPlus :: Nat -> Nat -> Bool
evenPlus n = foldN undefined undefined

fib 0 = 0
fib 1 = 1
-- fib (2+n) = fib (1+n) + fib n
fib n = fib (n-1) + fib (n-2)

 -- fib2 n = (fib (1+n), fib n)

fib2 = foldN undefined undefined


data ITree a = Null | Node a (ITree a) (ITree a)
  deriving (Show, Eq)

data ETree a = Tip a | Bin (ETree a) (ETree a)
  deriving (Show, Eq)

  -- folds, and fold fusion theorems for ITree and ETree?

  -- foldIT :: .... what should its type be?

foldIT = undefined

  -- foldET :: .... what should its type be?

foldET = undefined

--- utilities

infixr 0 ===

(===) :: a -> a -> a
x === y = y
