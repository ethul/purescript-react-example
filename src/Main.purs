module Main where

import Prelude

import Control.Monad.Eff
import Control.Monad.Eff.Console

import Data.Maybe.Unsafe (fromJust)
import Data.Nullable (toMaybe)

import DOM (DOM())
import DOM.HTML (window)
import DOM.HTML.Types (htmlDocumentToDocument)
import DOM.HTML.Window (document)

import DOM.Node.NonElementParentNode (getElementById)
import DOM.Node.Types (Element(), ElementId(..), documentToNonElementParentNode)

import React
import ReactDOM (render)

import qualified React.DOM as D
import qualified React.DOM.Props as P

import Container (container)

foreign import interval :: forall eff a.
                             Int ->
                             Eff eff a ->
                             Eff eff Unit

hello :: forall props. ReactClass { name :: String | props }
hello = createClass $ spec unit \ctx -> do
  props <- getProps ctx
  return $ D.h1 [ P.className "Hello"
                , P.style { background: "lightgray" }
                ]
                [ D.text "Hello, "
                , D.text props.name
                , createElement (createClassStateless \props -> D.div' [ D.text $ "Stateless" ++ props.test ])
                                { test: "test" } []
                ]

counter :: forall props. ReactClass props
counter = createClass counterSpec
  where
  counterSpec = (spec 0 render)
    { componentDidMount = \ctx ->
        interval 1000 $ do
          val <- readState ctx
          print val
    }

  render ctx = do
    val <- readState ctx
    return $ D.button [ P.className "Counter"
                      , P.onClick \_ -> do
                          val <- readState ctx
                          writeState ctx (val + 1)
                      ]
                      [ D.text (show val)
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
    return $ fromJust (toMaybe elm)
