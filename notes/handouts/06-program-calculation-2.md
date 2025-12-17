# Program Calculation: Work Less by Promising More

**Original Document**: [handouts_06.pdf](../../course-materials/handouts/handouts_06.pdf)

## Correct by Construction

Dijkstra: “The only effective way to raise the confidence level of a program significantly is to give a convincing proof of its correctness. But one should not first make the program and then prove its correctness... On the contrary: the programmer should ... [let] correctness proof and program grow hand in hand: with the choice of the structure of the correctness proof one designs a program for which this proof is applicable.”

### Deriving Programs from Specifications

*   In functional program derivation, the specification itself is a function, albeit probably not an efficient one.
*   From the specification we construct a function that equals the specification.
*   The calculation is the proof.
*   We often proceed by expanding and reducing the definitions, until we obtain an inductive definition of the specification.
*   But that does not work all the time. Sometimes we need to **generalize**.

---

## 1. Tupling

### Steep Lists

A **steep list** is a list in which every element is larger than the sum of those to its right:

```haskell
steep :: List Int -> Bool
steep [] = True
steep (x : xs) = steep xs && x > sum xs
```

*   The definition above, if executed directly, is an $O(n^2)$ program (since `sum` is $O(n)$ and it is called $n$ times).
*   Can we do better?
*   Just now we learned to construct a generalised function which takes more input. This time, we try the **dual technique**: to construct a function returning more results.

### Generalise by Returning More

*   It is hard to quickly compute `steep` alone. But if we define:
    ```haskell
    steepsum xs = (steep xs, sum xs)
    ```
*   and manage to synthesise a quick definition of `steepsum`, we can implement `steep` by `steep = fst . steepsum`.
*   This technique is called **Tupling**.

### Deriving for the Non-Empty Case

We proceed by case analysis. Trivially, `steepsum [] = (True, 0)`.

For the case for non-empty inputs `(x : xs)`:

```haskell
steepsum (x : xs)
= { definition of steepsum }
(steep (x : xs), sum (x : xs))
= { definitions of steep and sum }
(steep xs && x > sum xs, x + sum xs)
= { extracting sub-expressions involving xs }
let (b, y) = (steep xs, sum xs)
in (b && x > y, x + y)
= { definition of steepsum }
let (b, y) = steepsum xs
in (b && x > y, x + y)
```

### Synthesised Program

We have thus come up with a $O(n)$ time program:

```haskell
steep = fst . steepsum

steepsum [] = (True, 0)
steepsum (x : xs) = 
  let (b, y) = steepsum xs
  in (b && x > y, x + y)
```

*   Again we observe the phenomena that a more general function is easier to implement.

---

## 2. Accumulating Parameters

### Reversing a List

The function `reverse` is defined by:

```haskell
reverse [] = []
reverse (x : xs) = reverse xs ++ [x]
```

*   Since `(++)` is $O(n)$, it takes $O(n^2)$ time to revert a list this way.
*   Can we make it faster?

### Introducing an Accumulating Parameter

Let us consider a generalisation of `reverse`. Define:

```haskell
revcat :: [a] -> [a] -> [a]
revcat xs ys = reverse xs ++ ys
```

*   The partially reverted list is **accumulated** in `ys`.
*   The initial value of `ys` is set by `reverse xs = revcat xs []`.
*   If we can construct a fast implementation of `revcat`, we can implement `reverse` by `reverse xs = revcat xs []`.

### Reversing a List, Base Case

Consider the case when `xs` is `[]`:

```haskell
revcat [] ys
= { definition of revcat }
reverse [] ++ ys
= { definition of reverse }
[] ++ ys
= { definition of (++) }
ys
```

### Reversing a List, Inductive Case

Case `x : xs`:

```haskell
revcat (x : xs) ys
= { definition of revcat }
reverse (x : xs) ++ ys
= { definition of reverse }
(reverse xs ++ [x]) ++ ys
= { since (xs ++ ys) ++ zs = xs ++ (ys ++ zs) }
reverse xs ++ ([x] ++ ys)
= { definition of revcat }
revcat xs (x : ys)
```

