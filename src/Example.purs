module Example where

import Prelude

import Data.Array (snoc, modifyAt, elemIndex)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple (Tuple(..))

import React as React
import React.Hook (Hook)
import React.Hook as Hook

import Example.TodoList (todoList)
import Example.Types (Todo(..), TodoStatus(..))

data Action
  = Add Todo
  | Edit Todo
  | Done Todo
  | Clear Todo

example :: { } -> Hook React.ReactElement
example _ =
  React.createHookLeafElement todoList <$> hook
  where
  hook = do
    Tuple state dispatch <- Hook.useReducer reducer initialState

    let
        inputs = Just [ Hook.hookInput dispatch ]

    onAdd <- Hook.useCallback (Hook.dispatch dispatch <<< Add) inputs

    onEdit <- Hook.useCallback (Hook.dispatch dispatch <<< Edit) inputs

    onDone <- Hook.useCallback (Hook.dispatch dispatch <<< Done) inputs

    onClear <- Hook.useCallback (Hook.dispatch dispatch <<< Clear) inputs

    pure { todo: state.todo
         , todos: state.todos
         , onAdd
         , onEdit
         , onDone
         , onClear
         }
    where
    initialState =
      { todo: Nothing
      , todos: [ ]
      }

    reducer state =
      case _ of
           Add todo -> state
             { todo = Nothing
             , todos = snoc state.todos todo
             }

           Edit todo -> state
             { todo = Just todo
             }

           Done todo -> state
             { todos = setStatus todo TodoDone
             }

           Clear todo -> state
             { todos = setStatus todo TodoCleared
             }
      where
      setStatus todo status = fromMaybe state.todos $ do
        i <- elemIndex todo state.todos

        modifyAt i (\(Todo a) -> Todo a { status = status }) state.todos
