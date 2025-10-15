# Worksheet 1 & 2: Introduction to Haskell

**Author:** Shin-Cheng Mu
**Term:** Autumn 2025

---

- Everything in this worksheet are mentioned in the handouts already. This worksheet is a way to guide you through the materials so that you can learn mostly by yourself.
- To start with, read through the handout “1. Introduction to Haskell: Value, Functions, And Types”. Do not worry if you cannot understand everything — that is what this worksheet is for.
- Read the first two pages of the handout “2. Introduction to Haskell: Simple Datatypes & Functions on Lists” (up to Section 2.1 “List Generation”).
- Start ghci and try the following tasks.

## Functions Definitions and Types

Be sure that you have downloaded `MiniPrelude.hs`. Create a new file in your editor, starting with the two lines:
```haskell
import Prelude ()
import MiniPrelude
```
And try questions 3 - 10 of Practicals 1, if you have not done so.

Recall that once you import `MiniPrelude`, the operators for addition and multiplication for `Float` are renamed to `(+.)` and `(*.)`.

Some of the questions are simply designed to get you familiar with the syntax (of function definitions, `let`, `where`, guards, etc). Pay attention to function composition `(.)` and be sure that you understand it. The latter part of the questions are about types and could be confusing. Feel free to ask the instructor, if needed.

## List Deconstruction

The following can be done in `ghci`.

1.  (a) What is the type of the function `head`? Use the command `:t` to find out the type of a value.
    (b) Since the input type of `head` is a list (`List a`), let us try it on some input.
        i. `head [1, 2, 3]` =
        ii. `head "abcde"` =
        iii. `head []` =
    (c) Recall that the type `String` in Haskell is the same as `List Char`. Notice that `[1, 2, 3]` and `"abcde"` have different types. Why can we apply the same function `head` to them? Read the part about polymorphic type in the handouts if you are not sure.
    (d) In words, what does the function `head` do?

2.  (a) What is the type of the function `tail`?
    (b) Try `tail` on some input.
        i. `tail [1, 2, 3]` =
        ii. `tail "abcde"` =
        iii. `tail []` =
    (c) In words, what does the function `tail` do?
    (d) Is it true that `head xs : tail xs = xs`, for all `xs`? Can you think of an `xs` for which the property does not hold?

3.  (a) The function `(:)` should have type `a -> List a -> List a`. Try `(:)` on some input.
        i. `1 : [2, 3]` =
        ii. `'a' : "bcde"` =
        iii. `[1] : [2, 3]` = (Fails, why?)
        iv. `[1] : [[2], [3, 4]]` =
        v. `[[1]] : [[2], [3, 4]]` =
        vi. `[1, 2] : 3` = (Fails, why?)
        vii. `[1, 2] : [3]` = (Fails, why?)
    (b) In words, what does the function `(:)` do?

4.  (a) What is the type of the function `(++)`?
    (b) Try `(++)` on some input.
        i. `[1, 2, 3] ++ [4, 5]` =
        ii. `[] ++ [4, 5]` =
        iii. `[1, 2] ++ []` =
        iv. `1 ++ [2, 3]` = (Fails, why?)
        v. `[1, 2] ++ 3` = (Fails, why?)
    (c) In words, what does the function `(++)` do?
    (d) Both `(:)` and `(++)` seem to concatenate things into lists. How are they different?

5.  (a) What is the type of the function `last`?
    (b) Try `last` on some input.
    (c) In words, what does the function `last` do?

6.  (a) What is the type of the function `init`?
    (b) Try `init` on some input. Try to cause the function to fail.
    (c) In words, what does the function `init` do?
    (d) What property does `init` and `last` (and perhaps `(++)`) jointly satisfy?

7.  (a) What is the type of the function `null`?
    (b) Try `null` on some input.
    (c) Can you write down a definition of `null`, by pattern matching?

## List Generation

1.  What are the results of the following expressions?
    (a) `[0..25]` =
    (b) `[0, 2..25]` =
    (c) `[25..0]` =
    (d) `['a'..'z']` =
    (e) `[1..]` =

2.  What are the results of the following expressions?
    (a) `[x | x <- [1..10]]` =
    (b) `[x * x | x <- [1..10]]` =
    (c) `[(x, y) | x <- [0..2], y <- "abc"]` =
    (d) What is the type of the expression above?
    (e) `[x * x | x <- [1..10], odd x]` =

3.  What are the results of the following expressions?
    (a) `[(a, b) | a <- [1..3], b <- [1..2]]` =
    (b) `[(a, b) | b <- [1..2], a <- [1..3]]` =
    (c) `[(i, j) | i <- [1..4], j <- [(i + 1)..4]]` =
    (d) `[(i, j) | i <- [1..4], even i, j <- [(i + 1)..4], odd j]` =

## Combinators on Lists

1.  (a) What is the type of `(!!)`?
    (b) Try `[1, 2, 3] !! 1`. What does it do?

2.  (a) What is the type of `length`?
    (b) What does it do?

3.  (a) What is the type of `concat`?
    (b) How are `(:)`, `(++)`, and `concat` different?

4.  (a) What is the type of `take`?
    (b) Try `take` on extreme cases (e.g., `take 0 xs`, `take (-1) xs`, `take 100 xs` on a short list).

5.  (a) What is the type of `drop`?
    (b) What property do `take`, `drop`, and `(++)` together satisfy?

6.  (a) What is the type of `map`?
    (b) Try `map (1+) [1, 2, 3, 4]`.
    (c) Is `(1+)` a function? What is `((1+) . (1+) . (1+)) 0`?

## Sectioning

Infix operators can be partially applied:
- `(x ⊕) y = x ⊕ y`
- `(⊕ y) x = x ⊕ y`

1.  Define `doubleAll :: [Int] -> [Int]` that doubles each number.
2.  Define `quadAll :: [Int] -> [Int]` that quadruples each number, using `doubleAll`.

## λ Abstraction

Use `\` for λ in ASCII.
- `map (\x -> x * x) [1, 2, 3, 4]`

1.  What is the type of `(\x -> x + 1)`?
2.  What is the type of `(\x y -> x + 2 * y)`?
3.  What is `(\x y -> x + 2 * y) 1 2`?
4.  Define `doubleAll` again using a λ expression.
5.  What is the type of `(\(x, y) -> (y, x))`?

## Back to Lists

1.  (a) What is the type of `filter`?
    (b) Try `filter even [1..10]`.

2.  (a) What is the type of `takeWhile`?
    (b) How does it differ from `filter`?
    (c) Define `squaresUpto :: Int -> [Int]` that gives all positive square numbers at most `n`.

3.  (a) What is the type of `dropWhile`?

4.  (a) What is the type of `zip`?
    (b) Try `zip [1..10] "abcde"` and `zip "abcde" [0..]`.
    (c) Define `positions :: Char -> String -> [Int]` (e.g., `positions 'o' "roodo" = [1, 2, 4]`).
    (d) Define `pos :: Char -> String -> Int` for the first occurrence, by reusing `positions`.