module Example.Types where

import Prelude

import Data.Newtype (class Newtype)

newtype Todo
  = Todo { text :: String
         , status :: TodoStatus
         }

derive instance eqTodo :: Eq Todo

derive instance ordTodo :: Ord Todo

derive instance newtypeTodo :: Newtype Todo _

data TodoStatus
  = TodoPending
  | TodoDone
  | TodoCleared

derive instance eqTodoStatus :: Eq TodoStatus

derive instance ordTodoStatus :: Ord TodoStatus
