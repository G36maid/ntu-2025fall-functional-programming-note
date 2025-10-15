# Practicals 3: Definition and Proof by Induction (Solutions)

**Author:** Shin-Cheng Mu
**Term:** Autumn 2025

---

1.  **Prove that `length` distributes into `(++)`:**
    `length (xs ++ ys) = length xs + length ys`.

    **Solution:** Prove by induction on the structure of `xs`.

    *   **Case `xs := []`:**
        ```haskell
        length ([] ++ ys)
        = { definition of (++) }
        length ys
        = { definition of (+) }
        0 + length ys
        = { definition of length }
        length [] + length ys
        ```

    *   **Case `xs := x : xs`:**
        ```haskell
        length ((x : xs) ++ ys)
        = { definition of (++) }
        length (x : (xs ++ ys))
        = { definition of length }
        1 + length (xs ++ ys)
        = { by induction }
        1 + length xs + length ys
        = { definition of length }
        length (x : xs) + length ys
        ```
    Note that we in fact omitted one step using the associativity of `(+)`.

2.  **Prove: `sum . concat = sum . map sum`.**

    **Solution:** By extensional equality, this is equivalent to proving `sum (concat xss) = sum (map sum xss)` for all `xss`. We prove by induction on `xss`.

    *   **Case `xss := []`:**
        ```haskell
        sum (concat [])
        = { definition of concat }
        sum []
        = { definition of map }
        sum (map sum [])
        ```

    *   **Case `xss := xs : xss`:**
        ```haskell
        sum (concat (xs : xss))
        = { definition of concat }
        sum (xs ++ (concat xss))
        = { lemma: sum distributes over ++ }
        sum xs + sum (concat xss)
        = { by induction }
        sum xs + sum (map sum xss)
        = { definition of sum }
        sum (sum xs : map sum xss)
        = { definition of map }
        sum (map sum (xs : xss))
        ```
    The lemma `sum (xs ++ ys) = sum xs + sum ys` needs a separate proof by induction (proof omitted as it\'s similar to `length`).

3.  **Prove: `filter p . map f = map f . filter (p . f)`.**

    **Solution:** We proceed by induction on `xs`.

    *   **Case `xs := []`:**
        ```haskell
        filter p (map f [])
        = { definition of map }
        filter p []
        = { definition of filter }
        []
        = { definition of map }
        map f []
        = { definition of filter }
        map f (filter (p . f) [])
        ```

    *   **Case `xs := x : xs`:**
        ```haskell
        filter p (map f (x : xs))
        = { definition of map }
        filter p (f x : map f xs)
        = { definition of filter }
        if p (f x) then f x : filter p (map f xs) else filter p (map f xs)
        = { induction hypothesis }
        if p (f x) then f x : map f (filter (p . f) xs) else map f (filter (p . f) xs)
        = { defintion of map }
        if p (f x) then map f (x : filter (p . f) xs) else map f (filter (p . f) xs)
        = { since f (if q then e1 else e2) = if q then f e1 else f e2 }
        map f (if p (f x) then x : filter (p . f) xs else filter (p . f) xs)
        = { definition of (.) }
        map f (if (p . f) x then x : filter (p . f) xs else filter (p . f) xs)
        = { definition of filter }
        map f (filter (p . f) (x : xs))
        ```

4.  **Reflecting on the law `f (if q then e1 else e2) = if q then f e1 else f e2`:**
    Can you think of a counterexample when we allow the presence of `⊥`? What additional constraint shall we impose on `f` to make the law true?

    **Solution:** Let `f = const 1` (where `const x y = x`), and `q = ⊥`. We have:
    ```
    const 1 (if ⊥ then e1 else e2)
    = { definition of const }
    1
    ≠ ⊥
    = { if is strict on the conditional expression }
    if ⊥ then f e1 else f e2
    ```
    The rule is restored if `f` is strict, that is, `f ⊥ = ⊥`.

5.  **Prove: `take n xs ++ drop n xs = xs`, for all `n` and `xs`.**

    **Solution:** By induction on `n`, then induction on `xs`.

    *   **Case `n := 0`:**
        ```haskell
        take 0 xs ++ drop 0 xs
        = { definitions of take and drop }
        [] ++ xs
        = { definition of (++) }
        xs
        ```
    *   **Case `n := 1 + n` and `xs := []`:**
        ```haskell
        take (1 + n) [] ++ drop (1 + n) []
        = { definitions of take and drop }
        [] ++ []
        = { definition of (++) }
        []
        ```
    *   **Case `n := 1 + n` and `xs := x : xs`:**
        ```haskell
        take (1 + n) (x : xs) ++ drop (1 + n) (x : xs)
        = { definitions of take and drop }
        (x : take n xs) ++ drop n xs
        = { definition of (++) }
        x : (take n xs ++ drop n xs)
        = { induction }
        x : xs
        ```

6.  **Define `fan :: a -> [a] -> [[a]]`** that inserts an element into all possible positions.

    **Solution:**
    ```haskell
    fan :: a -> [a] -> [[a]]
    fan x [] = [[x]]
    fan x (y : ys) = (x : y : ys) : map (y :) (fan x ys)
    ```

7.  **Prove: `map (map f) . fan x = fan (f x) . map f`, for all `f`, `x`, and `xs`.**

    **Solution:** Proof by induction on `xs`. (Detailed steps omitted for brevity, they are in the original text).

8.  **Define `perms :: [a] -> [[a]]`** that returns all permutations.

    **Solution:**
    ```haskell
    perms :: [a] -> [[a]]
    perms [] = [[]]
    perms (x : xs) = concat (map (fan x) (perms xs))
    ```

9.  **Prove: `map (map f) . perm = perm . map f`.**

    **Solution:** Proof by induction on `xs`. (Detailed steps omitted for brevity, they are in the original text).

10. **Define `inits :: [a] -> [[a]]`** that returns all prefixes.

    **Solution:**
    ```haskell
    inits :: [a] -> [[a]]
    inits [] = [[]]
    inits (x : xs) = [] : map (x :) (inits xs)
    ```

11. **Define `tails :: [a] -> [[a]]`** that returns all suffixes.

    **Solution:**
    ```haskell
    tails :: [a] -> [[a]]
    tails [] = [[]]
    tails (x : xs) = (x : xs) : tails xs
    ```

12. **Define `splits :: [a] -> [([a], [a])]`** that returns all ways to split a list.

    **Solution:**
    ```haskell
    splits :: [a] -> [([a], [a])]
    splits [] = [([], [])]
    splits (x : xs) = ([], x : xs) : map (\(ys, zs) -> (x : ys, zs)) (splits xs)
    ```

13. **Define `interleave :: [a] -> [a] -> [[a]]`**.

    **Solution:**
    ```haskell
    interleave :: [a] -> [a] -> [[a]]
    interleave [] ys = [ys]
    interleave xs [] = [xs]
    interleave (x : xs) (y : ys) = map (x :) (interleave xs (y : ys)) ++ map (y :) (interleave (x : xs) ys)
    ```

14. **Define `sublist :: [a] -> [[a]]`** that computes all sublists.

    **Solution:**
    ```haskell
    sublist :: [a] -> [[a]]
    sublist [] = [[]]
    sublist (x : xs) = xss ++ map (x :) xss
        where xss = sublist xs
    ```

15. **Binary Tree Functions**
    *   **`minT :: Tree Nat -> Nat`**
        ```haskell
        minT :: Tree Nat -> Nat
        minT Null = maxBound -- Assuming maxBound is a very large number
        minT (Node x t u) = x `min` minT t `min` minT u
        ```
    *   **`mapT :: (a -> b) -> Tree a -> Tree b`**
        ```haskell
        mapT :: (a -> b) -> Tree a -> Tree b
        mapT f Null = Null
        mapT f (Node x t u) = Node (f x) (mapT f t) (mapT f u)
        ```
    *   **Inductive `(↓)` (min):**
        ```haskell
        (↓) :: Nat -> Nat -> Nat
        0 ↓ n = 0
        (1+m) ↓ 0 = 0
        (1+m) ↓ (1+n) = 1 + (m ↓ n)
        ```
    *   **Prove `minT (mapT (n+) t) = n + minT t`:** Proof by induction on `t`. (Detailed steps omitted).