# Worksheet 1 & 2: Introduction to Haskell (Solutions)

**Author:** Shin-Cheng Mu
**Term:** Autumn 2025

---

## List Deconstruction

1.  **`head`**
    (a) `:t head` -> `[a] -> a`
    (b) i. `head [1, 2, 3]` -> `1`
        ii. `head "abcde"` -> `'a'`
        iii. `head []` -> `*** Exception: Prelude.head: empty list`
    (d) `head` returns the first element of a list. It is a partial function and fails on an empty list.

2.  **`tail`**
    (a) `:t tail` -> `[a] -> [a]`
    (b) i. `tail [1, 2, 3]` -> `[2, 3]`
        ii. `tail "abcde"` -> `"bcde"`
        iii. `tail []` -> `*** Exception: Prelude.tail: empty list`
    (c) `tail` returns all elements of a list except the first one. It is also a partial function.
    (d) The property `head xs : tail xs = xs` does not hold for `xs = []` because both `head []` and `tail []` would cause an error.

3.  **`(:)` (Cons)**
    (a) i. `1 : [2, 3]` -> `[1, 2, 3]`
        ii. `'a' : "bcde"` -> `"abcde"`
        iii. `[1] : [2, 3]` -> **Type Error**. `(:)` expects an element `a` and a list `[a]`. Here, `[1]` is a list `[Int]`, not an element `Int`.
        iv. `[1] : [[2], [3, 4]]` -> `[[1], [2], [3, 4]]`
        v. `[[1]] : [[2], [3, 4]]` -> `[[[1]], [2], [3, 4]]`
        vi. `[1, 2] : 3` -> **Type Error**. The second argument must be a list.
        vii. `[1, 2] : [3]` -> **Type Error**. The first argument must be an element, not a list.
    (b) `(:)` prepends a single element to the front of a list.

4.  **`(++)` (Append)**
    (a) `:t (++)` -> `[a] -> [a] -> [a]`
    (b) i. `[1, 2, 3] ++ [4, 5]` -> `[1, 2, 3, 4, 5]`
        ii. `[] ++ [4, 5]` -> `[4, 5]`
        iii. `[1, 2] ++ []` -> `[1, 2]`
        iv. `1 ++ [2, 3]` -> **Type Error**. First argument must be a list.
        v. `[1, 2] ++ 3` -> **Type Error**. Second argument must be a list.
    (c) `(++)` concatenates two lists.
    (d) `(:)` takes an element and a list. `(++)` takes two lists.

5.  **`last`**
    (a) `:t last` -> `[a] -> a`
    (b) `last [1,2,3]` -> `3`. `last []` -> `*** Exception: Prelude.last: empty list`
    (c) `last` returns the last element of a list. It is a partial function.

6.  **`init`**
    (a) `:t init` -> `[a] -> [a]`
    (b) `init [1,2,3]` -> `[1,2]`. `init []` -> `*** Exception: Prelude.init: empty list`
    (c) `init` returns all elements except the last one. It is a partial function.
    (d) `init xs ++ [last xs] = xs` (for non-empty `xs`).

7.  **`null`**
    (a) `:t null` -> `[a] -> Bool`
    (b) `null []` -> `True`. `null [1]` -> `False`.
    (c) `null [] = True; null (_:_) = False`

## List Generation

1.  (a) `[0..25]` -> `[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]`
    (b) `[0, 2..25]` -> `[0,2,4,6,8,10,12,14,16,18,20,22,24]`
    (c) `[25..0]` -> `[]`
    (d) `['a'..'z']` -> `"abcdefghijklmnopqrstuvwxyz"`
    (e) `[1..]` -> An infinite list of natural numbers `[1,2,3,...]`

2.  (a) `[x | x <- [1..10]]` -> `[1,2,3,4,5,6,7,8,9,10]`
    (b) `[x * x | x <- [1..10]]` -> `[1,4,9,16,25,36,49,64,81,100]`
    (c) `[(x, y) | x <- [0..2], y <- "abc"]` -> `[(0,'a'),(0,'b'),(0,'c'),(1,'a'),(1,'b'),(1,'c'),(2,'a'),(2,'b'),(2,'c')]`
    (d) Type is `[(Integer, Char)]` (or `[(Int, Char)]`).
    (e) `[x * x | x <- [1..10], odd x]` -> `[1,9,25,49,81]`

