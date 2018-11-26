module Example.TodoForm where

import Prelude

import Effect (Effect)

import Data.Maybe (Maybe, maybe, isNothing)
import Data.Tuple (Tuple(..))

import React as React
import React.Hooks as Hooks
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

todoForm :: TodoFormProps -> Effect React.ReactElement
todoForm
  { todo
  , onEdit
  , onAdd
  } = render <$> Hooks.useState ""
  where
  render (Tuple value setState) =
    DOM.form
      [ Props.onSubmit onSubmit ]
      [ DOM.input
          [ Props._type "text"
          , Props.value value
          --, Props.onChange onChange
          , Props.onChange \event -> Hooks.setState setState (unsafeCoerce event).target.value
          ]
      , DOM.button
          [ Props._type "submit"
          , Props.disabled isDisabled
          ]
          [ DOM.text "Add" ]
      ]
    where
    value'' = maybe "" (\(Todo { text }) -> text) todo

    isDisabled = isNothing todo

    onSubmit event = do
      Event.preventDefault event

      maybe (pure unit) onAdd todo

    onChange'' event = onEdit $
      maybe (Todo { text, status: TodoPending })
            (\(Todo todo_) -> Todo todo_ { text = text })
            todo
      where
      text = (unsafeCoerce event).target.value
