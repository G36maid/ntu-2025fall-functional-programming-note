# Practical 01: Functions and Definitions

## Setup
- Install GHC with command-line interface GHCi
- Create a new plain text file with `.hs` extension
- Load file into GHCi with: `ghci <filename>.hs`

## Exercise 1: Even Number Function

Define a function `myeven :: Int → Bool` that determines whether input is even.

**Available functions:**
- `mod :: Int → Int → Int`
- `(==) :: Int → Int → Bool`

**Solution:**
```haskell
myeven :: Int -> Bool
myeven n = mod n 2 == 0
```

## Exercise 2: Circle Area

Define a function that computes the area of a circle with given radius r.
- Use `22/7` as approximation to π
- Return type should be `Float`

**Solution:**
```haskell
circleArea :: Float -> Float
circleArea r = (22/7) * r * r
```

## Exercise 3: Payment Calculation

Part-time students in Institute of Information Science are paid NTD 130 per hour.
Define `payment :: Int → Int` that computes payment for given weeks worked.

### 3a: Using `let`

Assumptions:
- 5 working days per week
- 8 working hours per day

**Solution:**
```haskell
payment :: Int -> Int
payment weeks = 
    let days = weeks * 5
        hours = days * 8
        salary = hours * 130
    in salary
```

### 3b: Using `where`

**Solution:**
```haskell
payment :: Int -> Int
payment weeks = salary
    where days = weeks * 5
          hours = days * 8
          salary = hours * 130
```

**Note:** Both styles are valid. `where` is often preferred for readability.

### 3c: With Insurance (Guards)

If worker works > 19 weeks, Institute pays additional 6% for health insurance and pension.

**Functions needed:**
- `fromIntegral :: Int -> Float`
- `round :: Float -> Int`

**Solution:**
```haskell
payment :: Int -> Int
payment weeks 
    | weeks > 19 = round (fromIntegral baseSalary * 1.06)
    | otherwise = baseSalary
    where days = weeks * 5
          hours = days * 8
          baseSalary = hours * 130
```

**Note:** Use `where` here since guards make `let` awkward.

## Exercise 4: More on `let`

### 4a: Nested `let` expressions

**Code:**
```haskell
nested :: Int
nested = let x = 3
         in (let x = 5
             in x + x) + x
```

**Analysis:**
- Inner `x = 5`, so `x + x = 10`
- Outer `x = 3`, so `10 + 3 = 13`
- **Result:** `nested = 13`

### 4b: Recursive `let`

**Code:**
```haskell
recursive :: Int
recursive = let x = 3
            in let x = x + 1
               in x
```

**Analysis:**
- Inner `x` refers to outer `x`
- `x = 3 + 1 = 4`
- **Result:** `recursive = 4`

## Exercise 5: Function Types and Currying

**Given function:**
```haskell
smaller :: Int -> Int -> Int
smaller x y = if x <= y then x else y
```

### Exploration:
a) `:t smaller` shows `smaller :: Int -> Int -> Int`
b) `smaller 3 4` returns `3`, `smaller 3 1` returns `1`
c) `:t smaller 3 4` shows `Int`
d) `:t smaller 3` shows `Int -> Int`
e) Define: `st3 = smaller 3`
f) `:t st3` shows `Int -> Int`; `st3 4` returns `3`, `st3 1` returns `1`

**Explanation:** `smaller 3` is a **partially applied function** that takes one argument and compares it with 3.

## Exercise 6: Curried Functions Practice

### 6a: Polynomial Function

**Task:** Define `poly a b c x = a × x² + b × x + c` (all `Float`)

**Solution:**
```haskell
poly :: Float -> Float -> Float -> Float -> Float
poly a b c x = a * x * x + b * x + c
```

### 6b: Specific Polynomial

**Task:** Define `poly1 x = x² + 2x + 1` using `poly`

**Solution:**
```haskell
poly1 :: Float -> Float
poly1 = poly 1 2 1
```

### 6c: Evaluate at x=2

**Task:** Define `poly2 a b c = a × 2² + b × 2 + c` using `poly`

**Solution:**
```haskell
poly2 :: Float -> Float -> Float -> Float
poly2 a b c = poly a b c 2
```

