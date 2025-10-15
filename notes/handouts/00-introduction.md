# Handout 00: Introduction to Functional Programming

## Course Overview

This course covers **Programming Language Theory** - theories about the language and tools we use to program. The central themes are:

- **Abstraction**: The three most important factors in programming languages
- **Equivalence**: Understanding when programs are equivalent
- **Algebraic Manipulation**: Using symbols and rules to reason about programs

## 1. The Isle of Knights and Knaves

### Problem Setup
On a remote isle live two kinds of people:
- **Knights**: Always tell the truth
- **Knaves**: Always lie
- Everyone is either a knight or a knave

### The Cave Problem
You're at a cave entrance. Legend says it contains either gold or a dragon. An old man stands there. How do you form a question to determine which is the case?

### Mathematical Formulation

**Key Insight**: "A said P" can be denoted by `A ≡ P`
- If A is a knight, P must be True
- If A is a knave, P must be False

### Example Problems

#### Problem 1: Self-Reference
A says: "I am a knight"
- Analysis: `A ≡ A` is always True
- Conclusion: Any person would say they're a knight

#### Problem 2: About Another
A says: "B is a knight"
- Analysis: `A ≡ B`
- Conclusion: A and B are of the same kind

#### Problem 3: Indirect Reference
A says: "If you ask B whether he is a knight, he would say 'Yes'"
```
A ≡ (B ≡ B)
≡ A ≡ True    { B ≡ B is always True }
≡ A           { x ≡ True equals x }
```
- Conclusion: A is a knight, nothing known about B

#### Problem 4: Same Kind Claim
A says: "B and I are of the same kind!"
```
A ≡ (A ≡ B)
≡ (A ≡ A) ≡ B    { ≡ is associative }
≡ True ≡ B       { A ≡ A is always True }
≡ B              { True ≡ x equals x }
```
- Conclusion: B is a knight, nothing known about A

### Solution to Cave Problem
**Goal**: Design question Q such that A answers Yes iff there is gold in the cave.

Let G = "there is gold in the cave"
```
(A ≡ Q) ≡ G
≡ Q ≡ (A ≡ G)    { rearranging }
```

**The Question**: "Is 'You are a knight' equivalent to 'there is gold in the cave'?"

## 2. Abstraction

### Definition
**Abstraction** is the process of:
- Extracting the underlying essence of a mathematical concept
- Removing dependence on real-world objects
- Generalizing for wider applications

### Problem-Solving Method
1. **Turn problems into mathematical formulae** (abstraction - harder step)
2. **Calculate using rules** (manipulation - easier step)

### Algebra Example
**Problem**: "Mary had twice as many apples as John. Mary found half her apples rotten and threw them away. John ate one apple. Still, Mary has twice as many apples as John. How many apples originally?"

**Abstraction**:
```
m = 2 × j
m/2 = 2 × (j - 1)
```

**What was extracted**: Values and relationships  
**What was dropped**: Time, causality, narrative

## 3. Programming Languages as Formal Systems

### Key Properties
- **Symbolic**: Uses abstract symbols
- **Formal**: Collection of symbols with manipulation rules
- **Abstract Model**: Models real world while throwing away "unimportant" parts

### Goal
A well-designed programming language relieves us of the mental burden of programming, just like mathematical notation relieves us of mental calculation burden.

### Different Logics for Different Purposes
- **Propositional logic**: Basic true/false reasoning
- **Predicate logic**: "for all", "exists"
- **Modal logic**: Time and order
- **Separation logic**: Resource sharing
- **Descriptive logic**: Concepts and relationships

Each logic corresponds to type systems in programming languages.

## 4. Algebraic Properties of Programs

### Example: Loop Equivalence
These two programs are equivalent:
```c
// Program 1
s = 0; m = 0;
for (i=0; i<=N; i++) s = a[i] + s;
for (i=0; i<=N; i++) m = a[i] + m;

// Program 2  
s = 0; m = 0;
for (i=0; i<=N; i++) {
    s = a[i] + s;
    m = a[i] + m;
}
```

**Questions**:
- Is this equivalence easily seen?
- Can we transform one to another systematically?
- Does equivalence hold for other statements?

### Maximum Segment Sum Example
**Specification**: `max { sum(i,j) :: 0 ≤ i ≤ j ≤ N }`  
where `sum(i,j) = a[i] + a[i+1] + ... + a[j-1]`

**Efficient Implementation**:
```c
s = 0; m = 0;
for (i=0; i<=N; i++) {
    s = max(0, a[i]+s);
    m = max(m, s);
}
```

**Moral**: Programs that appear simple might be sophisticated! The efficient solution looks nothing like the specification.

## 5. Programming vs Programming Languages

### Definitions
- **Specification**: What we want the program to do
- **Program**: How to do it  
- **Correctness**: Program behavior is allowed by specification
- **Semantics**: Defining "behaviors" of a program
- **Programming**: Coding up a correct program

### Language Design Goals
A programming language should help programmers by either:
1. Making it easy to check program correctness
2. Ensuring only correct programs can be constructed

### Dijkstra's Quote
> "The designer of the program had better regard the program as a sophisticated formula. And we also know that there is only one trustworthy way of designing a sophisticated formula, viz., derivation by means of symbol manipulation. We have to let the symbols do the work."  
> — E.W. Dijkstra, *The next forty years*, 14 June 1989

## 6. Course Plans

### Learning Approach
1. **Start with Haskell** - A functional programming language
2. **Emphasis on**:
   - Constructing programs in a disciplined manner
   - Showing programs are correct
3. **Later**: Use Agda (dependently typed language) for program-proof relationships

### Why Functional Programming?
- Different from imperative programming you're used to
- Provides new perspectives on programming
- **Alan Perlis**: "A language that doesn't affect the way you think about programming, is not worth knowing."

### Paradigm Abstractions
- **Object-oriented**: Everything is an object!
- **Functional**: Everything is a function!  
- **Logic**: "Computation = controlled deduction!" "Algorithm = logic + control!"

### Course Philosophy
> A programming language is an abstract view toward computation, with attention on aspects the designers care about. To learn a language is to learn its view.

## Key Takeaways

1. **Mathematical reasoning** can solve logical puzzles systematically
2. **Abstraction** is the key to managing complexity
3. **Formal systems** with symbols and rules enable mechanical reasoning
4. **Programming languages** are abstractions that shape how we think
5. **Functional programming** offers a mathematical approach to computation