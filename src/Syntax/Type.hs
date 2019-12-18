{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Syntax.Type
  ( Type (..),
    TVar (..),
    TEVar (..),
    isMono,
    tyFreeTEVars,
    tyFreeTVars,
    tvar,
    (-->),
    isTArr,
    isTAll,
    tyParen,
  )
where

import Data.Set as S
import Data.String (IsString)
import Data.Text (Text)
import qualified Data.Text as T

-- | A, B, C
newtype TVar = MkTVar Text deriving (Eq, Ord, IsString)

instance Show TVar where
  show (MkTVar v) = T.unpack v

tvar :: Text -> TVar
tvar = MkTVar

-- | Existential types. alpha, beta.
newtype TEVar = MkTEVar Text deriving (Eq, Show, Ord, IsString)

data Type
  = TUnit
  | TBool
  | TNat
  | TVar TVar
  | TEVar TEVar
  | TProd Type Type
  | TSum Type Type
  | TArr Type Type
  | TAll TVar Type
  | TData Text [Type]
  deriving (Eq)

infixr 2 -->

(-->) :: Type -> Type -> Type
(-->) = TArr

-- | Monotypes: tau, sigma.
isMono :: Type -> Bool
isMono TUnit = True
isMono TBool = True
isMono TNat = True
isMono (TVar _) = True
isMono (TEVar _) = True
isMono (TProd a b) = isMono a && isMono b
isMono (TArr a b) = isMono a && isMono b
isMono (TData _ pat) = all isMono pat
isMono _ = False

tyFreeTEVars :: Type -> Set TEVar
tyFreeTEVars TUnit = S.empty
tyFreeTEVars TBool = S.empty
tyFreeTEVars TNat = S.empty
tyFreeTEVars (TVar _) = S.empty
tyFreeTEVars (TEVar evar) = S.singleton evar
tyFreeTEVars (TProd a b) = tyFreeTEVars a <> tyFreeTEVars b
tyFreeTEVars (TSum a b) = tyFreeTEVars a <> tyFreeTEVars b
tyFreeTEVars (TArr a b) = tyFreeTEVars a <> tyFreeTEVars b
tyFreeTEVars (TAll _ ty) = tyFreeTEVars ty
tyFreeTEVars (TData _ pat) = mconcat $ fmap tyFreeTEVars pat

tyFreeTVars :: Type -> Set TVar
tyFreeTVars TUnit = S.empty
tyFreeTVars TBool = S.empty
tyFreeTVars TNat = S.empty
tyFreeTVars (TVar a) = S.singleton a
tyFreeTVars (TEVar _) = S.empty
tyFreeTVars (TProd a b) = tyFreeTVars a <> tyFreeTVars b
tyFreeTVars (TSum a b) = tyFreeTVars a <> tyFreeTVars b
tyFreeTVars (TArr a b) = tyFreeTVars a <> tyFreeTVars b
tyFreeTVars (TAll a ty) = S.delete a $ tyFreeTVars ty
tyFreeTVars (TData _ pat) = mconcat $ fmap tyFreeTVars pat

isTArr :: Type -> Bool
isTArr (TArr _ _) = True
isTArr _ = False

isTAll :: Type -> Bool
isTAll (TAll _ _) = True
isTAll _ = False

instance Show Type where
  show TUnit = "Unit"
  show TBool = "Bool"
  show TNat = "Nat"
  show (TVar (MkTVar x)) = T.unpack x
  show (TEVar (MkTEVar x)) = "Existential " ++ T.unpack x
  show (TProd a b) = "(" ++ tyParen a ++ ", " ++ tyParen b ++ ")"
  show (TSum a b) = tyParen a ++ " + " ++ tyParen b
  show (TArr a b) = tyParen a ++ " → " ++ tyParen b
  show (TAll a ty) = "∀" ++ show a ++ ". " ++ tyParen ty
  show (TData name pat) = show name ++ " " ++ unwords (show <$> pat)

tyParen :: Type -> String
tyParen ty = case ty of
  TUnit -> show ty
  TBool -> show ty
  TNat -> show ty
  TVar _ -> show ty
  TEVar _ -> show ty
  _ -> "(" ++ show ty ++ ")"
