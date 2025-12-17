# Practicals 8: Streams and Codata

**Original Document**: [practicals_08.pdf](../../course-materials/practicals/practicals_08.pdf)

**Solutions**: [practicals_08_sols.pdf](../../course-materials/practicals/practicals_08_sols.pdf)

---

1.  Try constructing the following streams. There might be more than one way to do so.

    (a) The stream of alternating 1 and -1’s: `[1, -1, 1, -1 ..]`. Try generating it in a way different from that in the handouts.

    (b) The stream of all natural numbers (`[0, 1, 2 ..]`). Try generating it in a way different from that in the handouts.

    (c) All the square numbers: `[0, 1, 4, 9, 16, 25 ..]`.

    (d) The sequence of natural numbers divisible by 3.

    (e) The sequence of natural numbers not divisible by 3.

    (f) The sequence of all finite binary strings (having type `Stream (List Int)`):

    `[[], [0], [1], [0, 0], [1, 0], [0, 1], [1, 1], [0, 0, 0], [1, 0, 0], [0, 1, 0]...]`

    (g) The bit-reversed representation of binary numbers (having type `Stream (List Int)`):

    `[[], [1], [0, 1], [1, 1], [0, 0, 1], [1, 0, 1], [0, 1, 1], [1, 1, 1], [0, 0, 0, 1]...]`

    (h) A sequence indexed by positive integers (starting from 1), such that position $i$ is `True` if $i$ is a power of two (2, 4, 8, 16.. etc), `False` otherwise.

2.  Let `n` be an `Int`, prove that `n + xs = map (n+) xs`. Note: recall that, according to the definition in our handouts, in `n + xs`, `n` is actually `repeat n` and `(+)` is `zipWith (+)`.

3.  To see the importance of admissibility, let us see some recursive expression not having unique solutions.

    (a) Find at least two `xs` such that `xs = head xs : tail xs`.

    (b) Show that `xs := c + ones` satisfy `xs = xs \/ 1 + xs`. Since there is no restriction on the value of `c`, that implies that `xs = xs \/ 1 + xs` has infinite solutions for `xs`.

4.  Prove the distributivity law `n + (xs \/ ys) = n + xs \/ n + ys`, where `n :: Int`. Give a counter example showing that `zs + (xs \/ ys) = zs + xs \/ zs + ys` does not hold in general.

5.  Prove that `(-1) ^ nat = 1 \/ (-1)`.

6.  Given `nat = 0 : 1 + nat` and `bin = 0 : 1 + 2 * bin \/ 2 + 2 * bin`, prove that `nat = bin`.

7.  Given a function `h` defined by:

    ```haskell
    h 0 = k
    h (1 + 2 * n) = f (h n)
    h (2 + 2 * n) = g (h n)
    ```

    prove that the sequence `map h bin = xs` where

    ```haskell
    xs = k : map f xs \/ map g xs
    ```

8.  Prove that `nat / 2 = nat \/ nat`, where `(/)` is integral division.

9.  Prove the abide law: `(fs <*> xs) \/ (gs <*> ys) = (fs \/ gs) <*> (xs \/ ys)`.