#/bin/bash

# Create Project Directory
mkdir $1

# Move into Project Directory
cd $1

# Create Project Sub-Directories
mkdir public server src src/components src/styles src/styles/base src/styles/components

# Initialize a Git Repository
git init

# Initialize NPM with Default Values
npm init -y

# Add Scripts to package.json
sed -i "7i\    \"start\": \"node server/server.js\"," package.json
sed -i "7i\    \"dev-server\": \"webpack-dev-server\"," package.json
sed -i "
7i\    \"build:dev\": \"webpack --mode=development\"," package.json
sed -i "7i\    \"build:prod\": \"webpack -p --env production\"," package.json
sed -i "7i\    \"heroku-postbuild\": \"npm run build:prod\"," package.json

# Install Project Dependencies
npm i -D @babel/cli @babel/core @babel/preset-env @babel/preset-react babel-loader css-loader mini-css-extract-plugin node-sass sass-loader style-loader webpack webpack-cli webpack-dev-server url-loader
npm i react react-dom

# Setup README.md
touch README.md
echo "# $1" >> README.md

# Setup webpack.config.js
touch webpack.config.js
echo "const path = require('path')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')

module.exports = {
  entry: ['./src/app.js'],
  output: {
    path: path.join(__dirname, 'public', 'dist')
  },
  module: {
    rules: [
      {
        test: /\.js\$/,
        exclude: /node_modules/,
        loader:'babel-loader'
      }, {
        test: /\.s?css\$/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader
          }, {
            loader: 'css-loader',
            options: {
              sourceMap: true
            }
          }, {
            loader: 'sass-loader',
            options: {
              sourceMap: true
            }
          }
        ]
      }, {
        test: /\.(png|jpg|gif)$/i,
        use: [
          {
            loader: 'url-loader',
          },
        ],
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: 'styles.css'
    })
  ],
  devtool: 'inline-source-map',
  devServer: {
    contentBase: path.join(__dirname, 'public'),
    publicPath: '/dist/'
  }
}" >> webpack.config.js

# Setup src/app.js
touch src/app.js
echo "import React from 'react'
import { render } from 'react-dom'
import App from './components/App'
import './styles/styles.scss'

render(<App />, document.getElementById('app'))" >> src/app.js

# Setup .babelrc
touch .babelrc
echo "{
  \"presets\": [
    \"@babel/preset-env\",
    \"@babel/preset-react\"
  ]
}" >> .babelrc

# Setup server/server.js
touch server/server.js
echo "const path = require('path')
const express = require('express')
const app = express()
const publicPath = path.join(__dirname, '..', 'public')
const port = process.env.PORT || 3000

app.use(express.static(publicPath))

app.get('*', (req, res) => res.sendFile(path.join(publicPath, 'index.html')))

app.listen(port, () => console.log(\`Server running on port \${ port }.\`))
" >> server/server.js

# Setup public/index.html
touch public/index.html
echo "<!DOCTYPE html>
<html>
<head>
  <link rel=\"stylesheet\" type=\"text/css\" href=\"/dist/styles.css\">
  <title>$1</title>
</head>
<body>
  <div id=\"app\"></div>
  <script src=\"/dist/main.js\"></script>
</body>
</html>" >> public/index.html

# Setup .gitignore
touch .gitignore
echo "node_modules/
dist/" >> .gitignore

# Setup src/components/App.js
touch src/components/App.js
echo "import React from 'react'

const App = () => (
  <div>
    <h1>$1</h1>
  </div>
)

export default App" >> src/components/App.js

# Setup src/styles/base/_base.scss
touch src/styles/base/_base.scss
echo "* {
  box-sizing: border-box;
}

html {
  font-size: 62.5%;
}

body {
  color: \$dark-grey;
  font-family: Helvetica, Arial, sans-serif;
  font-size: \$m-size;
  line-height: 1.6;
}

button {
  cursor: pointer;
}

button:disabled {
  cursor: default;
}

.is-active {
  font-weight: bold;
}
" >> src/styles/base/_base.scss

# Setup src/styles/base/_settings.scss
touch src/styles/base/_settings.scss
echo "// Colors
\$off-white: #f7f7f7;
\$dark-grey: #333;
\$grey: #666;
\$light-grey: #888;
\$blue: #1c88bf;
\$dark-blue: #364051;

// Font Sizes
\$font-size-large: 1.8rem;
\$font-size-small: 1.4rem;

// Spacing
\$s-size: 1.2rem;
\$m-size: 1.6rem;
\$l-size: 3.2rem;
\$xl-size: 4.8rem;
\$desktop-breakpoint: 45rem;" >> src/styles/base/_settings.scss

# Setup src/styles/styles.scss
touch src/styles/styles.scss
echo "@import './base/settings';
@import './base/base';" >> src/styles/styles.scss

# Stage Files in Git
git add .

# Commit Changes
git commit -m "first commit"

# Open SublimeText
subl .
