# Introduction to Haskell: A Quick Note on Type Classes

**Original Document**: [handouts_04.pdf](../../course-materials/handouts/handouts_04.pdf)

## 1. Parametric Polymorphism in Haskell

### The Type of `take`

Recall the definition:

```haskell
take 0 xs       = []
take (1 + n) [] = []
take (1 + n) (x : xs) = x : take n xs
```

*   The first argument has to be of a numeric type (e.g. `Int`), since we pattern matched it against `0` and `1+`.
*   The second argument must be a list, since we pattern matched it against `[]` and `(:)`.
*   But the element of the list is not examined at all. It is merely copied to the output.

The type of `take` can be:
*   `Int -> List Int -> List Int`
*   `Int -> List Char -> List Char`
*   etc.

There is a **most general type**: `Int -> List a -> List a`.
*   The small letter means that `a` is a **type variable**.
*   One can imagine that there is an implicit $\forall$ that quantifies all type variables: $\forall a . \text{Int} \to \text{List } a \to \text{List } a$.

### The Identity Function

*   It may have type `Int -> Int`, `Char -> Char`, or even `(Int -> Int) -> (Int -> Int)`.
*   The most general type is `a -> a`.

### Filter

Recall `filter`:

```haskell
filter :: (a -> Bool) -> List a -> List a
filter p [] = []
filter p (x : xs)
  | p x       = x : filter p xs
  | otherwise = filter p xs
```

*   Still, in `filter p (x : xs)` we merely passes `x` to `p`, without looking into `x`.
*   Therefore `filter` works for any type `a` for which there exists functions of type `a -> Bool` — which is true for all type `a`.

### Counting Lowercase Characters

For a counterexample, consider the following function:

```haskell
lowers :: List Char -> Int
lowers [] = 0
lowers (x : xs) = if isLower x
                  then 1 + lowers xs
                  else lowers xs
```

*   The function counts the number of lowercase characters in a string.
*   It is equivalent to `length . filter isLower`.
*   `x` is passed to `isLower`, which forces `x` to be a `Char`.

For a more obvious example, consider the (simple but important) **identity function**:

```haskell
id x = x
```

The argument is not touched at all.

### Parametric Polymorphism

*   **Polymorphism**: allowing a piece of code to have many types, such that it can be used in many occasions.
    *   Indeed, `take` can be applied to all types of lists. We do not need to define a separate version for `List Int`, `List (Int -> Int)`.
*   **Parametric polymorphism**, as we have seen just now, is common in many functional programming languages.
*   When `take n :: List a -> List a` is applied to an argument, say `[1, 2, 3]`, the type variable `a` is instantiated to the type of the argument (`Int` in this case).
    *   The type variable `a` behaves like a parameter, thus the name.
    *   Observe: the same piece of code (e.g. `take`, `filter`) works for all instantiations of `a`.
*   Object-oriented languages often adopt another kind of polymorphism for operator overloading, called **ad-hoc polymorphism**, to be introduced later.

---

## 2. Type Classes

### Membership Test

Given the definition below, `elem x xs` yields `True` iff `x` occurs in `xs`.

```haskell
elem x [] = False
elem x (y : xs)
  | x == y    = True
  | otherwise = elem x xs
```

*   It could have type `Int -> List Int -> Bool`, `Char -> List Char -> Bool`, etc.
*   We do not want to define `elem` once for each type, thus we wish that it has a polymorphic type, say `a -> List a -> Bool`.
*   However, not all values can be tested for equality! The operator `(==)` is defined for some types, but not all types. For example, we cannot in general decide whether two functions are equal.
    *   It is not possible to give a definition for, for example `Eq (a -> a)`. Thus `elem` cannot be applied to such types.
*   Thus `elem` cannot have type, for example, `(Int -> Int) -> List (Int -> Int) -> Bool`.

### The Eq Class

There is such a definition in the Standard Prelude:

```haskell
class Eq a where
  (==) :: a -> a -> Bool
```

*   This says that a type `a` is in the type class `Eq` if there is an operator `(==)`, of type `a -> a -> Bool`, defined.
*   `Int` is in `Eq` since we can define `(==)` for numbers. So is `Char`, although `(==)` for `Char` implements a different algorithm from that of `Int`.

### Type of `elem`

The most general type of `elem` is:

```haskell
Eq a => a -> List a -> Bool
```

*   This means that `elem` takes a value of type `a` and a list of type `List a` and returns a `Bool`, **provided that** `a` is in `Eq`.
*   The additional constraint arises from the fact that `elem` calls `(==)`.

