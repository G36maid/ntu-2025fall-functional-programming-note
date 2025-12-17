# Streams and Codata

**Original Document**: [handouts_08.pdf](../../course-materials/handouts/handouts_08.pdf)

## 1. Data vs. Codata

Most materials in this handout are from Hinze [Hin08, Hin09].

### Recap: Lists

*   Recall `List`, an **inductive type** given by:
    ```haskell
    data List a = [] | a : List a
    ```
*   An inductive type is defined by its constructors. Values are constructed by finite applications of constructors.
*   Functions consuming inductive types are defined by pattern matching.
    ```haskell
    f [] = ...
    f (x:xs) = ...
    ```

### Coinductive Stream

*   The type `Stream` represents infinite sequences.
*   **Codata** (Coinductive types) are defined by their **deconstructors**.
    ```haskell
    codata Stream a where
      head :: Stream a -> a
      tail :: Stream a -> Stream a
    ```
*   Observation: `head` yields an element, `tail` yields another Stream.
*   Potentially `tail` can be applied infinitely many times.

### Defining Coinductive Values (Copatterns)

*   An infinite stream of 1's:
    ```haskell
    one :: Stream Int
    head one = 1
    tail one = one
    ```
*   The stream `[n, n+1, n+2...]`:
    ```haskell
    from n :: Int -> Stream Int
    head (from n) = n
    tail (from n) = from (n + 1)
    ```
*   `map` for Stream:
    ```haskell
    map :: (a -> b) -> Stream a -> Stream b
    head (map f xs) = f (head xs)
    tail (map f xs) = map f (tail xs)
    ```

### Termination

*   Inductive types are finite. Inductive programs terminate.
*   Coinductive types are potentially infinite.
*   By restricting forms of coinductive programs (guarded by constructors/deconstructors), each call terminates in finite time.
*   Non-termination happens when mixing inductive and coinductive types with general recursion (like in Haskell).

### Comparison

| Data / Inductive Datatypes | Codata / Coinductive Datatypes |
| :--- | :--- |
| Least prefix points (initial algebra) | Greatest postfix points (final coalgebra) |
| Defined by constructors | Defined by deconstructors |
| Consumed by patterns | Produced by copatterns |
| Properties by inductive proofs | Properties by coinduction, unique fixed point, etc. |

---

## 2. Preparations

### Copatterns

*   **Advantages**: Contrast to patterns, consistent with "match, substitute".
*   **Disadvantages**: Verbose syntax.

### Cons-Based Syntax

To remedy the verbosity, we use an alternative syntax (simulating Stream using List in Haskell):
The definition:
```haskell
head xs = h
tail xs = t
```
is abbreviated to:
```haskell
xs = h : t
```

### Examples

```haskell
one = 1 : one
nat = 0 : map (1+) nat
fact = 1 : tail nat * fact
map f xs = f (head xs) : map f (tail xs)
```
Abbreviation: `s'` denotes `tail s`. E.g., `nat' = [1, 2, 3...]`.

### Combinators

*   `repeat x`: Stream of x's.
    ```haskell
    repeat x = x : repeat x
    ```
*   `iterate f`:
    ```haskell
    iterate f x = x : iterate f (f x)
    ```

---

## 3. More Combinators

### zipWith

```haskell
zipWith f xs ys = f (head xs) (head ys) : zipWith f (tail xs) (tail ys)
```

### Applicative

The `(<*>)` operator ("ap"):
```haskell
(<*>) :: Stream (a -> b) -> Stream a -> Stream b
fs <* > xs = head fs (head xs) : tail fs <* > tail xs
```

Redefining `map` and `zipWith`:
```haskell
map f xs = repeat f <* > xs
zipWith f xs ys = (repeat f <* > xs) <* > ys
```

### Streams as Numbers

```haskell
instance Num a => Num (Stream a) where
  (+) = zipWith (+)
  (-) = zipWith (-)
  (*) = zipWith (*)
  fromInteger n = repeat (fromInteger n)
```

