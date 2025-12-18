-- | Chapter 6 Review: Advanced Program Calculation (進階程式推導)
-- | 這個檔案整合了第六章的核心概念：Tupling 與 Accumulating Parameters。
-- | 註解中會包含與 Rust 的對比，幫助您理解「如何讓程式更快」。

module Chapter6_AdvancedCalculation_Review where

-- | =================================================================
-- | 0. 核心思想：Work Less by Promising More (透過承諾更多來做更少)
-- | =================================================================

-- | **Dijkstra 的名言**：
-- | "程式與證明應該一起成長 (grow hand in hand)"

-- | **本章的兩大技巧**：
-- | 1. Tupling: 回傳更多資訊 (一次計算多個結果)
-- | 2. Accumulating Parameters: 傳入更多資訊 (透過累積參數優化)

-- | **為什麼「做更多」反而「更快」？**
-- | 因為我們可以避免重複遍歷資料結構！

-- | =================================================================
-- | 1. Tupling: 回傳更多結果
-- | =================================================================

-- | **動機**：有時候單獨計算一個值很困難，但如果同時計算多個相關的值，
-- | 反而可以共享計算過程，提升效率。

-- | **經典範例：Steep List (陡峭列表)**

-- | 定義：一個 List 是 "steep" 當且僅當每個元素都大於其右邊所有元素的總和
-- | 例如：[5, 3, 1] 是 steep (5 > 3+1, 3 > 1)
-- | 例如：[4, 3, 1] 不是 steep (4 = 3+1，不符合 >)

-- | Naive 版本 (O(n²))：
steepNaive :: [Int] -> Bool
steepNaive []     = True
steepNaive (x:xs) = steepNaive xs && x > sum xs

-- | **問題分析**：
-- | - `steepNaive xs` 遍歷整個 xs
-- | - `sum xs` 又遍歷整個 xs
-- | - 每次遞迴都這樣做，所以是 O(n²)

-- | **關鍵洞察**：
-- | 如果我們在檢查 steep 的同時也計算 sum，就可以只遍歷一次！

-- | **Tupling 解法**：定義一個同時回傳兩個結果的函數

steepsum :: [Int] -> (Bool, Int)
steepsum []     = (True, 0)
steepsum (x:xs) = (b && x > y, x + y)
    where (b, y) = steepsum xs

-- | 推導過程：
-- | steepsum (x:xs)
-- | = { 目標：同時計算 (steep (x:xs), sum (x:xs)) }
-- |   (steep (x:xs), sum (x:xs))
-- | = { steep 和 sum 的定義 }
-- |   (steep xs && x > sum xs, x + sum xs)
-- | = { 提取共同的子運算式 }
-- |   let (b, y) = (steep xs, sum xs)
-- |   in (b && x > y, x + y)
-- | = { steepsum 的定義 }
-- |   let (b, y) = steepsum xs
-- |   in (b && x > y, x + y)

-- | 最終的高效實作：
steep :: [Int] -> Bool
steep = fst . steepsum

-- | 時間複雜度：O(n)，只遍歷一次！

-- | **Rust 視角**：
-- | 這就像是用 `.fold()` 同時累積多個狀態：
-- | ```rust
-- | let (is_steep, sum) = xs.iter().rev().fold((true, 0), |(steep, sum), &x| {
-- |     (steep && x > sum, x + sum)
-- | });
-- | ```

-- | =================================================================
-- | 2. Accumulating Parameters: 傳入累積參數
-- | =================================================================

-- | **動機**：某些遞迴函數效率低下，是因為它們不是「尾遞迴」。
-- | 透過引入累積參數，我們可以將一般遞迴轉換成尾遞迴。

-- | **經典範例 1：Reverse (反轉列表)**

-- | Naive 版本 (O(n²))：
reverseNaive :: [a] -> [a]
reverseNaive []     = []
reverseNaive (x:xs) = reverseNaive xs ++ [x]

-- | **問題**：`(++)` 是 O(n)，總共呼叫 n 次，所以是 O(n²)

-- | **解法：引入累積參數**

-- | 定義一個輔助函數，帶有一個「累積器」參數：
revcat :: [a] -> [a] -> [a]
revcat xs ys = reverse xs ++ ys

-- | 推導 (空 List)：
-- | revcat [] ys
-- | = reverse [] ++ ys
-- | = [] ++ ys
-- | = ys

-- | 推導 (x:xs)：
-- | revcat (x:xs) ys
-- | = reverse (x:xs) ++ ys
-- | = (reverse xs ++ [x]) ++ ys
-- | = reverse xs ++ ([x] ++ ys)    -- (++) 的結合律
-- | = reverse xs ++ (x : ys)
-- | = revcat xs (x:ys)

