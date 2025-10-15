# Practicals 3: Definition and Proof by Induction

**Author:** Shin-Cheng Mu
**Term:** Autumn 2025

---

1.  Prove that `length` distributes into `(++)`:
    ```haskell
    length (xs ++ ys) = length xs + length ys
    ```

2.  Prove: `sum . concat = sum . map sum`.

3.  Prove: `filter p . map f = map f . filter (p . f)`.

    **Hint:** For calculation, it might be easier to use this definition of `filter`:
    ```haskell
    filter p [] = []
    filter p (x : xs) = if p x then x : filter p xs else filter p xs
    ```
    and use the law that in the world of total functions we have:
    ```haskell
    f (if q then e1 else e2) = if q then f e1 else f e2
    ```
    You may also carry out the proof using the definition of `filter` using guards:
    ```haskell
    filter p (x : xs) | p x       = ...
                      | otherwise = ...
    ```
    You will then have to distinguish between the two cases: `p x` and `not (p x)`, which makes the proof more fragmented. Both proofs are okay, however.

4.  Reflecting on the law we used in the previous exercise:
    ```haskell
    f (if q then e1 else e2) = if q then f e1 else f e2
    ```
    Can you think of a counterexample to the law above, when we allow the presence of `⊥`? What additional constraint shall we impose on `f` to make the law true?

5.  Prove: `take n xs ++ drop n xs = xs`, for all `n` and `xs`.

6.  Define a function `fan :: a -> [a] -> [[a]]` such that `fan x xs` inserts `x` into the 0th, 1st... nth positions of `xs`, where `n` is the length of `xs`. For example:
    ```haskell
    fan 5 [1, 2, 3, 4] = [[5, 1, 2, 3, 4], [1, 5, 2, 3, 4], [1, 2, 5, 3, 4], [1, 2, 3, 5, 4], [1, 2, 3, 4, 5]]
    ```

7.  Prove: `map (map f) . fan x = fan (f x) . map f`, for all `f` and `x`. Hint: you will need the map-fusion law, and to spot that `map f . (y :) = (f y :) . map f` (why?).

8.  Define `perms :: [a] -> [[a]]` that returns all permutations of the input list. For example:
    ```haskell
    perms [1, 2, 3] = [[1, 2, 3], [2, 1, 3], [2, 3, 1], [1, 3, 2], [3, 1, 2], [3, 2, 1]]
    ```
    You will need several auxiliary functions defined in the lectures and in the exercises.

9.  Prove: `map (map f) . perm = perm . map f`. You may need previously proved results, as well as a property about `concat` and `map`: for all `g`, we have `map g . concat = concat . map (map g)`.

10. Define `inits :: [a] -> [[a]]` that returns all prefixes of the input list.
    ```haskell
    inits "abcde" = ["", "a", "ab", "abc", "abcd", "abcde"]
    ```
    Hint: the empty list has one prefix: the empty list. The solution has been given in the lecture. Please try it again yourself.

11. Define `tails :: [a] -> [[a]]` that returns all suffixes of the input list.
    ```haskell
    tails "abcde" = ["abcde", "bcde", "cde", "de", "e", ""]
    ```
    Hint: the empty list has one suffix: the empty list. The solution has been given in the lecture. Please try it again yourself.

12. The function `splits :: [a] -> [([a], [a])]` returns all the ways a list can be split into two. For example,
    ```haskell
    splits [1, 2, 3, 4] = [([], [1, 2, 3, 4]), ([1], [2, 3, 4]), ([1, 2], [3, 4]), ([1, 2, 3], [4]), ([1, 2, 3, 4], [])]
    ```
    Define `splits` inductively on the input list. Hint: you may find it useful to define, in a `where`-clause, an auxiliary function `f (ys, zs) = ...` that matches pairs. Or you may simply use `(\(ys, zs) -> ...)`

13. An interleaving of two lists `xs` and `ys` is a permutation of the elements of both lists such that the members of `xs` appear in their original order, and so does the members of `ys`. Define `interleave :: [a] -> [a] -> [[a]]` such that `interleave xs ys` is the list of interleaving of `xs` and `ys`. For example, `interleave [1, 2, 3] [4, 5]` yields:
    ```
    [[1, 2, 3, 4, 5], [1, 2, 4, 3, 5], [1, 2, 4, 5, 3], [1, 4, 2, 3, 5], [1, 4, 2, 5, 3], [1, 4, 5, 2, 3], [4, 1, 2, 3, 5], [4, 1, 2, 5, 3], [4, 1, 5, 2, 3], [4, 5, 1, 2, 3]]
    ```

14. A list `ys` is a sublist of `xs` if we can obtain `ys` by removing zero or more elements from `xs`. For example, `[2, 4]` is a sublist of `[1, 2, 3, 4]`, while `[3, 2]` is not. The list of all sublists of `[1, 2, 3]` is:
    ```
    [[], [3], [2], [2, 3], [1], [1, 3], [1, 2], [1, 2, 3]]
    ```
    Define a function `sublist :: [a] -> [[a]]` that computes the list of all sublists of the given list. Hint: to form a sublist of `xs`, each element of `xs` could either be kept or dropped.

15. Consider the following datatype for internally labelled binary trees:
    ```haskell
    data Tree a = Null | Node a (Tree a) (Tree a)
    ```
    a. Given `(↓) :: Nat -> Nat -> Nat`, which yields the smaller one of its arguments, define `minT :: Tree Nat -> Nat`, which computes the minimal element in a tree. (Note: `(↓)` is actually called `min` in the standard library. In the lecture we use the symbol `(↓)` to be brief.)
    b. Define `mapT :: (a -> b) -> Tree a -> Tree b`, which applies the functional argument to each element in a tree.
    c. Can you define `(↓)` inductively on `Nat`?
    d. Prove that for all `n` and `t`, `minT (mapT (n+) t) = n + minT t`. That is, `minT . mapT (n+) = (n+) . minT`.