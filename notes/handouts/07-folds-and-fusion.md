# Folds and Fold-Fusion

**Original Document**: [handouts_07.pdf](../../course-materials/handouts/handouts_07.pdf)

## 1. Folds On Lists

### Some Trivial Folds on Lists

A common pattern appears in many recursive functions on lists:

```haskell
sum []     = 0
sum (x:xs) = x + sum xs

length []     = 0
length (x:xs) = 1 + length xs

map f []     = []
map f (x:xs) = f x : map f xs
```

This pattern is extracted and called `foldr`:

```haskell
foldr :: (a -> b -> b) -> b -> List a -> b
foldr f e []     = e
foldr f e (x:xs) = f x (foldr f e xs)
```

For easy reference, we sometimes call `e` the "base value" and `f` the "step function".

### Replacing Constructors

One way to look at `foldr (⊕) e` is that it replaces `[]` with `e` and `(:)` with `(⊕)`:

```haskell
foldr (⊕) e [1, 2, 3, 4]
= foldr (⊕) e (1 : (2 : (3 : (4 : []))))
= 1 ⊕ (2 ⊕ (3 ⊕ (4 ⊕ e)))
```

**Examples:**
*   `sum = foldr (+) 0`
*   `length = foldr (\x n -> 1 + n) 0`
*   `map f = foldr (\x xs -> f x : xs) []`
*   `id = foldr (:) []` (Identity function replaces constructors with themselves)
*   `max = foldr (↑) -∞` (where `(↑)` returns the maximum of two arguments)
*   `prod = foldr (*) 1`
*   `and = foldr (&&) True`
*   `(++ ys) = foldr (:) ys`
*   `concat = foldr (++) []`

### All Prefixes (`inits`)

The function `inits` returns the list of all prefixes of the input list.

```haskell
inits []     = [[]]
inits (x:xs) = [] : map (x:) (inits xs)
```
E.g., `inits [1, 2, 3] = [[], [1], [1, 2], [1, 2, 3]]`.

It can be defined by a fold:
```haskell
inits = foldr (\x xss -> [] : map (x:) xss) [[]]
```

### All Suffixes (`tails`)

The function `tails` returns the list of all suffixes of the input list.

```haskell
tails []     = [[]]
tails (x:xs) = (x:xs) : tails xs
```

It appears `tails` is not a `foldr` because `(x:xs)` is used in the recursive step. However, since `head (tails xs) = xs`, we can rewrite it:

```haskell
tails (x:xs) = let yss = tails xs
               in (x : head yss) : yss
```

Thus `tails` can be defined by a fold:
```haskell
tails = foldr (\x yss -> (x : head yss) : yss) [[]]
```

### Functions on Lists That Are Not `foldr`

A function `f` is a `foldr` if in `f (x:xs) = ... f xs ...`, the argument `xs` does not appear outside of the recursive call.
*   **Not a `foldr`**: `tail`, `dropWhile p`. `tail` drops too much information which cannot be recovered.

### Longest Prefix (`takeWhile`)

```haskell
takeWhile p [] = []
takeWhile p (x:xs) = if p x then x : takeWhile p xs
                     else []
```

It can be defined by a fold:
```haskell
takeWhile p = foldr (\x xs -> if p x then x : xs else []) []
```

### Why Folds?

"What are the three most important factors in a programming language?" Abstraction, abstraction, and abstraction!

*   Program structure becomes an entity we can talk about, reason about, and reuse.
*   We can describe algorithms in terms of `fold`, `unfold`, etc.
*   We can prove properties about folds and apply theorems to all programs that are folds.

---

## 2. The Fold-Fusion Theorem

The theorem is about when the composition of a function and a fold can be expressed as a fold.

**Theorem 1 (`foldr`-Fusion)**:
Given `f :: a -> b -> b`, `e :: b`, `h :: b -> c`, and `g :: a -> c -> c`, we have:

$$ h \cdot \text{foldr} f e = \text{foldr} g (h e) $$

if $h (f x y) = g x (h y)$ for all $x$ and $y$.

