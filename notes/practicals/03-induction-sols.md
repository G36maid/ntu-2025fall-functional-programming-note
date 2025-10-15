Programming Languages
Practicals 3. Definition and Proof by Induction

Shin-Cheng Mu

Autumn 2025

1. Prove that length distributes into (++):

length (xs ++ ys) = length xs + length ys .

Solution: Prove by induction on the structure of xs.
Case xs := [ ]:

length ([ ] ++ ys)

= { definition of (++) }

length ys

= { definition of (+) }

0 + length ys

= { definition of length }
length [ ] + length ys

Case xs := x : xs:

length ((x : xs) ++ ys)
= { definition of (++) }
length (x : (xs ++ ys))
= { definition of length }
1 + length (xs ++ ys)

= { by induction }

1 + length xs + length ys
= { definition of length }

length (x : xs) + length ys

Note that we in fact omitted one step using the associativity of (+).

1

2. Prove: sum · concat = sum · map sum.

Solution: By extensional equality, sum · concat = sum · map sum if and only if

(sum · concat) xss = (sum · map sum) xss,

for all xss, which, by definition of (·), is equivalent to

sum (concat xss) = sum (map sum xss),

which we will prove by induction on xss.

Case xss := [ ]:

sum (concat [ ]))

= { definition of concat }

sum [ ]

= { definition of map }
sum (map sum [ ])

Case xss := xs : xss:

sum (concat (xs : xss))
= { definition of concat }
sum (xs ++(concat xss))

= { lemma: sum distributes over ++ }

sum xs + sum (concat xss)

= { by induction }

sum xs + sum (map sum xss)

= { definition of sum }

sum (sum xs : map sum xss)

= { definition of map }

sum (map sum (xs : xss)).

The lemma that sum distributes over ++, that is,

sum (xs ++ ys) = sum xs + sum ys,

needs a separate proof by induction. Here it goes:

Case xs := [ ]:

sum ([ ] ++ ys)

Page 2

= { definition of (++) }

sum ys

= { definition of (+) }

0 + sum ys

= { definition of sum }
sum [ ] + sum ys.

Case xs := x : xs:

sum ((x : xs) ++ ys)
= { definition of (++) }
sum (x : (xs ++ ys))
= { definition of sum }
x + sum (xs ++ ys)

= { induction }

x + (sum xs + sum ys)
= { since (+) is associative }
(x + sum xs) + sum ys
= { definition of sum }
sum (x : xs) + sum ys.

3. Prove: filter p · map f = map f · filter (p · f ).

Hint: for calculation, it might be easier to use this definition of filter :

filter p [ ]
filter p (x : xs) = if p x then x : filter p xs

= [ ]

else filter p xs

and use the law that in the world of total functions we have:

f (if q then e1 else e2) = if q then f e1 else f e2

You may also carry out the proof using the definition of filter using guards:

. . .
filter p (x : xs) | p x = . . .

| otherwise = . . .

You will then have to distinguish between the two cases: p x and ¬ (p x), which makes the
proof more fragmented. Both proofs are okay, however.

Page 3

Solution:

filter p · map f = map f · filter (p · f )

≡ { extensional equality }

(∀xs :: (filter p · map f ) xs = (map f · filter (p · f )) xs)

≡ { definition of (·) }

(∀xs :: filter p (map f xs) = map f (filter (p · f ) xs)).

We proceed by induction on xs.

Case xs := [ ]:

filter p (map f [ ])
= { definition of map }

filter p [ ]

= { definition of filter }

[ ]

= { definition of map }

map f [ ]

= { definition of filter }
map f (filter (p · f ) [ ])

Case xs := x : xs:

filter p (map f (x : xs))

= { definition of map }

filter p (f x : map f xs)
= { definition of filter }

if p (f x) then f x : filter p (map f xs) else filter p (map f xs)

= { induction hypothesis }

if p (f x) then f x : map f (f ilter(p · f ) xs) else map f (f ilter (p · f ) xs)

= { defintion of map }

if p (f x) then map f (x : filter (p · f ) xs) else map f (filter (p · f ) xs)

= { since f (if q then e1 else e2) = if q then f e1 else f e2 }

map f (if p (f x) then x : filter (p · f ) xs else filter (p · f ) xs)

= { definition of (·) }

map f (if (p · f ) x then x : filter (p · f ) xs else filter (p · f ) xs)

= { definition of filter }

map f (filter (p · f ) (x : xs))

Page 4

4. Reflecting on the law we used in the previous exercise:

f (if q then e1 else e2) = if q then f e1 else f e2

Can you think of a counterexample to the law above, when we allow the presence of ⊥?
What additional constraint shall we impose on f to make the law true?

Solution: Let f = const 1 (where const x y = x), and q = ⊥. We have:

const 1 (if ⊥ then e1 else e2)

= { definition of const }

1
̸= ⊥
= { if is strict on the conditional expression }

if ⊥ then f e1 else f e2

The rule is restored if f is strict, that is, f ⊥ = ⊥.

5. Prove: take n xs ++ drop n xs = xs, for all n and xs.

