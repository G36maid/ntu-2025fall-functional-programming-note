-- | Chapter 4 Review: Type Classes (型別類別)
-- | 這個檔案整合了第四章的核心概念：Type Classes 與多型。
-- | 註解中會包含與 Rust Traits 的對比，幫助您更好地理解。

module Chapter4_TypeClasses_Review where

-- | =================================================================
-- | 1. 參數多型 (Parametric Polymorphism)
-- | =================================================================

-- | 在 Haskell 中，小寫字母代表型別變數 (Type Variable)，類似 Rust 的泛型 <T>。
-- | 這種多型稱為「參數多型」，因為型別像參數一樣被傳遞。

-- | `id` 函數對所有型別運作方式都一樣，不檢查內容。
-- | Haskell: `id :: a -> a`
-- | Rust:    `fn id<T>(x: T) -> T { x }`
id' :: a -> a
id' x = x

-- | `take` 只關心列表的「結構」，不關心元素的「內容」。
-- | 型別 `Int -> [a] -> [a]` 表示：接收一個 Int 和一個「任意型別 a 的列表」，
-- | 回傳「同樣型別 a 的列表」。
take' :: Int -> [a] -> [a]
take' 0 _      = []
take' _ []     = []
take' n (x:xs) = x : take' (n-1) xs

-- | `filter` 需要一個 `a -> Bool` 的謂詞函數，但不需要知道 `a` 的具體型別。
-- | Haskell: `filter :: (a -> Bool) -> [a] -> [a]`
-- | Rust:    `fn filter<T, F>(f: F, xs: Vec<T>) -> Vec<T> where F: Fn(&T) -> bool`
filter' :: (a -> Bool) -> [a] -> [a]
filter' _ []     = []
filter' p (x:xs)
    | p x       = x : filter' p xs
    | otherwise = filter' p xs

-- | =================================================================
-- | 2. Ad-hoc 多型與 Type Classes
-- | =================================================================

-- | 有些操作「不是對所有型別都適用」。
-- | 例如：`(==)` 運算子。我們可以比較 Int，可以比較 Char，
-- | 但不能比較「函數」(因為函數相等性在一般情況下是不可判定的)。

-- | 問題：如何讓 `elem` 既能處理 [Int]，又能處理 [Char]，但不能處理 [Int -> Int]？
-- | 答案：Type Classes (型別類別)

-- | =================================================================
-- | 3. Eq 類別 (The Eq Class)
-- | =================================================================

-- | Type Class 的宣告定義了一組「必須實作的方法」。
-- | 這與 Rust 的 Trait 定義完全一致。

-- | Haskell:
-- | class Eq a where
-- |   (==) :: a -> a -> Bool
-- |   (/=) :: a -> a -> Bool
-- |   -- 可以提供預設實作
-- |   x /= y = not (x == y)

-- | Rust 等價：
-- | trait Eq {
-- |     fn eq(&self, other: &Self) -> bool;
-- |     fn ne(&self, other: &Self) -> bool {
-- |         !self.eq(other)
-- |     }
-- | }

-- | 現在 `elem` 的型別帶有「約束 (Constraint)」：
-- | `elem :: Eq a => a -> [a] -> Bool`
-- | 讀作：「對於任何屬於 Eq 類別的型別 a，elem 接收一個 a 和一個 [a]，回傳 Bool」
-- | Rust: `fn elem<T: Eq>(x: T, xs: Vec<T>) -> bool`

elem' :: Eq a => a -> [a] -> Bool
elem' _ []     = False
elem' x (y:ys)
    | x == y    = True
    | otherwise = elem' x ys

-- | =================================================================
-- | 4. Instance 宣告 (Instance Declaration)
-- | =================================================================

-- | 要讓一個型別「屬於」某個 Type Class，需要為它實作該 Class 的方法。
-- | 這稱為 Instance Declaration。

-- | 範例：自定義型別 Color
data Color = Red | Green | Blue deriving (Show)

