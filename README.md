# purescript-react-example

Example using low-level React DOM bindings for PureScript 0.9.1

## Building

    bower install
    npm install

    pulp browserify --to public/scripts/Main.js

    open public/index.html

## Build Scripts

    npm run watch  ->  pulp --watch browserify --to public/scripts/Main.js
    npm run build  ->  pulp browserify --to public/scripts/Main.js
