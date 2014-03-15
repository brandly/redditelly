var
gulp = require('gulp'),
coffee = require('gulp-coffee'),
concat = require('gulp-concat'),
htmlbuild = require('gulp-htmlbuild'),
sass = require('gulp-sass'),
gutil = require('gulp-util'),
uglify = require('gulp-uglify'),
minify = require('gulp-minify-css'),
path = require('path'),
express = require('express'),
karma = require('gulp-karma'),

build = gutil.env.gh ? './gh-pages/' : './build/';

// don't minify/uglify unless we're heading to github
if (!gutil.env.gh) {
    uglify = gutil.noop;
    minify = gutil.noop;
}

gulp.task('test', function () {
    return gulp.src([
        build + 'lib.js',
        'bower_components/angular-mocks/angular-mocks.js',
        build + 'app.js',
        'test/src/unit/**/*.coffee'
    ])
    .on('error', function (e) {
        throw e;
    })
    .pipe(karma({
        configFile: 'test/config/karma.conf.coffee',
        action: 'watch'
    }));
});

gulp.task('coffee', function () {
    return gulp.src('src/scripts/**/*.coffee')
        .pipe(coffee({bare: true}))
        .on('error', gutil.log)
        .pipe(uglify())
        .pipe(concat('app.js'))
        .pipe(gulp.dest(build));
});

gulp.task('index', function () {
    return gulp.src('src/index.html')
        .pipe(htmlbuild({
            js: function (files, callback) {
                gulp.src(files)
                    .pipe(uglify())
                    .pipe(concat('lib.js'))
                    .pipe(gulp.dest(build));
                callback(null, ['lib.js']);
            }
        }))
        .pipe(gulp.dest(build));
});

gulp.task('views', function () {
    return gulp.src('src/views/*.html')
        .pipe(gulp.dest(build + 'views/'));
});

gulp.task('sass', function () {
    return gulp.src('src/styles/**/*.scss')
        .pipe(sass())
        .on('error', gutil.log)
        .pipe(minify())
        .pipe(concat('the.css'))
        .pipe(gulp.dest(build));
});

gulp.task('icons', function () {
    return gulp.src('src/styles/icons/*')
        .pipe(gulp.dest(build + 'icons/'));
});

gulp.task('images', function () {
    return gulp.src('src/styles/img/*')
        .pipe(gulp.dest(build + 'img/'));
});

gulp.task('favicons', function () {
    return gulp.src('src/styles/favicons/*')
        .pipe(gulp.dest(build));
});

gulp.task('build', [
    'coffee',
    'index',
    'views',
    'sass',
    'icons',
    'images',
    'favicons'
]);

gulp.task('default', ['build'], function () {
    if (!gutil.env.gh) {
        gulp.watch(['src/**'], ['build']);

        var
        app = express(),
        port = 8888;
        app.use(express.static(path.resolve(build)));
        app.listen(port, function() {
            gutil.log('Listening on', port);
        });
    }
});
