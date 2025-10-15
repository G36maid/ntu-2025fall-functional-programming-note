-- | Chapter 2 Review: Mastering the List
-- | 這個檔案整合了第二章的核心概念，特別是列表的生成、操作以及 Haskell 的特有思想。

module Chapter2_Review where

-- | 為了使用 isDigit, isAlpha 等函數，我們需要匯入 Data.Char 模組
import Data.Char

-- | =================================================================
-- | 1. 列表的本質 (The Nature of Lists)
-- | =================================================================

-- | Haskell 的列表在概念上是一個遞迴的代數資料型別 (ADT)。
-- | `data [a] = [] | a : [a]`
-- | 這表示一個列表要嘛是空的 `[]`，要嘛是一個元素 `a` 加上 (`:`) 另一個列表。
-- | 這與 Rust 中手動實現的鏈結串列 enum 非常相似：
-- | `enum List<T> { Nil, Cons(T, Box<List<T>>) }`

-- | `[1, 2, 3]` 只是下面這個寫法的語法糖 (syntactic sugar)
sampleList :: [Int]
sampleList = 1 : (2 : (3 : []))

-- | =================================================================
-- | 2. 列表的生成 (List Generation)
-- | =================================================================

-- | (A) 範圍 (Ranges)
range1 :: [Int]
range1 = [1..10] -- -> [1,2,3,4,5,6,7,8,9,10]

range2 :: [Int]
range2 = [2, 4 .. 10] -- -> [2,4,6,8,10] (指定步長)

range3 :: [Char]
range3 = ['a'..'f'] -- -> "abcdef"

-- | (B) 列表生成式 (List Comprehensions)
-- | 這是 Haskell 一個極具表達力的特性，可看作是 Rust 迭代器鏈的另一種語法風格。

-- | 範例 1: 找出 1 到 20 中，所有能被 3 整除的數的平方
-- | `x <- [1..20]` 是「生成器」，從來源取值。
-- | `x `mod` 3 == 0` 是「守衛 (guard)」，功能類似 filter。
-- | `x*x` 是「輸出運算式」，功能類似 map。
comprehension1 :: [Int]
comprehension1 = [x*x | x <- [1..20], x `mod` 3 == 0]
-- -> [9,36,81,144,225,324]

-- | 範例 2: 產生多個來源的組合 (類似巢狀迴圈)
-- | 這在 Rust 中通常需要用 .flat_map() 來實現，在 Haskell 中則非常直觀。
comprehension2 :: [(Int, Char)]
comprehension2 = [(x, c) | x <- [1,2], c <- ['a', 'b']]
-- -> [(1,'a'),(1,'b'),(2,'a'),(2,'b')]

-- | =================================================================
-- | 3. 三大核心工具 (The Big Three): map, filter, zip
-- | =================================================================

-- | 這些函數的思想與 Rust 的迭代器方法完全相同。

-- | (A) map: 將一個函數應用到列表的每一個元素上。
-- | `map :: (a -> b) -> [a] -> [b]`
-- | Rust: `.map()`
mapExample :: [Int]
mapExample = map (*2) [1..5] -- -> [2,4,6,8,10]

-- | (B) filter: 保留所有符合條件的元素。
-- | `filter :: (a -> Bool) -> [a] -> [a]`
-- | Rust: `.filter()`
filterExample :: [Int]
filterExample = filter even [1..10] -- -> [2,4,6,8,10]

-- | (C) zip: 將兩個列表像拉鍊一樣合併成元組 (Tuple) 的列表。
-- | `zip :: [a] -> [b] -> [(a,b)]`
-- | Rust: `.zip()`
zipExample :: [(Int, Char)]
zipExample = zip [1,2,3] ['x', 'y', 'z'] -- -> [(1,'x'),(2,'y'),(3,'z')]

-- | Lambda 運算式 (`\`)，與 Rust 的閉包 `||` 作用相同。
lambdaExample :: [Int]
lambdaExample = map (\x -> x * x + 1) [1,2,3] -- -> [2,5,10]

-- | =================================================================
-- | 4. Haskell 特色 (1): 部分應用 (Partial Application)
-- | =================================================================

-- | 在 Haskell 中，`map (*2)` 本身就是一個可以傳遞和重用的新函數。
-- | 這讓程式碼的組合性變得極強。
doubleAll :: [Int] -> [Int]
doubleAll = map (*2)

-- | 現在可以隨意使用這個新函數
usePartialApp :: [Int]
usePartialApp = doubleAll [10, 20, 30] -- -> [20,40,60]

-- | =================================================================
-- | 5. Haskell 特色 (2): 惰性求值與無限列表
-- | =================================================================

-- | 惰性求值 (Lazy Evaluation) 表示任何運算在「需要其結果」之前都不會被執行。
-- | 這使得「無限列表」成為可能且實用的工具。

-- | 範例 1: 一個只包含 1 的無限列表
ones :: [Int]
ones = 1 : ones -- 遞迴定義

-- | 範例 2: 所有自然數的無限列表
naturals :: [Int]
naturals = [1..]

-- | 範例 3: 所有偶數的無限列表
evens :: [Int]
evens = [2, 4 ..]

-- | 因為惰性求值，我們可以安全地從無限列表中「取出」有限的元素。
-- | `take` 函數只要求 5 個元素，所以 Haskell 只會計算 5 次。
fiveNaturals :: [Int]
fiveNaturals = take 5 naturals -- -> [1,2,3,4,5]

-- | 這也讓我們可以用一種非常聲明式的方式解決問題。
-- | 問題：「找出第一個大於 100 的偶數」
-- | 思路：「先定義所有偶數的集合，然後從中過濾出大於 100 的，再取出第一個。」
firstEvenNumberOver100 :: Int
firstEvenNumberOver100 = head (filter (>100) evens)
-- `head` 函數取出列表的第一個元素。
-- Haskell 會一個個計算偶數 (2,4,6...)，直到找到 102，
-- `filter` 讓 102 通過，`head` 拿到 102，運算結束。後面的無限多個偶數完全不會被計算。

-- | =================================================================
-- | 6. 總結：「整體化程式設計」(Wholemeal Programming)
-- | =================================================================

-- | 第二章的核心思想是，不要去想「如何寫一個迴圈去一個個處理元素」，
-- | 而是去想「我可以用哪些現成的操作 (map, filter...) 來對『整個列表』進行轉換」。

-- | 範例：將一個字串中的所有小寫字母轉為大寫，並過濾掉非字母字元。
-- | 命令式思維：寫一個 for 迴圈，檢查每個字元，如果是小寫就轉換，如果不是字母就跳過...
-- | Haskell 思維：
-- | 1. 先過濾掉所有非字母的字元 (`filter isAlpha`)
-- | 2. 再將所有字元轉為大寫 (`map toUpper`)
-- | 3. 用函數組合 `(.)` 將它們串起來。
processString :: String -> String
processString = map toUpper . filter isAlpha

-- | `processString "Hello 123 World!"`
-- | 1. `filter isAlpha "Hello 123 World!"` -> `"HelloWorld"`
-- | 2. `map toUpper "HelloWorld"` -> `"HELLOWORLD"`