Solution: By induction on n, then induction on xs.

Case n := 0

take 0 xs ++ drop 0 xs

= { definitions of take and drop }

[ ] ++ xs

= { definition of (++) }

xs.

Case n := 1+ n and xs := [ ]

take (1+ n) [ ] ++ drop (1+ n) [ ]
= { definitions of take and drop }

[ ] ++[ ]

= { definition of (++) }

[ ].

Case n := 1+ n and xs := x : xs

take (1+ n) (x : xs) ++ drop (1+ n) (x : xs)

Page 5

= { definitions of take and drop }

(x : take n xs) ++ drop n xs

= { definition of (++) }

x : take n xs ++ drop n xs

= { induction }

x : xs.

6. Define a function fan :: a → List a → List (List a) such that fan x xs inserts x into the

0th, 1st. . . nth positions of xs, where n is the length of xs. For example:

fan 5 [1, 2, 3, 4] = [[5, 1, 2, 3, 4], [1, 5, 2, 3, 4], [1, 2, 5, 3, 4], [1, 2, 3, 5, 4], [1, 2, 3, 4, 5]] .

Solution:

fan
fan x [ ]
fan x (y : ys) = (x : y : ys) : map (y :) (fan xys)

:: a → List a → List (List a)
= [[x]]

7. Prove: map (map f ) · fan x = fan (f x) · map f , for all f and x. Hint: you will need the

map-fusion law, and to spot that map f · (y :) = (f y :) · map f (why?).

Solution: This is equivalent to proving that, for all f , x, and xs:

map (map f ) (fan x xs) = fan (f x) (map f xs) .

Induction on xs.
Case xs := [ ]:

map (map f ) (fan x [ ])

= { definition of fan }
map (map f ) [[x]]
= { definition of map }

[[f x]]

= { definition of fan }

fan(f x) [ ]

= { definition of fan }
fan (f x) (map f [ ]) .

Page 6

Case xs := y : ys:

map (map f ) (fan x (y : ys))

= { definition of fan }

map (map f ) ((x : y : ys) : map (y :) (fan x ys))

= { definition of map }

map f (x : y : ys) : map (map f ) (map (y :) (fan x ys)))

= { map-fusion }

map f (x : y : ys) : map (map f · (y :)) (fan x ys)

= { definition of map }

map f (x : y : ys) : map ((f y :) · map f ) (fan x ys)

= { map-fusion }

map f (x : y : ys) : map (f y :) (map (map f ) (fan x ys))

= { induction }

map f (x : y : ys) : map (f y :) (fan (f x) (map f ys))

= { definition of map }

(f x : f y : map f ys) : map (f y :) (fan (f x) (map f ys))

= { definition of fan }

fan (f x) (f y : map f ys)

= { definition of map }

fan (f x) (map f (y : ys)) .

8. Define perms :: List a → List (List a) that returns all permutations of the input list. For

example:

perms [1, 2, 3] = [[1, 2, 3], [2, 1, 3], [2, 3, 1], [1, 3, 2], [3, 1, 2], [3, 2, 1]] .

You will need several auxiliary functions defined in the lectures and in the exercises.

Solution:

perms
perms [ ]
perms (x : xs) = concat (map (fan x) (perms xs))

:: List a → List (List a)
= [[ ]]

9. Prove: map (map f ) · perm = perm · map f . You may need previously proved results, as well
as a property about concat and map: for all g, we have map g·concat = concat ·map (map g).

Page 7

Solution: This is equivalent to proving that, for all f and xs:

map (map f ) (perm xs) = perm (map f xs) .

Induction on xs.
Case xs := [ ]:

map (map f ) (perm [ ])
= { definition of perm }

map (map f ) [[ ]]
= { definition of map }

[[ ]]

= { definition of perm }

perm [ ]

= { definition of map }
perm (map f [ ]) .

Case xs := x : xs:

map (map f ) (perm (x : xs))

= { definition of perm }

map (map f ) (concat (map (fan x) (perm xs)))
= { since map g · concat = concat · map (map g) }

concat (map (map (map f ))(map (fan x) (perm xs)))

= { map-fusion }

concat (map (map (map f ) · fan x) (perm xs))

= { previous exercise }

concat (map (fan (f x) · map f ) (perm xs))

= { map-fusion }

concat (map (fan (f x)) (map (map f ) (perm xs)))

= { induction }

concat (map (fan (f x)) (perm (map f xs)))

= { definition of perm }
perm (f x : map f xs)
= { definition of map }

perm (map f (x : xs)) .

10. Define inits :: List a → List (List a) that returns all prefixes of the input list.

inits "abcde" = ["", "a", "ab", "abc", "abcd", "abcde"].

Hint: the empty list has one prefix: the empty list. The solution has been given in the lecture.
Please try it again yourself.

Page 8

Solution:

inits
inits [ ]
inits (x : xs) = [ ] : map (x :) (inits xs) .

:: List a → List (List a)
= [[ ]]

11. Define tails :: List a → List (List a) that returns all suffixes of the input list.

tails "abcde" = ["abcde", "bcde", "cde", "de", "e", ""].

