-- | Additional Exercises Review (補充練習題解析)
-- | 這些題目來自 additional_sols.pdf，難度較高，
-- | 涵蓋了 Fold Fusion, Tupling, 和 Accumulating Parameters 的進階應用。

module Additional_Exercises_Review where

import Prelude hiding (and, or, length, sublists)

-- | =================================================================
-- | 1. Logic & Fold Fusion (De Morgan's Laws)
-- | =================================================================

-- | 目標：證明 `or . map not = not . and`

-- | 定義 (為了完整性)
and :: [Bool] -> Bool
and = foldr (&&) True

or :: [Bool] -> Bool
or = foldr (||) False

-- | (a) Inductive Proof (歸納法證明)
-- | 證明 `or (map not xs) = not (and xs)`
-- |
-- | Case []:
-- | or (map not []) = or [] = False
-- | not (and []) = not True = False
-- |
-- | Case (x:xs):
-- | or (map not (x:xs))
-- | = or (not x : map not xs)
-- | = not x || or (map not xs)
-- | = not x || not (and xs)      -- 歸納假設
-- | = not (x && and xs)          -- De Morgan Law: !a || !b = !(a && b)
-- | = not (and (x:xs))

-- | (b) Fold Fusion Proof (融合證明)
-- | 左式：or . map not
-- | = foldr (||) False . foldr (\x xs -> not x : xs) []
-- | = foldr (\x acc -> not x || acc) False  -- Fusion
-- |
-- | 右式：not . and
-- | = not . foldr (&&) True
-- | = foldr (\x acc -> not (x && not acc) ???) ... -- 這邊比較難直接 fuse not
-- |
-- | 更好的方法是證明：
-- | foldr (\x acc -> not x || acc) False = not . foldr (&&) True
-- |
-- | 應用 Fusion 定理： h . foldr f e = foldr g (h e)
-- | h = not
-- | f = (&&)
-- | e = True
-- | g x y = not x || y
-- |
-- | 檢查條件：h (f x y) = g x (h y)
-- | not (x && y) = not x || not y
-- | 這正是 De Morgan 定律！得證。

-- | =================================================================
-- | 2. Sublists & Length (子集合數量)
-- | =================================================================

-- | 定義 sublists: 產生所有子列表
sublists :: [a] -> [[a]]
sublists []     = [[]]
sublists (x:xs) = yss ++ map (x:) yss
    where yss = sublists xs

-- | 目標：證明 length . sublists = exp 2 . length
-- | 即：長度為 n 的列表有 2^n 個子列表

-- | Step 1: Fuse `length . sublists`
-- | sublists = foldr (\x yss -> yss ++ map (x:) yss) [[]]
-- |
-- | 應用 Fusion:
-- | h = length
-- | f x yss = yss ++ map (x:) yss
-- | e = [[]]
-- |
-- | 條件：length (yss ++ map (x:) yss)
-- | = length yss + length (map (x:) yss)
-- | = length yss + length yss
-- | = 2 * length yss
-- |
-- | 所以：length . sublists = foldr (\x n -> 2 * n) 1

-- | Step 2: Fuse `exp 2 . length`
-- | length = foldr (\x n -> 1 + n) 0
-- |
-- | 應用 Fusion:
-- | h = exp 2  (即 2^n)
-- | f x n = 1 + n
-- | e = 0
-- |
-- | 條件：2 ^ (1 + n)
-- | = 2 * 2^n
-- | = 2 * h n
-- |
-- | 所以：exp 2 . length = foldr (\x acc -> 2 * acc) 1

-- | 兩邊都等於 foldr (\x acc -> 2 * acc) 1，得證。

-- | =================================================================
-- | 3. Leftist Tree (左傾樹 - Tupling)
-- | =================================================================

data ITree a = Null | Node (ITree a) a (ITree a)

dist :: ITree a -> Int
dist Null = 0
dist (Node t _ u) = 1 + min (dist t) (dist u)

-- | 左傾樹定義：
-- | 1. 左子樹 dist >= 右子樹 dist
-- | 2. 左右子樹也都是左傾樹
leftist :: ITree a -> Bool
leftist Null = True
leftist (Node t _ u) = dist t >= dist u && leftist t && leftist u

-- | 問題：leftist 是 O(n^2)
-- | 解法：Tupling (leftist t, dist t)

leftdist :: ITree a -> (Bool, Int)
leftdist Null = (True, 0)
leftdist (Node t x u) =
    let (lb, ld) = leftdist t
        (rb, rd) = leftdist u
    in (ld >= rd && lb && rb, 1 + min ld rd)

fastLeftist :: ITree a -> Bool
fastLeftist = fst . leftdist

-- | 複雜度：O(n)

-- | =================================================================
-- | 4. Tree Depths (Accumulating Parameters)
-- | =================================================================

-- | 目標：計算樹中每個節點的深度

-- | 原始定義 (效率差，因為 map 和 ++)
depths :: ITree a -> [(a, Int)]
depths Null = []
depths (Node t x u) =
    map (\(v, d) -> (v, d+1)) (depths t) ++
    [(x, 0)] ++
    map (\(v, d) -> (v, d+1)) (depths u)

-- | 優化 1: 引入 Accumulating Parameter k (當前深度)
-- | depthsAcc t k 計算子樹 t 的深度列表，其中 t 的根深度為 k

depthsAcc :: ITree a -> Int -> [(a, Int)]
depthsAcc Null _ = []
depthsAcc (Node t x u) k =
    depthsAcc t (k+1) ++ [(x, k)] ++ depthsAcc u (k+1)

-- | 優化 2: 消除 (++) (List Construction)
-- | 引入 Accumulating Parameter ys (後續列表)
-- | depthS t k ys = depthsAcc t k ++ ys

depthS :: ITree a -> Int -> [(a, Int)] -> [(a, Int)]
depthS Null _ ys = ys
depthS (Node t x u) k ys =
    -- 原始順序: left ++ [root] ++ right ++ ys
    -- 轉換為: depthS left (k+1) ([root] ++ depthS right (k+1) ys)
    depthS t (k+1) ((x, k) : depthS u (k+1) ys)

-- | 最終 O(n) 實作
fastDepths :: ITree a -> [(a, Int)]
fastDepths t = depthS t 0 []

-- | =================================================================
-- | 5. Rust 視角總結
-- | =================================================================

-- | 1. De Morgan Proof:
-- |    這就像在證明 Iterator adapter 的等價性：
-- |    xs.iter().map(|x| !x).any(|x| x) == !xs.iter().all(|x| x)

-- | 2. Sublists Count:
-- |    證明算法複雜度的數學基礎。

-- | 3. Leftist Tree:
-- |    典型的 "一次遍歷收集多個資訊"。
-- |    Rust: tree.post_order().fold(...)

-- | 4. Tree Depths:
-- |    這是最精彩的部分。
-- |    depthS t k ys 其實就是帶著狀態 (深度 k) 和 延續 (ys) 的遞迴。
-- |    在 Rust 中，這對應到傳遞 `&mut Vec` 或使用 `extend` 來避免產生中間 Vec。
-- |
-- |    Rust 對應寫法 (Accumulating style):
-- |    fn collect_depths<T>(node: &ITree<T>, k: usize, acc: &mut Vec<(T, usize)>) {
-- |        if let Node(left, val, right) = node {
-- |            collect_depths(left, k + 1, acc);
-- |            acc.push((val.clone(), k));
-- |            collect_depths(right, k + 1, acc);
-- |        }
-- |    }
