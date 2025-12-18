-- | Chapter 7 Review: Folds and Fold-Fusion (摺疊與融合)
-- | 這個檔案整合了第七章的核心概念：Folds 作為通用模式，以及 Fold-Fusion 定理。
-- | 註解中會包含與 Rust Iterator 的對比，幫助您理解「Zero-Cost Abstractions」的數學基礎。

module Chapter7_Folds_Fusion_Review where

-- | =================================================================
-- | 0. 核心思想：抽象化遞迴模式
-- | =================================================================

-- | **問題**：我們發現很多 List 函數都有相似的結構
-- | **解法**：將這個模式抽象化成 `foldr` (fold right)
-- | **價值**：
-- | 1. 程式結構變成「可討論的實體」
-- | 2. 可以證明關於 fold 的通用定理
-- | 3. 這些定理自動適用於所有使用 fold 的函數

-- | =================================================================
-- | 1. Foldr: 右摺疊的定義
-- | =================================================================

-- | 觀察以下函數的共同模式：

-- | sum []     = 0
-- | sum (x:xs) = x + sum xs

-- | product []     = 1
-- | product (x:xs) = x * product xs

-- | length []     = 0
-- | length (x:xs) = 1 + length xs

-- | 共同結構：
-- | - 空 List 回傳某個「基礎值」
-- | - 非空 List 將「元素」與「遞迴結果」用某個「二元運算」組合

-- | **Foldr 的定義**：
foldrCustom :: (a -> b -> b) -> b -> [a] -> b
foldrCustom f e []     = e
foldrCustom f e (x:xs) = f x (foldrCustom f e xs)

-- | 參數說明：
-- | - f :: a -> b -> b  -- 步進函數 (step function)
-- | - e :: b            -- 基礎值 (base value)
-- | - [a]               -- 輸入列表
-- | - b                 -- 結果

-- | **直觀理解：替換建構子**
-- | foldr f e [1, 2, 3]
-- | = foldr f e (1 : (2 : (3 : [])))
-- | = f 1 (f 2 (f 3 e))
-- |
-- | 將 (:) 替換成 f，將 [] 替換成 e

-- | =================================================================
-- | 2. 用 Foldr 定義常見函數
-- | =================================================================

-- | (A) 數值運算
sumF :: [Int] -> Int
sumF = foldr (+) 0

productF :: [Int] -> Int
productF = foldr (*) 1

-- | (B) 列表長度
lengthF :: [a] -> Int
lengthF = foldr (\_ n -> 1 + n) 0
-- 或：lengthF = foldr (const (1+)) 0

-- | (C) Map
mapF :: (a -> b) -> [a] -> [b]
mapF f = foldr (\x xs -> f x : xs) []

-- | 驗證：
-- | mapF (*2) [1,2,3]
-- | = foldr (\x xs -> x*2 : xs) [] [1,2,3]
-- | = 1*2 : (2*2 : (3*2 : []))
-- | = [2,4,6]

-- | (D) Filter
filterF :: (a -> Bool) -> [a] -> [a]
filterF p = foldr (\x xs -> if p x then x:xs else xs) []

-- | (E) Append (++)
appendF :: [a] -> [a] -> [a]
appendF ys = foldr (:) ys

-- | 驗證：
-- | [1,2] `appendF` [3,4]
-- | = foldr (:) [3,4] [1,2]
-- | = 1 : (2 : [3,4])
-- | = [1,2,3,4]

-- | (F) Concat (攤平)
concatF :: [[a]] -> [a]
concatF = foldr (++) []

-- | (G) And / Or
andF :: [Bool] -> Bool
andF = foldr (&&) True

orF :: [Bool] -> Bool
orF = foldr (||) False

-- | (H) Maximum / Minimum
maximumF :: [Int] -> Int
maximumF = foldr max minBound

minimumF :: [Int] -> Int
minimumF = foldr min maxBound

-- | =================================================================
-- | 3. 更複雜的 Fold 範例
-- | =================================================================

-- | (A) All Prefixes (inits)
-- | inits [1,2,3] = [[],[1],[1,2],[1,2,3]]

