# Handout 02: Introduction to Haskell - Simple Datatypes & Functions on Lists

## 1. Simple Datatypes

### 1.1 Booleans

#### Datatype Declaration
```haskell
data Bool = False | True
```
(Note: `Bool` is already defined in Haskell Prelude)

#### General Datatype Syntax
```haskell
data Type = Con1 Type11 Type12 ...
          | Con2 Type21 Type22 ...
          | ...
```

**Key Points:**
- Introduces a new type with several cases
- Each case starts with a constructor
- Types and constructors begin with capital letters
- Means "a value of type `Type` is either a `Con1` with arguments... or a `Con2` with arguments..."

#### Functions on Booleans

**Conjunction and Disjunction:**
```haskell
(&&), (||) :: Bool -> Bool -> Bool
False && x = False
True && x = x

False || x = x
True || x = True
```

**Negation:**
```haskell
not :: Bool -> Bool
not False = True
not True = False
```

**Equality Check:**
```haskell
(==), (/=) :: Bool -> Bool -> Bool
x == y = (x && y) || (not x && not y)
x /= y = not (x == y)
```

Note: `=` is definition, `==` is a function for equality testing.

#### Pattern Matching Example
```haskell
leapyear :: Int -> Bool
leapyear y = (y `mod` 4 == 0) &&
             (y `mod` 100 /= 0 || y `mod` 400 == 0)
```

**Key Insight:** Definition by pattern matching follows the shape of the datatype. Since `Bool` has two cases, functions on `Bool` typically have two cases.

### 1.2 Characters

#### Character Type
Think of `Char` as a large datatype:
```haskell
data Char = 'a' | 'b' | 'c' | ...
```

**Available Functions:**
- `ord :: Char -> Int` - convert character to ASCII
- `chr :: Int -> Char` - convert ASCII to character

**Character Predicates:**
```haskell
isDigit :: Char -> Bool
isDigit x = '0' <= x && x <= '9'
```

#### Equality and Overloading
```haskell
(==) :: Char -> Char -> Bool
```

**Important:** `(==)` is an **overloaded** function with different implementations for different types:
- `(==) :: Int -> Int -> Bool`
- `(==) :: (Int, Char) -> (Int, Char) -> Bool`
- `(==) :: [Int] -> [Int] -> Bool`

Haskell handles overloading through **type classes** - a major feature allowing one name to have many definitions.

### 1.3 Products (Tuples)

#### Tuple Types
```haskell
-- Polymorphic pair type (a, b) is like:
data Pair a b = MkPair a b
-- Or in Haskell's special syntax:
data (a, b) = (a, b)
```

**Projection Functions:**
```haskell
fst :: (a, b) -> a
fst (a, b) = a

snd :: (a, b) -> b
snd (a, b) = b
```

## 2. Functions on Lists

### Lists in Haskell

**Key Properties:**
- All elements must be same type
- Traditionally important in functional languages

**Examples:**
- `[1, 2, 3, 4] :: [Int]`
- `[True, False, True] :: [Bool]`
- `[[1, 2], [], [6, 7]] :: [[Int]]`
- `[] :: [a]` - empty list (element type undetermined)
- `String` is abbreviation for `[Char]`
- `"abcd"` is abbreviation for `['a', 'b', 'c', 'd']`

### List as Datatype

**Conceptual Definition:**
```haskell
data [a] = [] | a : [a]
```

**Key Components:**
- `[] :: [a]` - empty list
- `(:) :: a -> [a] -> [a]` - cons operator (builds lists)
- In `x : xs`, `x` is head, `xs` is tail
- `[1, 2, 3]` is abbreviation for `1 : (2 : (3 : []))`

### 2.1 Basic List Operations

#### Head and Tail
```haskell
head :: [a] -> a        -- head [1,2,3] = 1
tail :: [a] -> [a]      -- tail [1,2,3] = [2,3]
init :: [a] -> [a]      -- init [1,2,3] = [1,2]
last :: [a] -> a        -- last [1,2,3] = 3
```

**Warning:** These are **partial functions** - they fail on empty lists!

**Safe Empty Check:**
```haskell
null :: [a] -> Bool
null [] = True
null (x:xs) = False
```

#### Length and Indexing
```haskell
length :: [a] -> Int           -- length [0..9] = 10
(!!) :: [a] -> Int -> a        -- [1,2,3] !! 0 = 1 (zero-indexed)
```

#### Append and Concatenation
```haskell
(++) :: [a] -> [a] -> [a]      -- [1,2] ++ [3,4,5] = [1,2,3,4,5]
concat :: [[a]] -> [a]         -- concat [[1,2], [], [3,4], [5]] = [1,2,3,4,5]
```

**Important:** `(++)` appends lists, `(:)` prepends element. Type error: `[] : [3,4,5]`

### 2.2 List Generation

#### Range Notation
```haskell
[0..25]      -- [0,1,2,...,25]
[0,2..25]    -- [0,2,4,...,24]
[2..0]       -- [] (empty - can't count down without step)
['a'..'z']   -- ['a','b','c',...,'z']
[1..]        -- [1,2,3,...] (infinite list!)
```

#### List Comprehension
**Syntax:** `[expression | qualifier1, qualifier2, ...]`

