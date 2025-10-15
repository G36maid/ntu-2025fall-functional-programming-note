# Handout 03: Definition and Proof by Induction

## Total Functional Programming

### Course Focus
The next few lectures concern **inductive definitions** and **proofs** of datatypes and programs.

### Temporary Restrictions
While Haskell allows non-terminating functions and infinite data structures, we will initially focus on the **total, finite fragment**:

- **Finite data structures only**
- **Functions must terminate** for all values in input type  
- **Guidelines for constructing** such functions

*Note: Infinite datatypes and non-termination will be discussed later.*

## 1. Induction on Natural Numbers

### 1.1 Mathematical Induction Principle

#### The Standard Principle
To prove that predicate P holds for all natural numbers, it's sufficient to show:

1. **Base case:** P(0) holds
2. **Inductive step:** P(n) ⇒ P(1+n) for all n

#### Datatype View of Natural Numbers
We can see this principle as resulting from the datatype definition:
```haskell
data Nat = 0 | 1+ Nat  -- Not real Haskell syntax
```

Any natural number is either:
- `0`, or  
- `1+ n` where n is a natural number

*Note: `1+` is written in bold to emphasize it's a data constructor, not the function `(+)`.*

#### Proof Generation Example
**Given:** P(0) and P(n) ⇒ P(1+n)  
**To prove:** P(3)

```
P(1+ (1+ (1+ 0)))
⟸ { P(1+n) ⟸ P(n) }
P(1+ (1+ 0))
⟸ { P(1+n) ⟸ P(n) }  
P(1+ 0)
⟸ { P(1+n) ⟸ P(n) }
P(0)
```

**Key Insight:** Mathematical induction can be seen as **designing a program that generates proofs** - given any n::Nat, we can generate a proof of P(n).

### 1.2 Inductively Defined Functions

#### Pattern: Structure Follows Datatype
Since `Nat` is defined by two cases, functions on `Nat` naturally follow this structure:

**Addition:**
```haskell
(+) :: Nat -> Nat -> Nat
0 + n = n
(1+ m) + n = 1+ (m + n)
```

**Exponentiation:**
```haskell
exp :: Nat -> Nat -> Nat
exp b 0 = 1
exp b (1+ n) = b * exp b n
```

**Note:** Pattern `1+ n` reveals correspondence between Nat and lists. Remove `1+` patterns in actual Haskell code - use `Int` instead.

#### Value Generation Example
**Computing exp b 3:**
```
exp b (1+ (1+ (1+ 0)))
= { definition of exp }
b * exp b (1+ (1+ 0))
= { definition of exp }
b * b * exp b (1+ 0)  
= { definition of exp }
b * b * b * exp b 0
= { definition of exp }
b * b * b * 1
```

**Parallel:** This is a program that generates a value for any n::Nat, just like inductive proof generates a proof for any n.

### Key Insight: Proving is Programming
- **Inductive proof** = program that generates proof for any given natural number
- **Inductive program** = follows same structure as inductive proof
- **Proving and programming are very similar activities**

#### Proof by Induction Example
**Theorem:** exp b (m + n) = exp b m * exp b n

**Proof by induction on m:**
Let P(m) ≡ (∀n :: exp b (m + n) = exp b m * exp b n)

**Base case m := 0:**
```
exp b (0 + n)
= { definition of (+) }
exp b n
= { definition of (*) }  
1 * exp b n
= { definition of exp }
exp b 0 * exp b n
```

**Inductive case m := 1+ m:**
```
exp b ((1+ m) + n)
= { definition of (+) }
exp b (1+ (m + n))
= { definition of exp }
b * exp b (m + n)
= { induction hypothesis }
b * (exp b m * exp b n)
= { (*) associative }
(b * exp b m) * exp b n
= { definition of exp }
exp b (1+ m) * exp b n
```

### Structure: Proofs Follow Programs
- The inductive proof carried out smoothly because both `(+)` and `exp` are defined inductively on their lefthand argument
- **Structure of proof follows structure of program**, which follows **structure of datatype**

### 1.3 Set-Theoretic Explanation

#### Inductively Defined Sets
An "inductively defined" set is the **smallest fixed-point** of some function.

#### Fixed-Points and Prefixed-Points
- **Fixed-point** of f: value x such that f(x) = x
- **Prefixed-point** of f: value x such that f(x) ≤ x
- **Theorem:** All fixed-points are prefixed-points
- **Theorem:** The smallest prefixed-point is also the smallest fixed-point

#### Natural Numbers Formally
Define function F from sets to sets: F(X) = {0} ∪ {1+n | n ∈ X}

Nat is the set such that:
1. **F(Nat) ⊆ Nat** (Nat is prefixed-point of F)
2. **(∀X: F(X) ⊆ X ⇒ Nat ⊆ X)** (Nat is least prefixed-point)

#### Mathematical Induction Formally
Given property P (also denotes set of elements satisfying P):

- "P(0) and P(n) ⇒ P(1+n)" is equivalent to:
  - {0} ⊆ P and {1+n | n ∈ P} ⊆ P
  - Which equals F(P) ⊆ P