initsF :: [a] -> [[a]]
initsF = foldr (\x xss -> [] : map (x:) xss) [[]]

-- | 驗證：
-- | initsF [1,2,3]
-- | = 1 步： [] : map (1:) (initsF [2,3])
-- | = 2 步： [] : map (1:) ([] : map (2:) (initsF [3]))
-- | = 3 步： [] : map (1:) ([] : map (2:) ([] : map (3:) [[]]))
-- | = 3 步： [] : map (1:) ([] : map (2:) [[], [3]])
-- | = 2 步： [] : map (1:) [[], [2], [2,3]]
-- | = 1 步： [[], [1], [1,2], [1,2,3]]

-- | (B) All Suffixes (tails)
-- | tails [1,2,3] = [[1,2,3],[2,3],[3],[]]

-- | 乍看之下 tails 不是 fold，因為用到了 (x:xs)：
-- | tails (x:xs) = (x:xs) : tails xs

-- | 但我們可以利用 head (tails xs) = xs 來改寫：
tailsF :: [a] -> [[a]]
tailsF = foldr (\x xss -> (x : head xss) : xss) [[]]

-- | 驗證：
-- | tailsF [1,2,3]
-- | = (1 : head yss) : yss  where yss = tailsF [2,3]
-- | = (1 : [2,3]) : [[2,3],[3],[]]
-- | = [[1,2,3],[2,3],[3],[]]

-- | =================================================================
-- | 4. 什麼函數「不是」Foldr？
-- | =================================================================

-- | 判斷標準：在 `f (x:xs) = ... f xs ...` 中，
-- | 如果 `xs` 出現在遞迴呼叫「之外」的地方，就不是 foldr。

-- | (A) tail: 不是 foldr
-- | tail (x:xs) = xs  -- xs 直接被回傳，丟失了太多資訊

-- | (B) dropWhile: 不是 foldr
-- | dropWhile p (x:xs)
-- |   | p x       = dropWhile p xs
-- |   | otherwise = x:xs  -- 這裡 xs 被直接使用

-- | (C) reverse: 不是 foldr (但可以用 foldl！)
-- | reverse (x:xs) = reverse xs ++ [x]  -- 可以寫成 fold，但效率差

-- | =================================================================
-- | 5. Fold-Fusion Theorem (融合定理)
-- | =================================================================

-- | **這是本章最重要的定理！**

-- | **定理陳述**：
-- | 給定：
-- | - h :: b -> c         -- 外層函數
-- | - f :: a -> b -> b    -- foldr 的步進函數
-- | - e :: b              -- foldr 的基礎值
-- | - g :: a -> c -> c    -- 目標步進函數
-- |
-- | 如果對所有 x 和 y，滿足：
-- |     h (f x y) = g x (h y)  -- 融合條件
-- |
-- | 則：
-- |     h . foldr f e = foldr g (h e)

-- | **直觀意義**：
-- | 「先 fold 再 apply h」可以被優化成「直接 fold 成目標形式」
-- | 消除中間產生的資料結構！

-- | =================================================================
-- | 6. Fold-Fusion 範例 1: Sum of Squares
-- | =================================================================

-- | 規格：sum . map square
-- | 目標：用一個 foldr 表達

-- | Step 1: 將 map 寫成 foldr
-- | map square = foldr (\x xs -> square x : xs) []

-- | Step 2: 套用 fusion
-- | h = sum
-- | f x xs = square x : xs
-- | e = []
-- |
-- | 需要找到 g，使得：
-- | sum (square x : xs) = g x (sum xs)

-- | 推導：
-- | sum (square x : xs)
-- | = square x + sum xs
-- | = g x (sum xs)  where g x y = square x + y

-- | 因此：
sumOfSquares :: [Int] -> Int
sumOfSquares = foldr (\x acc -> x*x + acc) 0

-- | **Rust 視角**：
-- | Specification: xs.iter().map(|x| x*x).sum()
-- | Optimized:     xs.iter().fold(0, |acc, x| acc + x*x)
-- | Rust 編譯器會自動做這個優化！