*   `3 :: Stream Int` expands to `[3, 3...]`.
*   `1 + nat` expands to `[1, 2, 3...]` (since `nat = [0, 1, 2...]`).
*   Arithmetic laws hold.
*   Example: `nat = 0 : 1 + nat`.
*   Example: `fib = 0 : fib'`; `fib' = 1 : fib''`; `fib'' = fib + fib'`.

### Interleaving

```haskell
(\/) :: Stream a -> Stream a -> Stream a
xs \/ ys = head xs : ys \/ tail xs
```
*   Note: `(\/)` is neither commutative nor associative.
*   Precedence: Looser than arithmetic, tighter than `(:)`.

**Binary Construction of Naturals**:
```haskell
bin = 0 : 2 * bin + 1 \/ 2 * bin + 2
```
(Yields `0, 1, 2, 3, 4, 5...`)

**Properties**:
*   `repeat x \/ repeat x = repeat x`
*   `(fs <* > xs) \/ (gs <* > ys) = (fs \/ gs) <* > (xs \/ ys)` (Abide law)

---

## 4. Proving Equalities

### Unique Solutions

*   Induction works for inductive types (least prefix points).
*   For coinductive types (greatest postfix points), we use **Unique Fixed Points**.
*   If `xs = F xs` and `ys = F ys`, where `F` captures the same **admissible equation**, then `xs = ys`.

### Admissible Definitions

A constant definition `xs = h : t` is admissible if `h` is constant, and `t` (which may refer to `xs`) does not apply `head` or `tail` to `xs`.

### Example: `repeat`

Prove `repeat f <* > repeat x = repeat (f x)`.

```haskell
repeat f <* > repeat x
= { definition of repeat }
(f : repeat f) <* > (x : repeat x)
= { definition of (<*>) }
f x : (repeat f <* > repeat x)
```
It has the same pattern as `repeat (f x) = f x : repeat (f x)`. Thus they are equal.

### Example: `nat`

Prove `nat = 2 * nat \/ 1 + 2 * nat`. (Recall `nat = 0 : 1 + nat`)

```haskell
2 * nat \/ 1 + 2 * nat
= { definition of nat }
2 * (0 : 1 + nat) \/ 1 + 2 * nat
= { definition of (*) }
(0 : 2 * (1 + nat)) \/ 1 + 2 * nat
= { definition of (\/) }
0 : 1 + 2 * nat \/ 2 * (1 + nat)
= { arithmetic }
0 : 1 + (2 * nat \/ 1 + 2 * nat) -- by distributivity
```
Both have the recursive pattern `xs = 0 : 1 + xs`. Therefore `nat = 2 * nat \/ 1 + 2 * nat`.

### Example: Cassini's Identity

Prove `fib'^2 - fib * fib'' = (-1)^nat`.
(See original text for derivation steps).

---

## 5. More about Interleaving

### Binary Recurrence

Given `h` defined by:
```haskell
h 0 = k
h (1 + 2*n) = f (h n)
h (2 + 2*n) = g (h n)
```
The sequence `xs = map h bin` is generated by:
```haskell
xs = k : map f xs \/ map g xs
```

### Positive Numbers

Sequence of positive integers (`1 + bin`):
```haskell
bin' = 1 : 2 * bin' \/ 1 + 2 * bin'
```

### Most Significant Bit

```haskell
msb = 1 : 2 * msb \/ 2 * msb
```
`msb = [1, 2, 2, 4, 4, 4, 4, 8, 8...]`

### Binary Carry Sequence (Ruler Sequence)

```haskell
carry = 0 : 1 + carry \/ 0
```
`carry = [0, 1, 0, 2, 0, 1, 0, 3, 0, 1, 0, 4...]`
This is the exponent of the largest power of 2 that divides `bin'`.

## References

*   [Hin08] Ralf Hinze. Functional pearl: streams and unique fixed points. ICFP 2008.
*   [Hin09] Ralf Hinze. Reasoning about codata. CEFP 2009.