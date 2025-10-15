# Practical 02-1: Program Synthesis

This practical exercise focuses on **program synthesis**—constructing programs by composing existing functions to match a given specification. The goal is to develop an intuition for using higher-order functions to solve problems without resorting to explicit recursion.

## 1. Setup Instructions

1.  **Navigate to Course Homepage**: Go to the course page at `https://cool.ntu.edu.tw/courses/51303` and find the materials for this practical.
2.  **Install QuickCheck (Optional)**: For automated testing, it is highly recommended to install the `QuickCheck` package. On UNIX-based systems, you can typically do this with:
    ```bash
    cabal install QuickCheck
    cabal install --lib QuickCheck
    ```
3.  **Download Code**:
    -   If you installed `QuickCheck`, download `practicals_02-1_code.zip`.
    -   Otherwise, download `practicals_02-1_code_no_quickcheck.zip`.
4.  **Load into GHCi**: Unzip the file, navigate into the directory, and load the exercise file for a specific digit `n` (e.g., `T3.hs`) into GHCi:
    ```bash
    ghci T3.hs
    ```

## 2. The Task

Your main goal is to **define a function that behaves identically to a hidden function `f0`**.

-   Inside the loaded module, there is a function `f0`. You can inspect its type with `:t f0` and test it with various inputs.
-   You must open the `Tn.hs` file and define your own function (e.g., `my_f0`) that produces the exact same output as `f0` for all possible inputs.
-   You are not allowed to simply copy the definition of `f0` or any functions from the corresponding `Mn.hs` file.

## 3. Hints and Approach

-   **Composition is Key**: You do not need to write any new recursive functions. All exercises can be solved by composing existing functions from the Prelude and previous lectures.
-   **Focus on Specification, Not Efficiency**: The goal is to clearly specify the problem's solution using function composition. Don't worry about making your solution the most performant one.
-   **Solutions are Short**: A correct solution is typically only one or two lines long.
-   **Type Signatures**: If you see a type like `Eq a => ...`, you can ignore the `Eq a` part for now. It's a hint that the function tests for equality somewhere.
-   **Auxiliary Functions (`f1`, `f2`)**: The files contain helper functions (`f1` and sometimes `f2`) that are simpler versions of the problem. It is highly recommended to solve for these first, as `f0` will likely use `f1` in its definition.

## 4. Testing Your Solution

If you have `QuickCheck` installed, you can automatically verify your solution.

1.  The `Tn.hs` file contains a testing function `correct0`.
2.  Assuming your solution is named `my_f0`, run the following in GHCi:
    ```haskell
    quickCheck (correct0 my_f0)
    ```
3.  **Interpreting the Output**:
    -   `+++ OK, passed 100 tests.` means your function is correct!
    -   If it fails, `QuickCheck` will provide a **counterexample**—an input for which your function's output does not match `f0`'s output.

Helper functions `correct1` and `correct2` are also available to test your solutions for `f1` and `f2`.

## 5. The Challenge: `find`

For an extra challenge, look at `TChallenge.hs`. The goal is to implement the `find` function.

-   **Specification**: `find xs ys` finds the first occurrence of the sublist `xs` within the list `ys` and returns the rest of `ys` starting from the end of that occurrence.
-   Again, the goal is to provide the clearest possible specification, not the most efficient algorithm.

## Learning Objectives

-   **Program Synthesis**: Build new programs by combining existing ones.
-   **Higher-Order Thinking**: Solve problems by thinking in terms of function composition, `map`, `filter`, etc.
-   **Specification-Driven Development**: Write code that matches a precise, given behavior.
-   **Problem Decomposition**: Break a complex problem (`f0`) into simpler sub-problems (`f1`, `f2`).
-   **Property-Based Testing**: Use tools like `QuickCheck` to verify function properties against a specification.