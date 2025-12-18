-- | Chapter 8 Review: Streams and Codata (串流與對偶資料)
-- | 這個檔案整合了第八章的核心概念：無限資料結構與 Coinductive Types。
-- | 註解中會包含與 Rust Iterator 的對比，幫助您理解「惰性求值」與「無限序列」。

{-# LANGUAGE PostfixOperators #-}

module Chapter8_Streams_Codata_Review where

-- | =================================================================
-- | 0. 核心思想：Data vs Codata
-- | =================================================================

-- | **Data (歸納資料型別)**：
-- | - 由建構子 (Constructors) 定義
-- | - 有限的結構
-- | - 透過模式匹配 (Pattern Matching) 消費
-- | - 證明方法：歸納法 (Induction)

-- | **Codata (餘歸納資料型別)**：
-- | - 由解構子 (Destructors) 定義
-- | - 可能無限
-- | - 透過協模式 (Copatterns) 產生
-- | - 證明方法：餘歸納法 (Coinduction) 或唯一不動點 (Unique Fixed Points)

-- | **Rust 視角**：
-- | Data    ≈ Vec<T> (資料已經在記憶體中)
-- | Codata  ≈ Iterator<Item=T> (資料按需產生)

-- | =================================================================
-- | 1. List 的回顧 (Inductive Type)
-- | =================================================================

-- | List 是典型的歸納資料型別：
-- | data List a = [] | a : List a

-- | 特性：
-- | - 由「有限次」應用建構子產生
-- | - [] 是基礎情況，(:) 是歸納步驟

-- | 函數透過模式匹配定義：
sumList :: [Int] -> Int
sumList []     = 0
sumList (x:xs) = x + sumList xs

-- | =================================================================
-- | 2. Stream 的定義 (Coinductive Type)
-- | =================================================================

-- | 概念上，Stream 是由解構子定義：
-- | codata Stream a where
-- |   headS :: Stream a -> a
-- |   tailS :: Stream a -> Stream a

-- | 在 Haskell 中，我們用 List 模擬 Stream（因為 Haskell 是惰性的）
-- | 但概念上它們是不同的！

-- | 類型別名（實際上 Haskell 的 List 在惰性求值下就能表達無限序列）
type Stream a = [a]

-- | =================================================================
-- | 3. 用 Copatterns 定義 Stream
-- | =================================================================

-- | **範例 1：無限個 1 的串流**
-- | 用協模式思考：
-- |   head ones = 1
-- |   tail ones = ones

ones :: Stream Int
ones = 1 : ones

-- | 執行過程（惰性）：
-- | take 5 ones
-- | = take 5 (1 : ones)
-- | = 1 : take 4 ones
-- | = 1 : take 4 (1 : ones)
-- | = 1 : 1 : take 3 ones
-- | ...
-- | = [1,1,1,1,1]

-- | **範例 2：自然數串流**
-- | 協模式：
-- |   head (from n) = n
-- |   tail (from n) = from (n+1)

from :: Int -> Stream Int
from n = n : from (n+1)

naturals :: Stream Int
naturals = from 0

-- | **範例 3：斐波那契數列**
-- | fib = 0 : fib'
-- | fib' = 1 : fib''
-- | fib'' = zipWith (+) fib fib'

fibs :: Stream Int
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

-- | 執行過程：
-- | fibs = 0 : 1 : zipWith (+) [0,1,...] [1,...]
-- |      = 0 : 1 : 1 : zipWith (+) [1,1,...] [1,...]
-- |      = 0 : 1 : 1 : 2 : zipWith (+) [1,1,2,...] [2,...]
-- |      = [0,1,1,2,3,5,8,13,...]

testFibs :: [Int]
testFibs = take 10 fibs  -- [0,1,1,2,3,5,8,13,21,34]

-- | =================================================================
-- | 4. Stream 的基本運算
-- | =================================================================

-- | (A) headS 和 tailS
headS :: Stream a -> a
headS (x:_) = x

tailS :: Stream a -> Stream a
tailS (_:xs) = xs

-- | (B) map for Streams
-- | 協模式定義：
-- |   head (mapS f xs) = f (head xs)
-- |   tail (mapS f xs) = mapS f (tail xs)

mapS :: (a -> b) -> Stream a -> Stream b
mapS f (x:xs) = f x : mapS f xs

-- | 或用 cons-based 語法：
-- | mapS f xs = f (head xs) : mapS f (tail xs)

-- | (C) repeat: 無限重複的串流
repeatS :: a -> Stream a
repeatS x = x : repeatS x

-- | (D) iterate: 反覆應用函數
-- | iterate f x = [x, f x, f (f x), f (f (f x)), ...]
iterateS :: (a -> a) -> a -> Stream a
iterateS f x = x : iterateS f (f x)

-- | 範例：2 的冪次
powersOf2 :: Stream Int
powersOf2 = iterateS (*2) 1  -- [1,2,4,8,16,32,...]

testPowersOf2 :: [Int]
testPowersOf2 = take 8 powersOf2

-- | =================================================================
-- | 5. zipWith: 組合兩個串流
-- | =================================================================

-- | 協模式：
-- |   head (zipWithS f xs ys) = f (head xs) (head ys)
-- |   tail (zipWithS f xs ys) = zipWithS f (tail xs) (tail ys)

zipWithS :: (a -> b -> c) -> Stream a -> Stream b -> Stream c
zipWithS f (x:xs) (y:ys) = f x y : zipWithS f xs ys

-- | 範例：用 zipWith 定義自然數
nats :: Stream Int
nats = 0 : zipWithS (+) nats (repeatS 1)

-- | nats = 0 : zipWith (+) [0,1,2,...] [1,1,1,...]
-- |      = 0 : 1 : zipWith (+) [1,2,3,...] [1,1,1,...]
-- |      = 0 : 1 : 2 : zipWith (+) [2,3,4,...] [1,1,1,...]
-- |      = [0,1,2,3,4,...]

-- | =================================================================
-- | 6. Applicative Style: (<*>)
-- | =================================================================

-- | 在 Stream 上定義 Applicative Functor
-- | (<*>) :: Stream (a -> b) -> Stream a -> Stream b
-- | 協模式：
-- |   head (fs <*> xs) = (head fs) (head xs)
-- |   tail (fs <*> xs) = (tail fs) <*> (tail xs)

(<**>) :: Stream (a -> b) -> Stream a -> Stream b
(f:fs) <**> (x:xs) = f x : (fs <**> xs)

-- | 用 (<*>) 重新定義 mapS 和 zipWithS
mapS' :: (a -> b) -> Stream a -> Stream b
mapS' f xs = repeatS f <**> xs

zipWithS' :: (a -> b -> c) -> Stream a -> Stream b -> Stream c
zipWithS' f xs ys = (repeatS f <**> xs) <**> ys

-- | =================================================================
-- | 7. Streams as Numbers (將串流視為數字)
-- | =================================================================

-- | 我們可以讓 Stream 實作 Num 類別！
instance Num a => Num (Stream a) where
    -- 逐元素相加
    (x:xs) + (y:ys) = (x+y) : (xs + ys)

    -- 逐元素相減
    (x:xs) - (y:ys) = (x-y) : (xs - ys)

    -- 逐元素相乘
    (x:xs) * (y:ys) = (x*y) : (xs * ys)

    -- negate
    negate xs = mapS negate xs

    -- abs 和 signum 沒有太大意義，但為了符合 Num 類別
    abs xs = mapS abs xs
    signum xs = mapS signum xs

    -- fromInteger 產生常數串流
    fromInteger n = repeatS (fromInteger n)

-- | 現在可以寫出更簡潔的定義！
-- | naturals = [0,1,2,3,...]
-- | 可以寫成：
nats' :: Stream Int
nats' = 0 : 1 + nats'

-- | 驗證：
-- | nats' = 0 : (1 + nats')
-- |       = 0 : (1 + [0,1,2,...])
-- |       = 0 : [1,2,3,...]
-- |       = [0,1,2,3,...]

