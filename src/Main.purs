module Main where

import Prelude

import Control.Monad.Eff (Eff)

import Data.Array (snoc, modifyAt, elemIndex)
import Data.Maybe (Maybe(..), fromJust, fromMaybe)

import DOM (DOM)
import DOM.HTML (window) as DOM
import DOM.HTML.Types (htmlDocumentToDocument) as DOM
import DOM.HTML.Window (document) as DOM
import DOM.Node.NonElementParentNode (getElementById) as DOM
import DOM.Node.Types (ElementId(..))
import DOM.Node.Types (documentToNonElementParentNode) as DOM

import Partial.Unsafe (unsafePartial)

import React as React
import ReactDOM as ReactDOM

import Example.TodoList (todoListClass)
import Example.Types (Todo(..), TodoStatus(..))

main :: forall eff. Eff (dom :: DOM | eff) Unit
main = void $ do
  window <- DOM.window

  document <- DOM.document window

  let
      node = DOM.documentToNonElementParentNode (DOM.htmlDocumentToDocument document)

  element <- DOM.getElementById (ElementId "example") node

  let
      element' = unsafePartial (fromJust element)

  ReactDOM.render (React.createLeafElement mainClass { }) element'

mainClass :: React.ReactClass { }
mainClass = React.component "Main" component
  where
  component this =
    pure { state:
            { todo: Nothing
            , todos: []
            }
         , render: render <$> React.readState this
         }
    where
    render
      { todo
      , todos
      } =
      React.createLeafElement todoListClass
        { todos
        , todo

        , onAdd: \todo' -> React.transformState this \a ->
            a { todo = Nothing
              , todos = snoc a.todos todo'
              }

        , onEdit: \todo' -> React.transformState this
            _ { todo = Just todo'
              }

        , onDone: \todo' -> React.transformState this \a ->
            a { todos = setStatus a.todos todo' TodoDone
              }

        , onClear : \todo' -> React.transformState this \a ->
            a { todos = setStatus a.todos todo' TodoCleared
              }
        }

    setStatus todos todo status = fromMaybe todos $ do
      i <- elemIndex todo todos

      modifyAt i (\(Todo a) -> Todo a { status = status }) todos
