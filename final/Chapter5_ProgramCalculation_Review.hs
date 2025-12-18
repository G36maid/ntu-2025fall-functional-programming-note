-- | Chapter 5 Review: Simple Program Calculation (程式推導基礎)
-- | 這個檔案整合了第五章的核心概念：透過數學等式推導來優化程式。
-- | 註解中會包含與 Rust 的對比，幫助您理解如何「手動執行編譯器優化」。

module Chapter5_ProgramCalculation_Review where

-- | =================================================================
-- | 0. 核心思想：為什麼要程式推導？
-- | =================================================================

-- | 在函數式程式設計中，我們常常先寫出「簡潔但沒效率」的 Specification (規格)，
-- | 然後透過數學推導將它轉換成「高效」的實作。

-- | **關鍵優勢**：
-- | 1. 規格簡單易懂，不易出錯
-- | 2. 推導過程本身就是正確性證明
-- | 3. 最終程式碼經過數學驗證，保證與規格等價

-- | **Rust 視角**：
-- | 這類似於理解為什麼 `iter().map().filter()` 會被編譯器優化成單一迴圈。
-- | Haskell 是用數學「手動」做這件事，Rust 是讓編譯器「自動」做。

-- | =================================================================
-- | 1. 資料結構的時間複雜度
-- | =================================================================

-- | Haskell 的 List 是 Linked List (單向鏈結串列)
-- | data [a] = [] | a : [a]

-- | 時間複雜度：
-- | 操作          | Haskell List | Rust Vec    | Rust LinkedList
-- | ------------- | ------------ | ----------- | ---------------
-- | head/first    | O(1)         | O(1)        | O(1)
-- | tail          | O(1)         | -           | O(1)
-- | last          | O(n)         | O(1)        | O(n)
-- | (++)          | O(m) [左邊]  | O(n) [concat] | O(1) [append]
-- | index (!!)    | O(n)         | O(1)        | O(n)
-- | length        | O(n)         | O(1) [cached] | O(n)

-- | **關鍵洞察**：Haskell List 最適合「從左到右逐一處理」的操作。
-- | 這也是為什麼我們要學習如何避免 `(++)` 和 `reverse` 的低效使用。

-- | =================================================================
-- | 2. List 連接 (++) 的效率問題
-- | =================================================================

-- | 定義：
appendList :: [a] -> [a] -> [a]
appendList []     ys = ys
appendList (x:xs) ys = x : appendList xs ys

-- | 時間複雜度：O(length xs)
-- | 關鍵：`(++)` 需要重建左邊的整個 List

-- | 範例執行過程：
-- | [1,2,3] ++ [4,5]
-- | = 1 : ([2,3] ++ [4,5])
-- | = 1 : 2 : ([3] ++ [4,5])
-- | = 1 : 2 : 3 : ([] ++ [4,5])
-- | = 1 : 2 : 3 : [4,5]
-- | = [1,2,3,4,5]

-- | **問題**：如果在遞迴中重複使用 `(++)`，時間複雜度會爆炸！
-- | 例如：reverse 的 naive 實作

naiveReverse :: [a] -> [a]
naiveReverse []     = []
naiveReverse (x:xs) = naiveReverse xs ++ [x]

-- | 時間複雜度：O(n²)
-- | 原因：每次遞迴都要做一次 O(n) 的 `(++)`，總共 n 次

-- | =================================================================
-- | 3. 程式推導入門：消除中間資料結構
-- | =================================================================

-- | **經典範例：Sum of Squares**

-- | Step 1: 寫出簡潔的 Specification
square :: Int -> Int
square x = x * x

sumSquaresSpec :: [Int] -> Int
sumSquaresSpec xs = sum (map square xs)

-- | 這個版本很清楚：「先平方每個元素，再加總」
-- | 但它會產生一個中間的 List

-- | Step 2: 透過數學推導消除中間 List

-- | 推導過程 (Case 1: 空 List)：
-- | sumSquares []
-- | = { 定義 }
-- |   sum (map square [])
-- | = { map 的定義 }
-- |   sum []
-- | = { sum 的定義 }
-- |   0

-- | 推導過程 (Case 2: (x:xs))：
-- | sumSquares (x:xs)
-- | = { 定義 }
-- |   sum (map square (x:xs))
-- | = { map 的定義 }
-- |   sum (square x : map square xs)
-- | = { sum 的定義 }
-- |   square x + sum (map square xs)
-- | = { 定義 }
-- |   square x + sumSquares xs

-- | Step 3: 寫出推導後的高效版本
sumSquares :: [Int] -> Int
sumSquares []     = 0
sumSquares (x:xs) = square x + sumSquares xs

-- | 這個版本：
-- | 1. 不產生中間 List (省記憶體)
-- | 2. 單次遍歷 (O(n) 時間)
-- | 3. 數學上保證與 Specification 等價

-- | **Rust 視角**：
-- | Specification: `xs.iter().map(|x| x*x).sum()`
-- | Rust 編譯器會自動將上面的程式碼優化成類似：
-- | let mut total = 0;
-- | for x in xs {
-- |     total += x * x;
-- | }

-- | =================================================================
-- | 4. 為什麼函數式程式設計適合推導？
-- | =================================================================

-- | **關鍵特性：Referential Transparency (引用透明性)**

-- | 在純函數式語言中，我們可以自由地進行等式替換：
-- | - `f x + f x = 2 * f x` 永遠成立
-- | - 因為 `f x` 每次計算都保證得到相同結果，沒有副作用

