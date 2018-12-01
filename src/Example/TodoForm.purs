module Example.TodoForm where

import Prelude

import Data.Maybe (Maybe, maybe, isNothing)

import Effect (Effect)

import React as React
import React.Hook (Hook)
import React.SyntheticEvent as Event
import React.DOM as DOM
import React.DOM.Props as Props

import Unsafe.Coerce (unsafeCoerce)

import Example.Types (Todo(..), TodoStatus(..))

type TodoFormProps
  = { todo :: Maybe Todo
    , onEdit :: Todo -> Effect Unit
    , onAdd :: Todo -> Effect Unit
    }

todoForm :: TodoFormProps -> Hook React.ReactElement
todoForm
  { todo
  , onEdit
  , onAdd
  } = pure render
  where
  render =
    DOM.form
      [ Props.onSubmit onSubmit ]
      [ DOM.input
          [ Props._type "text"
          , Props.value value
          , Props.onChange onChange
          ]
      , DOM.button
          [ Props._type "submit"
          , Props.disabled isDisabled
          ]
          [ DOM.text "Add" ]
      ]
    where
    value = maybe "" (\(Todo { text }) -> text) todo

    isDisabled = isNothing todo

    onSubmit event = do
      Event.preventDefault event

      maybe (pure unit) onAdd todo

    onChange event = onEdit $
      maybe (Todo { text, status: TodoPending })
            (\(Todo todo_) -> Todo todo_ { text = text })
            todo
      where
      text = (unsafeCoerce event).target.value
