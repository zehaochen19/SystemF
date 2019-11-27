module Main where


import           SystemF


main :: IO ()
main = do
  putStrLn "id'"
  print $ typecheck id'
  print $ eval id'
  putStrLn "idIdAnno"
  print $ typecheck idIdAnno
  print $ eval idIdAnno
  putStrLn "idUnit"
  print $ typecheck idUnit
  print $ eval idUnit
  putStrLn "idUnit'"
  print $ typecheck idUnit'
  print $ eval idUnit'
  putStrLn "nestedId"
  print $ typecheck nestedId
  print $ eval nestedId
  putStrLn "nestedIdId"
  print $ typecheck nestedIdId
  print $ eval nestedIdId
  putStrLn "nestedIdUnit"
  print $ typecheck nestedIdUnit
  print $ eval nestedIdUnit
  putStrLn "nestedIdIdUnit"
  print $ typecheck nestedIdIdUnit
  print $ eval nestedIdIdUnit
