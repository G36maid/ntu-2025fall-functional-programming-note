# Simple Program Calculation

**Original Document**: [handouts_05.pdf](../../course-materials/handouts/handouts_05.pdf)

## A Quick Review

*   Functions are the basic building blocks. They may be passed as arguments, may return functions, and can be composed together.
*   While one issues commands in an imperative language, in functional programming we specify values, and computers try to reduce the values to their normal forms.
*   **Formal reasoning**: reasoning with the form (syntax) rather than the semantics. Let the symbols do the work!
*   **'Wholemeal' programming**: think of aggregate data as a whole, and process them as a whole.
*   Once you describe the values as algebraic datatypes, most programs write themselves through structural recursion.
*   Programs and their proofs are closely related. They share similar structure, by induction over input data.

---

## 1. Some Comments on Efficiency

So far we have (surprisingly) been talking about mathematics without much concern regarding efficiency. Time for a change. Take lists for example.

### Data Representation

Recall the definition:
```haskell
data List a = [] | a : List a
```
*   Our representation of lists is biased. The left most element can be fetched immediately.
*   Thus `(:)`, `head`, and `tail` are constant-time operations, while `init` and `last` takes linear-time.
*   In most implementations, the list is represented as a linked-list.

### Full Persistency

*   Compound data structures, like simple values, are just values, and thus must be fully persistent.
*   That is, in the following code:
    ```haskell
    let xs = [1, 2, 3]
        ys = [4, 5]
        zs = xs ++ ys
    in ... body ...
    ```
    The body may have access to all three values. Thus `++` cannot perform a destructive update.

### Linked v.s. Block Data Structures

*   Trees are usually represented in a similar manner, through links.
*   Fully persistency is easier to achieve for such linked data structures.
*   Accessing arbitrary elements, however, usually takes linear time.
*   In imperative languages, constant-time random access is usually achieved by allocating lists (usually called arrays in this case) in a consecutive block of memory.

**Updating arrays:**
```haskell
let xs = [1..100]
    ys = update xs 10 20
in ... body ...
```
*   To allow access to both `xs` and `ys` in body, the `update` operation has to duplicate the entire array.
*   Thus people have invented some smart data structure to do so, in around $O(\log n)$ time.
*   On the other hand, `update` may simply overwrite `xs` if we can somehow make sure that nobody other than `ys` uses `xs` (Advanced topic).

### List Concatenation Takes Linear Time

Recall `(++)`:
```haskell
[] ++ ys = ys
(x : xs) ++ ys = x : (xs ++ ys)
```

Consider `[1, 2, 3] ++ [4, 5]`:
```haskell
(1 : 2 : 3 : []) ++ (4 : 5 : [])
= 1 : ((2 : 3 : []) ++ (4 : 5 : []))
= 1 : 2 : ((3 : []) ++ (4 : 5 : []))
= 1 : 2 : 3 : ([] ++ (4 : 5 : []))
= 1 : 2 : 3 : 4 : 5 : []
```
*   `(++)` runs in time proportional to the length of its **left** argument.

### Another Linear-Time Operation

Taking all but the last element of a list:

```haskell
init [x]      = []
init (x : xs) = x : init xs
```
Consider `init [1, 2, 3, 4]`:
```haskell
init (1 : 2 : 3 : 4 : [])
= 1 : init (2 : 3 : 4 : [])
= 1 : 2 : init (3 : 4 : [])
= 1 : 2 : 3 : init (4 : [])
= 1 : 2 : 3 : []
```

### Sum, Map, etc

*   Functions like `sum`, `maximum`, etc. needs to traverse through the list once to produce a result. So their running time is definitely $O(n)$, where $n$ is the length of the list.
*   If `f` takes time $O(t)$, `map f` takes time $O(n \times t)$ to complete. Similarly with `filter p`.

---

## 2. A First Taste of Program Calculation

Properties of programs can be reasoned about in equations, just like high school algebra.

### Sum of Squares

Given a sequence $a_1, a_2, ..., a_n$, compute $a_1^2 + a_2^2 + ... + a_n^2$.

**Specification**:
```haskell
sumsq = sum . map square
```
The spec builds an intermediate list. Can we eliminate it?

The input is either empty or not.

**Case 1: Empty List**
```haskell
sumsq []
= { definition of sumsq }
(sum . map square) []
= { function composition }
sum (map square [])
= { definition of map }
sum []
= { definition of sum }
0
```

**Case 2: The Inductive Case (x:xs)**
```haskell
sumsq (x : xs)
= { definition of sumsq }
sum (map square (x : xs))
= { definition of map }
sum (square x : map square xs)
= { definition of sum }
square x + sum (map square xs)
= { definition of sumsq }
square x + sumsq xs
```

### Alternative Definition for `sumsq`

From `sumsq = sum . map square`, we have proved that:

```haskell
sumsq [] = 0
sumsq (x : xs) = square x + sumsq xs
```

*   Equivalently, we have shown that `sum . map square` is a solution of:
    ```haskell
    f [] = 0
    f (x : xs) = square x + f xs
    ```
*   However, the solution of the equations above is **unique**.
*   Thus we can take it as another definition of `sumsq`.
    *   Denotationally it is the same function.
    *   Operationally, it is (slightly) quicker (avoids intermediate list).

### Remark: Why Functional Programming?

*   Time to muse on the merits of functional programming. Why functional programming?
    *   Algebraic datatype? List comprehension? Lazy evaluation? Garbage collection? These are just language features that can be migrated.
    *   **No side effects**. But why taking away a language feature?
*   By being pure, we have a simpler semantics in which we are allowed to construct and reason about programs.
    *   In an imperative language we do not even have `f 4 + f 4 = 2 * f 4` (if `f` modifies global state).
*   **Ease of reasoning**. That’s the main benefit we get.

### How Far Can We Get?

Specification of **maximum segment sum**:

```haskell
mss :: List Int -> Int
mss = maximum . map sum . segments

segments :: List a -> List (List a)
segments = concat . map inits . tails
-- Or, segments xs = [zs | ys <- tails xs, zs <- inits ys]
```

From the specification we can calculate a linear time algorithm (to be discussed later).