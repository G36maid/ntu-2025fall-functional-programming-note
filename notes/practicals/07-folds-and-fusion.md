# Practicals 7: Folds, and Fold-Fusion

**Original Document**: [practicals_07.pdf](../../course-materials/practicals/practicals_07.pdf)

**Solutions**: [practicals_07_sols.pdf](../../course-materials/practicals/practicals_07_sols.pdf)

---

1.  Express the following functions by `foldr`:

    1.  `all p :: List a -> Bool`, where `p :: a -> Bool`.
    2.  `elem z :: List a -> Bool`, where `z :: a`.
    3.  `concat :: List (List a) -> List a`.
    4.  `filter p :: List a -> List a`, where `p :: a -> Bool`.
    5.  `takeWhile p :: List a -> List a`, where `p :: a -> Bool`.
    6.  `id :: List a -> List a`.

    In case you haven’t seen them, `all p xs` is `True` iff all elements in `xs` satisfy `p`, and `elem z xs` is `True` iff `x` is a member of `xs`.

2.  Given `p :: a -> Bool`, can `dropWhile p :: List a -> List a` be written as a `foldr`?

3.  Express the following functions by `foldr`:

    1.  `inits :: List a -> List (List a)`.
    2.  `tails :: List a -> List (List a)`.
    3.  `perms :: List a -> List (List a)`.
    4.  `sublists :: List a -> List (List a)`.
    5.  `splits :: List a -> List (List a, List a)`.

4.  Prove the **`foldr`-fusion theorem**. To recite the theorem: given `f :: a -> b -> b`, `e :: b`, `h :: b -> c` and `g :: a -> c -> c`, we have

    $$ h \cdot \text{foldr} \ f \ e = \text{foldr} \ g \ (h \ e) $$

    if $h \ (f \ x \ y) = g \ x \ (h \ y)$ for all $x$ and $y$.

5.  Prove the map-fusion rule `map f . map g = map (f . g)` by `foldr`-fusion.

6.  Prove that `sum . concat = sum . map sum` by `foldr`-fusion, twice. Compare the proof with your previous proof in earlier parts of this course.

7.  The map fusion theorem is an instance of the **`foldr`-map fusion theorem**: `foldr f e . map g = foldr (f . g) e`.

    (a) Prove the theorem.

    (b) Express `sum . map (2*)` as a `foldr`.

    (c) Show that `(2*) . sum` reduces to the same `foldr` as the one above.

8.  Prove that `map f (xs ++ ys) = map f xs ++ map f ys` by `foldr`-fusion. Hint: this is equivalent to `map f . (++ ys) = (++ map f ys) . map f`. You may need to do (any kinds of) fusion twice.

9.  Prove that `length . concat = sum . map length` by fusion.

10. Let `scanr f e = map (foldr f e) . tails`. Construct, by `foldr`-fusion, an implementation of `scanr` whose number of calls to `f` is proportional to the length of the input list.

11. Recall the function `binary :: Nat -> List Nat` that returns the reversed binary representation of a natural number, for example `binary 4 = [0, 0, 1]`. Also, we talked about a function `decimal :: List Nat -> Nat` that converts the representation back to a natural number.

    (a) This time, express `decimal` using a `foldr`.

    (b) Recall the function $exp \ m \ n = m^n$. Use `foldr`-fusion to construct `step` and `base` such that:

    $$ \exp \ m \cdot \text{decimal} = \text{foldr} \ \text{step} \ \text{base} $$

    If the fusion succeeds, we have derived a hylomorphism computing $m^n$:

    $$ \text{fastexp} \ m = \text{foldr} \ \text{step} \ \text{base} \cdot \text{binary} $$

12. Express `reverse :: List a -> List a` by a `foldr`. Let `revcat = (++) . reverse`. Express `revcat` as a `foldr`.

13. **Fold on natural numbers.**

    (a) The predicate `even :: Nat -> Bool` yields `True` iff the input is an even number. Define `even` in terms of `foldN`.

    (b) Express the identity function on natural numbers `id n = n` in terms of `foldN`.

14. Fuse `even` into `(+n)`. This way we get a function that checks whether a natural number is even after adding `n`.

15. The famous Fibonacci number is defined by:

    ```haskell
    fib 0 = 0
    fib 1 = 1
    fib (2 + n) = fib (1 + n) + fib n
    ```

    The definition above, when taken directly as an algorithm, is rather slow. Define `fib2 n = (fib (1 + n), fib n)`. Derive an $O(n)$ implementation of `fib2` by fusing it with `id :: Nat -> Nat`.

16. What are the fold fusion theorems for `ETree` and `ITree`?