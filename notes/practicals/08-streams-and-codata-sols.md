# Practicals 8 Solutions: Streams and Codata

**Original Document**: [practicals_08_sols.pdf](../../course-materials/practicals/practicals_08_sols.pdf)

---

1.  **Try constructing the following streams.**

    (a) The stream of alternating 1 and -1’s: `[1, -1, 1, -1 ..]`.
    **Solution:** `1 \/ (-1)`.

    (b) The stream of all natural numbers (`[0, 1, 2 ..]`).
    **Solution:** `iterate (1+) 0`.

    (c) All the square numbers: `[0, 1, 4, 9, 16, 25 ..]`.
    **Solution:** `nat * nat`, or `map (\x -> x ^ 2) nat`, etc.

    (d) The sequence of natural numbers divisible by 3.
    **Solution:** `3 * nat`.

    (e) The sequence of natural numbers not divisible by 3.
    **Solution:** `1 + 3 * nat \/ 2 + 3 * nat`.

    (f) The sequence of all finite binary strings.
    **Solution:** `allBits = [] : map (0:) allBits \/ map (1:) allBits`.

    (g) The bit-reversed representation of binary numbers.
    **Solution:**
    ```haskell
    binReps = [] : binReps'
    binReps' = [1] : map (0:) binReps' \/ map (1:) binReps'
    ```

    (h) A sequence indexed by positive integers (starting from 1), such that position `i` is `True` if `i` is a power of two, `False` otherwise.
    **Solution:** `pot = True : pot \/ repeat False`.

2.  **Let `n` be an `Int`, prove that `n + xs = map (n+) xs`.**

    **Solution:**
    Expanding `n + xs`:
    ```haskell
    n + xs
    = { definition of repeat }
    (n : repeat n) + xs
    = { definition of (+) }
    (n + head xs) : (n + tail xs)
    ```

    Expanding `map (n+) xs`:
    ```haskell
    map (n+) xs = (n + head xs) : map (n+) (tail xs)
    ```

    Both have the form `f xs = (n + head xs) : f (tail xs)`, which is an admissible expression, and therefore `n + xs = map (n+) xs`.

3.  **Recursive expressions not having unique solutions.**

    (a) Find at least two `xs` such that `xs = head xs : tail xs`.
    **Solution:** In fact, any stream satisfies `xs = head xs : tail xs`.

    (b) Show that `xs := c + ones` satisfy `xs = xs \/ 1 + xs`.

    **Solution:**
    Recall that `ones = 0 : 1 : ones' \/ 1 + ones'`. We calculate:
    ```haskell
    (c + ones) \/ 1 + (c + ones)
    = { definition of ones and (+) }
    (c : c + ones') \/ (1 + c : 1 + c + ones')
    = { definition of (\/), twice }
    c : 1 + c : c + ones' \/ 1 + c + ones'
    = { distributivity }
    c + (0 : 1 : ones' \/ 1 + ones')
    = { ones = 0 : 1 : ones' \/ 1 + ones' }
    c + ones
    ```

4.  **Distributivity law**

    Prove `n + (xs \/ ys) = n + xs \/ n + ys`.

    **Solution:**
    Expanding `n + (xs \/ ys)`:
    ```haskell
    n + (xs \/ ys)
    = { definitions of repeat and (\/) }
    (n : repeat n) + (head xs : ys \/ tail xs)
    = { definition of (+) }
    (n + head xs) : (n + (ys \/ tail xs))
    ```

    Expanding `n + xs \/ n + ys`:
    ```haskell
    n + xs \/ n + ys
    = { definitions of repeat }
    (n : repeat n) + xs \/ n + ys
    = { definition of (+) }
    ((n + head xs) : (n + tail xs)) \/ n + ys
    = { definition of (\/) }
    (n + head xs) : n + ys \/ n + tail xs
    ```
    Both have the form `f n xs ys = (n + head xs) : f n ys (tail xs)`, which is an admissible equation. Therefore they must be equal.

    **Counter example** for `zs + (xs \/ ys) = zs + xs \/ zs + ys`:
    Let `zs = nat`, `xs = nat`, `ys = nat`.
    `zs + (xs \/ ys) = 1 + x0 : 2 + y0 : 3 + x1 : 4 + y1 ...`
    `zs + xs \/ zs + ys = 1 + x0 : 1 + y0 : 2 + x1 : 2 + y1 ...`
    Apparently not equal in general.