-- | 手動實作 Eq Instance
-- | Haskell:
instance Eq Color where
    Red   == Red   = True
    Green == Green = True
    Blue  == Blue  = True
    _     == _     = False

-- | Rust 等價：
-- | impl Eq for Color {
-- |     fn eq(&self, other: &Self) -> bool {
-- |         match (self, other) {
-- |             (Color::Red, Color::Red) => true,
-- |             (Color::Green, Color::Green) => true,
-- |             (Color::Blue, Color::Blue) => true,
-- |             _ => false,
-- |         }
-- |     }
-- | }

-- | 測試我們的 Eq Instance
testColorEq :: Bool
testColorEq = Red == Red && Red /= Blue

-- | =================================================================
-- | 5. 衍生實例 (Derived Instances)
-- | =================================================================

-- | 對於常見的 Type Classes (Eq, Ord, Show, Read)，
-- | Haskell 編譯器可以自動生成 Instance，使用 `deriving` 關鍵字。

data Shape = Circle Float | Rectangle Float Float
    deriving (Eq, Show, Ord)

-- | Rust 的等價寫法：
-- | #[derive(Eq, PartialEq, Debug, Ord, PartialOrd)]
-- | enum Shape {
-- |     Circle(f32),
-- |     Rectangle(f32, f32),
-- | }

testShapeEq :: Bool
testShapeEq = Circle 5.0 == Circle 5.0

testShapeShow :: String
testShapeShow = show (Rectangle 3.0 4.0)

-- | =================================================================
-- | 6. 實例繼承 (Instance Inheritance)
-- | =================================================================

-- | 如果型別 `a` 的元素可以比較相等，那麼 `[a]` (列表) 也可以比較相等。
-- | 這需要「條件式 Instance」。

-- | 標準 Prelude 中的定義：
-- | instance Eq a => Eq [a] where
-- |   []     == []     = True
-- |   []     == (_:_)  = False
-- |   (_:_)  == []     = False
-- |   (x:xs) == (y:ys) = x == y && xs == ys

-- | 範例：自定義 Pair 型別
data Pair a b = Pair a b deriving (Show)

-- | 只有當 a 和 b 都屬於 Eq，Pair a b 才能比較相等
instance (Eq a, Eq b) => Eq (Pair a b) where
    Pair x1 y1 == Pair x2 y2 = (x1 == x2) && (y1 == y2)

-- | Rust 等價：
-- | impl<A: Eq, B: Eq> Eq for Pair<A, B> {}
-- | impl<A: PartialEq, B: PartialEq> PartialEq for Pair<A, B> {
-- |     fn eq(&self, other: &Self) -> bool {
-- |         self.0 == other.0 && self.1 == other.1
-- |     }
-- | }

testPairEq :: Bool
testPairEq = Pair 1 'a' == Pair 1 'a'

-- | =================================================================
-- | 7. 類別階層 (Class Hierarchy)
-- | =================================================================

-- | Type Classes 可以有「繼承關係」。
-- | `Ord` (可排序) 繼承自 `Eq` (可比較相等)。

-- | Haskell:
-- | class Eq a => Ord a where
-- |   (<)  :: a -> a -> Bool
-- |   (<=) :: a -> a -> Bool
-- |   (>)  :: a -> a -> Bool
-- |   (>=) :: a -> a -> Bool
-- |   compare :: a -> a -> Ordering

-- | Rust 等價：
-- | trait Ord: Eq { ... }

-- | 這表示：要成為 Ord 的成員，必須先是 Eq 的成員。
-- | 因為「排序」本質上需要「比較相等」。

-- | 範例：定義一個帶有優先級的任務
data Priority = Low | Medium | High deriving (Show, Eq)

-- | 手動實作 Ord Instance
instance Ord Priority where
    Low    <= _      = True
    Medium <= Low    = False
    Medium <= _      = True
    High   <= High   = True
    High   <= _      = False

testPriorityOrd :: Bool
testPriorityOrd = High > Medium && Medium > Low

-- | =================================================================
-- | 8. 常見的 Type Classes
-- | =================================================================

