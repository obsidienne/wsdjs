const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;
const MediaQueryPlugin = require('media-query-plugin');

module.exports = (env, options) => ({
  optimization: {
    minimizer: [
      new UglifyJsPlugin({
        cache: true,
        parallel: true,
        sourceMap: false
      }),
      new OptimizeCSSAssetsPlugin({})
    ]
  },
  entry: './js/app.js',
  output: {
    filename: '[name].js',
    path: path.resolve(__dirname, '../priv/static/js')
  },
  module: {
    rules: [{
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      },
      {
        test: /\.scss$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          MediaQueryPlugin.loader,
          'sass-loader'
        ]
      },
      {
        test: /\.(gif|svg|jpg|png)$/,
        loader: 'file-loader',
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: '../css/[name].css'
    }),
    new BundleAnalyzerPlugin({
      openAnalyzer: false,
      defaultSizes: 'gzip',
      analyzerMode: 'static'
    }),
    new MediaQueryPlugin({
      include: true,
      queries: {
        'print': 'print',
        '(min-width: 576px)': 'phone',
        '(min-width: 768px)': 'tablet',
        '(min-width: 992px)': 'desktop',
        '(min-width: 1200px)': 'wide'
      }
    }),
    new CopyWebpackPlugin([{
      from: 'static/',
      to: '../'
    }])
  ]
});