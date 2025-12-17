# Practicals 7 Solutions: Folds, and Fold-Fusion

**Original Document**: [practicals_07_sols.pdf](../../course-materials/practicals/practicals_07_sols.pdf)

---

1.  **Express the following functions by `foldr`:**

    1.  `all p = foldr (\x b -> p x && b) True`
    2.  `elem x = foldr (\y b -> x == y || b) False`
    3.  `concat = foldr (++) []`
    4.  `filter p = foldr (\x xs -> if p x then x : xs else xs) []`
    5.  `takeWhile p = foldr (\x xs -> if p x then x : xs else []) []`
    6.  `id = foldr (:) []`

2.  **Given `p :: a -> Bool`, can `dropWhile p :: List a -> List a` be written as a `foldr`?**

    **Solution**: No.
    Consider `dropWhile even [5, 4, 2, 1]`, which ought to be `[5, 4, 2, 1]`.
    Meanwhile, `dropWhile even [4, 2, 1] = [1]`.
    In a `foldr`, the processing of the tail `[4, 2, 1]` would yield a result (presumably `[1]`), and the step function would then have to combine `5` with `[1]` to get `[5, 4, 2, 1]`. But if the list was `[4, 2, 1]` (head is `4`), it would combine `4` with `[1]` (result of tail `[2, 1]`) to get `[1]`.
    Essentially, `foldr` processes from right to left, but `dropWhile`'s decision depends on the prefix (left to right) until the condition fails. The lost elements cannot be recovered from the result of the recursive call.

3.  **Express the following functions by `foldr`:**

    1.  `inits = foldr (\x xss -> [] : map (x :) xss) [[]]`
    2.  `tails = foldr (\x xss -> (x : head xss) : xss) [[]]`
    3.  `perms = foldr (\x xss -> concat (map (fan x) xss)) [[]]`
        (where `fan` inserts `x` into all positions of a list)
    4.  `sublists = foldr (\x xss -> xss ++ map (x :) xss) [[]]`
    5.  `splits = foldr spl [([], [])]`
        where
        ```haskell
        spl x ((xs, ys) : zss) = ([], x : xs ++ ys) : map ((x :) `cross` id) ((xs, ys) : zss)
        (f `cross` g) (x, y) = (f x, g y)
        ```

4.  **Prove the `foldr`-fusion theorem.**

    The aim is to prove that `h (foldr f e xs) = foldr g (h e) xs` for all `xs`, assuming that `h (f x y) = g x (h y)`.

    **Proof by induction on `xs`:**

    Case `xs := []`:
    ```haskell
    h (foldr f e [])
    = h e
    = foldr g (h e) []
    ```

    Case `xs := x : xs`:
    ```haskell
    h (foldr f e (x : xs))
    = { definition of foldr }
    h (f x (foldr f e xs))
    = { fusion condition: h (f x y) = g x (h y) }
    g x (h (foldr f e xs))
    = { induction }
    g x (foldr g (h e) xs)
    = { definition of foldr }
    foldr g (h e) (x : xs)
    ```

5.  **Prove the map-fusion rule `map f . map g = map (f . g)` by `foldr`-fusion.**

    Since `map g` is a `foldr`, we proceed as follows:

    ```haskell
    map f . map g
    = { map g is a foldr }
    map f . foldr (\x ys -> g x : ys) []
    = { foldr-fusion }
    foldr (\x ys -> f (g x) : ys) []
    = { definition of map as a foldr }
    map (f . g)
    ```

    The fusion condition is proved below:
    ```haskell
    map f (g x : ys)
    = { definition map }
    f (g x) : map f ys
    ```

6.  **Prove that `sum . concat = sum . map sum` by `foldr`-fusion.**

    ```haskell
    sum . concat
    = sum . foldr (++) []
    = { foldr-fusion }
    foldr (\xs n -> sum xs + n) 0
    = { foldr-map fusion, see Exercise 7 }
    foldr (+) 0 . map sum
    = sum . map sum
    ```

    The fusion condition for the `foldr`-fusion is `sum (xs ++ ys) = sum xs + sum ys`.
    The penultimate equality holds because `(+) . sum = (\xs n -> sum xs + n)`.

7.  **The `foldr`-map fusion theorem: `foldr f e . map g = foldr (f . g) e`.**

    (a) **Prove the theorem.**
    Since `map g` is a `foldr`, we proceed as follows:

    ```haskell
    foldr f e . map g
    = { map g is a foldr }
    foldr f e . foldr (\x ys -> g x : ys) []
    = { foldr-fusion }
    foldr (f . g) (foldr f e [])
    = { definition of foldr }
    foldr (f . g) e
    ```

    The fusion condition is proved below:
    ```haskell
    foldr f e (g x : ys)
    = { definition foldr }
    f (g x) (foldr f e ys)
    ```

    (b) **Express `sum . map (2*)` as a `foldr`.**
    ```haskell
    sum . map (2*)
    = foldr (+) 0 . map (2*)
    = { foldr-map fusion }
    foldr ((+) . (2*)) 0
    ```

    (c) **Show that `(2*) . sum` reduces to the same `foldr`.**
    ```haskell
    (2*) . sum
    = (2*) . foldr (+) 0
    = { foldr fusion }
    foldr ((+) . (2*)) 0
    ```
    The fusion condition is:
    ```haskell
    2 * (x + y)
    = { distributivity }
    2 * x + 2 * y
    = { definition of (.) }
    ((+) . (2*)) x (2 * y)
    ```