-- | 推導出的實作：
revcatImpl :: [a] -> [a] -> [a]
revcatImpl []     ys = ys
revcatImpl (x:xs) ys = revcatImpl xs (x:ys)

-- | 最終的 reverse：
reverseOptimized :: [a] -> [a]
reverseOptimized xs = revcatImpl xs []

-- | 執行過程：
-- | reverse [1,2,3,4]
-- | = revcat [1,2,3,4] []
-- | = revcat [2,3,4] [1]
-- | = revcat [3,4] [2,1]
-- | = revcat [4] [3,2,1]
-- | = revcat [] [4,3,2,1]
-- | = [4,3,2,1]

-- | **關鍵特性：尾遞迴 (Tail Recursion)**
-- | 遞迴呼叫是函數的「最後一個操作」，不需要保存返回地址的堆疊。

-- | **Rust 視角**：
-- | 尾遞迴在 Rust 中可以被編譯器優化成迴圈：
-- | ```rust
-- | let mut acc = vec![];
-- | let mut xs = original_list;
-- | while let Some((head, tail)) = xs.split_first() {
-- |     acc.insert(0, head);
-- |     xs = tail;
-- | }
-- | ```

-- | =================================================================
-- | 3. 經典範例 2：Sum of Squares (尾遞迴版本)
-- | =================================================================

-- | 之前的版本：
sumSquares :: [Int] -> Int
sumSquares []     = 0
sumSquares (x:xs) = x*x + sumSquares xs

-- | 這個版本雖然是 O(n)，但它不是尾遞迴，需要 O(n) 的堆疊空間。

-- | **引入累積參數**：
-- | 定義 `ssp xs n = sumSquares xs + n`

-- | 推導 (空 List)：
-- | ssp [] n
-- | = sumSquares [] + n
-- | = 0 + n
-- | = n

-- | 推導 (x:xs)：
-- | ssp (x:xs) n
-- | = sumSquares (x:xs) + n
-- | = (x*x + sumSquares xs) + n
-- | = sumSquares xs + (x*x + n)
-- | = ssp xs (x*x + n)

-- | 尾遞迴實作：
ssp :: [Int] -> Int -> Int
ssp []     n = n
ssp (x:xs) n = ssp xs (x*x + n)

sumSquaresTail :: [Int] -> Int
sumSquaresTail xs = ssp xs 0

-- | 執行過程：
-- | sumSquaresTail [1,2,3]
-- | = ssp [1,2,3] 0
-- | = ssp [2,3] 1
-- | = ssp [3] 5
-- | = ssp [] 14
-- | = 14

-- | =================================================================
-- | 4. 為什麼更一般化的函數反而更容易實作？
-- | =================================================================

-- | **矛盾的現象**：
-- | - `reverse` 很難高效實作 (O(n²))
-- | - 但 `revcat` (更一般化的版本) 卻可以高效實作 (O(n))

-- | **原因**：
-- | 1. 額外的參數提供了「更多資訊」，讓遞迴更強大
-- | 2. 我們可以利用資料結構的性質 (如 List 的結合律)
-- | 3. 更強的歸納假設讓證明/推導更容易

-- | **類比**：數學中的「強化命題」(Strengthening)
-- | 有時候證明一個更強的定理反而比證明原始定理容易，因為歸納假設變強了。

-- | =================================================================
-- | 5. Proof by Strengthening (透過強化來證明)
-- | =================================================================

-- | **範例：證明 sum . reverse = sum**

-- | 使用 reverseNaive 的定義很容易證明，但使用 reverseOptimized 就需要技巧。

-- | **錯誤的嘗試**：
-- | sum (reverse (x:xs))
-- | = sum (revcat (x:xs) [])
-- | = sum (revcat xs [x])
-- | = ???  -- 卡住了，因為累積器不是 []

-- | **解法：證明一個更強的引理**

-- | 引理：sum (revcat xs ys) = sum xs + sum ys

-- | 證明 (空 List)：
-- | sum (revcat [] ys)
-- | = sum ys
-- | = 0 + sum ys
-- | = sum [] + sum ys

-- | 證明 (x:xs)：
-- | sum (revcat (x:xs) ys)
-- | = sum (revcat xs (x:ys))
-- | = sum xs + sum (x:ys)         -- 歸納假設
-- | = sum xs + (x + sum ys)
-- | = (x + sum xs) + sum ys
-- | = sum (x:xs) + sum ys

-- | 令 ys = []，得到：
-- | sum (revcat xs []) = sum xs + sum []
-- | sum (reverse xs) = sum xs

-- | **關鍵洞察**：
-- | 原始命題太弱，無法進行歸納。
-- | 強化命題後，歸納假設變強，證明變得可行。

-- | =================================================================
-- | 6. 綜合範例：Maximum Prefix Sum (最大前綴和)
-- | =================================================================

