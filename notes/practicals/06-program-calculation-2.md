# Practicals 6: Program Calculation

**Original Document**: [practicals_06.pdf](../../course-materials/practicals/practicals_06.pdf)

---

1.  Consider the internally labelled binary tree:

    ```haskell
    data ITree a = Null | Node a (ITree a) (ITree a)
    ```

    (a) Define `sumT :: ITree Int -> Int` that computes the sum of labels in an `ITree`.

    (b) A **baobab tree** is a kind of tree with very thick trunks. An `ITree Int` is called a baobab tree if every label in the tree is larger than the sum of the labels in its two subtrees. The following function determines whether a tree is a baobab tree:

    ```haskell
    baobab :: ITree Int -> Bool
    baobab Null = True
    baobab (Node x t u) = baobab t && baobab u && x > (sumT t + sumT u)
    ```

    What is the time complexity of `baobab`? Define a variation of `baobab` that runs in time proportional to the size of the input tree by tupling.

2.  Recall the externally labelled binary tree:

    ```haskell
    data ETree a = Tip a | Bin (ETree a) (ETree a)
    ```

    The function `size` computes the size (number of labels) of a tree, while `repl t xs` tries to relabel the tips of `t` using elements in `xs`. Note the use of `take` and `drop` in `repl`:

    ```haskell
    size (Tip _) = 1
    size (Bin t u) = size t + size u

    repl :: ETree a -> List b -> ETree b
    repl (Tip _) xs = Tip (head xs)
    repl (Bin t u) xs = Bin (repl t (take n xs)) (repl u (drop n xs))
      where n = size t
    ```

    The function `repl` runs in time $O(n^2)$ where $n$ is the size of the input tree. Can we do better? Try discovering a linear-time algorithm that computes `repl`.

    **Hint**: try calculating the following function:

    ```haskell
    repTail :: ETree a -> List b -> (ETree b, List b)
    repTail s xs = (???, ???)
    ```

    where the function `repTail` returns a tree labelled by some prefix of `xs`, together with the suffix of `xs` that is not yet used (how to specify that formally?).

    You might need properties including:
    *   `take m (take (m + n) xs) = take m xs`
    *   `drop m (take (m + n) xs) = take n (drop m xs)`
    *   `drop (m + n) xs = drop n (drop m xs)`

3.  The function `tags` returns all labels of an internally labelled binary tree:

    ```haskell
    tags :: ITree a -> List a
    tags Null = []
    tags (Node x t u) = tags t ++ [x] ++ tags u
    ```

    Try deriving a faster version of `tags` by calculating:

    ```haskell
    tagsAcc :: ITree a -> List a -> List a
    tagsAcc t ys = tags t ++ ys
    ```

4.  Recall the standard definition of factorial:

    ```haskell
    fact :: Nat -> Nat
    fact 0 = 1
    fact (1+ n) = (1+ n) * fact n
    ```

    This program implicitly uses space linear to `n` in the call stack.

    1.  Introduce `factAcc n m = ...` where `m` is an accumulating parameter.
    2.  Express `fact` in terms of `factAcc`.
    3.  Construct a space efficient implementation of `factAcc`.

5.  Define the following function `expAcc`:

    ```haskell
    expAcc :: Nat -> Nat -> Nat -> Nat
    expAcc b n x = x * exp b n
    ```

    (a) Calculate a definition of `expAcc` that uses only $O(\log n)$ multiplications to compute $b^n$. You may assume all the usual arithmetic properties about exponentials. Hint: consider the cases when `n` is zero, non-zero even, and odd.

    (b) The derived implementation of `expAcc` shall be tail-recursive. What imperative loop does it correspond to?

6.  Recall the standard definition of Fibonacci:

    ```haskell
    fib :: Nat -> Nat
    fib 0 = 0
    fib 1 = 1
    fib (1+ (1+ n)) = fib (1+ n) + fib n
    ```

    Let us try to derive a linear-time, tail-recursive algorithm computing `fib`.

    1.  Given the definition `ffib n x y = fib n * x + fib (1+ n) * y`. Express `fib` using `ffib`.
    2.  Derive a linear-time version of `ffib`.