Hint: the empty list has one suffix: the empty list. The solution has been given in the lecture.
Please try it again yourself.

Solution:

:: List a → List (List a)
tails
= [[ ]]
tails [ ]
tails (x : xs) = (x : xs) : tails xs .

12. The function splits :: List a → List (List a, List a) returns all the ways a list can be split

into two. For example,

splits [1, 2, 3, 4] = [([ ], [1, 2, 3, 4]), ([1], [2, 3, 4]), ([1, 2], [3, 4]),

([1, 2, 3], [4]), ([1, 2, 3, 4], [ ])] .

Define splits inductively on the input list. Hint: you may find it useful to define, in a where-
clause, an auxiliary function f (ys, zs) = . . . that matches pairs. Or you may simply use
(λ (ys, zs) → . . .).

Solution:

splits
splits [ ]
splits (x : xs) = ([ ], x : xs) : map cons1 (splits xs) ,

:: List a → List (List a, List a)
= [([ ], [ ])]

where cons1 (ys, zs) = (x : ys, zs) .

If you know how to use λ expressions, you may:

splits
splits [ ]
splits (x : xs) = ([ ], x : xs) : map (λ (ys, zs) → (x : ys, zs)) (splits xs) .

:: List a → List (List a, List a)
= [([ ], [ ])]

Page 9

13. An interleaving of two lists xs and ys is a permutation of the elements of both lists such that
the members of xs appear in their original order, and so does the members of ys. Define
interleave :: List a → List a → List (List a) such that interleave xs ys is the list of
interleaving of xs and ys. For example, interleave [1, 2, 3] [4, 5] yields:

[[1, 2, 3, 4, 5], [1, 2, 4, 3, 5], [1, 2, 4, 5, 3], [1, 4, 2, 3, 5], [1, 4, 2, 5, 3],
[1, 4, 5, 2, 3], [4, 1, 2, 3, 5], [4, 1, 2, 5, 3], [4, 1, 5, 2, 3], [4, 5, 1, 2, 3]].

Solution:

interleave
interleave [ ] ys
interleave xs [ ]
interleave (x : xs) (y : ys) = map (x :) (interleave xs (y : ys)) ++
map (y :) (interleave (x : xs) ys) .

:: List a → List a → List (List a)
= [ys]
= [xs]

14. A list ys is a sublist of xs if we can obtain ys by removing zero or more elements from xs. For
example, [2, 4] is a sublist of [1, 2, 3, 4], while [3, 2] is not. The list of all sublists of [1, 2, 3] is:

[[], [3], [2], [2, 3], [1], [1, 3], [1, 2], [1, 2, 3]].

Define a function sublist :: List a → List (List a) that computes the list of all sublists of the
given list. Hint: to form a sublist of xs, each element of xs could either be kept or dropped.

Solution:

:: List a → List (List a)
= [[ ]]

sublist
sublist [ ]
sublist (x : xs) = xss ++ map (x :) xss ,
where xss = sublist xs .

The righthand side could be sublist xs ++ map (x :) (sublist xs) (but it could be much
slower).

15. Consider the following datatype for internally labelled binary trees:

data Tree a = Null | Node a (Tree a) (Tree a) .

(a) Given (↓) :: Nat → Nat → Nat, which yields the smaller one of its arguments, define
minT :: Tree Nat → Nat, which computes the minimal element in a tree. (Note: (↓) is
actually called min in the standard library. In the lecture we use the symbol (↓) to be
brief.)

Page 10

Solution:

minT
minT Null
minT (Node x t u) = x ↓ minT t ↓ minT u .

:: Tree Nat → Nat
= maxBound

(b) Define mapT :: (a → b) → Tree a → Tree b, which applies the functional argument

to each element in a tree.

Solution:

mapT
mapT f Null
mapT f (Node x t u) = Node (f x) (mapT f t) (mapT f u) .

:: (a → b) → Tree a → Tree b
= Null

(c) Can you define (↓) inductively on Nat?

Solution:

(↓)
0 ↓ n
(1+m) ↓ 0
(1+m) ↓ (1+n) = 1+ (m ↓ n) .

:: Nat → Nat → Nat
= 0
= 0

(d) Prove that for all n and t, minT (mapT (n+) t) = n + minT t. That is, minT ·

mapT (n+) = (n+) · minT .

Solution: Induction on t.
Case t := Null. Omitted.
Case t := Node x t u.

minT (mapT (n+) (Node x t u))

= { definition of mapT }

minT (Node (n + x) (mapT (n+) t) (mapT (n+) u))

= { definition of minT }

(n + x) ↓ minT (mapT (n+) t)) ↓ minT (mapT (n+) u)

= { by induction }

(n + x) ↓ (n + minT t) ↓ (n + minT u)
= { lemma: (n + x) ↓ (n + y) = n + (x ↓ y) }

Page 11

n + (x ↓ minT t ↓ minT u)

= { definition of minT }
n + minT (Node x t u) .

The lemma (n + x) ↓ (n + y) = n + (x ↓ y) can be proved by induction on n, using
inductive definitions of (+) and (↓).

Page 12