**Qualifiers can be:**
- **Generator:** `x <- list` (introduces local variable)
- **Guard:** boolean expression (filters results)

**Examples:**
```haskell
[x * x | x <- [1..5], odd x]  -- [1,9,25]

[(a,b) | a <- [1..3], b <- [1..2]]
-- [(1,1), (1,2), (2,1), (2,2), (3,1), (3,2)]

[(a,b) | b <- [1..2], a <- [1..3]]  -- Order matters!
-- [(1,1), (2,1), (3,1), (1,2), (2,2), (3,2)]

[(i,j) | i <- [1..4], j <- [i+1..4]]
-- [(1,2), (1,3), (1,4), (2,3), (2,4), (3,4)]

[(i,j) | i <- [1..4], even i, j <- [i+1..4], odd j]
-- [(2,3)]
```

### 2.3 Take and Drop

```haskell
take :: Int -> [a] -> [a]
take 0 xs = []
take (n+1) [] = []
take (n+1) (x:xs) = x : take n xs

drop :: Int -> [a] -> [a]
drop 0 xs = xs
drop (n+1) [] = []
drop (n+1) (x:xs) = drop n xs
```

**Examples:**
- `take 3 "abcde" = "abc"`
- `take 3 "ab" = "ab"`
- `drop 3 "abcde" = "de"`
- `drop 3 "ab" = ""`

**Important Property:** `take n xs ++ drop n xs = xs`

**Lazy Evaluation:** `take 5 [1..] = [1,2,3,4,5]` works with infinite lists!

## 2.4 Combinatorial Programming

### Two Programming Modes

1. **Inductive/Recursive Mode:** 
   - Go into structure of input data
   - Process recursively

2. **Combinatorial Mode:**
   - Compose programs using existing functions (combinators)
   - Process input in stages
   - Today's focus!

### Important Combinators

#### Map
```haskell
map :: (a -> b) -> [a] -> [b]
```
**Examples:**
- `map (+1) [1,2,3,4,5] = [2,3,4,5,6]`
- `map (\x -> x * x) [1,2,3,4] = [1,4,9,16]`

#### Filter
```haskell
filter :: (a -> Bool) -> [a] -> [a]
```
**Examples:**
- `filter even [2,7,4,3] = [2,4]`
- `filter (\n -> n `mod` 3 == 0) [3,2,6,7] = [3,6]`

#### Zip
```haskell
zip :: [a] -> [b] -> [(a,b)]
```
**Example:**
- `zip "abcde" [1,2,3] = [('a',1), ('b',2), ('c',3)]`

Result length is minimum of input lengths.

### Complex Example: Finding Positions

**Problem:** Find positions of character in string.

```haskell
positions :: Char -> String -> [Int]
positions x xs = map snd (filter ((x ==) . fst) (zip xs [0..]))
```

**Or using lambda:**
```haskell
positions x xs = map snd (filter (\(y,i) -> x == y) (zip xs [0..]))
```

**First occurrence only:**
```haskell
pos :: Char -> String -> Int
pos x xs = head (positions x xs)
```

Thanks to lazy evaluation, only the first position is computed!

## 3. Lambda Expressions

### Basic Syntax
- `\x -> e` denotes function with argument `x` and body `e`
- `(\x -> e1) e2` applies the function to `e2`
- Reduces to `e1` with free occurrences of `x` replaced by `e2`

### Examples
```haskell
(\x -> x * x) (3 + 4) = (3 + 4) * (3 + 4) = 49
```

### Function Definition Equivalences
These are all equivalent:
```haskell
smaller x y = if x <= y then x else y
smaller x = \y -> if x <= y then x else y  
smaller = \x -> \y -> if x <= y then x else y
smaller = \x y -> if x <= y then x else y
```

### Lambda Calculus
- Lambda expressions are primitive and essential
- Many constructs are syntax sugar for lambdas
- Complete programming languages can be built with only lambdas and applications
- `\x -> \y -> e` abbreviated as `\x y -> e`

### Functions as Values
- Lambdas are values like any other
- Can appear in expressions
- Can be passed as parameters
- Can be returned as results

## Key Programming Principles

### Lazy Evaluation Benefits
- **Improves Modularity:** List combinators can be conveniently reused
- **Efficiency:** Only relevant parts are computed
- **Infinite Structures:** Can work with infinite lists

### Wholemeal Programming
**Philosophy:** Think of aggregate data as a whole and process them as a whole!

**Example:** Instead of:
```c
for (i = 0; i < n; i++) {
    if (condition(a[i])) {
        result[j++] = transform(a[i]);
    }
}
```

**Think:** `map transform (filter condition list)`

### List Comprehensions vs Combinators
Any list comprehension can be translated into combinations of:
- Primitive list generators
- `map`
- `filter` 
- `concat`

## Summary

1. **Datatypes:** Defined by constructors, functions follow datatype structure
2. **Pattern Matching:** Function definitions mirror datatype cases
3. **Lists:** Fundamental data structure with rich combinator library
4. **Lazy Evaluation:** Enables modular programming with infinite structures
5. **Higher-Order Functions:** Functions that take/return other functions
6. **Lambda Expressions:** Anonymous functions, foundation of functional programming
7. **Combinatorial Style:** Compose simple functions to build complex behavior