-- | 斐波那契也可以更簡潔：
fibs' :: Stream Int
fibs' = 0 : fibs''
    where
        fibs'' = 1 : fibs'''
        fibs''' = fibs' + fibs''

testNats' :: [Int]
testNats' = take 10 nats'

-- | =================================================================
-- | 8. Interleaving (交錯運算子)
-- | =================================================================

-- | (\/) 將兩個串流交錯合併
-- | 協模式：
-- |   head (xs \/ ys) = head xs
-- |   tail (xs \/ ys) = ys \/ tail xs

(\/) :: Stream a -> Stream a -> Stream a
(x:xs) \/ ys = x : (ys \/ xs)

infixr 5 \/  -- 設定優先級

-- | 注意：(\/) 既不滿足交換律也不滿足結合律！
-- | [1,2,3,...] \/ [10,20,30,...] = [1,10,2,20,3,30,...]
-- | [10,20,30,...] \/ [1,2,3,...] = [10,1,20,2,30,3,...]

testInterleave :: [Int]
testInterleave = take 10 (from 1 \/ from 100)  -- [1,100,2,101,3,102,4,103,5,104]

-- | =================================================================
-- | 9. Binary Construction of Naturals (二進位建構自然數)
-- | =================================================================

-- | 用交錯運算子建構所有自然數：
-- | bin = [0, 奇數, 偶數（不含0）]
-- |     = [0] + [1,3,5,7,...] 交錯 [2,4,6,8,...]
-- |     = 0 : (2*bin + 1) \/ (2*bin + 2)