3.  (a) `[(a, b) | a <- [1..3], b <- [1..2]]` -> `[(1,1),(1,2),(2,1),(2,2),(3,1),(3,2)]`
    (b) `[(a, b) | b <- [1..2], a <- [1..3]]` -> `[(1,1),(2,1),(3,1),(1,2),(2,2),(3,2)]`
    (c) `[(i, j) | i <- [1..4], j <- [(i + 1)..4]]` -> `[(1,2),(1,3),(1,4),(2,3),(2,4),(3,4)]`
    (d) `[(i, j) | i <- [1..4], even i, j <- [(i + 1)..4], odd j]` -> `[(2,3)]`

## Combinators on Lists

1.  **`(!!)`**
    (a) `:t (!!)` -> `[a] -> Int -> a`
    (b) `[1, 2, 3] !! 1` -> `2`. `[1,2,3] !! 3` -> `*** Exception: Prelude.(!!): index too large`
    (c) It returns the element at the specified index (0-based).

2.  **`length`**
    (a) `:t length` -> `[a] -> Int`
    (c) It returns the number of elements in a list.

3.  **`concat`**
    (a) `:t concat` -> `[[a]] -> [a]`
    (c) It flattens a list of lists into a single list.
    (d) `(:)` prepends an element, `(++)` concatenates two lists, `concat` concatenates a list of lists.

4.  **`take`**
    (a) `:t take` -> `Int -> [a] -> [a]`
    (c) It returns the first `n` elements of a list.

5.  **`drop`**
    (a) `:t drop` -> `Int -> [a] -> [a]`
    (c) It returns the list without its first `n` elements.
    (d) `take n xs ++ drop n xs = xs`

6.  **`map`**
    (a) `:t map` -> `(a -> b) -> [a] -> [b]`
    (b) i. `map square [1, 2, 3, 4]` -> `[1,4,9,16]` (assuming `square x = x*x`)
        ii. `map (1+) [1, 2, 3, 4]` -> `[2,3,4,5]`
        iii. `map (const 'a') [1..10]` -> `"aaaaaaaaaa"`
    (c) It applies a function to every element of a list.
    (d) i. `(1+) 2` -> `3`
        ii. `((1+) . (1+) . (1+)) 0` -> `3`

## Sectioning

1.  `doubleAll xs = map (*2) xs`
2.  `quadAll xs = doubleAll . doubleAll $ xs` or `quadAll = map (*4)`

## λ Abstraction

1.  Type is `Num a => a -> a`.
2.  `(λx → x + 1) 2` -> `3`
3.  Type is `Num a => a -> a -> a`.
4.  Type is `Num a => a -> a`.
5.  `(λx → λy → x + 2 * y) 1 2` -> `5`
9.  `doubleAll xs = map (\x -> x * 2) xs`
10. (a) Type is `(a, b) -> (b, a)`.
    (b) `(λ(x, y) → (y, x)) (1, ’a’)` -> `('a', 1)`

## Back to Lists

1.  **`filter`**
    (a) `:t filter` -> `(a -> Bool) -> [a] -> [a]`
    (b) i. `filter even [1..10]` -> `[2,4,6,8,10]`
        ii. `filter (> 10) [1..20]` -> `[11,12,13,14,15,16,17,18,19,20]`
        iii. `filter (\x -> x `mod` 3 == 1) [1..20]` -> `[1,4,7,10,13,16,19]`
    (c) It returns a new list containing only the elements that satisfy the predicate.

2.  **`takeWhile`**
    (a) `:t takeWhile` -> `(a -> Bool) -> [a] -> [a]`
    (b) i. `takeWhile even [1..10]` -> `[]`
        ii. `takeWhile (< 10) [1..20]` -> `[1,2,3,4,5,6,7,8,9]`
    (c) It takes elements from the beginning of a list as long as they satisfy a predicate. It stops at the first element that does not.
    (d) `squaresUpto n = takeWhile (<= n) [x*x | x <- [1..]]`

3.  **`dropWhile`**
    (a) `:t dropWhile` -> `(a -> Bool) -> [a] -> [a]`
    (b) `dropWhile (< 10) [1..20]` -> `[10,11,12,13,14,15,16,17,18,19,20]`
    (c) It removes elements from the beginning of a list as long as they satisfy a predicate.

4.  **`zip`**
    (a) `:t zip` -> `[a] -> [b] -> [(a,b)]`
    (b) i. `zip [1..10] "abcde"` -> `[(1,'a'),(2,'b'),(3,'c'),(4,'d'),(5,'e')]`
        ii. `zip "abcde" [0..]` -> `[('a',0),('b',1),('c',2),('d',3),('e',4)]`
    (c) It pairs up elements from two lists into a list of tuples, stopping at the length of the shorter list.
    (d) `positions x xs = map snd (filter ((==x) . fst) (zip xs [0..]))`
    (e) `pos x xs = head (positions x xs)`