5.  **Prove that `(-1) ^ nat = 1 \/ (-1)`.**

    **Solution:**
    We start with expanding `(-1) ^ nat`:
    ```haskell
    (-1) ^ nat
    = { definition of nat }
    (-1) ^ (0 : 1 + nat)
    = { definition of (^) }
    (-1) ^ 0 : (-1) ^ (1 + nat)
    = { arithmetics }
    1 : (-1) * (-1) ^ nat
    ```

    Expanding `1 \/ (-1)`:
    ```haskell
    1 \/ (-1)
    = { definition of repeat }
    (1 : repeat 1) \/ (-1)
    = { definition of (\/) }
    1 : (-1) \/ 1
    = { arithmetics }
    1 : ((-1) * 1) \/ (-1 * (-1))
    = { distributivity }
    1 : (-1) * (1 \/ (-1))
    ```
    Therefore `(-1) ^ nat = 1 \/ (-1)`.

6.  **Given `nat = 0 : 1 + nat` and `bin = 0 : 1 + 2 * bin \/ 2 + 2 * bin`, prove that `nat = bin`.**

    **Solution:**
    It turns out to be easier to prove that `nat` matches the recursion pattern of `bin`.
    We have proved in the handouts that `nat = 2 * nat \/ 1 + 2 * nat`.
    
    ```haskell
    nat
    = { definition of nat }
    0 : 1 + nat
    = { property above }
    0 : 1 + (2 * nat \/ 1 + 2 * nat)
    = { distributivity, arithmetics }
    0 : 1 + 2 * nat \/ 2 + 2 * nat
    ```
    Therefore `nat = bin`.

7.  **Prove `map h bin` pattern.**

    Given `h` defined by:
    ```haskell
    h 0 = k
    h (1 + 2 * n) = f (h n)
    h (2 + 2 * n) = g (h n)
    ```
    Prove `map h bin = k : map f (map h bin) \/ map g (map h bin)`.

    **Solution:**
    Note that the definition says that `h . (1+) . (2*) = f . h` and `h . (2+) . (2*) = g . h`.

    ```haskell
    map h bin
    = { definition of bin }
    map h (0 : 1 + 2 * bin \/ 2 + 2 * bin)
    = { definition of map and h }
    k : map h (1 + 2 * bin \/ 2 + 2 * bin)
    = { map distributes into (\/) }
    k : map h (1 + 2 * bin) \/ map h (2 + 2 * bin)
    = { map fusion }
    k : map (h . (1+) . (2*)) bin \/ map (h . (2+) . (2*)) bin
    = { definition of h }
    k : map f (map h bin) \/ map g (map h bin)
    ```

8.  **Prove that `nat / 2 = nat \/ nat`.**

    **Solution:**
    Expanding `nat / 2`:
    ```haskell
    nat / 2
    = { definition of nat }
    (0 : 1 + nat) / 2
    = { definition of (/) }
    (0 / 2) : (1 + nat) / 2
    = { definition of nat }
    0 : (1 + (0 : 1 + nat)) / 2
    = { definition of (+) }
    0 : (1 : 2 + nat) / 2
    = { definition of (/), arithmetics }
    0 : 0 : 1 + nat / 2
    ```

    Expanding `nat \/ nat`:
    ```haskell
    nat \/ nat
    = { definition of nat }
    (0 : 1 + nat) \/ nat
    = { definition of (\/) }
    0 : nat \/ 1 + nat
    = { definition of (nat) }
    0 : (0 : 1 + nat) \/ 1 + nat
    = { definition of (\/) }
    0 : 0 : 1 + nat \/ 1 + nat
    = { (1+) distributes into (\/) }
    0 : 0 : 1 + (nat \/ nat)
    ```
    Both have form `X = 0 : 0 : 1 + X`, therefore `nat / 2 = nat \/ nat`.

9.  **Prove the abide law: `(fs <*> xs) \/ (gs <*> ys) = (fs \/ gs) <*> (xs \/ ys)`.**

    **Solution:**
    Expanding `(fs <*> xs) \/ (gs <*> ys)`:
    ```haskell
    (fs <*> xs) \/ (gs <*> ys)
    = { definition of (<*>) }
    (head fs (head xs) : tail fs <*> tail xs) \/ (gs <*> ys)
    = { definition of (\/) }
    head fs (head xs) : (gs <*> ys) \/ (tail fs <*> tail xs)
    ```

    Expanding `(fs \/ gs) <*> (xs \/ ys)`:
    ```haskell
    (fs \/ gs) <*> (xs \/ ys)
    = { definition of (\/) }
    (head fs : gs \/ tail fs) <*> (head xs : ys \/ tail xs)
    = { definition of (<*>) }
    head fs (head xs) : (gs \/ tail fs) <*> (ys \/ tail xs)
    ```
    Both have the form `f fs xs gs ys = head fs (head xs) : f gs ys (tail fs) (tail xs)`, therefore they are equal.