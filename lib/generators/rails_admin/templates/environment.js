const webpack = require('webpack');
const { environment } = require('@rails/webpacker')

environment.plugins.append('ProvidePlugin-jQuery', new webpack.ProvidePlugin({jQuery: 'jquery'}));

module.exports = environment
