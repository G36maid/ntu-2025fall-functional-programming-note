# Worksheet 3: Definition and Proof by Induction

**Author:** Shin-Cheng Mu
**Term:** Autumn 2025

---

This worksheet is to fill in the definitions and proofs discussed in the lecture.

## 1. Induction on Natural Numbers

Finish the definitions.

```haskell
(+) :: Nat -> Nat -> Nat
0 + n       = n
(1+ m) + n  = 1 + (m + n)

(×) :: Nat -> Nat -> Nat
0 × n       = 0
(1+ m) × n  = n + (m * n) -- Assuming n is added m+1 times

exp :: Nat -> Nat -> Nat
exp b 0     = 1
exp b (1+ n) = b * exp b n
```

## 2. Induction on Lists

```haskell
sum :: [Int] -> Int
sum []        = 0
sum (x : xs)  = x + sum xs

map :: (a -> b) -> [a] -> [b]
map f []        = []
map f (x : xs)  = f x : map f xs

(++) :: [a] -> [a] -> [a]
[] ++ ys       = ys
(x : xs) ++ ys = x : (xs ++ ys)
```

**Prove: `xs ++ (ys ++ zs) = (xs ++ ys) ++ zs`.**

*Proof. Induction on `xs`.*

*   **Case `xs := []`:**
    ```
    [] ++ (ys ++ zs)
    = { def of ++ }
    ys ++ zs
    = { def of ++, applied to [] ++ ys }
    ([] ++ ys) ++ zs
    ```

*   **Case `xs := x : xs`:**
    ```
    (x : xs) ++ (ys ++ zs)
    = { def of ++ }
    x : (xs ++ (ys ++ zs))
    = { induction hypothesis }
    x : ((xs ++ ys) ++ zs)
    = { def of ++ }
    (x : (xs ++ ys)) ++ zs
    = { def of ++ }
    ((x:xs) ++ ys) ++ zs
    ```

---

**`length` defined inductively:**
```haskell
length :: [a] -> Int
length []       = 0
length (x : xs) = 1 + length xs
```

**`concat` repeatedly calls `(++)`:**
```haskell
concat :: [[a]] -> [a]
concat []         = []
concat (xs : xss) = xs ++ concat xss
```

**`filter p xs` keeps only those elements in `xs` that satisfy `p`:**
```haskell
filter :: (a -> Bool) -> [a] -> [a]
filter p []       = []
filter p (x : xs) | p x       = x : filter p xs
                  | otherwise = filter p xs
```

**`take` and `drop`:**
```haskell
take :: Int -> [a] -> [a]
take 0 xs         = []
take n []         = []
take n (x : xs)   = x : take (n-1) xs

drop :: Int -> [a] -> [a]
drop 0 xs         = xs
drop n []         = []
drop n (x : xs)   = drop (n-1) xs
```

**`takeWhile p xs` yields the longest prefix of `xs` such that `p` holds for each element:**
```haskell
takeWhile :: (a -> Bool) -> [a] -> [a]
takeWhile p []       = []
takeWhile p (x : xs) | p x       = x : takeWhile p xs
                     | otherwise = []
```

**`dropWhile p xs` drops the prefix from `xs`:**
```haskell
dropWhile :: (a -> Bool) -> [a] -> [a]
dropWhile p []       = []
dropWhile p (x : xs) | p x       = dropWhile p xs
                     | otherwise = x : xs
```

**List reversal:**
```haskell
reverse :: [a] -> [a]
reverse []       = []
reverse (x : xs) = reverse xs ++ [x]
```

**`inits` and `tails`:**
- `inits [1, 2, 3] = [[], [1], [1, 2], [1, 2, 3]]`
- `tails [1, 2, 3] = [[1, 2, 3], [2, 3], [3], []]`
```haskell
inits :: [a] -> [[a]]
inits []       = [[]]
inits (x : xs) = [] : map (x:) (inits xs)

tails :: [a] -> [[a]]
tails []       = [[]]
tails (x : xs) = (x:xs) : tails xs
```

**`fib` with multiple base cases:**
```haskell
fib :: Nat -> Nat
fib 0 = 0
fib 1 = 1
fib (n+2) = fib (n+1) + fib n
```

**`merge` two sorted lists:**
```haskell
merge :: [Int] -> [Int] -> [Int]
merge [] [] = []
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys) | x <= y    = x : merge xs (y:ys)
                    | otherwise = y : merge (x:xs) ys
```

**`zip`:**
```haskell
zip :: [a] -> [b] -> [(a, b)]
zip [] _ = []
zip _ [] = []
zip (x:xs) (y:ys) = (x,y) : zip xs ys
```

**Non-structural induction: `msort`**
```haskell
msort :: [Int] -> [Int]
msort []  = []
msort [x] = [x]
msort xs  = merge (msort left) (msort right)
    where
        half = length xs `div` 2
        left = take half xs
        right = drop half xs
```

## 3. User Defined Inductive Datatypes

**Internally labelled binary trees:**
```haskell
data Tree a = Null | Node a (Tree a) (Tree a)
```

**Inductively defined function on `Tree`:**
```haskell
sumT :: Tree Int -> Int
sumT Null           = 0
sumT (Node x t u) = x + sumT t + sumT u
```