bin :: Stream Int
bin = 0 : (2 * bin + 1) \/ (2 * bin + 2)

testBin :: [Int]
testBin = take 16 bin  -- [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]

-- | 神奇！這個定義產生了所有自然數，按照特定順序排列。

-- | =================================================================
-- | 10. Ruler Sequence (尺規序列 / 二進位進位序列)
-- | =================================================================

-- | Ruler sequence: [0,1,0,2,0,1,0,3,0,1,0,2,0,1,0,4,...]
-- | 第 n 項是「n 能被 2 的幾次方整除」

-- | 定義：
-- | carry = 0 : (1 + carry) \/ 0

carry :: Stream Int
carry = 0 : (1 + carry) \/ repeatS 0

testCarry :: [Int]
testCarry = take 16 carry  -- [0,1,0,2,0,1,0,3,0,1,0,2,0,1,0,4]

-- | 應用：這在某些演算法（如 Skew Binary Numbers）中很有用

-- | =================================================================
-- | 11. 證明 Stream 的等式：Unique Fixed Points
-- | =================================================================

-- | 對於有限資料（List），我們用歸納法證明。
-- | 對於無限資料（Stream），我們用「唯一不動點原理」。

-- | **原理**：
-- | 如果 xs 和 ys 滿足「相同的可允許方程式」，則 xs = ys

-- | **可允許方程式**：
-- | xs = h : t
-- | 其中 h 是常數，t 可能引用 xs，但不能對 xs 做 head 或 tail 操作

-- | **範例 1：證明 repeat f <*> repeat x = repeat (f x)**

-- | 左邊：
-- | repeat f <*> repeat x
-- | = (f : repeat f) <*> (x : repeat x)
-- | = f x : (repeat f <*> repeat x)

-- | 右邊：
-- | repeat (f x)
-- | = f x : repeat (f x)

-- | 兩邊都滿足 ys = f x : ys，所以相等！

-- | **範例 2：證明 naturals = 2 * naturals \/ (1 + 2 * naturals)**

-- | 已知 naturals = 0 : 1 + naturals

-- | 右邊：
-- | 2 * naturals \/ (1 + 2 * naturals)
-- | = 2 * (0 : 1 + naturals) \/ (1 + 2 * naturals)
-- | = (0 : 2 * (1 + naturals)) \/ (1 + 2 * naturals)
-- | = 0 : (1 + 2 * naturals) \/ 2 * (1 + naturals)
-- | = 0 : (1 + 2 * naturals) \/ (2 + 2 * naturals)

-- | 使用分配律：a \/ b 與 (+) 滿足某種分配律（需證明）
-- | 最終可以證明它們相等（詳細證明見講義）

-- | =================================================================
-- | 12. 實戰範例：Hamming Numbers (漢明數)
-- | =================================================================

