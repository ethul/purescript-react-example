module Main where

import Prelude

import Effect (Effect)

import Data.Array (snoc, modifyAt, elemIndex)
import Data.Maybe (Maybe(..), fromJust, fromMaybe)
import Data.Tuple (Tuple(..))

import Web.HTML.HTMLDocument (toNonElementParentNode) as DOM
import Web.DOM.NonElementParentNode (getElementById) as DOM
import Web.HTML (window) as DOM
import Web.HTML.Window (document) as DOM

import Partial.Unsafe (unsafePartial)

import React as React
import React.Hooks as Hooks
import ReactDOM as ReactDOM

import Example.TodoList (todoList)
import Example.Types (Todo(..), TodoStatus(..))

main :: Effect Unit
main = void $ do
  window <- DOM.window

  document <- DOM.document window

  let
      node = DOM.toNonElementParentNode document

  element <- DOM.getElementById "example" node

  let
      element' = unsafePartial (fromJust element)

  ReactDOM.render (React.createElementHooks wrapper { }) element'

wrapper :: { } -> Effect React.ReactElement
wrapper _ = render <$> Hooks.useState initialState
  where
  initialState =
    { todo: Nothing
    , todos: []
    }

  render
    (Tuple
      { todo
      , todos
      } setState) =
    React.createElementHooks todoList
      { todos
      , todo

      , onAdd: \todo' -> Hooks.modifyState setState \a ->
          a { todo = Nothing
            , todos = snoc a.todos todo'
            }

      , onEdit: \todo' -> Hooks.modifyState setState
          _ { todo = Just todo'
            }

      , onDone: \todo' -> Hooks.modifyState setState \a ->
          a { todos = setStatus a.todos todo' TodoDone
            }

      , onClear : \todo' -> Hooks.modifyState setState \a ->
          a { todos = setStatus a.todos todo' TodoCleared
            }
      }

  setStatus todos todo status = fromMaybe todos $ do
    i <- elemIndex todo todos

    modifyAt i (\(Todo a) -> Todo a { status = status }) todos
