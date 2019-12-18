{-# LANGUAGE OverloadedStrings #-}

module EvalSpec where

import Data.Sequence as S
import Dynamic.Step (eval)
import Syntax.Expr
import Syntax.Program
import Test.Hspec
import Utils
  ( intToNat,
    natToInt,
  )
import Vanilla.Examples

evalSpec = describe "eval" $ do
  it "evals id'" $ do
    let EAnno e _ = id'
    eval id' `shouldSatisfy` isELam
    eval id' `shouldBe` e
  it "evals id''" $ do
    let EAnno e _ = id''
    eval id'' `shouldSatisfy` isELam
    eval id'' `shouldBe` e
  it "evals idUnit" $ eval idUnit `shouldBe` EUnit
  it "evals idUnit'" $ eval idUnit' `shouldBe` EUnit
  it "evalsidIdAnno" $ do
    let res = eval idIdAnno
    print res
    res `shouldSatisfy` isELam
  it "evals nestedId" $ do
    let res = eval nestedId
    print res
    res `shouldSatisfy` isELam
  it "evals nestedIdId" $ do
    let res = eval nestedIdId
    print res
    res `shouldSatisfy` isELam
  it "evals nestedIdUnit" $ eval nestedIdUnit `shouldBe` EUnit
  it "evlas nestedIdIdUnit" $ eval nestedIdIdUnit `shouldBe` EUnit
  it "evals letIdUnit" $ eval letIdUnit `shouldBe` EUnit
  it "evals letNestedIdUnit" $ eval letNestedIdUnit `shouldBe` EUnit
  it "evals letNestIdUnitId" $ eval letNestIdUnitId `shouldBe` EUnit
  it "evals applyToUnitId" $ eval applyToUnitId `shouldBe` EUnit
  it "evals polyLetNat" $ eval polyLetNat `shouldBe` ESucc EZero
  it "evals annotedIdSZero" $ eval annotedIdSZero `shouldBe` ESucc EZero
  it "evals ifElseIdNat" $ eval ifElseIdNat `shouldSatisfy` isELam
  it "evals ifElseIdNatZero" $ eval ifElseIdNatZero `shouldBe` EZero
  it "evals nonZeroZero" $ eval nonZeroZero `shouldBe` ETrue
  it "evals nonZeroTwo" $ eval nonZeroTwo `shouldBe` EFalse
  it "evals 0 + 2 = 2" $
    eval (natAdd $$ EZero $$ intToNat 2)
      `shouldBe` intToNat 2
  it "evals 4 + 6 = 10" $
    eval (natAdd $$ intToNat 4 $$ intToNat 6)
      `shouldBe` intToNat 10
  it "evals 6 - 2 = 4" $
    eval (natMinus $$ intToNat 6 $$ intToNat 2)
      `shouldBe` intToNat 4
  it "evals fibinacci 10 = 55" $
    (natToInt . eval $ (fibonacci $$ intToNat 10))
      `shouldBe` 144
  it "evals aLetId" $ eval aLetId `shouldBe` ETrue
  it "evals idProd" $ eval idProd `shouldBe` EProd EFalse EZero
  it "evals boolNatProj1" $ eval boolNatProj1 `shouldBe` ETrue
  it "evals (isInj1 inj2Unit)" $ eval (isInj1 $$ inj2Unit) `shouldBe` EFalse
  it "evals (isInj1 inj1Nat)" $ eval (isInj1 $$ inj1Nat) `shouldBe` ETrue
  it "evals listEmptyProg" $ eval (mainExpr listEmptyProg) `shouldBe` ETrue
  it "evals listNonEmptyProg" $ eval (mainExpr listNonEmptyProg) `shouldBe` EFalse
  it "evals nonzeroSingletonList" $
    eval (mainExpr nonzeroSingletonList)
      `shouldBe` ECons "Cons" (fromList [ECons "Succ" $ fromList [cons "Zero"], cons "Nil"])
