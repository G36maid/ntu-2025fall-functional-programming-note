Programming Languages: Functional Programming
Worksheet for 3. Definition and Proof by Induction

Shin-Cheng Mu

Autumn 2025

Finish the definitions.

1 Induction on Natural Numbers

(+)
:: Nat → Nat → Nat
=
0 + n
(1+ m) + n =

:: Nat → Nat → Nat
(×)
0 × n
=
(1+ m) × n =

:: Nat → Nat → Nat
exp
exp b 0
=
exp b (1+ n) =

2 Induction on Lists

sum
:: List Int → Int
=
sum [ ]
sum (x : xs) =

:: (a → b) → List a → List b
map
map f [ ]
=
map f (x : xs) =

:: List a → List a → List a
(++)
[ ] ++ ys
=
(x : xs) ++ ys =

Prove: xs ++(ys ++ zs) = (xs ++ ys) ++ zs.

1

Proof. Induction on xs.
Case xs := [ ]:

Case xs := x : xs:

• The function length defined inductively:

:: List a → Int
length
length [ ]
=
length (x : xs) =

• While (++) repeatedly applies (:), the function concat repeatedly calls (++):

:: List (List a) → List a
concat
=
concat [ ]
concat (xs : xss) =

2

• filter p xs keeps only those elements in xs that satisfy p.

filter
filter p [ ]
filter p (x : xs)

:: (a → Bool ) → List a → List a
=

• Recall take and drop, which we used in the previous exercise.

•

:: Nat → List a → List a
take
=
take 0 xs
=
take (1+ n) [ ]
take (1+ n) (x : xs) =

:: Nat → List a → List a
drop
=
drop 0 xs
drop (1+ n) [ ]
=
drop (1+ n) (x : xs) =

• takeWhile p xs yields the longest prefix of xs such that p holds for each element.

takeWhile
takeWhile p [ ]
takeWhile p (x : xs)

:: (a → Bool ) → List a → List a
=

• dropWhile p xs drops the prefix from xs.

dropWhile
dropWhile p [ ]
dropWhile p (x : xs)

:: (a → Bool ) → List a → List a
=

• List reversal.

:: List a → List a
reverse
reverse [ ]
=
reverse (x : xs) =

• inits [1, 2, 3] = [[ ], [1], [1, 2], [1, 2, 3]]

:: List a → List (List a)
inits
=
inits [ ]
inits (x : xs) =

3

• tails [1, 2, 3] = [[1, 2, 3], [2, 3], [3], [ ]]

:: List a → List (List a)
tails
tails [ ]
=
tails (x : xs) =

• Some functions discriminate between several base cases. E.g.

:: Nat → Nat
fib
=
fib 0
fib 1
=
fib (2 + n) =

• E.g. the function merge merges two sorted lists into one sorted list:

merge
merge [ ] [ ]
merge [ ] (y : ys)
merge (x : xs) [ ]
merge (x : xs) (y : ys)

:: List Int → List Int → List Int
=
=
=

•

:: List a → List b → List (a, b)
zip
=
zip [ ] [ ]
=
zip [ ] (y : ys)
zip (x : xs) [ ]
=
zip (x : xs) (y : ys) =

• Non-structural induction. Example: merge sort.

:: List Int → List Int

msort
msort [ ] =
msort [x] =
msort xs =

3 User Defined Inductive Datatypes

• This is a possible definition of internally labelled binary trees:

data Tree a = Null | Node a (Tree a) (Tree a) ,

4

• on which we may inductively define functions:

:: Tree Nat → Nat
sumT
sumT Null
=
sumT (Node x t u) =

5
