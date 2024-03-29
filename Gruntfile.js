module.exports = function(grunt) {
  grunt.loadNpmTasks("grunt-bower-task");
  grunt.loadNpmTasks("grunt-contrib-clean");
  grunt.loadNpmTasks("grunt-contrib-requirejs");
  grunt.loadNpmTasks("grunt-filerev");
  grunt.loadNpmTasks("grunt-modernizr");
  grunt.loadNpmTasks("grunt-sass");

  grunt.initConfig({
    pkg: grunt.file.readJSON("package.json"),

    bower: {
      development: {
        options: {
          copy: false,
        }
      },

      production: {
        options: {
          copy: false,

          bowerOptions: {
            production: true
          }
        }
      }
    },

    clean: {
      assets: ["public/assets"]
    },

    modernizr: {
      compile: {
        devFile: "tmp/public/javascripts/modernizr/modernizr.js",
        outputFile: "tmp/public/javascripts/modernizr/modernizr.build.js",
        parseFiles: false,
        uglify: false,

        extra: {
          cssclasses: true,
          load: true,
          mq: false,
          printshiv: false,
          shiv: true,
          touch: true,
        },

        extensibility: {
          addtest: false,
          domprefixes: false,
          hasevents: false,
          prefixed: false,
          prefixes: false,
          testallprops: false,
          testprops: false,
          teststyles: false
        }
      }
    },

    requirejs: {
      compile: {
        options: {
          baseUrl: "./public/javascripts",
          mainConfigFile: "./public/javascripts/config/requirejs/production.js",
          name: "almond",
          include: "cs!config/boot",
          out: "public/assets/application.js",
        }
      }
    },

    sass: {
      compile: {
        options: {
          imagePath: (process.env.APP_ASSET_HOST || "") + "/assets",
          outputStyle: "compressed",
        },

        files: {
          "public/assets/application.css": "public/stylesheets/app.scss"
        }
      }
    },

    filerev: {
      images: {
        cwd: "public/images/",
        src: "**/*.{jpg,gif,png,ico}",
        dest: "public/assets",
        expand: true,
      },

      fonts: {
        cwd: "public/fonts/",
        src: "**/*.{eot,ttf,woff,svg}",
        dest: "public/assets",
        expand: true,
      },

      application: {
        src: [
          "public/assets/application.js",
          "public/assets/application.css",
        ]
      }
    },

    exportrev: {
      assets: {
        options: {
          dest: "public/assets/map.json"
        }
      }
    },

    maprev: {
      assets: {
        src: ["public/assets/*.css"]
      }
    },
  });

  grunt.registerMultiTask("exportrev", function() {
    if (!grunt.filerev) {
      grunt.fail.warn('Could not find grunt.filerev. Required task "filerev" must be run first.');
    }

    // BUG: https://github.com/yeoman/grunt-filerev/issues/15

    var map = {}

    for (var filename in grunt.filerev.summary) {
      map[filename.replace(/public\/(images|fonts|assets)\//, "")] = grunt.filerev.summary[filename].replace("public/assets/", "");
    }

    grunt.filerev.summary = map;

    grunt.file.write(this.options().dest, JSON.stringify(grunt.filerev.summary));
  });

  grunt.registerMultiTask("maprev", function() {
    this.files.forEach(function(file) {
      file.src.filter(function(filepath) {
        if (grunt.file.exists(filepath)) {
          return true;
        } else {
          grunt.log.warn('Source file "' + filepath + '" not found.');
        }
      }).forEach(function(filepath) {
        var content = grunt.file.read(filepath);

        for(var filename in grunt.filerev.summary) {
          content = content.replace(filename, grunt.filerev.summary[filename]);
        }

        grunt.file.write(filepath, content);
      });
    });
  });

  grunt.registerTask("assets:compile", [
    "clean:assets",
    "modernizr:compile",
    "requirejs:compile",
    "sass:compile",
    "filerev",
    "exportrev",
    "maprev",
  ]);

  grunt.registerTask("build:development", [
    "bower:development",
  ]);

  grunt.registerTask("build:production", [
    "bower:production",
    "assets:compile",
  ]);
};
