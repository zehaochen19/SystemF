module Vanilla.Static.WellForm where

import Data.Map as M
import Data.Maybe (isJust)
import Data.Text (Text)
import Vanilla.Static.Context
import Vanilla.Syntax.Decl
import Vanilla.Syntax.Type

typeWellForm :: Map Text Declaration -> Context -> Type -> Bool
typeWellForm decls ctx ty = case ty of
  TVar alpha -> CVar alpha `ctxElem` ctx
  TArr a b -> typeWellForm decls ctx a && typeWellForm decls ctx b
  TAll alpha a -> typeWellForm decls (ctx |> CVar alpha) a
  TEVar ea -> CEVar ea `ctxElem` ctx || isJust (ctxSolve ctx ea)
  TData name pat -> case M.lookup name decls of
    Nothing -> False
    Just dec -> length pat == length (tvars dec) && all (typeWellForm decls ctx) pat
