module Example.TodoItem where

import Prelude

import React as React
import React.DOM as DOM
import React.DOM.Props as Props

import Example.Types (Todo(..), TodoStatus(..))

type TodoItemProps = { todo :: Todo }

todoItemClass :: React.ReactClass TodoItemProps
todoItemClass = React.component "TodoItem" component
  where
  component this =
    pure { state: {}
         , render: render <$> React.getProps this
         }
    where
    render { todo: Todo { text, status } } =
      DOM.div
        [ Props.style { textDecoration } ]
        [ React.toElement text ]
      where
      textDecoration =
        case status of
             TodoDone -> "line-through"
             _ -> "none"
