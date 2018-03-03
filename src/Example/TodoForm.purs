module Example.TodoForm where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Unsafe (unsafeCoerceEff)

import Data.Maybe (Maybe, maybe, isNothing)

import React as React
import React.DOM as DOM
import React.DOM.Props as Props

import Unsafe.Coerce (unsafeCoerce)

import Example.Types (Todo(..), TodoStatus(..))

type TodoFormProps eff
  = { todo :: Maybe Todo
    , onEdit :: Todo -> Eff eff Unit
    , onAdd :: Todo -> Eff eff Unit
    }

todoFormClass :: forall eff. React.ReactClass (TodoFormProps eff)
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
            [ ]
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
        React.preventDefault event

        unsafeCoerceEff $ maybe (pure unit) onAdd todo

      onChange event = unsafeCoerceEff $ onEdit $
        maybe (Todo { text, status: TodoPending })
              (\(Todo todo_) -> Todo todo_ { text = text })
              todo
        where
        text = (unsafeCoerce event).target.value