-- | Hamming Numbers: 只包含質因數 2, 3, 5 的正整數
-- | [1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, ...]

-- | 定義：hamming 是「1」加上「2*hamming, 3*hamming, 5*hamming 的合併（去重）」

-- | 合併兩個有序串流（去重）
merge :: Ord a => Stream a -> Stream a -> Stream a
merge (x:xs) (y:ys)
    | x < y     = x : merge xs (y:ys)
    | x > y     = y : merge (x:xs) ys
    | otherwise = x : merge xs ys  -- x == y，去重

hamming :: Stream Int
hamming = 1 : merge (mapS (*2) hamming)
                    (merge (mapS (*3) hamming)
                           (mapS (*5) hamming))

testHamming :: [Int]
testHamming = take 20 hamming
-- [1,2,3,4,5,6,8,9,10,12,15,16,18,20,24,25,27,30,32,36]

-- | =================================================================
-- | 13. Rust 視角：Iterator vs Stream
-- | =================================================================

-- | Haskell Stream              | Rust Iterator
-- | --------------------------- | -----------------------------------
-- | ones = 1 : ones             | std::iter::repeat(1)
-- | from n = n : from (n+1)     | (n..)
-- | iterate f x                 | std::iter::successors(Some(x), |&x| Some(f(x)))
-- | zipWith f xs ys             | xs.zip(ys).map(|(x,y)| f(x,y))
-- | take n xs                   | xs.take(n)

-- | **關鍵差異**：
-- | 1. Haskell 的 Stream 會「記憶化」(Memoize)
-- |    變數 `let xs = from 0` 會把計算過的值存在記憶體
-- | 2. Rust 的 Iterator 通常是「一次性」的
-- |    `next()` 呼叫完，值就消失了（除非 collect）

-- | **相似之處**：
-- | 都支援「惰性求值」，只在需要時計算

-- | =================================================================
-- | 14. 終止性 (Termination)
-- | =================================================================

-- | **歸納型別的程式必須終止**：
-- | - 因為資料是有限的
-- | - 遞迴必須在有限步內到達基礎情況

-- | **餘歸納型別的程式可以不終止**：
-- | - 資料可能無限
-- | - 但每次「觀察」(head, take) 必須在有限時間內完成

-- | **非終止的例子**：
-- | loop = loop  -- 不是 guarded，會無限遞迴
-- | bad = head bad : bad  -- 試圖觀察自己，會無限遞迴

-- | **終止的例子**：
-- | ones = 1 : ones  -- guarded by (:)，每次計算都會產生一個值

-- | =================================================================
-- | 15. 總結：Data vs Codata
-- | =================================================================

-- | 特性            | Data (List)        | Codata (Stream)
-- | --------------- | ------------------ | -------------------
-- | 定義方式        | 建構子             | 解構子
-- | 大小            | 有限               | 可能無限
-- | 消費方式        | Pattern Matching   | Copatterns
-- | 證明方式        | 歸納法             | 餘歸納/不動點
-- | 終止性          | 必須終止           | 可以不終止
-- | 範例            | [1,2,3]            | [1,2,3,...]
-- | Rust 類比       | Vec<T>             | Iterator<Item=T>

-- | =================================================================
-- | 16. 期末複習重點
-- | =================================================================

-- | **必須理解的概念**：
-- | 1. Stream 的 copattern 定義方式
-- | 2. 如何用遞迴定義無限串流 (ones, naturals, fibs)
-- | 3. zipWith 和 Applicative 的使用
-- | 4. 交錯運算子 (\/) 的行為
-- | 5. 唯一不動點原理證明等式

-- | **必須會做的題型**：
-- | 1. 定義給定規則的無限串流
-- | 2. 證明兩個串流定義相等
-- | 3. 使用 Stream 解決組合問題（如 Hamming Numbers）

-- | **Rust 使用者的優勢**：
-- | - 已經熟悉 Iterator 的概念
-- | - 理解惰性求值的價值
-- | - 知道如何組合小的運算子建構複雜邏輯

-- | **下一步**：
-- | - 練習定義不同的無限序列
-- | - 練習證明串流等式
-- | - 將 Stream 的思維應用到實際問題
