'use strict'

// Modules
const path = require('path')
const webpack = require('webpack')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')

// Environment
const Env = process.env.MIX_ENV || 'dev'
const isProd = (Env === 'prod')

function resolve (dir) {
  return path.join(__dirname, dir)
}

module.exports = (env) => {
  return {
    devtool: '#source-map',
    entry: {
      app: ['./js/app.js', './css/app.css']
    },
    output: {
      path: path.resolve(__dirname, '../priv/static'),
      filename: 'js/[name].js'
    },
    resolve: {
      extensions: ['.js', '.json', '.css']
    },
    module: {
      rules: [{
          test: /\.js$/,
          exclude: /node_modules/,
          loader: 'babel-loader'
        },{
          test: /\.css$/,
          use: ExtractTextPlugin.extract({fallback: 'style-loader', use: 'css-loader'})
        }
      ]
    },

    plugins: [
      new ExtractTextPlugin({filename: 'css/[name].css', allChunks: true}),
      new CopyWebpackPlugin([{
        from: './static',
        to: path.resolve(__dirname, '../priv/static'),
        ignore: ['.*']
      }]),
      new webpack.optimize.UglifyJsPlugin({
        compress: {
          warnings: false
        },
        sourceMap: true,
        beautify: false,
        comments: false
      })
    ]
  }
}