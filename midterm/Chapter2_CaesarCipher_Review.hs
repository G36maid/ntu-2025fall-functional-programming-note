-- | Chapter 2 Review Part 2: Caesar Cipher Application
-- | 這個檔案是第二章的綜合應用範例，展示如何使用 `map`, `filter`, `zip` 等核心工具
-- | 來解決一個具體的問題：凱薩密碼的加密、解密與破解。

module Chapter2_CaesarCipher_Review where

-- | 為了使用 isLower, toLower 等函數，我們需要匯入 Data.Char 模組
import Data.Char

-- | =================================================================
-- | 1. 輔助函數 (Helper Functions)
-- | =================================================================

-- | 將一個小寫字母轉為 0-25 的整數。
-- | `ord` 函數取得字元的 ASCII 值，例如 `ord 'a'` 是 97。
let2int :: Char -> Int
let2int c = ord c - ord 'a'

-- | 將 0-25 的整數轉回小寫字母。
-- | `chr` 是 `ord` 的反函數。
int2let :: Int -> Char
int2let n = chr (n + ord 'a')

-- | `shift` 是核心的位移函數。
-- | 它只對小寫字母進行位移，其他字元保持不變。
-- | `mod` 運算子確保位移會「循環」。例如 (24 + 3) `mod` 26 = 2，即 'y' -> 'b'。
shift :: Int -> Char -> Char
shift n c
    | isLower c = int2let ((let2int c + n) `mod` 26)
    | otherwise   = c

-- | =================================================================
-- | 2. 加密 (Encode)
-- | =================================================================

-- | `encode` 函數完美體現了 "Wholemeal Programming" 的思想。
-- | 我們不用迴圈，而是用 `map` 將 `shift n` 這個操作應用到整個字串上。
encode :: Int -> String -> String
encode n s = map (shift n) s

-- | =================================================================
-- | 3. 破解 (Crack)
-- | =================================================================

-- | 破解的核心是頻率分析。其演算法步驟如下：
-- | 1. 產生所有可能的解碼結果 (位移 0 到 25)。
-- | 2. 為每一個解碼結果計算一個「分數」，代表它有多像真正的英文。
-- | 3. 找出分數最低 (最像英文) 的那個結果，其對應的位移量就是金鑰。

-- | (A) 計算頻率

-- | 英文中 'a' 到 'z' 的標準頻率表 (取自網路)
table :: [Float]
table = [8.1, 1.5, 2.8, 4.2, 12.7, 2.2, 2.0, 6.1, 7.0,
         0.2, 0.8, 4.0, 2.4, 6.7, 7.5, 1.9, 0.1, 6.0,
         6.3, 9.0, 2.8, 1.0, 2.4, 0.2, 2.0, 0.1]

-- | 計算一個字串中，各個字母的出現頻率。
freqs :: String -> [Float]
freqs s = [fromIntegral (count c lowers) / fromIntegral total * 100 | c <- ['a'..'z']]
    where
        -- 只計算小寫字母
        lowers = filter isLower s
        total  = length lowers

-- | 輔助函數：計算 x 在 xs 中出現的次數
count :: Eq a => a -> [a] -> Int
count x = length . filter (== x)

-- | (B) 評分 (卡方檢定)

-- | `chisqr` 接收觀察到的頻率和期望的頻率，計算它們的「差距」。
chisqr :: [Float] -> [Float] -> Float
chisqr observed expected = sum [((o - e)^2) / e | (o, e) <- zip observed expected]

-- | `score` 函數將 `freqs` 和 `chisqr` 組合起來，為一個字串評分。
score :: String -> Float
score s = chisqr (freqs s) table

-- | (C) 找出最佳解

-- | `crack` 函數是所有邏輯的總和。
crack :: String -> Int
crack ciphertext = snd (minimum (zip scores keys))
    where
        -- 所有可能的金鑰
        keys   = [0..25]
        -- 步驟 1: 產生所有可能的解碼結果 (注意解碼是用負數金鑰)
        decodedStrings = [encode (-k) ciphertext | k <- keys]
        -- 步驟 2: 對每個解碼結果評分
        scores = map score decodedStrings
        -- 步驟 3: 將分數和金鑰配對，並找出分數最低的一組，最後用 snd 取出金鑰。
