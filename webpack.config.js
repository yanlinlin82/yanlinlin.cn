const path = require('path');

module.exports = {
  entry: './src/js/main.js',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'static/assets/js'),
  },
  mode: 'production',
  resolve: {
    fallback: {
      "path": false,
      "fs": false
    }
  }
};
