var gulp = require('gulp');
var gutil = require('gulp-util');
var coffee = require('gulp-coffee');
var sass = require('gulp-sass');

gulp.task('js', function(){
    return gulp.src('./src/*.coffee')
        .pipe(coffee())
        .on('error', gutil.log)
        .pipe(gulp.dest('./dist/'))
        .pipe(gulp.dest('./demo/'));
});

gulp.task('css', function(){
    return gulp.src('./src/*.sass')
        .pipe(sass())
        .on('error', gutil.log)
        .pipe(gulp.dest('./dist/'))
        .pipe(gulp.dest('./demo/'));
});

gulp.task('watch', function(){
    gulp.watch('./src/*.coffee', ['js']);
    gulp.watch('./src/*.sass', ['css']);
});
