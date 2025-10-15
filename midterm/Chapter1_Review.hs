-- | Chapter 1 Review: Foundations of Haskell
-- | 這個檔案整合了第一章的所有核心概念，可作為期中複習的學習筆記。
-- | 註解中會包含與 Rust 的對比，幫助您更好地理解。

-- | `module` 關鍵字定義了模組名稱，通常與檔名相同。
module Chapter1_Review where

-- | =================================================================
-- | 1. 基本函數定義 (Basic Functions)
-- | =================================================================

-- | 在 Haskell 中，函數定義包含兩個部分：
-- | 1. 型別宣告 (Type Signature)，非強制但強烈建議。`::` 讀作 "has type of"。
-- | 2. 函數實作 (Implementation)。

-- | `myeven` 是一個接收 Int 並回傳 Bool 的函數。
-- | 這與 Rust 的 `fn my_even(n: i32) -> bool` 概念相同。
myeven :: Int -> Bool
-- | 函數本體是一個運算式。Haskell 會自動回傳運算式的結果。
-- | 這類似於 Rust 中不加分號的最後一行運算式。
myeven n = mod n 2 == 0

-- | `Float` 是浮點數型別，對應 Rust 的 `f32` 或 `f64`。
circleArea :: Float -> Float
circleArea r = (22/7) * r * r

-- | =================================================================
-- | 2. 區域變數 (Local Definitions): `where` vs. `let`
-- | =================================================================

-- | 使用 `where` 來定義輔助變數。
-- | `where` 綁定的變數作用域是整個函數，通常放在函數定義的尾部，可讀性較高。
-- | 這在 Rust 中沒有直接對應，但可以想成是為了程式碼清晰而定義在函數尾部的輔助變數。
paymentWithWhere :: Int -> Int
paymentWithWhere weeks = salary
  where
    days = weeks * 5
    hours = days * 8
    salary = hours * 130

-- | 使用 `let...in...` 來定義區域變數。
-- | `let...in...` 本身就是一個運算式 (Expression)。`in` 後面的部分是整個運算式的值。
-- | 這非常類似於 Rust 的塊運算式： `let result = { let x = 5; x + 1 };`
paymentWithLet :: Int -> Int
paymentWithLet weeks =
  let
    days = weeks * 5
    hours = days * 8
    salary = hours * 130
  in
    salary

-- | =================================================================
-- | 3. 條件判斷：守衛 (Guards)
-- | =================================================================

-- | 守衛 `|` 提供了一種比 `if-then-else` 更優雅的多重條件判斷方式。
-- | `otherwise` 是一個永遠為 `True` 的值，功能完全等同於 Rust `match` 中的 `_`。
paymentWithGuards :: Int -> Int
paymentWithGuards weeks
  -- | 這個 `|` 就非常像 Rust `match` 中的守衛 `if`。
  -- | `match weeks { w if w > 19 => ..., _ => ... }`
  | weeks > 19 = round (fromIntegral baseSalary * 1.06)
  | otherwise  = baseSalary
  where
    baseSalary = weeks * 5 * 8 * 130
    -- `fromIntegral` 用於數字型別轉換，類似 Rust 的 `as` 關鍵字。
    -- `round` 則進行四捨五入。

-- | =================================================================
-- | 4. 柯里化 (Currying) 與 部分應用 (Partial Application)
-- | ** 這是與 Rust 的核心差異點 **
-- | =================================================================

-- | `smaller` 的型別 `Int -> Int -> Int` 應該這樣解讀：
-- | "一個接收 `Int`，並回傳一個 `(Int -> Int)` 型別的新函數"。
-- | Haskell 的所有函數天生都是柯里化的。
smaller :: Int -> Int -> Int
smaller x y = if x <= y then x else y

-- | 在 Rust 中，`fn smaller(x: i32, y: i32)` 必須一次接收所有參數。
-- | 但在 Haskell 中，我們可以只提供部分參數，這個過程稱為「部分應用」。

