module Example.TodoList where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Unsafe (unsafeCoerceEff)

import Data.Array (filter)
import Data.Maybe (Maybe)

import React as React
import React.DOM as DOM
import React.DOM.Props as Props

import Example.TodoForm (todoFormClass)
import Example.TodoItem (todoItemClass)
import Example.Types (Todo(..), TodoStatus(..))

type TodoListProps eff
  = { todos :: Array Todo
    , todo :: Maybe Todo
    , onAdd :: Todo -> Eff eff Unit
    , onEdit :: Todo -> Eff eff Unit
    , onDone :: Todo -> Eff eff Unit
    , onClear :: Todo -> Eff eff Unit
    }

todoListClass :: forall eff. React.ReactClass (TodoListProps eff)
todoListClass = React.component "TodoList" component
  where
  component this =
    pure { state: {}
         , render: render <$> React.getProps this
         }
    where
    render
      { todos
      , todo
      , onAdd
      , onEdit
      , onDone
      , onClear
      } =
      DOM.div
        [ ]
        [ React.createLeafElement todoFormClass
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
          [ React.createLeafElement todoItemClass { todo: todo' }
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

        onClick event = unsafeCoerceEff $
          case status of
               TodoPending -> onDone todo'
               TodoDone -> onClear todo'
               _ -> pure unit