-- | 問題：找出所有前綴中，元素和最大的那個

-- | Specification：
maxPrefixSumSpec :: [Int] -> Int
maxPrefixSumSpec xs = maximum (map sum (inits xs))

-- | 輔助函數：inits 產生所有前綴
inits :: [a] -> [[a]]
inits []     = [[]]
inits (x:xs) = [] : map (x:) (inits xs)

-- | 例如：inits [1,2,3] = [[],[1],[1,2],[1,2,3]]

-- | **問題分析**：
-- | - inits 是 O(n)
-- | - map sum 對每個前綴計算總和，最長的前綴是 O(n)
-- | - maximum 是 O(n)
-- | 總複雜度：O(n²)

-- | **優化策略：Tupling + Accumulating**

-- | 定義：同時追蹤「當前和」與「最大和」
mpsHelper :: [Int] -> Int -> Int -> Int
mpsHelper []     currentSum maxSum = maxSum
mpsHelper (x:xs) currentSum maxSum =
    mpsHelper xs newSum (max newSum maxSum)
    where newSum = currentSum + x

maxPrefixSum :: [Int] -> Int
maxPrefixSum xs = mpsHelper xs 0 0

-- | 執行過程：
-- | maxPrefixSum [1, -2, 3, -1]
-- | = mpsHelper [1,-2,3,-1] 0 0
-- | = mpsHelper [-2,3,-1] 1 1
-- | = mpsHelper [3,-1] (-1) 1
-- | = mpsHelper [-1] 2 2
-- | = mpsHelper [] 1 2
-- | = 2

-- | 時間複雜度：O(n)，只遍歷一次！

-- | =================================================================
-- | 7. 實戰技巧：如何選擇累積參數？
-- | =================================================================

-- | **步驟 1：分析原始函數的問題**
-- | - 是否有重複計算？
-- | - 是否需要多次遍歷？
-- | - 是否不是尾遞迴？

-- | **步驟 2：找出可以「累積」的資訊**
-- | - 部分結果 (如 reverse 中的部分反轉列表)
-- | - 中間狀態 (如 sum 中的當前總和)
-- | - 多個相關值 (如 steep 中的 sum)

-- | **步驟 3：定義廣義化的函數**
-- | - 原函數 f :: A -> B
-- | - 廣義化 g :: A -> Acc -> B
-- | - 設定初始值，使得 f x = g x initial

-- | **步驟 4：推導新函數的定義**
-- | - 利用結合律、分配律等性質
-- | - 確保新函數是尾遞迴

-- | =================================================================
-- | 8. Tupling vs Accumulating Parameters
-- | =================================================================

-- | 技巧              | 何時使用？                    | 效果
-- | ----------------- | ----------------------------- | ------------------
-- | Tupling           | 需要同時計算多個相關值        | 避免重複遍歷
-- | Accumulating      | 函數不是尾遞迴，或效率低下    | 轉換成尾遞迴/迴圈
-- | 兩者結合          | 複雜的優化問題                | 最大化效率

-- | =================================================================
-- | 9. Rust 視角：這些技巧的對應
-- | =================================================================

-- | Haskell 技巧           | Rust 對應
-- | ---------------------- | ---------------------------------------
-- | Tupling                | fold() 維護多個累積器
-- | Accumulating Parameter | 尾遞迴 -> 迴圈優化
-- | 引用透明性             | 純函數 (沒有 &mut self)
-- | 數學推導               | 理解編譯器優化原理

-- | **範例：Rust 中的 Tupling**
-- | ```rust
-- | let (is_steep, sum) = xs.iter()
-- |     .rev()
-- |     .fold((true, 0), |(steep, sum), &x| {
-- |         (steep && x > sum, x + sum)
-- |     });
-- | ```

-- | **範例：Rust 中的 Accumulating**
-- | ```rust
-- | fn reverse<T>(xs: Vec<T>) -> Vec<T> {
-- |     let mut acc = Vec::new();
-- |     for x in xs.into_iter() {
-- |         acc.insert(0, x);  // 或用 VecDeque
-- |     }
-- |     acc
-- | }
-- | ```

-- | =================================================================
-- | 10. 總結：進階推導的核心價值
-- | =================================================================

-- | **本章學到的關鍵技巧**：
-- | 1. Tupling: 一次遍歷計算多個結果
-- | 2. Accumulating Parameters: 將遞迴轉為尾遞迴
-- | 3. Proof by Strengthening: 透過強化命題簡化證明
-- | 4. 利用代數性質 (結合律、分配律) 進行推導

-- | **實務價值**：
-- | - 從 O(n²) 優化到 O(n)
-- | - 從需要堆疊空間到常數空間
-- | - 保證正確性的同時提升效能

-- | **下一步**：
-- | 第七章會介紹 Folds，將這些技巧抽象化成可重用的模式
