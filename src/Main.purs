module Main where

import Prelude

import Effect (Effect)

import Data.Maybe (fromJust)

import Web.HTML.HTMLDocument (toNonElementParentNode) as DOM
import Web.DOM.NonElementParentNode (getElementById) as DOM
import Web.HTML (window) as DOM
import Web.HTML.Window (document) as DOM

import Partial.Unsafe (unsafePartial)

import React as React
import ReactDOM as ReactDOM

import Example (example)

main :: Effect Unit
main = void $ do
  window <- DOM.window

  document <- DOM.document window

  let
      node = DOM.toNonElementParentNode document

  element <- DOM.getElementById "example" node

  let
      element' = unsafePartial (fromJust element)

  ReactDOM.render (React.createHookLeafElement example { }) element'
