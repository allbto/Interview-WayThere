/**
 * Created by allan on 5/2/15.
 */


module.exports = function(grunt) {

    var RootSrcFolder = 'src/';

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        sass: {
            // https://github.com/sindresorhus/grunt-sass
            prod: {
                options: {
                    outputStyle : 'compressed',     // CSS output style, compressed for production
                    sourceMap: true
                },
                files: {
                    'dest/css/main.min.css': RootSrcFolder + 'scss/main.scss'
                }
            },
            dev: {
                options: {
                    outputStyle : 'expanded',       // CSS output style (nested | expanded | compact | compressed)
                    sourceComments : true           // Add comments to css file to help you find where a class is defined for example
                },
                files: {
                    'dest/css/main.css': RootSrcFolder + 'scss/main.scss'
                }
            }
        },

        uglify: {
            // https://github.com/gruntjs/grunt-contrib-uglify
            options: {
                sourceMap: true,
                mangle: false,                      // To prevent changes to your variable and function names. Useful for AngularJS
                compress: true                      // Compress js code
            },
            prod: {
                files: {
                    'dest/js/main.min.js': RootSrcFolder + 'js/**/*.js'
                }
            }
        },

        concat: {
            // https://github.com/gruntjs/grunt-contrib-concat
            js: {
                files: {
                    'dest/js/main.js': RootSrcFolder + 'js/**/*.js'
                }
            }
        },

        watch: {
            // https://github.com/gruntjs/grunt-contrib-watch
            sass: {
                files: RootSrcFolder + 'scss/**/*.scss',
                tasks: ['sass:dev']
            },

            js: {
                 files: RootSrcFolder + 'js/**/*.js',
                 tasks: ['uglify:dev']
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-sass');

    grunt.registerTask('prod', ['sass', 'concat', 'uglify']);
    grunt.registerTask('dev', ['sass:dev', 'concat', 'watch']);
    grunt.registerTask('default', ['dev']);
};