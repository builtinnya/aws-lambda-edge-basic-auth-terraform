const { src, dest } = require('gulp')
const babel = require('gulp-babel')
const concat = require('gulp-concat')
const uglify = require('gulp-uglify')
const zip = require('gulp-zip')
const rimraf = require('rimraf')

const ZIP_FILENAME = 'lambda-edge-basic-auth-function.zip'
const ZIP_DIR = 'module/functions'

function build() {
  return src('src/**/*.js')
    .pipe(babel({
      presets: [ '@babel/env' ]
    }))
    .pipe(concat('basic-auth.js'))
    .pipe(uglify())
    .pipe(zip(ZIP_FILENAME))
    .pipe(dest(ZIP_DIR))
}

function clean(cb) {
  return rimraf(`${ZIP_DIR}/${ZIP_FILENAME}`, cb)
}

function defaultTask() {
  return build()
}

exports.clean = clean
exports.default = defaultTask
