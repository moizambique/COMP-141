-- Team members: Muhammad Moiz, Mohammed Saleh, Shabbir Murtaza
-- This Haskell source code defines functions for manipulating lists and solving a simple AI task 
-- of finding a path to the Wumpus while avoiding pits.
-- AI tools were used to help generate and debug parts of the functions, particularly in designing 
-- the recursive structure for the 'findWumpus' function.

-- Function to replace an element in a list at a specific index
replaceByIndex :: [a] -> Int -> a -> [a]
replaceByIndex xs i v = take i xs ++ [v] ++ drop (i + 1) xs

-- Function to replace an element in a list of lists at a specific row and column
replaceByIndices :: [[a]] -> Int -> Int -> a -> [[a]]
replaceByIndices xss row col val = take row xss ++ 
                                   [replaceByIndex (xss !! row) col val] ++ 
                                   drop (row + 1) xss

-- Function to find an element in a list of lists at a specific row and column
findByIndices :: [[a]] -> Int -> Int -> a
findByIndices xss row col = (xss !! row) !! col

-- Function to find the Wumpus by exploring the cave from the starting point (row 3, col 0)
findWumpus :: [[Char]] -> String
findWumpus cave = search 3 0 []
  where
    -- Recursive helper function to search for the Wumpus, avoiding pits and out-of-bounds moves
    search :: Int -> Int -> String -> String
    search row col path
      | row < 0 || row >= 4 || col < 0 || col >= 6 = []  -- Out of bounds
      | cave !! row !! col == 'P' = []                 -- Hit a pit
      | cave !! row !! col == 'W' = path               -- Found the Wumpus
      | otherwise = case search (row - 1) col (path ++ "u") of -- Up
          [] -> case search (row + 1) col (path ++ "d") of     -- Down
            [] -> case search row (col - 1) (path ++ "l") of   -- Left
              [] -> search row (col + 1) (path ++ "r")         -- Right
              result -> result
            result -> result
          result -> result

-- Example cave layout and main function for testing the implementation
cave1 :: [[Char]]
cave1 = [['O', 'O', 'O', 'O', 'P', 'O'],
         ['O', 'O', 'P', 'W', 'O', 'O'],
         ['O', 'O', 'O', 'P', 'O', 'P'],
         ['O', 'O', 'O', 'O', 'O', 'O']]

main :: IO ()
main = do
  putStrLn ("Replacing index 3 with 'y': " ++ show (replaceByIndex ['n', 'n', 'n', 'n', 'n', 'n'] 3 'y'))
  putStrLn ("Replacing index 1 2 with 'y': " ++ show (replaceByIndices [['n','n','n'],['n','n','n'],['n','n','n']] 1 2 'y'))
  putStrLn ("Element at 1 2: " ++ show (findByIndices [['O','P','O'],['P','O','W'],['O','O','O']] 1 2))
  putStrLn ("Finding Wumpus in cave1: " ++ show (findWumpus cave1))
