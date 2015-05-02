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
                 tasks: ['concat:js']
            },

            express: {
                files:  [ 'server.js' ],
                tasks:  [ 'express:dest' ],
                options: {
                    spawn: false,                   // for grunt-contrib-watch v0.5.0+, "nospawn: true" for lower versions. Without this option specified express won't be reloaded
                    nospawn: true
                }
            }
        },

        express: {
            // https://github.com/ericclemmons/grunt-express-server
            dest: {
                options: {
                    script: 'server.js'
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-express-server');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-sass');

    grunt.registerTask('prod', ['sass', 'concat', 'uglify', 'express:dest']);
    grunt.registerTask('dev', ['sass:dev', 'concat', 'express:dest', 'watch']);
    grunt.registerTask('default', ['dev']);
};