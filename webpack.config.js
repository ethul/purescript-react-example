'use strict';

var path = require('path');

var modulesDirectories = [
  'node_modules',
  'output'
];

var config
  = { entry: './index'
    , output: { path: __dirname
              , pathinfo: true
              , filename: 'bundle.js'
              }
    , resolve: { modulesDirectories: modulesDirectories }
    }
    ;

module.exports = config;
