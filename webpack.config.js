'use strict';

module.exports = {
  entry: './src/App',

  debug: true,

  devtool: 'cheap-module-inline-source-map',

  devServer: {
    contentBase: '.',
    port: 4008,
    stats: 'errors-only'
  },

  output: {
    path: __dirname,
    pathinfo: true,
    filename: 'bundle.js'
  },

  module: {
    loaders: [
      {
        test: /\.purs$/,
        loader: 'purs-loader',
        exclude: /node_modules/,
        query: {
          src: [
            'bower_components/purescript-*/src/**/*.purs',
            'src/**/*.purs'
          ],
          pscIde: true
        }
      }
    ]
  },

  resolve: {
    modulesDirectories: [
      'node_modules',
      'bower_components'
    ],
    extensions: [ '', '.purs', '.js']
  }
};
