module Example.TodoForm where

import Prelude

import Data.Maybe (Maybe(..), maybe, isNothing)

import Effect (Effect)

import React as React
import React.Hook (Hook)
import React.Hook as Hook
import React.Ref (Ref, DOMRef)
import React.Ref as Ref
import React.SyntheticEvent as Event
import React.DOM as DOM
import React.DOM.Props as Props

import Unsafe.Coerce (unsafeCoerce)

import Example.TodoContext as TodoContext
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
  } =
  render <$> hook
  where
  hook = do
    context <- Hook.useContext TodoContext.todoContext

    ref <- Hook.useRef Nothing

    pure { ref, context }

  render
    { ref
    , context:
        { backgroundColor
        }
    } =
    DOM.form
      [ Props.onSubmit onSubmit ]
      [ DOM.input
          [ Props._type "text"
          , Props.value value
          , Props.ref ref
          , Props.onChange onChange
          , Props.style { backgroundColor }
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

      domRef <- Ref.getRef ref

      maybe (pure unit) blur domRef

      pure unit

    onChange event = onEdit $
      maybe (Todo { text, status: TodoPending })
            (\(Todo todo_) -> Todo todo_ { text = text })
            todo
      where
      text = (unsafeCoerce event).target.value

foreign import blur :: DOMRef -> Effect Unit
