
# Practicals 02-1 Program Synthesis Solutions

## S0.hs
```haskell
--module Main where
import M0
import Test.QuickCheck

{- Your code here -}

withNext :: [a] -> [(a,a)]
withNext xs = zip xs (tail xs)

p2l :: (a,a) -> [a]
p2l (x,y) = [x,y]

adj = concat . map p2l . withNext

{- Test your code using quickCheck -}

correct0 :: ([Int] -> [Int]) -> [Int] -> Bool
correct0 f xs = f xs == f0 xs

correct1 :: ((Int, Int) -> [Int]) -> (Int, Int) -> Bool
correct1 f (x,y) = f (x,y) == f1 (x,y)

correct2 :: ([Int] -> [(Int, Int)]) -> [Int] -> Bool
correct2 f xs = f xs == f2 xs
```

## S1.hs
```haskell
--module Main where
import M1
import Test.QuickCheck

{- Your code here -}

rotate :: Int -> [a] -> [a]
rotate n xs = drop n xs ++ take n xs

rotates :: [a] -> [[a]]
rotates xs = [rotate i xs | i <- [0.. length xs -1]]

{- Test your code using quickCheck -}

correct0 :: ([Integer] -> [[Integer]]) -> [Integer] -> Bool
correct0 f xs = f xs == f0 xs

correct1 :: (Int -> [Integer] -> [Integer]) -> Int -> [Integer] -> Bool
correct1 f n xs = f n xs == f1 n xs
```

## S2.hs
```haskell
--module Main where
import M2
import Test.QuickCheck

{- Your code here -}

rotate2 :: Int -> [a] -> [a]
rotate2 n xs = drop (length xs - n) xs ++ take  (length xs - n) xs

rotates2 :: [a] -> [[a]]
rotates2 xs = [rotate2 i xs | i <- [0.. length xs -1]]

{- Test your code using quickCheck -}

correct0 :: ([Int] -> [[Int]]) -> [Int] -> Bool
correct0 f xs = f xs == f0 xs

correct1 :: (Int -> [Int] -> [Int]) -> Int -> [Int] -> Bool
correct1 f n xs = f n xs == f1 n xs
```

## S3.hs
```haskell
--module Main where
import M3
import Test.QuickCheck

{- Your code here -}


lens :: [a] -> [Int]
lens xs = [0..length xs]

repeatN :: [a] -> [a]
repeatN xs = concat (map (const xs) (lens xs))

{- Test your code using quickCheck -}

correct0 :: ([Int] -> [Int]) -> [Int] -> Bool
correct0 f xs = f xs == f0 xs

correct1 :: ([Int] -> [Int]) -> [Int] -> Bool
correct1 f xs = f xs == f1 xs
```

## S4.hs
```haskell
--module Main where
import M4
import Test.QuickCheck

{- Your code here -}

lens :: [a] -> [Int]
lens xs = [0..length xs]

inits :: [a] -> [[a]]
inits xs = map (\i -> take i xs) (lens xs)

{- Test your code using quickCheck -}

correct0 :: ([Int] -> [[Int]]) -> [Int] -> Bool
correct0 f xs = f xs == f0 xs

correct1 :: ([Int] -> [Int]) -> [Int] -> Bool
correct1 f xs = f xs == f1 xs
```

## S5.hs
```haskell
--module Main where
import M5
import Test.QuickCheck

{- Your code here -}

lens :: [a] -> [Int]
lens xs = [0..length xs]

tails :: [a] -> [[a]]
tails xs = map (\i -> drop i xs) (lens xs)

{- Test your code using quickCheck -}

correct0 :: ([Int] -> [[Int]]) -> [Int] -> Bool
correct0 f xs = f xs == f0 xs

correct1 :: ([Int] -> [Int]) -> [Int] -> Bool
correct1 f xs = f xs == f1 xs
```

## S6.hs
```haskell
--module Main where
import M6
import Test.QuickCheck

{- Your code here -}

occurs :: Eq a => a -> [a] -> [a]
occurs x = filter (x==)

count :: Eq a => a -> [a] -> Int
count x xs = length (filter (x ==) xs)

{- Test your code using quickCheck -g}

correct0 :: (Int -> [Int] -> Int) -> Int -> [Int] -> Bool
correct0 f x xs = f x xs == f0 x xs

correct1 :: (Int -> [Int] -> [Int]) -> Int -> [Int] -> Bool
correct1 f x xs = f x xs == f1 x xs
```

## S7.hs
```haskell
--module Main where
import M7
import Test.QuickCheck

{- Your code here -}

withNext :: [a] -> [(a,a)]
withNext xs = zip xs (tail xs)

eqNext :: Eq a => a -> [a] -> [(a,a)]
eqNext x = filter ((x ==) . fst) . withNext

{- Test your code using quickCheck -}

correct0 :: (Int -> [Int] -> [(Int,Int)]) -> Int -> [Int] -> Bool
correct0 f x xs = f x xs == f0 x xs

correct1 :: ([Int] -> [(Int,Int)]) -> [Int] -> Bool
correct1 f xs = f xs == f1 xs
```

## S8.hs
```haskell
--module Main where
import M8
import Test.QuickCheck

{- Your code here -}

withNext :: [a] -> [(a,a)]
withNext xs = zip xs (tail xs)

eqPrev :: Eq a => a -> [a] -> [(a,a)]
eqPrev x = filter ((x ==) . snd) . withNext

{- Test your code using quickCheck -}

correct0 :: (Int -> [Int] -> [(Int,Int)]) -> Int -> [Int] -> Bool
correct0 f x xs = f x xs == f0 x xs

correct1 :: ([Int] -> [(Int,Int)]) -> [Int] -> Bool
correct1 f xs = f xs == f1 xs
```

## S9.hs
```haskell
--module Main where
import M9
import Test.QuickCheck

{- Your code here -}


idx1 :: [a] -> [(a,Int)]
idx1 xs = filter (\(x,n) -> n `mod` 3 /= 0)
            (zip xs [0..])

idx2 :: [a] -> [a]
idx2 = map fst . idx1

{- Test your code using quickCheck -}

correct0 :: ([Int] -> [Int]) -> [Int] -> Bool
correct0 f xs = f xs == f0 xs

correct1 :: ([Int] -> [(Int,Int)]) -> [Int] -> Bool
correct1 f xs = f xs == f1 xs
```

## SChallenge.hs
```haskell
--module Main where
import MChallenge
import Test.QuickCheck

{- Your code here -g}

find' :: Eq a => [a] -> [a] -> [a]
find' xs ys = head (filter (\zs -> xs == take (length xs) zs) (tails ys))

tails :: [a] -> [[a]]
tails xs = map (\i -> drop i xs) (lens xs)

lens :: [a] -> [Int]
lens xs = [i | i <- [0..length xs]]

{- Equivalently:

tails :: [a] -> [[a]]
tails = foldr (\x xss -> (x : head xss) : xss) [[]]

-}

{- Test your code using quickCheck -}

correct0 :: ([Int] -> [Int] -> [Int]) -> [Int] -> [Int] -> Bool
correct0 f xs ys = f xs ys == find xs ys
```
