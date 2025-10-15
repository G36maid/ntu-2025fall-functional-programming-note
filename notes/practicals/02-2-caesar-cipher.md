# Practical 02-2: Caesar Cipher

This practical exercise involves implementing the Caesar cipher, a simple substitution cipher where each letter in the plaintext is shifted a certain number of places down or up the alphabet. This project is a classic introduction to using functional programming concepts for text manipulation and analysis.

This practical is adapted from a chapter in Graham Hutton's "Programming in Haskell". For more fascinating stories about cryptography, see Simon Singh's "The Code Book".

## 1. Setup Instructions

1.  **Navigate to Course Homepage**: Go to the course page at `https://cool.ntu.edu.tw/courses/51303`.
2.  **Download Code**: In the "Modules" tab for Week 3, download the `CaesarCipher.zip` file.
3.  **Explore the Code**: Unzip the file and open the `.hs` file in your editor. You will find several function definitions are marked as `undefined`. Your task is to provide the correct implementations.

## 2. The Main Task

The core of the exercise is to implement three main functions:

1.  `encode :: Int → String → String`
2.  `crack :: String → Int`
3.  `decode :: String → String`

### Function Explanations

#### `encode`
-   **Purpose**: `encode k xs` enciphers the input string `xs` using an integer key `k`.
-   **Logic**: Each letter in `xs` should be shifted `k` positions through the alphabet. Non-alphabetic characters should remain unchanged. The shift should wrap around (e.g., shifting 'z' by 2 results in 'b').

#### `crack`
-   **Purpose**: `crack ys` takes an enciphered string `ys` and attempts to automatically determine the key that was used to encode it.
-   **Logic**: This is the most challenging part. A common method is to use frequency analysis. The function should try decoding the string with every possible key (0 through 25) and calculate a "score" for each resulting plaintext. The key that produces the most "English-like" text is the most likely candidate. The chi-square statistic is a great way to measure this.

#### `decode`
-   **Purpose**: `decode xs` takes an enciphered string `xs` and returns the fully decoded plaintext.
-   **Logic**: This function should be a straightforward composition of `crack` and `encode`. It will use `crack` to find the key and then use that key (with a negative shift) to decode the message.

## 3. Implementation Strategy

You will need to define several helper functions to build up to the final solution. Many of these are already specified in the file but are `undefined`.

### Suggested Steps:

1.  **Character Conversion**:
    -   Write functions to convert between characters and integers (`'a' -> 0`, `'b' -> 1`, etc.). `ord` and `chr` are your friends here.
    -   `let2int :: Char -> Int`
    -   `int2let :: Int -> Char`

2.  **Single Character Shift**:
    -   Create a function `shift :: Int -> Char -> Char` that applies the Caesar cipher shift to a single character.
    -   It should handle both upper and lower case letters.
    -   It must correctly wrap around the alphabet.
    -   It should leave non-alphabetic characters unchanged.

3.  **Encoding**:
    -   Use `shift` and `map` to implement `encode`. This should be a one-liner!

4.  **Frequency Analysis**:
    -   Write a function to count the occurrences of each character in a string.
    -   `count :: Char -> String -> Int`
    -   `freqs :: String -> [Float]` to calculate the frequency of each letter 'a'..'z'.
    -   You will be given a table of standard English letter frequencies (`table`).

5.  **Chi-Square Statistic**:
    -   Implement the chi-square formula: `chisqr :: [Float] -> [Float] -> Float`.
    -   This function will take the observed frequencies in a decoded text and the expected English frequencies and return a score. A lower score means the text is more like English.

6.  **Cracking the Code**:
    -   Generate a list of all possible decodings of the ciphertext (one for each key from 0 to 25).
    -   Calculate the chi-square score for each decoding.
    -   Find the decoding with the minimum chi-square score.
    -   The key that produced this best-scoring text is your answer for `crack`.

7.  **Decoding**:
    -   Combine `crack` and `encode` to implement `decode`. Remember that decoding is just encoding with the inverse shift.

## Learning Objectives

-   **Text Processing**: Manipulate strings and characters in a functional style.
-   **Higher-Order Functions**: Use `map`, `filter`, and composition (`.`) to write concise, declarative code.
-   **Problem Decomposition**: Break a complex problem (cracking a cipher) into a series of smaller, manageable functions.
-   **Algorithmic Thinking**: Implement a statistical algorithm (chi-square) to solve a real-world problem.
-   **List Comprehensions**: Use list comprehensions to generate and test possibilities.