-- | =================================================================
-- | 7. Fold-Fusion 範例 2: Scanr (掃描)
-- | =================================================================

-- | scanr 計算每個後綴的 fold 結果
-- | scanr f e [1,2,3] = [f 1 (f 2 (f 3 e)), f 2 (f 3 e), f 3 e, e]

-- | 例如：scanr (+) 0 [1,2,3] = [6,5,3,0]

-- | 規格：
scanrSpec :: (a -> b -> b) -> b -> [a] -> [b]
scanrSpec f e = map (foldr f e) . tailsF

-- | 這個版本效率差：對每個後綴都做一次 foldr

-- | 使用 Fold-Fusion 優化：
-- | h = map (foldr f e)
-- | 我們要將它融合進 tails 的 fold

-- | 推導過程（詳見講義），結果是：
scanrOptimized :: (a -> b -> b) -> b -> [a] -> [b]
scanrOptimized f e = foldr (\x ys -> f x (head ys) : ys) [e]

-- | 驗證：
-- | scanrOptimized (+) 0 [8,1,3]
-- | = 8 步：(8 + head ys) : ys  where ys = scanrOptimized (+) 0 [1,3]
-- | = 1 步：(1 + head zs) : zs  where zs = scanrOptimized (+) 0 [3]
-- | = 3 步：(3 + head ws) : ws  where ws = scanrOptimized (+) 0 []
-- | = base: [0]
-- | = 3 步：(3 + 0) : [0] = [3,0]
-- | = 1 步：(1 + 3) : [3,0] = [4,3,0]
-- | = 8 步：(8 + 4) : [4,3,0] = [12,4,3,0]  -- 錯誤，應該是 [12,4,3,0]

-- | 正確的計算：
-- | scanrOptimized (+) 0 [8,1,3] = [12,4,3,0]

testScanr :: [Int]
testScanr = scanrOptimized (+) 0 [8,1,3]  -- [12,4,3,0]

-- | =================================================================
-- | 8. Maximum Segment Sum (最大區段和) - 融合的極致
-- | =================================================================

-- | **問題**：找出列表中，所有連續子列表的最大和

-- | 規格：
segments :: [a] -> [[a]]
segments = concatF . map initsF . tailsF

mssSpec :: [Int] -> Int
mssSpec = maximum . map sum . segments

-- | 這是 O(n³) 的算法！

-- | **優化策略：連續套用 Fold-Fusion**

-- | Step 1: 融合 max . map sum . inits
-- | 定義：ini x xss = [] : map (x:) xss
-- |
-- | max . map sum . inits
-- | = max . map sum . foldr ini [[]]
-- | = foldr zplus [0]  -- 第一次 fusion
-- |   where zplus x yss = 0 : map (x+) yss

-- | Step 2: 再次融合 max
-- | max (0 : map (x+) yss)
-- | = 0 `max` (x + max yss)  -- 因為 max 分配律
-- | = 0 `max` (x + y)  where y = max yss

-- | 因此：
-- | max . map sum . inits = foldr zmax 0
-- |   where zmax x y = 0 `max` (x + y)

zmax :: Int -> Int -> Int
zmax x y = max 0 (x + y)

-- | Step 3: 最終的 MSS
-- | mss = max . map (max . map sum . inits) . tails
-- |     = max . map (foldr zmax 0) . tails
-- |     = max . scanr zmax 0

mss :: [Int] -> Int
mss = maximum . scanrOptimized zmax 0

-- | **驚人的結果**：從 O(n³) 優化到 O(n)，只靠數學推導！

testMSS :: Int
testMSS = mss [1, -2, 3, -1, 4]  -- 6 (子列表 [3,-1,4])

-- | =================================================================
-- | 9. Folds on Other Data Types (其他資料型別的 Fold)
-- | =================================================================

-- | Fold 不只適用於 List，任何「歸納資料型別」都有對應的 fold

-- | (A) Natural Numbers
data Nat = Zero | Succ Nat deriving (Show, Eq)

