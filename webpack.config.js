const path = require('path');

module.exports = {
  entry: './src/js/main.js',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'static/js'),
  },
  mode: 'production',
  resolve: {
    fallback: {
      "path": false,
      "fs": false
    }
  }
};
