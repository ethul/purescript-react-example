module Container where

import Prelude
import React (ReactClass, getChildren, spec, createClass)
import React.DOM.Dynamic as D
import React.DOM.Props as P

container :: ReactClass Unit
container = createClass $ spec unit \ctx -> do
  children <- getChildren ctx

  let ui = D.div [ P.style { borderColor: "red"
                           , borderWidth: 2
                           , borderStyle: "solid"
                           , padding: 10
                           }
                 ] children

  pure ui
