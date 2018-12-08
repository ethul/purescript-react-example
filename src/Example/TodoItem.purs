module Example.TodoItem where

import Prelude

import React as React
import React.Context as Context
import React.Hook (Hook)
import React.DOM as DOM
import React.DOM.Props as Props

import Example.TodoContext as TodoContext
import Example.Types (Todo(..), TodoStatus(..))

type TodoItemProps = { todo :: Todo }

todoItem :: TodoItemProps -> Hook React.ReactElement
todoItem
  { todo: Todo
      { text
      , status
      }
  } = pure $
  React.createRenderPropsElement consumer { } $ \{ backgroundColor } ->
    DOM.div
      [ Props.style
          { textDecoration
          , backgroundColor
          }
      ]
      [ React.toElement text ]
  where
  consumer = Context.getConsumer TodoContext.todoContext

  textDecoration =
    case status of
         TodoDone -> "line-through"
         _ -> "none"

