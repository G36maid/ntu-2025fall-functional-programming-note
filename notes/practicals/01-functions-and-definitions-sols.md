# Practical 01: Functions and Definitions - Solutions

This document provides the solutions and explanations for the exercises in Practical 01.

## 1. Even Number Function

**Task:** Define `myeven :: Int → Bool` that determines if a number is even.

**Solution:**
```haskell
myeven :: Int -> Bool
myeven x = x `mod` 2 == 0
```

## 2. Circle Area

**Task:** Define a function to compute the area of a circle using `22/7` for π.

**Solution:**
```haskell
area :: Float -> Float
area r = (22 / 7) * r * r
```

## 3. Payment Calculation

### 3a. Using `let`

**Task:** Calculate payment for a student based on weeks worked, using `let`.

**Solution:**
```haskell
payment :: Int -> Int
payment weeks = 
    let days = 5 * weeks
        hours = 8 * days
    in 130 * hours
```

### 3b. Using `where`

**Task:** Redefine the payment function using `where`.

**Solution:**
```haskell
payment :: Int -> Int
payment weeks = 130 * hours
    where hours = 8 * days
          days = 5 * weeks
```

### 3c. With Insurance (Guards)

**Task:** Update the payment function to include a 6% charge for work over 19 weeks.

**Solution:**
```haskell
payment :: Int -> Int
payment weeks 
    | weeks > 19 = round (fromIntegral baseSalary * 1.06)
    | otherwise = baseSalary
    where baseSalary = 130 * hours
          hours = 8 * days
          days = 5 * weeks
```
**Explanation:** For this situation, `where` works better than `let` because we want the scope of `baseSalary` to extend to both guarded branches.

## 4. More on `let`

### 4a. Nested `let`

**Task:** Guess the value of `nested`.

**Code:**
```haskell
nested :: Int
nested = let x = 3
         in (let x = 5
             in x + x) + x
```
**Solution:** `nested` evaluates to **13**. The inner `x` in `x + x` refers to 5, while the outer `x` in `... + x` refers to 3.

### 4b. Recursive `let`

**Task:** Guess the value of `recursive`.

**Code:**
```haskell
recursive :: Int
recursive = let x = 3
            in let x = x + 1
               in x
```
**Solution:** This computation **does not terminate**. The `x` in `x + 1` refers to itself, creating an infinite loop. *Note: The original prompt had a different analysis, but this is the behavior in standard Haskell where `let` bindings are recursive.*

## 5. Function Types and Currying

This exercise was for exploration and understanding of partial application. The key takeaway is that applying a function to fewer arguments than it expects results in a new function. For example, `smaller 3` has the type `Int -> Int`.

## 6. Curried Functions Practice

**Task:** Define a polynomial function and reuse it.

**Solution:**
```haskell
-- Defines a general polynomial
poly :: Float -> Float -> Float -> Float -> Float
poly a b c x = a * x * x + b * x + c

-- Defines poly1(x) = x^2 + 2x + 1
poly1 :: Float -> Float
poly1 = poly 1 2 1

-- Defines poly2(a,b,c) = a*2^2 + b*2 + c
poly2 :: Float -> Float -> Float -> Float
poly2 a b c = poly a b c 2
```

## 7. Higher-Order Functions

### 7a. `quad` function

**Task:** Define `quad x` to compute x⁴.

**Solution:**
```haskell
quad :: Int -> Int
quad x = square (square x)
```

### 7b. `twice` function

**Task:** Describe what `twice` does.

**Solution:** `twice f x` applies a function `f` to an argument `x` twice, i.e., `f(f(x))`.

### 7c. `quad` using `twice`

**Task:** Redefine `quad` using `twice`.

**Solution:**
```haskell
quad :: Int -> Int
quad = twice square
```

## 8. Function Composition

**Task:** Explain the `(.)` operator in the new `twice` definition.

**Solution:** The `(.)` operator is for **function composition**. `(f . g) x` is equivalent to `f (g x)`. The definition `twice f = f . f` creates a new function that is the composition of `f` with itself.

## 9. Functions as Arguments

### 9b. Using `forktimes`

**Task:** Compute `x² + 3x + 2` using `forktimes`.

**Solution:**
```haskell
compute :: Int -> Int
compute = forktimes (+1) (+2)
```

### 9c. `lift2` type

**Task:** Find and explain the type of `lift2`.

**Solution:**
```haskell
lift2 :: (a -> b -> c) -> (d -> a) -> (d -> b) -> d -> c
```
It "lifts" a binary function `(a -> b -> c)` to work on the results of two unary functions `(d -> a)` and `(d -> b)`.

### 9d. Using `lift2`

**Task:** Compute `x² + 3x + 2` using `lift2`.

**Solution:**
```haskell
compute :: Int -> Int
compute = lift2 (*) (+1) (+2)
```

## 10. Type Checking

**Task:** Determine which expressions are type-correct.

**Solutions & Explanations:**

1.  `(g . f) x c`
    -   **Incorrect**. `g . f` means `g(f(x))`. `f x` returns a `Char`, but `g`'s first argument must be an `Int`.

2.  `(g x . f) y`
    -   **Correct**. `(g x . f) y` means `(g x)(f y)`.
    -   `f y :: Char`.
    -   `g x :: Char -> Int`.
    -   ` (g x)(f y) :: Int`. The expression is valid.

3.  `(h . g) x y`
    -   **Incorrect**. `(h . g) x y` means `h(g(x))(y)`.
    -   `g x :: Char -> Int`.
    -   `h(g x) :: Int -> Int`.
    -   `h(g x) y :: Int`. The expression seems valid based on this breakdown. Let's re-check the original solution's reasoning.
    -   *Correction from original PDF analysis*: The PDF states this is correct. Let's trace again: `(h . g) x y` is `((h . g) x) y` which is `(h (g x)) y`.
        - `g :: Int -> Char -> Int`, `x :: Int` => `g x :: Char -> Int`.
        - `h :: (Char -> Int) -> Int -> Int`. The first argument matches `g x`.
        - `h (g x) :: Int -> Int`.
        - `y :: Int`. So `(h (g x)) y :: Int`. **Correct**.

4.  `(h . g x) c`
    -   **Incorrect**. `(h . g x) c` means `h((g x)(c))`.
    -   `(g x)(c) :: Int`.
    -   `h` expects its first argument to be a function of type `Char -> Int`, but it receives an `Int`.

5.  `h . g x c`
    -   **Incorrect**. This parses as `h . (g x c)`.
    -   `g x c :: Int`.
    -   The composition operator `(.)` expects its second operand to be a function, not a value of type `Int`.