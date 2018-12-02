module Example.TodoList where

import Prelude

import Effect (Effect)

import Data.Array (filter)
import Data.Maybe (Maybe)

import React as React
import React.Hook (Hook)
import React.DOM as DOM
import React.DOM.Props as Props

import Example.TodoForm (todoForm)
import Example.TodoItem (todoItem)
import Example.Types (Todo(..), TodoStatus(..))

type TodoListProps
  = { todos :: Array Todo
    , todo :: Maybe Todo
    , onAdd :: Todo -> Effect Unit
    , onEdit :: Todo -> Effect Unit
    , onDone :: Todo -> Effect Unit
    , onClear :: Todo -> Effect Unit
    }

todoList :: TodoListProps -> Hook React.ReactElement
todoList
  { todos
  , todo
  , onAdd
  , onEdit
  , onDone
  , onClear
  } = pure $
  DOM.div
    [ ]
    [ React.createHookLeafElement todoForm
        { todo
        , onEdit
        , onAdd
        }
    , DOM.ol
        [ ]
        (renderItem <$> todos')
    ]
  where
  todos' = filter (\(Todo { status }) -> TodoCleared /= status) todos

  renderItem todo' @ Todo { status } =
    DOM.li
      [ ]
      [ React.createHookLeafElement todoItem { todo: todo' }
      , DOM.button
          [ Props._type "button"
          , Props.onClick onClick
          ]
          [ DOM.text text ]
      ]
    where
    text =
      case status of
           TodoPending -> "Done"
           TodoDone -> "Clear"
           _ -> ""

    onClick event =
      case status of
           TodoPending -> onDone todo'
           TodoDone -> onClear todo'
           _ -> pure unit
