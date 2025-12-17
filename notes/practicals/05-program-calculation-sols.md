# Practicals 5 Solutions: Program Calculation

**Original Document**: [practicals_05_sols.pdf](../../course-materials/practicals/practicals_05_sols.pdf)

---

1.  **descend and sumseries**

    (a) Let `sumseries = sum . descend`. Synthesise an inductive definition of `sumseries`.

    **Solution:**
    It is immediate that `sum (descend 0) = 0`. For the inductive case we calculate:

    ```haskell
    sum (descend (1+ n))
    = { definition of descend }
    sum ((1+ n) : descend n)
    = { definition of sum }
    (1+ n) + sum (descend n)
    = { definition of sumseries }
    (1+ n) + sumseries n
    ```

    Thus we have:
    ```haskell
    sumseries 0 = 0
    sumseries (1+ n) = (1+ n) + sumseries n
    ```

    (b) Calculate an inductive definition of `repeatN`.

    **Solution:**
    It is immediate that `repeatN (0, x) = []`. For the inductive case we calculate:

    ```haskell
    repeatN (1+ n, x)
    = { definition of repeatN }
    map (const x) (descend (1+ n))
    = { definition of descend }
    map (const x) (1+ n : descend n)
    = { definition of map and const }
    x : map (const x) (descend n)
    = { definition of repeatN }
    x : repeatN (n, x)
    ```

    Thus we have:
    ```haskell
    repeatN (0, x) = []
    repeatN (1+ n, x) = x : repeatN (n, x)
    ```

    (c) Come up with an inductive definition of `rld`.

    **Solution:**
    For the base case:
    ```haskell
    rld []
    = { definition of rld }
    concat (map repeatN [])
    = { definitions of map and concat }
    []
    ```

    For the inductive case:
    ```haskell
    rld ((n, x) : xs)
    = { definition of rld }
    concat (map repeatN ((n, x) : xs))
    = { definitions of map }
    concat (repeatN (n, x) : map repeatN xs)
    = { definitions of concat }
    repeatN (n, x) ++ concat (map repeatN xs)
    = { definition of rld }
    repeatN (n, x) ++ rld xs
    ```

    We have thus derived:
    ```haskell
    rld [] = []
    rld ((n, x) : xs) = repeatN (n, x) ++ rld xs
    ```

    We can in fact further construct a definition of `rld` that does not use `(++)`, by pattern matching on `n`. It is immediate that `rld ((0, x) : xs) = rld xs`. By a routine calculation we get:

    ```haskell
    rld [] = []
    rld ((0, x) : xs) = rld xs
    rld ((1+ n, x) : xs) = x : rld ((n, x) : xs)
    ```

2.  **pos**

    Construct an inductive definition of `pos`.

    **Solution:**
    It is immediate that `pos x [] = 0`. For the inductive case we calculate:

    ```haskell
    pos x (y : ys)
    = { definition of pos }
    length (takeWhile (x /=) (y : ys))
    = { definition of takeWhile }
    length (if x /= y then y : takeWhile (x /=) ys else [])
    = { function application distributes into if, defn. of length }
    if x /= y then 1+ (length (takeWhile (x /=) ys)) else 0
    = { definition of pos }
    if x /= y then 1+ (pos x ys) else 0
    ```

    Thus we have constructed:
    ```haskell
    pos x [] = 0
    pos x (y : xs) = if x /= y then 1+ (pos x xs) else 0
    ```

