import Prelude ()
import MiniPrelude hiding (exp)
import Test.QuickCheck

{-
 Install QuickCheck by issueing the command:
   cabal install QuickCheck
 in your shell.

 In ghci you might need to issue the command:
   :set -package QuickCheck

 Test a property by evaluating in GHCi:
   quickCheck (property)
 for more information on what is being checked:
   verboseCheck (property)
-}

-- Q1

data ITree a = Null | Node a (ITree a) (ITree a)
  deriving (Show, Eq)

-- allowing us to display trees of this type, and
-- checking for equality.

it0 :: ITree Int
it0 = Node 26 (Node 8 (Node 4 Null Null)
                      (Node 2 Null Null))
              (Node 9 Null
                      (Node 3 (Node 1 Null Null)
                              Null))

it1 :: ITree Char
it1 = undefined --- try creating some trees!

sumT :: ITree Int -> Int
sumT = undefined -- define this!

baobab :: ITree Int -> Bool
baobab Null         = True
baobab (Node x t u) = baobab t && baobab u && x > sumT t + sumT u

bbsum t = (undefined, undefined)

baobab' = fst . bbsum'

-- calculate a faster version of bbsum!

bbsum' = undefined

baobab_correct :: ITree Int -> Bool
baobab_correct t = baobab' t == baobab t

-- Q2

data ETree a = Tip a | Bin (ETree a) (ETree a)
  deriving (Show, Eq)

et0 :: ETree Char
et0 = Bin (Bin (Bin (Tip 'a') (Tip 'b'))
               (Tip 'c'))
          (Bin (Tip 'd')
               (Bin (Tip 'e') (Tip 'f')))

et1 :: ETree Int
et1 = undefined -- try creating some trees!

size :: ETree a -> Nat
size (Tip _) = 1
size _       = undefined -- finish this

repl :: ETree a -> List b -> ETree b
repl (Tip _)   xs = Tip (head xs)
repl (Bin t u) xs = Bin (repl t (take n xs)) (repl u (drop n xs))
  where n = size t

-- wish: fst (replTail s xs) = repl s xs
replTail :: ETree a -> List b -> (ETree a, List b)
replTail s xs = (undefined, undefined)
  where n = size s

repl' s xs = fst (replTail s xs)

-- calculate a faster version of replTail!

replTail' = undefined

repl_correct :: ETree Int -> Bool
repl_correct t = repl' t [0..] == repl t [0..]

-- Q3

tags :: ITree a -> List a
tags Null         = []
tags (Node x t u) = tags t ++ [x] ++ tags u

tagsAcc :: ITree a -> List a -> List a
tagsAcc t ys = tags t ++ ys

-- redefine tag in terms of tagsAcc!

tags' = undefined

-- calculate a faster version of tagsAcc.

tagsAcc' = undefined

tags_correct :: ITree Int -> Bool
tags_correct t = tags' t == tags t

-- Q4

fact :: Nat -> Nat
fact 0 = 1
-- fact (1+n) = (1+n) * fact n
fact n = n * fact (n - 1)

factAcc n m = undefined

-- define fact in terms of factAcc

fact' = undefined

-- calculate a faster version of factAcc.

factAcc' = undefined

fact_correct :: NonNegative Nat -> Bool
fact_correct (NonNegative n) = fact' n == fact n

-- Q5

exp :: Nat -> Nat -> Nat
exp b 0 = 1
-- exp b (1+ n) = b * exp b n
exp b n = b * exp b (n - 1)

expAcc :: Nat -> Nat -> Nat -> Nat
expAcc b n x = x * exp b n

-- how do you compute b^n using expAcc?

exp' b n = undefined

-- calculate a faster version of expAcc.

expAcc' b n x = undefined

exp_correct :: NonNegative Nat -> NonNegative Nat -> Bool
exp_correct (NonNegative b) (NonNegative n) = exp' b n == exp b n

-- Q6

fib :: Nat -> Nat
fib = undefined -- finish this

ffib :: Nat -> Nat -> Nat -> Nat
ffib n x y = fib n * x + fib (1 + n) * y

-- how to compute fib using ffib?

fib' :: Nat -> Nat
fib' n = undefined --- using ffib

-- calculate a faster version of ffib.

ffib' n x y = undefined

fib_correct1 :: NonNegative Nat -> Bool
fib_correct1 (NonNegative n) = fib' n == fib n

-- Alternatively, use tupling.

fib2 :: Nat -> (Nat, Nat)
fib2 n = (fib n, fib (1 + n))

-- define fib in terms of fib2

fib'' = undefined

-- calculate a faster version of fib2.

fib2' = undefined

fib_correct2:: NonNegative Nat -> Bool
fib_correct2 (NonNegative n) = fib'' n == fib n

--- utilities

infixr 0 ===

(===) :: a -> a -> a
x === y = y

instance Arbitrary a => Arbitrary (ITree a) where
  arbitrary = sized arbITree

arbITree :: Arbitrary a => Int -> Gen (ITree a)
arbITree 0 = return Null
arbITree n = do n' <- choose (0,n)
                x <- arbitrary
                t <- arbITree (n' `div` 2)
                u <- arbITree (n' `div` 2)
                return (Node x t u)

instance Arbitrary a => Arbitrary (ETree a) where
  arbitrary = sized arbETree

arbETree :: Arbitrary a => Int -> Gen (ETree a)
arbETree 0 = Tip <$> arbitrary
arbETree n = do n' <- choose (0,n)
                t <- arbETree (n' `div` 2)
                u <- arbETree (n' `div` 2)
                return (Bin t u)