-- | (A) Show: 可以轉換為字串 (類似 Rust 的 Display 或 Debug)
-- | class Show a where
-- |   show :: a -> String

data Point = Point Int Int

instance Show Point where
    show (Point x y) = "Point(" ++ show x ++ ", " ++ show y ++ ")"

testShow :: String
testShow = show (Point 3 4)  -- "Point(3, 4)"

-- | (B) Read: 可以從字串解析 (Rust 的 FromStr)
-- | class Read a where
-- |   read :: String -> a

-- | 使用 deriving Read 需要指定型別
data Status = Active | Inactive deriving (Show, Read)

testRead :: Status
testRead = read "Active" :: Status

-- | (C) Num: 數值型別
-- | class Num a where
-- |   (+), (-), (*) :: a -> a -> a
-- |   negate :: a -> a
-- |   abs :: a -> a
-- |   signum :: a -> a
-- |   fromInteger :: Integer -> a

-- | 範例：定義一個模擬「模運算」的型別
newtype Mod5 = Mod5 Int deriving (Show, Eq)

instance Num Mod5 where
    Mod5 x + Mod5 y = Mod5 ((x + y) `mod` 5)
    Mod5 x * Mod5 y = Mod5 ((x * y) `mod` 5)
    Mod5 x - Mod5 y = Mod5 ((x - y) `mod` 5)
    negate (Mod5 x) = Mod5 ((-x) `mod` 5)
    abs x = x
    signum _ = Mod5 1
    fromInteger n = Mod5 (fromInteger n `mod` 5)

testMod5 :: Mod5
testMod5 = Mod5 3 + Mod5 4  -- Mod5 2 (因為 7 mod 5 = 2)

-- | =================================================================
-- | 9. 重要觀念整理
-- | =================================================================

-- | **參數多型 (Parametric Polymorphism)**:
-- | - 同一段程式碼對所有型別運作方式相同
-- | - 型別變數如 `a`, `b` 可以是任意型別
-- | - 範例: `id`, `length`, `map`

-- | **Ad-hoc 多型 (Ad-hoc Polymorphism)**:
-- | - 同一個名稱，不同型別有不同實作
-- | - 透過 Type Classes 實現
-- | - 範例: `(==)`, `show`, `(+)`

-- | **Type Classes vs Rust Traits**:
-- | Haskell                  | Rust
-- | ------------------------ | ---------------------------
-- | class Eq a where         | trait Eq
-- | instance Eq Int where    | impl Eq for i32
-- | Eq a =>                  | where T: Eq
-- | class Eq a => Ord a      | trait Ord: Eq

-- | **關鍵差異**:
-- | - Haskell 的 Type Class 可以在「任何地方」為任何型別實作 Instance (Orphan Instances)
-- | - Rust 要求至少 Trait 或 Type 其中一個在當前 crate 中 (Coherence Rule)

-- | =================================================================
-- | 10. 實戰範例：實作自己的 Functor (預告後續章節)
-- | =================================================================

-- | Functor 是一個極其重要的 Type Class，定義了「可以被 map 的東西」。
-- | Rust 沒有直接對應，但概念類似於實作 Iterator。

-- | class Functor f where
-- |   fmap :: (a -> b) -> f a -> f b

-- | 範例：為 Maybe 實作 Functor
data Maybe' a = Nothing' | Just' a deriving (Show, Eq)

-- | 注意：f 是一個「型別建構子」，不是一個具體型別
-- | Maybe' 接收一個型別參數，產生一個具體型別
-- | Maybe' Int, Maybe' Char 都是具體型別
class Functor' f where
    fmap' :: (a -> b) -> f a -> f b

instance Functor' Maybe' where
    fmap' _ Nothing'  = Nothing'
    fmap' g (Just' x) = Just' (g x)

testFunctor :: Maybe' Int
testFunctor = fmap' (*2) (Just' 21)  -- Just' 42

-- | 這讓我們可以對「容器內的值」進行操作，而不需要手動拆解容器
-- | 這是函數式程式設計中「抽象」的極致展現