## Exercise 7: Higher-Order Functions

### 7a: Square and Quad

**Given:** `square :: Int -> Int` (define x²)
**Task:** Define `quad :: Int -> Int` (computes x⁴)

**Solutions:**
```haskell
square :: Int -> Int
square x = x * x

quad :: Int -> Int
quad x = square (square x)
```

### 7b: The `twice` Function

**Code:**
```haskell
twice :: (a -> a) -> (a -> a)
twice f x = f (f x)
```

**Description:** `twice` takes a function and applies it twice to its argument.

### 7c: Quad using `twice`

**Solution:**
```haskell
quad :: Int -> Int
quad = twice square
```

## Exercise 8: Function Composition

**New definition:**
```haskell
twice :: (a -> a) -> (a -> a)
twice f = f . f
```

### Analysis:
a) `quad` still behaves the same
b) The operator `(.)` is **function composition**: `(f . g) x = f (g x)`

## Exercise 9: Functions as Arguments

### 9a: `forktimes` Function

**Code:**
```haskell
forktimes f g x = f x * g x
```

**Type:** `(t -> Int) -> (t -> Int) -> t -> Int`

**Explanation:** Takes two functions (both `t -> Int`) and a value `t`, applies both functions to the value, and multiplies results.

### 9b: Using `forktimes`

**Task:** Compute `x² + 3x + 2` using the hint `x² + 3x + 2 = (x + 1) × (x + 2)`

**Solution:**
```haskell
polyCompute :: Int -> Int
polyCompute x = forktimes (+1) (+2) x
-- Or more concisely:
polyCompute = forktimes (+1) (+2)
```

### 9c: The `lift2` Function

**Code:**
```haskell
lift2 h f g x = h (f x) (g x)
```

**Type:** `(b -> c -> d) -> (a -> b) -> (a -> c) -> a -> d`

**Explanation:** Takes a binary function `h` and two unary functions `f`, `g`. Returns function that applies `f` and `g` to argument, then applies `h` to results.

### 9d: Using `lift2`

**Solution:**
```haskell
polyCompute2 :: Int -> Int
polyCompute2 = lift2 (*) (+1) (+2)
```

## Exercise 10: Type Checking

**Given types:**
- `f :: Int -> Char`
- `g :: Int -> Char -> Int`
- `h :: (Char -> Int) -> Int -> Int`
- `x, y :: Int`
- `c :: Char`

**Type correctness analysis:**

1. `(g . f) x c`
   - `g . f :: Int -> (Char -> Int)`
   - `(g . f) x :: Char -> Int`
   - `(g . f) x c :: Int` ✓ **Correct**

2. `(g x . f) y`
   - `g x :: Char -> Int`
   - `g x . f :: Int -> Int`
   - `(g x . f) y :: Int` ✓ **Correct**

3. `(h . g) x y`
   - `h . g` has type `Int -> Char -> Int -> Int`
   - `(h . g) x :: Char -> Int -> Int`
   - `(h . g) x y` expects `Char` but gets `Int` ✗ **Incorrect**

4. `(h . g x) c`
   - `g x :: Char -> Int`
   - `h . g x :: Int -> Int`
   - `(h . g x) c :: Int` ✓ **Correct**

5. `h . g x c`
   - This is `h . (g x c)`
   - `g x c :: Int`
   - `h . (g x c)` tries to compose `h` with `Int` ✗ **Incorrect**

## Key Concepts Learned

1. **Pattern Matching:** Functions defined by cases
2. **Local Definitions:** `let` vs `where`
3. **Guards:** Conditional function definitions
4. **Currying:** Functions taking multiple arguments one at a time
5. **Higher-Order Functions:** Functions that take/return other functions
6. **Function Composition:** `(.)` operator combines functions
7. **Type System:** Static type checking prevents errors
8. **Partial Application:** Fixing some arguments to create new functions

## Important Haskell Syntax

- Function definition: `name args = expression`
- Type signature: `name :: Type1 -> Type2 -> Result`
- Guards: `| condition = result`
- Let expressions: `let var = value in expression`
- Where clauses: `expression where var = value`
- Lambda functions: `\x -> expression`
- Function composition: `f . g`
- Sectioning: `(+1)`, `(*2)` for partial application