For program derivation, we are usually given $h$, $f$, and $e$, from which we have to construct $g$.

### Sum of Squares, Again

Consider `sum . map square`. Recall `map f = foldr (mf f) []` where `mf f x xs = f x : xs`.
`sum . map square` is a fold if we can find a `ssq` such that `sum (mf square x xs) = ssq x (sum xs)`.

```haskell
sum (mf square x xs)
= { definition of mf }
sum (square x : xs)
= { definition of sum }
square x + sum xs
= { let ssq x y = square x + y }
ssq x (sum xs)
```
Therefore, `sum . map square = foldr ssq 0`.

### Scan

The function `scanr` computes `foldr` for every suffix of the given list:

```haskell
scanr :: (a -> b -> b) -> b -> List a -> List b
scanr f e = map (foldr f e) . tails
```

Example: `scanr (+) 0 [8, 1, 3] = [12, 4, 3, 0]`.

Using `foldr`-fusion (details in original text), we can derive an efficient implementation:

```haskell
scanr f e = foldr (\x ys -> f x (head ys) : ys) [e]
```
This is equivalent to:
```haskell
scanr f e [] = [e]
scanr f e (x:xs) = f x (head ys) : ys
  where ys = scanr f e xs
```

### Other Fusions

*   **Tupling as Fold-fusion**: The derivation of `steepsum` can be seen as fusing `steepsum . id = steepsum . foldr (:) []`.
*   **Accumulating Parameter as Fold-Fusion**: Introducing an accumulating parameter often fuses a higher-order function with a `foldr`.
    *   `revcat = (++) . reverse` can be seen as fusion.

### Folds on Other Algebraic Datatypes

#### Fold on Natural Numbers

```haskell
data Nat = 0 | 1 + Nat

foldN :: (a -> a) -> a -> Nat -> a
foldN f e 0 = e
foldN f e (1 + n) = f (foldN f e n)
```

**Theorem 2 (`foldN`-Fusion)**:
Given `f :: a -> a`, `e :: a`, `h :: a -> b`, and `g :: b -> b`, we have:

$$ h \cdot \text{foldN} f e = \text{foldN} g (h e) $$

if $h (f x) = g (h x)$ for all $x$.

#### Folds on Trees

```haskell
data ITree a = Null | Node a (ITree a) (ITree a)

foldIT :: (a -> b -> b -> b) -> b -> ITree a -> b
foldIT f e Null = e
foldIT f e (Node a t u) = f a (foldIT f e t) (foldIT f e u)
```

---

## 3. Finally, Solving Maximum Segment Sum

### Specifying Maximum Segment Sum

*   A **segment** can be seen as a prefix of a suffix.
*   `segs = concat . map inits . tails`
*   Specification:
    ```haskell
    mss = max . map sum . segs
    ```

### The Derivation

```haskell
max . map sum . concat . map inits . tails
= { since map f . concat = concat . map (map f) }
max . concat . map (map sum) . map inits . tails
= { since max . concat = max . map max }
max . map max . map (map sum) . map inits . tails
= { since map f . map g = map (f . g) }
max . map (max . map sum . inits) . tails
```

Now concentrate on `max . map sum . inits`. Let `ini x xss = [] : map (x:) xss`.

```haskell
max . map sum . inits
= { definition of inits }
max . map sum . foldr ini [[]]
= { fold fusion }
max . foldr zplus [0]  -- where zplus x yss = 0 : map (x+) yss
= { fold fusion again }
foldr zmax 0
```
where `zmax x y = 0 `$\uparrow$` (x + y)`.

The second fold fusion works because $\uparrow$ distributes into $(+)$:
`max (0 : map (x+) xs) = 0 `$\uparrow$` (x + max xs)`.

### Maximum Segment Sum in Linear Time!

Back to the main derivation:

```haskell
max . map (max . map sum . inits) . tails
= { result from above }
max . map (foldr zmax 0) . tails
= { introducing scanr }
max . scanr zmax 0
```

We have derived `mss = max . scanr zmax 0`, where `zmax x y = 0 `$\uparrow$` (x + y)`.
This runs in linear time!