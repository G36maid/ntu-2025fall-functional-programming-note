# Functional Programming Final Exam Cheat Sheet (戰術手冊)

這是一份為考試設計的「戰術手冊」。當你遇到特定題型時，直接查找對應章節，複製模板並替換變數。

---

## 目錄

1.  [⚡ 核心定理與證明模板 (Fusion & Proofs)](#1-核心定理與證明模板-fusion--proofs)
2.  [🛠 萬用函數定義庫 (Definitions)](#2-萬用函數定義庫-definitions)
3.  [🚀 優化模式 (Optimization Patterns)](#3-優化模式-optimization-patterns)
4.  [🌊 無限串流 (Streams & Codata)](#4-無限串流-streams--codata)
5.  [🏆 經典難題速查 (Classic Solutions)](#5-經典難題速查-classic-solutions)
6.  [📝 語法緊急救援 (Syntax Rescue)](#6-語法緊急救援-syntax-rescue)

---

## 1. 核心定理與證明模板 (Fusion & Proofs)

### 1.1 List Fold-Fusion 定理

**題目**：證明 `h . foldr f e = foldr g (h e)` 或找出 `g`。

**公式**：
$$ h (f\ x\ y) = g\ x\ (h\ y) $$

**證明模板** (直接抄寫，替換 `h`, `f`, `e`, `g`)：

> We prove by induction on list `xs`.
>
> **Base Case (`[]`):**
> ```haskell
> LHS = h (foldr f e [])
>     = h e
> RHS = foldr g (h e) []
>     = h e
> -- LHS = RHS holds.
> ```
>
> **Inductive Case (`x:xs`):**
> ```haskell
> LHS = h (foldr f e (x:xs))
>     = h (f x (foldr f e xs))      -- def of foldr
>     = g x (h (foldr f e xs))      -- by Fusion Condition: h (f x y) = g x (h y)
>     = g x (foldr g (h e) xs)      -- by Induction Hypothesis
>
> RHS = foldr g (h e) (x:xs)
>     = g x (foldr g (h e) xs)      -- def of foldr
> -- LHS = RHS holds.
> ```

---

### 1.2 Map-Fusion 定理

**題目**：證明 `map f . map g = map (f . g)`。

**證明模板**：

> Since `map g = foldr (\x xs -> g x : xs) []`, we can use Fold-Fusion.
> Let `h = map f`, `foldr_src = map g`.
>
> Fusion Condition:
> ```haskell
> h (step_src x y) = step_tgt x (h y)
> map f (g x : y) = (f . g) x : map f y
> f (g x) : map f y = f (g x) : map f y
> -- Holds by definition.
> ```

---

### 1.3 Tree Fold-Fusion 定理

**公式**：
對於 `ITree`: `h (f x l r) = g x (h l) (h r)`

**證明模板**：

> **Base Case (`Null`):**
> `h (foldIT f e Null) = h e = foldIT g (h e) Null`. Holds.
>
> **Inductive Case (`Node t x u`):**
> ```haskell
> LHS = h (foldIT f e (Node t x u))
>     = h (f x (foldIT f e t) (foldIT f e u))   -- def of foldIT
>     = g x (h (foldIT f e t)) (h (foldIT f e u)) -- by Fusion Condition
>     = g x (foldIT g (h e) t) (foldIT g (h e) u) -- by Induction Hypothesis
>     = RHS                                       -- def of foldIT
> ```

---

### 1.4 Stream 唯一不動點證明 (Unique Fixed Point)

**題目**：證明兩個 Stream `xs` 和 `ys` 相等。

**策略**：證明它們滿足同一個 **Admissible Equation** (`X = h : t(X)`).

**證明模板**：

> We prove `LHS` and `RHS` satisfy the same admissible equation: `X = head_val : tail_expr(X)`.
>
> **LHS Expansion:**
> ```haskell
> LHS = ...
>     = head_val : ... LHS ...
> ```
>
> **RHS Expansion:**
> ```haskell
> RHS = ...
>     = head_val : ... RHS ...
> ```
>
> Since both satisfy `X = ... : ...`, by the Unique Fixed Point Principle, `LHS = RHS`.

---

## 2. 萬用函數定義庫 (Definitions)

### List Folds (`foldr`)

若題目要求「用 foldr 表達 xxx」，直接查表：

| 函數 | 定義 | 備註 |
| :--- | :--- | :--- |
| `sum` | `foldr (+) 0` | |
| `product` | `foldr (*) 1` | |
| `and` | `foldr (&&) True` | |
| `or` | `foldr (||) False` | |
| `length` | `foldr (\_ n -> 1 + n) 0` | 不看元素值 |
| `map f` | `foldr (\x xs -> f x : xs) []` | |
| `filter p` | `foldr (\x xs -> if p x then x:xs else xs) []` | |
| `xs ++ ys` | `foldr (:) ys xs` | 把 xs 的 [] 換成 ys |
| `concat` | `foldr (++) []` | |
| `reverse` | `foldr (\x xs -> xs ++ [x]) []` | 效率差，僅供理論參考 |
| `inits` | `foldr (\x xss -> [] : map (x:) xss) [[]]` | 所有前綴 |
| `tails` | `foldr (\x xss -> (x : head xss) : xss) [[]]` | 所有後綴 |

### Stream 定義

| 串流 | 定義 | 備註 |
| :--- | :--- | :--- |
| `ones` | `1 : ones` | 無限 1 |
| `nats` | `0 : map (1+) nats` | 自然數 [0,1,2...] |
| `fibs` | `0 : 1 : zipWith (+) fibs (tail fibs)` | 費氏數列 |
| `iterate f x` | `x : iterate f (f x)` | 重複應用 |
| `repeat x` | `x : repeat x` | 重複元素 |
| `map f xs` | `f (head xs) : map f (tail xs)` | |
| `zipWith f` | `f (head xs) (head ys) : zipWith f (tail xs) (tail ys)` | |

---

## 3. 優化模式 (Optimization Patterns)

### 3.1 Tupling (元組化)

**適用情境**：需要遍歷 List 多次以計算多個值 (如 `sum` 和 `length`，或 `steep` 和 `sum`)。

**模板**：

```haskell
-- 原始：需要多次遍歷
func xs = (task1 xs, task2 xs)

-- 優化後：單次遍歷
func = tupleFunc
  where
    tupleFunc []     = (base1, base2)
    tupleFunc (x:xs) =
        let (r1, r2) = tupleFunc xs
        in (step1 x r1, step2 x r2)
```

**範例 (Steep List)**:
```haskell
steep xs = fst (steepsum xs)
  where
    steepsum [] = (True, 0)
    steepsum (x:xs) =
        let (b, s) = steepsum xs
        in (b && x > s, x + s)
```

### 3.2 Accumulating Parameters (累積參數)

**適用情境**：消除 `++` (Append) 或將遞迴轉為尾遞迴 (Tail Recursion)。

**模板**：

```haskell
-- 原始
func []     = base
func (x:xs) = func xs `op` x  -- 這裡 op 可能是 ++ 或其他運算

-- 優化後 (定義 accFunc xs acc = func xs `op` acc)
func xs = accFunc xs base_acc
  where
    accFunc []     acc = acc
    accFunc (x:xs) acc = accFunc xs (new_acc)
```

**範例 (Reverse)**:
```haskell
reverse xs = revcat xs []
  where
    revcat []     ys = ys
    revcat (x:xs) ys = revcat xs (x:ys)
```

---

## 4. 無限串流 (Streams & Codata)

### 交錯運算子 (`\/`)
`head (xs \/ ys) = head xs`
`tail (xs \/ ys) = ys \/ tail xs` (注意 ys 換到前面)

**性質**：
- `(x:xs) \/ ys = x : (ys \/ xs)`
- `map f (xs \/ ys) = map f xs \/ map f ys` (Distributivity)

### 證明 Admissible Equation
若要證明 `X` 是合法的定義，檢查：
1. `head X` 是否能直接計算 (不依賴 X)。
2. `tail X` 是否只依賴 `X` 而不依賴 `tail X` 或 `head X`。
   - ✅ `X = 1 : X` (Admissible)
   - ❌ `X = head X : tail X` (Not Admissible - 恆等式)
   - ❌ `X = tail X` (Not Admissible)

### 經典 Stream 構造
- **Binary Construction (所有自然數)**:
  `bin = 0 : (2 * bin + 1) \/ (2 * bin + 2)`
- **Hamming Numbers (2,3,5 因數)**:
  `hamming = 1 : map (2*) hamming \`merge\` map (3*) hamming \`merge\` map (5*) hamming`

---

## 5. 經典難題速查 (Classic Solutions)

### 5.1 Maximum Segment Sum (MSS)
**問題**：最大子區段和。
**O(n) 解法**：
```haskell
mss :: [Int] -> Int
mss = maximum . scanr (\x y -> 0 `max` (x + y)) 0
```
**原理**：`0 `max` (x + y)` 計算的是「以 x 為開頭的最大前綴和」。

### 5.2 Horner's Rule (霍納法則)
**問題**：計算多項式 $x_0 + x_1 y + x_2 y^2 ...$
**O(n) 解法**：
```haskell
horner y = foldr (\a b -> a + y * b) 0
```
**原理**：$x_0 + y(x_1 + y(x_2 + ...))$

### 5.3 Fast Exponentiation (快速冪)
**問題**：計算 $m^n$。
**O(log n) 解法** (配合 binary representation `bs`):
```haskell
-- bs 是 n 的二進位反向列表 (Least Significant Bit First)
roll m = foldr (\b res -> if b then m * (res^2) else res^2) 1
```

### 5.4 Fibonacci (O(n) / O(log n))
**O(n) Linear**:
```haskell
fib n = fst (foldN (\(a,b) -> (b, a+b)) (0,1) n)
```
**O(log n) Matrix/Tuple**:
利用 $F_{2n} = F_n(2F_{n+1} - F_n)$ 等公式配合 Tupling。

---

## 6. 語法緊急救援 (Syntax Rescue)

### Type Class 定義
```haskell
class Eq a where
    (==), (/=) :: a -> a -> Bool
    x /= y = not (x == y)  -- 預設實作

instance Eq MyType where
    A == A = True
    B == B = True
    _ == _ = False
```

### List 生成
- `[1..10]` -> 1 到 10
- `[1,3..10]` -> 1, 3, 5, 7, 9
- `[x*2 | x <- xs, x > 3]` -> List Comprehension

### 常用 List 函數型別
- `map :: (a -> b) -> [a] -> [b]`
- `filter :: (a -> Bool) -> [a] -> [a]`
- `foldr :: (a -> b -> b) -> b -> [a] -> b`
- `zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]`
- `take :: Int -> [a] -> [a]`
- `drop :: Int -> [a] -> [a]`