### Instance Declaration

To use `elem` on concrete types, we have to teach Haskell how to check equality for each type. The following are defined somewhere in the Haskell Prelude:

```haskell
instance Eq Int where
  m == n = {- how to check equality for Int -}

instance Eq Char where
  m == n = {- how to check equality for Char -}
```

When we define a new type, we might want to teach Haskell how to check equality:

```haskell
data Color = Red | Green | Blue ...

instance Eq Color where
  Red   == Red   = True
  Red   == Green = False
  ...
```

### Derived Instances

*   Instance declaration:
    ```haskell
    instance Eq MyType where
      x == y = ...
    ```
    `((==))` above should have type `MyType -> MyType -> Bool`, but the type is not written.

*   The Haskell compiler may automatically construct some routine instance declarations, to save you some typing. E.g.
    ```haskell
    data Colors = Red | Green | Blue
      deriving (Eq, Show, Read)
    ```

### Summary So Far...

*   **Class declaration**:
    ```haskell
    class Eq a where
      (==) :: a -> a -> Bool
    ```
    The method `(==)` then has type `Eq a => a -> a -> Bool`.
*   A function that calls a function with class constraint `Eq a` (e.g. `(==)`) also has the constraint in its type:
    ```haskell
    elem :: Eq a => a -> List a -> Bool
    elem = ... == ...
    ```
    *   `elem 2 [1, 2, 3]` is allowed because there is an instance declaration for `Eq Int`.
    *   `elem id [id, (1+), (2+)]` is not (unless you define and instance `Eq (Int -> Int)`, which is usually not a good idea).

### Ad-hoc Polymorphism

*   Note that `(==)` for `Int` is a different program from that for `Char`.
*   Type classes is thus a way to describe operator overloading — using one name to refer to different piece of code.
*   Such mechanisms are often called **ad-hoc polymorphism**.
*   Compare with parametric polymorphism, where the same code, say, the same definition of `take`, works for all types.

### Other Important Type Classes

*   `Show`: things that can be printed (converted to string).
*   `Read`: things that can be parsed from strings.
*   `Num`: things that behave like numbers (with addition, multiplication, etc).
*   `Integral`: things that behave like integers.
*   `Monad`, `Functor`... hope we will be able to talk about them later!
*   Use `:i` in GHCi to find out what methods and instances each class has!

## 3. Instance Inheritance

How do we check whether two lists are equal? We can do so if we know how to check whether their elements are equal.

```haskell
instance Eq a => Eq (List a) where
  [] == []             = True
  [] == (x : xs)       = False
  (x : xs) == []       = False
  (x : xs) == (y : ys) = x == y && xs == ys
```

*   Note that in `x == y`, the `(==)` refers to the method for type `a`, while the `(==)` in `xs == ys` is a recursive call.

Another example:

```haskell
instance (Eq a, Eq b) => Eq (a, b) where
  (x1, y1) == (x2, y2) = (x1 == x2) && (y1 == y2)
```

*   All the three `(==)` in the expression above refer to different methods!

## 4. Class Hierarchy

### The Type Class Ord

Another type class `Ord` includes things are can be "ordered":

```haskell
class Eq a => Ord a where
  (<)  :: a -> a -> Bool
  (>=) :: a -> a -> Bool
  (>)  :: a -> a -> Bool
  (<=) :: a -> a -> Bool
  ...
```

*   The declaration `Eq a => Ord a` intends to mean that for a type `a` to be in class `Ord` it has to be in class `Eq`.
    *   The methods `(<)`, `(>=)`, etc, is allowed to use `(==)`.
    *   Logically, it makes more sense to write `Eq a <= Ord a`. But it's a historical mistake that has been made.
*   The function `sort` that sorts a list might have type `Ord a => List a -> List a`.

### Class Hierarchy

*   Inheritance between type classes are not to be confused with inheritance between types.
*   Through inheritance, type classes form a hierarchy.
*   Types in the standard Haskell Prelude form a complex hierarchy (e.g., standard numerical classes).
*   Other libraries may extend the existing hierarchy or build their own hierarchy.

### Notes

*   The name "type class" is merely a mechanism for operator overloading and shall not be confused with classes in object oriented languages.
*   Type classes are an important feature of Haskell. Use of type classes has extended far beyond the inventors had imagined.
*   We may use type classes in this course, but might not talk too much about their theoretical aspects, as they are orthogonal to the purpose of this course.