module Example.TodoForm where

import Prelude

import Effect (Effect)

import Data.Maybe (Maybe, maybe, isNothing)

import React as React
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

todoFormClass :: React.ReactClass TodoFormProps
todoFormClass = React.component "TodoForm" component
  where
  component this =
    pure { state: {}
         , render: render <$> React.getProps this
         }
    where
    render
      { todo
      , onEdit
      , onAdd
      } =
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
