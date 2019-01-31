const { src, dest } = require('gulp')
const babel = require('gulp-babel')
const concat = require('gulp-concat')
const uglify = require('gulp-uglify')
const rimraf = require('rimraf')

const OUTPUT_FILENAME = 'basic-auth.js'
const OUTPUT_DIR = 'module/functions'

function build() {
  return src('src/**/*.js')
    .pipe(babel({
      presets: [ '@babel/env' ]
    }))
    .pipe(concat(OUTPUT_FILENAME))
    .pipe(uglify())
    .pipe(dest(OUTPUT_DIR))
}

function clean(cb) {
  return rimraf(`${OUTPUT_DIR}/${OUTPUT_FILENAME}`, cb)
}

function defaultTask() {
  return build()
}

exports.clean = clean
exports.default = defaultTask
