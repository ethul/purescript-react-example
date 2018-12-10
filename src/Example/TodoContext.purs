module Example.TodoContext where

import Data.Maybe (Maybe(..))

import React.Context (Context)
import React.Context as Context

type TodoContext = Context { backgroundColor :: String }

todoContext :: TodoContext
todoContext = Context.createContext { backgroundColor: "red" } Nothing