- So P is a prefixed-point!
- By property (2): Nat ⊆ P
- Therefore: all Nat satisfy P!

**This is why mathematical induction is correct.**

#### Coinduction Preview
**Coinduction** is the dual technique using **greatest post-fixed points** (largest x such that x ≤ f(x)). This allows talking about **infinite data structures**.

## 2. Induction on Lists

### 2.1 Lists as Inductive Datatype

#### List Definition
```haskell
data [a] = [] | a : [a]  -- Conceptual definition
```

Every finite list is built from base case `[]` with elements added by `(:)`:
`[1,2,3] = 1 : (2 : (3 : []))`

#### Set-Theoretic Definition
`[a]` is the smallest set such that:
1. `[]` is in `[a]`
2. If `xs` is in `[a]` and `x` is in `a`, then `x : xs` is in `[a]`

#### Structural Induction on Lists
To prove property P holds for all finite lists:
1. **Base case:** P([]) holds
2. **Inductive step:** For all x and xs, P(x:xs) holds provided P(xs) holds

#### Proof Generation Example
**Given:** P([]) and P(xs) ⇒ P(x:xs)  
**To prove:** P([1,2,3])

```
P(1 : 2 : 3 : [])
⟸ { P(x:xs) ⟸ P(xs) }
P(2 : 3 : [])
⟸ { P(x:xs) ⟸ P(xs) }
P(3 : [])
⟸ { P(x:xs) ⟸ P(xs) }
P([])
```

### 2.2 Inductively Defined Functions on Lists

#### Basic Functions
**Sum:**
```haskell
sum :: [Int] -> Int
sum [] = 0
sum (x:xs) = x + sum xs
```

**Map:**
```haskell
map :: (a -> b) -> [a] -> [b]
map f [] = []
map f (x:xs) = f x : map f xs
```

**List Append:**
```haskell
(++) :: [a] -> [a] -> [a]
[] ++ ys = ys
(x:xs) ++ ys = x : (xs ++ ys)
```

*Compare append definition with addition on Nat!*

### 2.3 Proving Properties of List Functions

#### Associativity of Append
**Theorem:** xs ++ (ys ++ zs) = (xs ++ ys) ++ zs

**Proof by induction on xs:**
Let P(xs) = (∀ys,zs :: xs ++ (ys ++ zs) = (xs ++ ys) ++ zs)

**Base case xs := []:**
```
[] ++ (ys ++ zs)
= { definition of (++) }
ys ++ zs
= { definition of (++) }
([] ++ ys) ++ zs
```

**Inductive case xs := x:xs:**
```
(x:xs) ++ (ys ++ zs)
= { definition of (++) }
x : (xs ++ (ys ++ zs))
= { induction hypothesis }
x : ((xs ++ ys) ++ zs)
= { definition of (++) }
(x : (xs ++ ys)) ++ zs
= { definition of (++) }
((x:xs) ++ ys) ++ zs
```

#### Importance of Formality
**Why be so formal?**
- Being formal helps you do the proof
- Work on the **form**, not the meaning (like knight/knave problems)
- **Makes proofs easier** - let the symbols do the work
- In proof of exp property, we expected to use induction, so we generated exp b (m + n)
- In associativity proof, we worked toward generating xs ++ (ys ++ zs)

#### Length Distribution
**Exercise:** Prove length distributes over append:
```
length (xs ++ ys) = length xs + length ys
```

**Length definition:**
```haskell
length :: [a] -> Nat
length [] = 0
length (x:xs) = 1 + length xs
```

### 2.4 More Inductively Defined Functions

#### Definition by Induction/Recursion
- **Functional programming:** Specify values rather than give commands
- **Induction/recursion** is the only "control structure"
- To define function f on lists inductively:
  - Specify value for base case f([])
  - Assuming f(xs) computed, construct f(x:xs) from f(xs)

#### Filter
```haskell
filter :: (a -> Bool) -> [a] -> [a]
filter p [] = []
filter p (x:xs) | p x = x : filter p xs
                | otherwise = filter p xs
```

#### Take and Drop
```haskell
take :: Nat -> [a] -> [a]
take 0 xs = []
take (1+n) [] = []
take (1+n) (x:xs) = x : take n xs

drop :: Nat -> [a] -> [a]  
drop 0 xs = xs
drop (1+n) [] = []
drop (1+n) (x:xs) = drop n xs
```

**Exercise:** Prove take n xs ++ drop n xs = xs

#### TakeWhile and DropWhile
```haskell
takeWhile :: (a -> Bool) -> [a] -> [a]
takeWhile p [] = []
takeWhile p (x:xs) | p x = x : takeWhile p xs
                   | otherwise = []

dropWhile :: (a -> Bool) -> [a] -> [a]
dropWhile p [] = []
dropWhile p (x:xs) | p x = dropWhile p xs
                   | otherwise = x:xs
```

**Exercise:** Prove takeWhile p xs ++ dropWhile p xs = xs

