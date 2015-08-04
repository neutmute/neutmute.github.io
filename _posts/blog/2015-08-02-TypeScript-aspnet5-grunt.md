---
layout: post
title: 'How to setup TypeScript and ASP.NET 5 DNX with grunt'
categories:
- blog
- aspnet-5
tags: 
- grunt
- typescript
- aspnet-5
- dnx
- vnext
excerpt: Notes on setting up TypeScript in an ASP.NET 5 solution
---
I didn't find a lot of documentation on how to setup TypeScript in an ASP.NET 5 project. This is how I did it with grunt and ASP.NET 5 Beta 6. If you know of a better method, comments welcome. 

The TypeScripts are located in `wwwroot/typescript`. Intitially I had them in `$\Scripts` and used grunt to copy them to `wwwroot` but then Visual Studio sees two copies of every `*.ts` file and the TypeScript compiler complains about duplicates.

![Scripts folder](/assets/img/blog/20150802/sln.png)  

We could keep the TypeScript in `$\Scripts` and copy the `*.js` to `wwwroot` with grunt, but then we lose the benefit of sourcemaps and stepping through TypeScript in the browser. 

### Project Open Task ###

First things first, lets ensure the [tsd package manager](http://definitelytyped.org/tsd/) is firing when the project opens and downloads any missing type definitions. Add a reference to `grunt.loadNpmTasks("grunt-tsd");` in your `gruntfile.js` and a matching task:


        tsd: {
            refresh: {
                options: {
                    command: 'reinstall',
                    latest: false,
                    config: 'tsd.json',
                    // experimental: options to pass to tsd.API
                    opts: {
                        // props from tsd.Options
                    }
                }
            }
        },

Add a new `tsd.json` to your project root. It might look like this where I am referencing Angular.

	{
	  "version": "v4",
	  "repo": "borisyankov/DefinitelyTyped",
	  "ref": "master",
	  "path": "wwwroot/typescript/typings",
	  "bundle": "wwwroot/typescript/typings/tsd.d.ts",
	  "installed": {
	    "angularjs/angular.d.ts": {
	      "commit": "4df20c9706ce6ca27137617770b57f3a0d3f9689"
	    },
	}

Now you can use the `tsd` console application to install type definitions. I ignore these `*.d.ts` files in git. 

### Compile time tasks ###

Add a `grunt.loadNpmTasks("grunt-contrib-clean");` then make sure our javascript is kept nice and clean. I guess this is optional.

      clean: {
            typescriptJS: ["wwwroot/typescript/**/.js"]
            ,appJS: ["wwwroot/assets/app*.js"]
        },
    

Next we add a `grunt.loadNpmTasks("grunt-typescript");` task:

    typescript: {
            webui: {
                src: ['wwwroot/typescript/**/*.ts'],
                dest: 'wwwroot/assets/app-ts-full.js',
                options: {
                    module: 'amd', //or commonjs 
                    target: 'es5', //or es3
                    sourceMap: true,
                    declaration: false
                }
            }
        },

This is compiling and concatenating the TypeScript into a single JavaScript file: `wwwroot/assets/app-ts-full-js` which we can reference in our `Shared/Layout.cshtml`.

In the TypeScript options we set `sourceMap=true` so that the browser can use load them and allow us to step through TypeScript in the browser with F12 tools. 

This does mean a double compile since Visual Studio compiles TypeScript but it doesn't take long on my solution. I wasn't sure whether `concat` would honour the individual sourcefiles, so that is another reason I did it this way.

At this point we now have TypeScript, JavaScript and sourcemaps being compiled and created off `wwwroot` on every project build. What if we want to simply edit a TypeScript file and hit F5 in the browser?

### Another Project Open Task ###

Lets watch the TypeScript source folder with 
    `grunt.loadNpmTasks('grunt-contrib-watch');`

	watch: {
	    typescript: {
	        files: ['wwwroot/typescript/**/*.ts'],
	        tasks: ['typeScript']
        }
    }

One final trick is that you will note the `zzApp` folder in my folder structure (see screenshot above). This holds `app.ts` which forces my angular modules to register last otherwise I had runtime errors in the browser when the app is trying to load modules that are yet to be parsed in the JavaScript file.  

### TLDR - Complete gruntfile.js

Pulling it all together, here is the final `gruntfile.js`. Notice how the first line is `binding` tasks to Visual Studio events.
In the real world, you probably also want to copy your `bower` references to `wwwroot`, which you also see below.

	/// <binding AfterBuild='postBuild' ProjectOpened='projectOpen' />
	/*
	This file in the main entry point for defining grunt tasks and using grunt plugins.
	Click here to learn more. http://go.microsoft.com/fwlink/?LinkID=513275&clcid=0x409
	*/
	module.exports = function(grunt) {
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks("grunt-typescript");
    grunt.loadNpmTasks("grunt-tsd");

    grunt.initConfig({

        typescript: {
            webui: {
                src: ['wwwroot/typescript/**/*.ts'],
                dest: 'wwwroot/assets/app-ts-full.js',
                options: {
                    module: 'amd', //or commonjs 
                    target: 'es5', //or es3
                    sourceMap: true,
                    declaration: false
                }
            }
        },

        tsd: {
            refresh: {
                options: {
                    command: 'reinstall',
                    latest: false,
                    config: 'tsd.json',
                    // experimental: options to pass to tsd.API
                    opts: {
                        // props from tsd.Options                    
                    }
                }
            }
        },

   		copy: {
            bowerDist: {
                src: 'bower_components/**/dist/*',
                dest: 'wwwroot/assets/lib/',
                expand: true,
                flatten: true
            }
        },

        watch: {
            typescript: {
                files: ['wwwroot/typescript/**/*.ts'],
                tasks: ['typeScript']
            }
        }
    });

    grunt.registerTask('postBuild', ['typescript']);
    grunt.registerTask('projectOpen', ['tsd', 'copy', 'watch']);
	};

Now with our JavaScript sourceMaps we can browse to TypeScript source and hit breakpoints in our application. Happy days!

![Scripts folder](/assets/img/blog/20150802/break.png)

Lastly, if you want to minify your `app-ts-full.js`, there is no bundling anymore. Just throw in an `uglify` grunt task to make a `app-ts-min.js`.