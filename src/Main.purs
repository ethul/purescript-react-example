module Main where

import Prelude
import React.DOM as D
import React.DOM.Props as P
import Container (container)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (log)
import DOM (DOM())
import DOM.HTML (window)
import DOM.HTML.Types (htmlDocumentToDocument)
import DOM.HTML.Window (document)
import DOM.Node.NonElementParentNode (getElementById)
import DOM.Node.Types (Element, ElementId(..), documentToNonElementParentNode)
import Data.Int (decimal, toStringAs)
import Data.Maybe (fromJust)
import Data.Nullable (toMaybe)
import Partial.Unsafe (unsafePartial)
import React (ReactElement, ReactClass, createElement, createFactory, createClass, writeState, readState, spec, createClassStateless, getProps)
import ReactDOM (render)

foreign import interval :: forall eff a.
                             Int ->
                             Eff eff a ->
                             Eff eff Unit

newtype AppState = AppState
  { count :: Int }

initialState :: AppState
initialState = AppState { count: 0  }


hello :: forall props. ReactClass { name :: String | props }
hello = createClass $ spec unit \ctx -> do
  props <- getProps ctx
  pure $ D.h1 [ P.className "Hello"
              , P.style { background: "lightgray" }
              ]
              [ D.text "Hello, "
              , D.text props.name
              , createElement (createClassStateless \props' -> D.div' [ D.text $ "Stateless" <> props'.test ])
                                { test: " test" } []
              ]



counter :: forall props. ReactClass props
counter = createClass counterSpec
  where
  counterSpec = (spec initialState render)
    { componentDidMount = \ctx ->
        interval 1000 $ do
          readState ctx >>=
            toString >>> log
    }

  toString :: AppState -> String
  toString ( AppState { count } )  =
      toStringAs decimal count

  addOne :: AppState -> AppState
  addOne ( AppState { count } ) = do
      AppState { count: count + 1 }

  render ctx = do
    count <- readState ctx
    pure $ D.button [ P.className "Counter"
                    , P.onClick \_ -> do
                        readState ctx >>=
                          addOne >>> writeState ctx
                    ]
                    [ D.text (toString count)
                    , D.text " Click me to increment!"
                    ]

main :: forall eff. Eff (dom :: DOM | eff) Unit
main = void (elm' >>= render ui)
  where
  ui :: ReactElement
  ui = D.div' [ createFactory hello { name: "World" }
              , createFactory counter unit
              , createElement container unit
                              [ D.p [ P.key "1" ] [ D.text  "This is line one" ]
                              , D.p [ P.key "2" ] [ D.text "This is line two" ]
                              ]
              ]

  elm' :: Eff (dom :: DOM | eff) Element
  elm' = do
    win <- window
    doc <- document win
    elm <- getElementById (ElementId "example") (documentToNonElementParentNode (htmlDocumentToDocument doc))
    pure $ unsafePartial fromJust (toMaybe elm)