### Linear-Time List Reversal

We have therefore constructed an implementation of `revcat` which runs in linear time!

```haskell
reverse xs = revcat xs []

revcat [] ys = ys
revcat (x : xs) ys = revcat xs (x : ys)
```

*   Operational understanding:
    ```haskell
    reverse [1, 2, 3, 4]
    = revcat [1, 2, 3, 4] []
    = revcat [2, 3, 4] [1]
    = revcat [3, 4] [2, 1]
    = revcat [4] [3, 2, 1]
    = revcat [] [4, 3, 2, 1]
    = [4, 3, 2, 1]
    ```

### Tail Recursion and Loops

*   **Tail recursion**: a special case of recursion in which the last operation is the recursive call.
*   To implement general recursion, we need to keep a stack of return addresses. For tail recursion, we do not need such a stack.
*   Tail recursive definitions are like loops.
    ```
    xs, ys <- XS, [];
    while xs != [] do
      xs, ys <- (tail xs), (head xs : ys);
    return ys
    ```

### Being Quicker by Doing More?

*   A more generalised program can be implemented more efficiently.
*   To efficiently perform a computation (e.g. `reverse xs`), we introduce a generalisation with an extra parameter.
    *   The extra parameter is usually used to "accumulate" some results, hence the name.
*   Finding the right generalisation is an art.
    *   For the past few examples, we choose the generalisation to exploit **associativity**.

### Accumulating Parameter: Another Example (Sum of Squares)

Recall the "sum of squares" problem:
```haskell
sumsq [] = 0
sumsq (x : xs) = square x + sumsq xs
```
The program still takes linear space (for the stack of return addresses). Let us construct a tail recursive auxiliary function.

*   Introduce `ssp xs n = sumsq xs + n`.
*   Initialisation: `sumsq xs = ssp xs 0`.
*   Construct `ssp`:
    ```haskell
    ssp [] n
    = 0 + n = n

    ssp (x : xs) n
    = (square x + sumsq xs) + n
    = sumsq xs + (square x + n)
    = ssp xs (square x + n)
    ```

---

## 3. Proof by Strengthening

### Work Less by Proving More

*   A stronger theorem is easier to prove! Why is that?
*   By strengthening the theorem, we also have a **stronger induction hypothesis**, which makes an inductive proof possible.
*   The same with programming. By generalising a function with additional arguments, it is passed more information it may use.

### Summing Up a List in Reverse

Prove: `sum . reverse = sum`, using the definition `reverse xs = revcat xs []`.
That is, proving `sum (revcat xs []) = sum xs`.

**Base case**: Trivial.

**Inductive case (`x : xs`)**:
```haskell
sum (reverse (x : xs))
= sum (revcat (x : xs) [])
= sum (revcat xs [x])
```
Then we are stuck, since we cannot use the induction hypothesis `sum (revcat xs []) = sum xs` because the second argument is `[x]`, not `[]`.

**Technique**: Generalise `[x]` to a variable.

### Summing Up a List in Reverse, Second Attempt

Prove a lemma:
```haskell
sum (revcat xs ys) = sum xs + sum ys
```
By letting `ys = []` we get the original property.

**Proof**:
Base case `[]`:
```haskell
sum (revcat [] ys)
= sum ys
= 0 + sum ys
= sum [] + sum ys
```

Case `x : xs`:
```haskell
sum (revcat (x : xs) ys)
= sum (revcat xs (x : ys))
= { induction hypothesis }
sum xs + sum (x : ys)
= sum xs + x + sum ys
= sum (x : xs) + sum ys
```
Proof complete!

### A Real Case

Sometimes finding the right generalisation is difficult. The author once spent a week to find the right generalisation for a proof, which then took 20 minutes to complete.

"Someone once described research as 'finding out something to find out, then finding it out'; the first part is often harder than the second."

### Remark

*   The `sum . reverse` example is superficial — the same property is much easier to prove using the $O(n^2)$-time definition of `reverse`.
*   That's one of the reason we defer the discussion about efficiency — to prove properties of a function we sometimes prefer to roll back to a slower version.