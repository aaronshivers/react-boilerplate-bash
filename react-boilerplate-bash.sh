#/bin/bash

# Create Project Directory
mkdir $1

# Move into Project Directory
cd $1

# Create Project Sub-Directories
mkdir server src src/components src/styles src/styles/custom src/styles/components

# Initialize a Git Repository
git init

# Initialize NPM with Default Values
npm init -y

# Add Scripts to package.json
sed -i "7i\    \"start\": \"node server/server.js\"," package.json
sed -i "7i\    \"dev-server\": \"webpack-dev-server\"," package.json
sed -i "7i\    \"build:dev\": \"webpack --mode=development\"," package.json
sed -i "7i\    \"build:prod\": \"webpack -p --env production\"," package.json
sed -i "7i\    \"heroku-postbuild\": \"npm run build:prod\"," package.json

# Install Project Dependencies
npm i -D @babel/cli @babel/core @babel/preset-env @babel/preset-react babel-loader css-loader mini-css-extract-plugin node-sass sass-loader style-loader webpack webpack-cli webpack-dev-server url-loader bootstrap dotenv-webpack clean-webpack-plugin html-webpack-plugin eslint eslint-config-airbnb eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-react eslint-plugin-react-hooks
npm i express react react-dom react-bootstrap

# Setup README.md
touch README.md
echo "# $1" >> README.md

# Setup webpack.config.js
touch webpack.config.js
echo "const Dotenv = require('dotenv-webpack')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const { CleanWebpackPlugin } = require('clean-webpack-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')

module.exports = env => (
  {
    entry: ['./src/app.jsx'],
    resolve: {
      extensions: ['.js', '.jsx']
    },
    module: {
      rules: [
        {
          test: /\.jsx?\$/,
          exclude: /node_modules/,
          loader: 'babel-loader',
          options: {
            presets: [
              '@babel/preset-env',
              '@babel/preset-react'
            ]
          }
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
              loader: 'url-loader'
            }
          ]
        }
      ]
    },
    plugins: [
      new CleanWebpackPlugin(),
      new HtmlWebpackPlugin({
        template: './src/index.html',
        title: '$1',
        meta: {
          viewport: 'width=device-width, initial-scale=1'
        }
      }),
      new MiniCssExtractPlugin({
        filename: '[name].css',
        chunkFilemane: '[id].css'
      }),
      new Dotenv()
    ],
    devtool: env === 'production' ? 'source-map' : 'inline-source-map',
    devServer: {
      historyApiFallback: true
    }
  }
)" >> webpack.config.js

# Setup src/app.jsx
touch src/app.jsx
echo "import React from 'react'
import { render } from 'react-dom'
import App from './components/App'
import './styles/styles.scss'

render(<App />, document.getElementById('app'))" >> src/app.jsx

# Setup server/server.js
touch server/server.js
echo "const path = require('path')
const express = require('express')

const app = express()
const publicPath = path.join(__dirname, '..', 'public')
const port = process.env.PORT || 3000

app.use(express.static(publicPath))

app.get('*', (req, res) => res.sendFile(path.join(publicPath, 'index.html')))

app.listen(port, () => console.log(\`Server running on port \${port}.\`))" >> server/server.js

# Setup src/index.html
touch src/index.html
echo "<!DOCTYPE html>
<html>
<head>
</head>
<body>
<div id=\"app\"></div>
</body>
</html>" >> src/index.html

# Setup .gitignore
touch .gitignore
echo "node_modules/
dist/
.env" >> .gitignore

# Create Empty .env file
touch .env

# Setup src/components/App.jsx
touch src/components/App.jsx
echo "import React from 'react'
import { Container } from 'react-bootstrap'

const App = () => (
  <Container>
    <h1 className=\"display-1 text-center\">$1</h1>
  </Container>
)

export default App" >> src/components/App.jsx

# Setup src/styles/custom/_custom.scss
touch src/styles/custom/_custom.scss
echo "// Colors
\$purple: #3f3250;
\$blue: #22252c;
\$red: #e14658;
\$yellow: #c0b3a0;
\$gray-900: #16181d;
\$gray-800: #2c303a;
\$gray-700: #434956;
\$gray-600: #596173;
\$gray-500: #6f7990;
\$gray-400: #8c94a6;
\$gray-300: #a9afbc;
\$gray-200: #c5c9d3;
\$gray-100: #e2e4e9;

\$primary: \$purple;
\$secondary: \$blue;" >> src/styles/custom/_custom.scss

# Setup src/styles/styles.scss
touch src/styles/styles.scss
echo "@import './custom/custom';
@import '../../node_modules/bootstrap/scss/bootstrap';" >> src/styles/styles.scss

# Setup .eslintignore
touch .eslintignore
echo "node_modules/
dist/" >> .eslintignore

# Setup .eslintrc.js
touch .eslintrc.js
echo "module.exports = {
  env: {
    browser: true,
    es6: true,
  },
  extends: [
    'airbnb',
  ],
  globals: {
    Atomics: 'readonly',
    SharedArrayBuffer: 'readonly',
  },
  parserOptions: {
    ecmaFeatures: {
      jsx: true,
    },
    ecmaVersion: 2018,
    sourceType: 'module',
  },
  plugins: [
    'react',
  ],
  rules: {
    semi: ['error', 'never'],
    'comma-dangle': ['error', 'never'],
    'arrow-parens': ['warn', 'as-needed']
  },
}" >> .eslintrc.js

# Stage Files in Git
git add .

# Commit Changes
git commit -m "first commit"

# Open SublimeText
subl .