-- | **部分應用的範例：**
-- | 我們只給 `smaller` 第一個參數 `3`。
-- | `st3` 現在是一個**新函數**，它的型別是 `Int -> Int`。
-- | 它的功能是「接收一個整數，並回傳它與 3 之間的較小值」。
st3 :: Int -> Int
st3 = smaller 3

-- | 現在我們可以使用這個新函數。
-- | `st3 5` 會回傳 `3`，因為 `smaller 3 5` 的結果是 `3`。
-- | `st3 1` 會回傳 `1`，因為 `smaller 3 1` 的結果是 `1`。
exampleUsageOfSt3 :: Int
exampleUsageOfSt3 = st3 5

-- | =================================================================
-- | 5. 高階函數 (Higher-Order Functions)
-- | =================================================================

-- | 高階函數是指可以「接收函數作為參數」或「回傳一個函數」的函數。
-- | 這在 Rust 中也很常見，通常是透過 `Fn`, `FnMut`, `FnOnce` Trait 實現。

square :: Int -> Int
square x = x * x

-- | `twice` 是一個高階函數。它接收一個型別為 `(a -> a)` 的函數 `f` 作為參數。
-- | `a` 是一個泛型，類似 Rust 的 `<T>`。
twice :: (a -> a) -> a -> a
twice f x = f (f x)

-- | 使用 `twice` 來定義 `quad` (計算 x 的 4 次方)。
-- | `twice square` 的意思是將 `square` 函數自身作為參數傳給 `twice`。
quad_v1 :: Int -> Int
quad_v1 x = twice square x

-- | =================================================================
-- | 6. 函數組合 (Function Composition)
-- | =================================================================

-- | `(.)` 運算子是函數組合。`(g . f) x` 等同於 `g(f(x))`。
-- | 這是 Haskell 中一個極其常用且強大的工具，可以將小函數像樂高一樣組合起來。
-- | Rust 沒有內建這個運算子，需要手動寫 `g(f(x))`。

-- | 使用函數組合來重新定義 `twice`。
-- | `f . f` 創造了一個新的匿名函數，它會將 `f` 連續作用兩次。
twice_composed :: (a -> a) -> (a -> a)
twice_composed f = f . f

-- | **Point-Free 風格：**
-- | 當我們使用函數組合時，常常可以省略掉最後的參數 `x`，讓定義更簡潔。
-- | 下面兩個 `quad` 的定義是完全等價的。
quad_v2 :: Int -> Int
quad_v2 = twice_composed square

-- | =================================================================
-- | 7. 綜合應用
-- | =================================================================

-- | `lift2` 是一個更高階的函數，它將一個二元函數 `h` "提升"，
-- | 使其可以作用於兩個一元函數 `f` 和 `g` 的結果上。
lift2 :: (b -> c -> d) -> (a -> b) -> (a -> c) -> a -> d
lift2 h f g x = h (f x) (g x)

-- | **問題：** 計算 `(x+1) * (x+2)`
-- | **思路：**
-- | 1. 我們需要一個乘法函數 `(*)`，這是我們的 `h`。
-- | 2. 我們需要一個 `+1` 的函數，這是我們的 `f`。
-- | 3. 我們需要一個 `+2` 的函數，這是我們的 `g`。
-- | `(+1)` 和 `(*)` 這種寫法稱為「運算子區段 (Operator Section)」，是部分應用的語法糖。

polyCompute :: Int -> Int
-- | `lift2 (*) (+1) (+2)` 透過組合創造了一個新函數，
-- | 這個新函數接收 `x`，然後計算 `(*) ((+1) x) ((+2) x)`。
polyCompute = lift2 (*) (+1) (+2)

-- | 執行 `polyCompute 10` 會得到 `(10+1) * (10+2) = 11 * 12 = 132`。