8.  **Prove that `map f (xs ++ ys) = map f xs ++ map f ys` by `foldr`-fusion.**
    (Equivalent to `map f . (++ ys) = (++ map f ys) . map f`)

    Recall that `(++ ys)` is a `foldr`. Use `foldr` fusion and `foldr`-map fusion:

    ```haskell
    (++ map f ys) . map f
    = { foldr-map fusion }
    foldr ((:) . f) (map f ys)
    = { foldr fusion }
    map f . (++ ys)
    ```

    The fusion condition of the last step is:
    ```haskell
    map f (x : zs)
    = { definition of map }
    f x : map f zs
    = { definition of (.) }
    ((:) . f) x (map f zs)
    ```

9.  **Prove that `length . concat = sum . map length` by fusion.**

    ```haskell
    length . concat
    = length . foldr (++) []
    = { foldr-fusion }
    foldr ((+) . length) 0
    = { sum = foldr (+) 0, foldr-map fusion }
    sum . map length
    ```

    The fusion condition:
    ```haskell
    length (xs ++ ys)
    = { (++) and (+) homorphic }
    length xs + length ys
    = { definition of (.) }
    ((+) . length) xs (length ys)
    ```

10. **`scanr` by `foldr`-fusion**

    Recall `scanr f e = map (foldr f e) . tails` and `tails = foldr (\x xss -> (x : head xss) : xss) [[]]`.
    
    Base value: `map (foldr f e) [[]] = [e]`.

    Step function fusion condition:
    ```haskell
    map (foldr f e) ((x : head xss) : xss)
    = { definition of map }
    foldr f e (x : head xss) : map (foldr f e) xss
    = { definition of foldr }
    f x (foldr f e (head xss)) : map (foldr f e) xss
    = { foldr f e (head xss) = head (map (foldr f e) xss) }
    let ys = map (foldr f e) xss
    in f x (head ys) : ys
    ```

    Therefore:
    ```haskell
    scanr f e = foldr (\x ys -> f x (head ys) : ys) [e]
    ```

11. **Fast Exponentiation**

    (a) **Express `decimal` using a `foldr`.**
    ```haskell
    decimal = foldr (\d n -> d + 2 * n) 0
    ```

    (b) **Construct `step` and `base` such that `exp m . decimal = foldr step base`.**
    
    Base value: `base = exp m 0 = 1`.

    Step function:
    ```haskell
    exp m (d + 2 * n)
    = { since m^(x+y) = m^x * m^y }
    exp m d * exp m (2 * n)
    = { since m^(2n) = (m^n)^2, let square x = x * x }
    exp m d * square (exp m n)
    ```
    Since `d` is either 0 or 1:
    ```haskell
    if d == 0 then square (exp m n) else m * square (exp m n)
    ```

    Therefore:
    ```haskell
    exp m . decimal = foldr (\d x -> if d == 0 then square x else m * square x) 1
    ```

12. **`revcat` as a `foldr`.**

    `reverse = foldr (\x xs -> xs ++ [x]) []`.

    To fuse `(++)` into `reverse`, the base value is `(++) [] = id`.
    
    Fusion condition:
    ```haskell
    (++) ((\x xs -> xs ++ [x]) x xs) ys
    = (++) (xs ++ [x]) ys
    = (xs ++ [x]) ++ ys
    = { (++) associative }
    xs ++ ([x] ++ ys)
    = { definition of (.) }
    (((++) xs) . (x :)) ys
    = { factor out x, ((++) xs), and ys }
    (\x f -> f . (x :)) x ((++) xs) ys
    ```

    Conclusion:
    ```haskell
    revcat = foldr (\x f -> f . (x :)) id
    ```

13. **Fold on natural numbers.**

    (a) **`even` in terms of `foldN`.**
    ```haskell
    even = foldN not True
    ```

    (b) **`id` in terms of `foldN`.**
    ```haskell
    id = foldN (1+) 0
    ```

14. **Fuse `even` into `(+n)`.**

    Recall `(+n) = foldN (1+) n`.
    Base value: `even n`.
    Step function: `even (1+ n) = not (even n)`.

    ```haskell
    even . (+n) = foldN not (even n)
    ```

15. **Fibonacci Fusion**

    Recall `id = foldN (1+) 0`. Fusing `fib2` into `id`.
    Base value: `fib2 0 = (1, 0)`.

    Step function:
    ```haskell
    fib2 (1+ n)
    = (fib (1 + 1 + n), fib (1 + n))
    = { definition of fib }
    (fib (1 + n) + fib n, fib (1 + n))
    = (\(x, y) -> (x + y, x)) (fib2 n)
    ```

    Therefore:
    ```haskell
    fib2 = foldN (\(x, y) -> (x + y, x)) (1, 0)
    ```

16. **Fold fusion theorems for `ETree` and `ITree`.**

    **Solution:**

    For `ITree`:
    ```haskell
    h . foldIT f e = foldIT g (h e)
    <= h (f x y z) = g x (h y) (h z)
    ```

    For `ETree`:
    ```haskell
    h . foldET f k = foldET g (h . k)
    <= h (f x y) = g (h x) (h y)
    ```
