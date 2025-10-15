# Practical 03: Definition and Proof by Induction

This practical focuses on defining functions using structural induction and proving properties about them using inductive proofs. These exercises are fundamental to mastering the functional programming paradigm.

## 1. `length` and `(++)`
**Task:** Prove that `length` distributes into `(++)`.
```haskell
length (xs ++ ys) = length xs + length ys
```
**Proof Strategy:**
- Use structural induction on `xs`.
- **Base Case (`xs := []`):** Show that `length ([] ++ ys)` equals `length [] + length ys`. This follows directly from the definitions of `(++)`, `length`, and `(+)`.
- **Inductive Step (`xs := x : xs'`):** Assume the property holds for `xs'`. Show that it holds for `x : xs'`. You will need to use the definitions of `(++)` and `length`, the inductive hypothesis, and the associativity of `(+)`.

## 2. `sum`, `concat`, and `map`
**Task:** Prove the property `sum . concat = sum . map sum`.
**Proof Strategy:**
- By extensional equality, this is equivalent to proving `sum (concat xss) = sum (map sum xss)` for all `xss`.
- Use structural induction on `xss`.
- **Base Case (`xss := []`):** Straightforward application of definitions.
- **Inductive Step (`xss := xs : xss'`):** This step will require a **lemma**: `sum (xs ++ ys) = sum xs + sum ys`. You should prove this lemma separately using induction on `xs`.

## 3. `filter` and `map` (Filter-Map Fusion)
**Task:** Prove the property `filter p . map f = map f . filter (p . f)`.
**Proof Strategy:**
- Use structural induction on the list argument.
- The proof is cleaner if you use the `if-then-else` definition of `filter`.
- You will need the law: `g (if q then e1 else e2) = if q then g e1 else g e2`, which holds for total functions.

## 4. Strictness and `⊥`
**Task:** Find a counterexample to the law `f (if q then e1 else e2) = if q then f e1 else f e2` when `⊥` (non-termination or error) is allowed. What constraint on `f` makes the law true?
**Explanation:**
- The `if-then-else` construct is strict in its first argument. If `q` is `⊥`, the whole expression is `⊥`.
- **Counterexample:** Let `f = const 1` and `q = ⊥`.
  - `f (if ⊥ then e1 else e2)` evaluates to `f ⊥`. If `f` is non-strict (like `const 1`), this can be `1`.
  - `if ⊥ then f e1 else f e2` evaluates to `⊥`.
- **Constraint:** The law holds if `f` is a **strict** function, meaning `f ⊥ = ⊥`.

## 5. `take` and `drop`
**Task:** Prove `take n xs ++ drop n xs = xs` for all `n` and `xs`.
**Proof Strategy:**
- This requires a double induction.
- First, perform induction on `n`.
- Inside the inductive step for `n`, you will need to perform a structural induction on `xs`.

## 6. `fan` Function
**Task:** Define `fan x xs` which inserts `x` into every possible position in `xs`.
**Example:** `fan 5 [1,2] = [[5,1,2], [1,5,2], [1,2,5]]`
**Inductive Definition:**
```haskell
fan :: a -> [a] -> [[a]]
fan x [] = [[x]]
fan x (y:ys) = (x:y:ys) : map (y:) (fan x ys)
```

## 7. `map` and `fan` Property
**Task:** Prove `map (map f) . fan x = fan (f x) . map f`.
**Proof Strategy:**
- Use induction on the list argument `xs`.
- You will need the **map-fusion law**: `map g . map h = map (g . h)`.
- You will also need to prove or use the helper lemma: `map f . (y:) = (f y:) . map f`.

## 8. `perms` Function
**Task:** Define `perms xs` which returns all permutations of `xs`.
**Inductive Definition:**
- The permutations of an empty list is a list containing just the empty list.
- The permutations of `x:xs` are formed by taking all permutations of `xs` and using `fan` to insert `x` into every possible position of each permutation.
```haskell
perms :: [a] -> [[a]]
perms [] = [[]]
perms (x:xs) = concat (map (fan x) (perms xs))
```

## 9. `map` and `perms` Property
**Task:** Prove `map (map f) . perms = perms . map f`.
**Proof Strategy:**
- Use induction on the list argument `xs`.
- You will need the results from the `fan` proof (Exercise 7).
- You will also need a property relating `map` and `concat`: `map g . concat = concat . map (map g)`.

## 10. `inits` Function
**Task:** Define `inits xs` which returns all prefixes of `xs`.
**Inductive Definition:**
```haskell
inits :: [a] -> [[a]]
inits [] = [[]]
inits (x:xs) = [] : map (x:) (inits xs)
```

## 11. `tails` Function
**Task:** Define `tails xs` which returns all suffixes of `xs`.
**Inductive Definition:**
```haskell
tails :: [a] -> [[a]]
tails [] = [[]]
tails (x:xs) = (x:xs) : tails xs
```

## 12. `splits` Function
**Task:** Define `splits xs` which returns all ways a list can be split into two.
**Inductive Definition:**
```haskell
splits :: [a] -> [([a], [a])]
splits [] = [([], [])]
splits (x:xs) = ([], x:xs) : map (\(ys, zs) -> (x:ys, zs)) (splits xs)
```

## 13. `interleave` Function
**Task:** Define `interleave xs ys` which produces all interleavings of the two lists.
**Recursive Definition:**
```haskell
interleave :: [a] -> [a] -> [[a]]
interleave [] ys = [ys]
interleave xs [] = [xs]
interleave (x:xs) (y:ys) = map (x:) (interleave xs (y:ys)) ++
                           map (y:) (interleave (x:xs) ys)
```

## 14. `sublist` Function
**Task:** Define `sublist xs` which computes all sublists of `xs`.
**Hint:** For each element, you can either keep it or drop it.
**Inductive Definition:**
```haskell
sublists :: [a] -> [[a]]
sublists [] = [[]]
sublists (x:xs) = xss ++ map (x:) xss
  where xss = sublists xs
```
The right-hand side can be read as "the sublists of `x:xs` are the sublists of `xs` (where `x` is dropped), plus the sublists of `xs` with `x` prepended to each (where `x` is kept)."

## 15. Binary Tree Induction
Consider the datatype: `data Tree a = Null | Node a (Tree a) (Tree a)`

**(a) `minT`:** Define a function to find the minimum element in a `Tree Nat`.
```haskell
minT :: Tree Nat -> Nat
minT Null = maxBound -- A very large number to act as identity for min
minT (Node x t u) = x `min` minT t `min` minT u
```

**(b) `mapT`:** Define a map function for the `Tree` datatype.
```haskell
mapT :: (a -> b) -> Tree a -> Tree b
mapT f Null = Null
mapT f (Node x t u) = Node (f x) (mapT f t) (mapT f u)
```

**(c) Inductive `min`:** Define `min` (or `(↓)`) inductively on `Nat`.
```haskell
min :: Nat -> Nat -> Nat
0 `min` n = 0
(1+m) `min` 0 = 0
(1+m) `min` (1+n) = 1 + (m `min` n)
```

**(d) Proof:** Prove `minT (mapT (n+) t) = n + minT t`.
**Proof Strategy:**
- Use structural induction on the tree `t`.
- **Base Case (`t := Null`):** Show `minT (mapT (n+) Null) = n + minT Null`.
- **Inductive Step (`t := Node x t' u'`):** Assume the property holds for `t'` and `u'`. Prove it for `Node x t' u'`. This will require a lemma: `(n + x) `min` (n + y) = n + (x `min` y)`, which you can prove by induction on `n`.