#### List Reversal
```haskell
reverse :: [a] -> [a]
reverse [] = []
reverse (x:xs) = reverse xs ++ [x]
```

#### Concatenation
```haskell
concat :: [[a]] -> [a]
concat [] = []
concat (xs:xss) = xs ++ concat xss
```

**Exercise:** Prove sum ∘ concat = sum ∘ map sum

#### All Prefixes and Suffixes
```haskell
inits :: [a] -> [[a]]
inits [] = [[]]
inits (x:xs) = [] : map (x:) (inits xs)

tails :: [a] -> [[a]]
tails [] = [[]]
tails (x:xs) = (x:xs) : tails xs
```

### 2.5 Totality and Termination

#### Structure of Total Definitions
```haskell
f [] = ...
f (x:xs) = ... f xs ...
```

**Guarantees:**
- **Coverage:** Both empty and non-empty cases covered
- **Termination:** Recursive call on "smaller" argument

**Result:** Total functions on lists - every input maps to some output

#### Variations with Base Cases
**Multiple base cases:**
```haskell
fib :: Nat -> Nat
fib 0 = 0
fib 1 = 1
fib (2+n) = fib (1+n) + fib n
```

**Non-empty lists only:**
```haskell
f [x] = ...
f (x:xs) = ...
```

*Question: What about totality in this case?*

### 2.6 Other Induction Patterns

#### Lexicographic Induction
Induction on **multiple arguments** where some decrease while others stay same:

```haskell
merge :: [Int] -> [Int] -> [Int]
merge [] [] = []
merge [] (y:ys) = y:ys  
merge (x:xs) [] = x:xs
merge (x:xs) (y:ys) | x <= y = x : merge xs (y:ys)
                    | otherwise = y : merge (x:xs) ys
```

**Zip example:**
```haskell
zip :: [a] -> [b] -> [(a,b)]
zip [] [] = []
zip [] (y:ys) = []
zip (x:xs) [] = []
zip (x:xs) (y:ys) = (x,y) : zip xs ys
```

#### Non-Structural Induction
Most functions use **structural induction** (recursive calls on direct sub-components).

**Non-structural example - Mergesort:**
```haskell
msort :: [Int] -> [Int]
msort [] = []
msort [x] = [x]
msort xs = merge (msort ys) (msort zs)
  where n = length xs `div` 2
        ys = take n xs
        zs = drop n xs
```

Arguments get "smaller" in size under well-founded ordering.

*What if we omit the [x] case?*

#### Non-Terminating Example
```haskell
f :: Int -> Int
f 0 = 0
f n = f n  -- Argument doesn't reduce!
```

Certainly not a total function. Do such definitions "mean" something? (To be discussed later.)

## 3. User-Defined Inductive Datatypes

### 3.1 Binary Trees

#### Definition
```haskell
data Tree a = Null | Node a (Tree a) (Tree a)
```

#### Functions on Trees
```haskell
sumT :: Tree Nat -> Nat
sumT Null = 0
sumT (Node x t u) = x + sumT t + sumT u
```

#### Exercises
Given `(↓) :: Nat -> Nat -> Nat` (returns smaller argument):

1. **minT :: Tree Nat -> Nat** - computes minimal element
2. **mapT :: (a -> b) -> Tree a -> Tree b** - applies function to each element  
3. **Can you define (↓) inductively on Nat?**

### 3.2 Induction Principle for Trees

**To prove predicate P holds for every tree:**
1. **Base:** P(Null) holds
2. **Inductive:** For all x, t, u: if P(t) and P(u) hold, then P(Node x t u) holds

**Exercise:** Prove for all n and t:
```
minT (mapT (n+) t) = n + minT t
```
That is: `minT ∘ mapT (n+) = (n+) ∘ minT`

### 3.3 Induction for Other Types

#### Boolean Induction
```haskell
data Bool = False | True
```

**To prove P holds for all booleans:**
1. P(False) holds
2. P(True) holds

*Well, of course!*

#### Product Types
For `(A × B)`, the "induction principle" allows extracting from proof of P the proofs P₁ on A and P₂ on B that together imply P.

#### General Principle
**Every inductively defined datatype comes with its induction principle.**

*We will return to this important point later.*

## Summary

### Key Concepts
1. **Total Functional Programming:** Focus on terminating functions and finite data
2. **Induction ≈ Programming:** Similar structure between proofs and programs  
3. **Structural Induction:** Follow datatype structure in both proofs and programs
4. **Formal Reasoning:** Let symbols do the work - makes proofs easier
5. **Totality:** Ensure coverage and termination for well-defined functions

### Patterns Learned
- **Mathematical induction** on natural numbers
- **Structural induction** on lists and trees
- **Lexicographic induction** on multiple arguments
- **Non-structural induction** with well-founded orderings

### Connection to Set Theory
- Inductive types as least fixed-points
- Induction principle follows from minimality
- Foundation for understanding why induction is valid

*Next: We'll see how these principles extend to more complex datatypes and programming patterns.*