foldNat :: (a -> a) -> a -> Nat -> a
foldNat f e Zero     = e
foldNat f e (Succ n) = f (foldNat f e n)

-- | 用 foldNat 定義加法
addNat :: Nat -> Nat -> Nat
addNat m n = foldNat Succ n m

-- | (B) Binary Trees
data Tree a = Leaf | Node a (Tree a) (Tree a) deriving (Show, Eq)

foldTree :: (a -> b -> b -> b) -> b -> Tree a -> b
foldTree f e Leaf         = e
foldTree f e (Node x l r) = f x (foldTree f e l) (foldTree f e r)

-- | 用 foldTree 計算樹的大小
sizeTree :: Tree a -> Int
sizeTree = foldTree (\_ l r -> 1 + l + r) 0

-- | 用 foldTree 計算樹的深度
depthTree :: Tree a -> Int
depthTree = foldTree (\_ l r -> 1 + max l r) 0

-- | (C) Maybe
data Maybe' a = Nothing' | Just' a deriving (Show, Eq)

foldMaybe :: b -> (a -> b) -> Maybe' a -> b
foldMaybe e f Nothing'  = e
foldMaybe e f (Just' x) = f x

-- | =================================================================
-- | 10. Fusion Theorem for Other Types
-- | =================================================================

-- | **Natural Numbers 的 Fusion**：
-- | h . foldNat f e = foldNat g (h e)
-- | 條件：h (f x) = g (h x)

-- | **Trees 的 Fusion**：
-- | h . foldTree f e = foldTree g (h e)
-- | 條件：h (f x l r) = g x (h l) (h r)

-- | =================================================================
-- | 11. Tupling 也是 Fold-Fusion！
-- | =================================================================

-- | 回顧 Chapter 6 的 steepsum 範例：
-- | steepsum = (steep, sum)
-- |          = (foldr ..., foldr ...)
-- |          = fork (foldr steep_step ...) (foldr sum_step ...)

-- | 這其實可以看成是將兩個 fold 融合成一個「回傳 Tuple 的 fold」

steepsumFused :: [Int] -> (Bool, Int)
steepsumFused = foldr step (True, 0)
    where step x (b, y) = (b && x > y, x + y)

-- | =================================================================
-- | 12. Rust 視角：理解 Iterator Adapters
-- | =================================================================

-- | Haskell 的 Fold-Fusion        | Rust 的對應
-- | ----------------------------- | -----------------------------
-- | foldr f e                     | .fold(e, f)
-- | map f . map g = map (f . g)   | .map(f).map(g) -> 融合
-- | sum . map f                   | .map(f).sum() -> 融合
-- | filter p . map f              | .map(f).filter(p) -> 融合

-- | **Rust 的 Zero-Cost Abstractions**：
-- | ```rust
-- | let result = vec.iter()
-- |     .map(|x| x * x)      // 不產生中間 Vec
-- |     .filter(|x| x > 10)  // 不產生中間 Vec
-- |     .sum();              // 只有一個迴圈
-- | ```

-- | Haskell 的 Fold-Fusion 定理就是「證明這種優化是正確的」的數學基礎！

-- | =================================================================
-- | 13. 總結：為什麼 Folds 重要？
-- | =================================================================

-- | **抽象化**：
-- | - 將遞迴模式提升為「可討論的實體」
-- | - 不再說「寫一個迴圈」，而是說「這是一個 fold」

-- | **通用定理**：
-- | - 證明關於 fold 的性質，自動適用於所有用 fold 寫的函數
-- | - Fold-Fusion 讓我們可以系統性地優化程式

-- | **正確性保證**：
-- | - 融合後的程式在數學上保證與原始規格等價
-- | - 這是編譯器優化的理論基礎

-- | **實務價值**：
-- | - 從 O(n³) 到 O(n) (Maximum Segment Sum)
-- | - 消除中間資料結構
-- | - 理解現代語言（如 Rust）的優化原理

-- | **下一步**：
-- | 第八章會探討無限的資料結構 (Streams/Codata)