3.  **Zipping and mapping**

    (a) Prove that `zip xs (map f ys) = map (second f) (zip xs ys)`.

    **Solution:**
    Recall one of the possible definitions of `zip`:
    ```haskell
    zip [] ys = []
    zip (x : xs) [] = []
    zip (x : xs) (y : ys) = (x, y) : zip xs ys
    ```

    We prove the proposition by induction on `xs` and `ys`.
    
    Case `xs := []`:
    ```haskell
    map (second f) (zip [] ys)
    = { definition of zip }
    map (second f) []
    = { definition of map }
    []
    = { definition of zip }
    zip [] (map f ys)
    ```

    Case `xs := x : xs`, `ys := []`:
    ```haskell
    map (second f) (zip (x : xs) [])
    = { definiton of zip }
    map (second f) []
    = { definition of map }
    []
    = { definition of zip }
    zip (x : xs) []
    = { definition of map }
    zip (x : xs) (map f [])
    ```

    Case `xs := x : xs`, `ys := y : ys`:
    ```haskell
    map (second f) (zip (x : xs) (y : ys))
    = { definition of zip }
    map (second f) ((x, y) : zip xs ys)
    = { definition of map }
    second f (x, y) : map (second f) (zip xs ys)
    = { definition of second }
    (x, f y) : map (second f) (zip xs ys)
    = { induction }
    (x, f y) : zip xs (map f ys)
    = { definiton of zip }
    zip (x : xs) (f y : map f ys)
    = { definition of map }
    zip (x : xs) (map f (y : ys))
    ```

    (b) Come up with an inductive definition of `select`.

    **Solution:**
    The base case `[]` is immediate. For the inductive case:

    ```haskell
    select (x : xs)
    = { definition of select }
    zip (x : xs) (delete (x : xs))
    = { definition of delete }
    zip (x : xs) (xs : map (x :) (delete xs))
    = { definition of zip }
    (x, xs) : zip xs (map (x :) (delete xs))
    = { property proved above }
    (x, xs) : map (second (x :)) (zip xs (delete xs))
    = { definition of select }
    (x, xs) : map (second (x :)) (select xs)
    ```

    We thus have:
    ```haskell
    select [] = []
    select (x : xs) = (x, xs) : map (second (x :)) (select xs)
    ```

    (c) Derive the inductive definition of `delete` from the alternative specification.

    **Solution:**
    ```haskell
    delete (x : xs)
    = { definition of delete }
    map (del (x : xs)) [0 .. length (x : xs) - 1]
    = { defintion of length, arithmetics }
    map (del (x : xs)) [0 .. length xs]
    = { length xs >= 0, by (1) }
    map (del (x : xs)) (0 : map (1+) [0 .. length xs - 1])
    = { definition of map }
    del (x : xs) 0 : map (del (x : xs)) (map (1+) [0 .. length xs - 1])
    = { map fusion (2) }
    del (x : xs) 0 : map (del (x : xs) . (1+)) [0 .. length xs - 1]
    ```

    Now we pause to inspect `del (x : xs)`. Apparently, `del (x : xs) 0 = xs`.
    For `del (x : xs) . (1+)` we calculate:

    ```haskell
    (del (x : xs) . (1+)) i
    = { definition of (.) }
    del (x : xs) (1+ i)
    = { definition of del }
    take (1+ i) (x : xs) ++ drop (1+ (1+ i)) (x : xs)
    = { definitions of take and drop }
    x : take i xs ++ drop (1+ i) xs
    = { definition of del }
    x : del xs i
    = { definition of (.) }
    ((x :) . del xs) i
    ```

    We resume the calculation:
    ```haskell
    del (x : xs) 0 : map (del (x : xs) . (1+)) [0 .. length xs - 1]
    = { calculation above }
    xs : map ((x :) . del xs) [0 .. length xs - 1]
    = { map fusion (2) }
    xs : map (x :) (map (del xs) [0 .. length xs - 1])
    = { definition of delete }
    xs : map (x :) (delete xs)
    ```
    We have thus derived the first, inductive definition of `delete`.

4.  **Map Fusion Law**

    Prove `map f . map g = map (f . g)`.

    **Solution:**
    To find out how to conduct induction:
    ```
    map f . map g = map (f . g)
    = { extensional equality }
    (forall xs : (map f . map g) xs = map (f . g) xs)
    = { definition of (.) }
    (forall xs : map f (map g xs) = map (f . g) xs)
    ```
    We prove the proposition by induction on `xs`.

    Case `xs := []`. Omitted.

    Case `xs := x : xs`.
    ```haskell
    map f (map g (x : xs))
    = { definition of map, twice }
    f (g x) : map f (map g xs)
    = { induction }
    f (g x) : map (f . g) xs
    = { definition of (.) }
    (f . g) x : map (f . g) xs
    = { definition of map }
    map (f . g) (x : xs)
    ```