-- | 在命令式語言中，這「不一定」成立：
-- | ```rust
-- | fn f(x: i32) -> i32 {
-- |     unsafe { COUNTER += 1; }  // 修改全域狀態
-- |     x + COUNTER
-- | }
-- | // f(4) + f(4) 不等於 2 * f(4)
-- | ```

-- | **這就是為什麼 Haskell 可以進行嚴格的數學推導**

-- | =================================================================
-- | 5. 推導技巧：展開與摺疊定義
-- | =================================================================

-- | 推導的基本步驟：
-- | 1. 根據輸入做 Case Analysis (通常是空 List vs 非空 List)
-- | 2. 展開 (Unfold) 函數定義
-- | 3. 套用已知的定律 (Laws)
-- | 4. 摺疊 (Fold) 回目標函數

-- | 範例：證明 map 的融合律 (Fusion Law)
-- | 定律：map f . map g = map (f . g)

-- | 證明 (空 List)：
-- | (map f . map g) []
-- | = map f (map g [])
-- | = map f []
-- | = []
-- | = map (f . g) []

-- | 證明 (x:xs)：
-- | (map f . map g) (x:xs)
-- | = map f (map g (x:xs))
-- | = map f (g x : map g xs)
-- | = f (g x) : map f (map g xs)
-- | = (f . g) x : (map f . map g) xs    -- 歸納假設
-- | = (f . g) x : map (f . g) xs
-- | = map (f . g) (x:xs)

-- | =================================================================
-- | 6. 實戰範例 1：Filter + Map 的融合
-- | =================================================================

-- | 規格：找出所有偶數並平方
evenSquaresSpec :: [Int] -> [Int]
evenSquaresSpec xs = map square (filter even xs)

-- | 推導 (空 List)：
-- | evenSquares []
-- | = map square (filter even [])
-- | = map square []
-- | = []

-- | 推導 (x:xs，x 是偶數)：
-- | evenSquares (x:xs)  -- 假設 even x == True
-- | = map square (filter even (x:xs))
-- | = map square (x : filter even xs)
-- | = square x : map square (filter even xs)
-- | = square x : evenSquares xs

-- | 推導 (x:xs，x 是奇數)：
-- | evenSquares (x:xs)  -- 假設 even x == False
-- | = map square (filter even (x:xs))
-- | = map square (filter even xs)
-- | = evenSquares xs

evenSquares :: [Int] -> [Int]
evenSquares [] = []
evenSquares (x:xs)
    | even x    = square x : evenSquares xs
    | otherwise = evenSquares xs

-- | =================================================================
-- | 7. 實戰範例 2：計算平均值
-- | =================================================================

-- | 規格：計算列表的平均值
averageSpec :: [Int] -> Float
averageSpec xs = fromIntegral (sum xs) / fromIntegral (length xs)

-- | **問題**：這個版本遍歷了 List 兩次 (一次 sum，一次 length)

-- | **解法**：使用 Tupling (下一章會詳細介紹)
-- | 同時計算總和與長度

sumAndLength :: [Int] -> (Int, Int)
sumAndLength []     = (0, 0)
sumAndLength (x:xs) = (x + s, 1 + n)
    where (s, n) = sumAndLength xs

averageOptimized :: [Int] -> Float
averageOptimized xs = fromIntegral s / fromIntegral n
    where (s, n) = sumAndLength xs

-- | 現在只需要遍歷一次！

-- | =================================================================
-- | 8. 常用的等式定律 (Laws for Reasoning)
-- | =================================================================

-- | 這些定律在推導中經常使用：

-- | (A) List 的結合律
-- | (xs ++ ys) ++ zs = xs ++ (ys ++ zs)

-- | (B) map 的融合律
-- | map f . map g = map (f . g)

-- | (C) map 與 append 的交換律
-- | map f (xs ++ ys) = map f xs ++ map f ys

-- | (D) filter 的融合律
-- | filter p . filter q = filter (\x -> p x && q x)

-- | (E) sum 與 append 的交換律
-- | sum (xs ++ ys) = sum xs + sum ys

-- | (F) length 與 append 的交換律
-- | length (xs ++ ys) = length xs + length ys

-- | (G) 函數組合的結合律
-- | (f . g) . h = f . (g . h)

-- | =================================================================
-- | 9. 推導模板 (Calculation Template)
-- | =================================================================

-- | 標準的推導結構：

-- | ```
-- | f 的目標定義
-- | f pattern1 = ?
-- | f pattern2 = ?
-- |
-- | 推導：
-- | f pattern1
-- | = { 展開 f 的規格定義 }
-- |   ...
-- | = { 套用某個定律 }
-- |   ...
-- | = { 簡化 }
-- |   result1
-- |
-- | f pattern2
-- | = { 同上 }
-- |   ...
-- | = result2
-- | ```

-- | =================================================================
-- | 10. 總結：程式推導的價值
-- | =================================================================

-- | **為什麼要學程式推導？**

-- | 1. **正確性保證**：推導過程就是證明過程
-- | 2. **效能優化**：從清晰的規格出發，推導出高效實作
-- | 3. **深入理解**：理解「為什麼這個程式碼是對的」
-- | 4. **遷移技能**：這些思維方式可以應用到其他語言

-- | **Rust 使用者的收穫**：
-- | - 理解編譯器優化的數學原理
-- | - 學會用數學方式驗證程式碼
-- | - 更好地設計 Iterator 鏈

-- | **下一步**：
-- | 第六章會介紹更強大的推導技巧：Tupling 和 Accumulating Parameters