5.  **Fast Exponentiation**

    (a) Define `binary`.

    **Solution:**
    ```haskell
    binary 0 = []
    binary n 
      | even n = F : binary (n `div` 2)
      | odd n  = T : binary (n `div` 2)
    ```

    (b) Termination argument.

    **Solution:**
    All non-zero natural numbers strictly decreases when being divided by 2, and thus we eventually reaches the base case for 0.

    (c) Define `decimal`.

    **Solution:**
    ```haskell
    decimal [] = 0
    decimal (c : cs) = if c then 1 + 2 * decimal cs else 2 * decimal cs
    ```
    Or equivalently:
    ```haskell
    decimal [] = 0
    decimal (False : cs) = 2 * decimal cs
    decimal (True : cs) = 1 + 2 * decimal cs
    ```

    (d) Construct a definition of `roll`.

    **Solution:**
    Let's calculate `roll m xs = exp m (decimal xs)` by distinguishing between the three cases of `xs`:

    Case `xs := []`:
    ```haskell
    roll m []
    = exp m (decimal [])
    = { definition of decimal }
    exp m 0
    = { definition of exp }
    1
    ```

    Case `xs := False : xs`:
    ```haskell
    roll m (False : xs)
    = { definition of roll }
    exp m (decimal (False : xs))
    = { definition of decimal }
    exp m (2 * decimal xs)
    = { arithmetic: m^(2n) = (m^2)^n }
    exp (m * m) (decimal xs)
    = { definition of roll }
    roll (m * m) xs
    ```

    Case `xs := True : xs`:
    ```haskell
    roll m (True : xs)
    = { definition of roll }
    exp m (decimal (True : xs))
    = { definition of decimal }
    exp m (1 + 2 * decimal xs)
    = { definition of exp }
    m * exp m (2 * decimal xs)
    = { arithmetic: m^(2n) = (m^2)^n }
    m * exp (m * m) (decimal xs)
    = { definition of roll }
    m * roll (m * m) xs
    ```

    We have thus constructed:
    ```haskell
    roll m [] = 1
    roll m (False : cs) = roll (m * m) cs
    roll m (True : cs) = m * roll (m * m) cs
    ```

6.  **Horner's Rule**

    (a) Show that `mul . second (y*) = (y*) . mul`.

    **Solution:**
    ```haskell
    mul (second (y*) (x, z))
    = { definition of second }
    mul (x, y * z)
    = { definition of mul }
    x * (y * z)
    = { arithmetics }
    y * (x * z)
    = { definition of mul }
    y * mul (x, z)
    ```

    (b) Asymptotic complexity of `horner y xs`.

    **Solution:**
    We need $O(n^2)$ multiplications.

    (c) Prove that `sum . map (y*) = (y*) . sum`.

    **Solution:**
    The aim is equivalent to prove that `sum (map (y*) xs) = y * sum xs` for all `xs`. The case for `xs := []` is immediate. We consider the case for `x := x : xs`.

    ```haskell
    sum (map (y*) (x : xs))
    = { definition of map }
    sum (y * x : map (y*) xs)
    = { definition of sum }
    y * x + sum (map (y*) xs)
    = { induction }
    y * x + y * sum xs
    = { arithmetics }
    y * (x + sum xs)
    = { definition of sum }
    y * sum (x : xs)
    ```

    (d) Construct an inductive definition of `horner` that uses only $O(n)$ multiplications.

    **Solution:**
    We construct an inductive definition of `horner` by case analysis.
    Case `xs := []`. It is immediate that `horner y [] = 0`. Details omitted.
    Case `xs := x : xs`:

    ```haskell
    horner y (x : xs)
    = { definition of horner }
    sum (map mul (zip (x : xs) (geo y)))
    = { definition of geo }
    sum (map mul (zip (x : xs) (1 : map (y*) (geo y))))
    = { definition of zip }
    sum (map mul ((x, 1) : zip xs (map (y*) (geo y))))
    = { definitions of map, mul, and sum }
    x + sum (map mul (zip xs (map (y*) (geo y))))
    = { since zip xs (map f ys) = map (second f) (zip xs ys) }
    x + sum (map mul (map (second (y*)) (zip xs (geo y))))
    = { map fusion }
    x + sum (map (mul . second (y*)) (zip xs (geo y)))
    = { since mul . second (y*) = (y*) . mul, map fusion }
    x + sum (map (y*) (map mul (zip xs (geo y))))
    = { since sum . map (y*) = (y*) . sum }
    x + y * sum (map mul (zip xs (geo y)))
    = { definition of horner }
    x + y * horner y xs
    ```

    Thus we conclude that:
    ```haskell
    horner y [] = 0
    horner y (x : xs) = x + y * horner y xs
    ```
