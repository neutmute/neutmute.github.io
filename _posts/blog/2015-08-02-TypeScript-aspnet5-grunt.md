---
layout: post
title: 'How to setup TypeScript, ASP.NET 5 (vNext) with grunt'
categories:
- blog
- aspnet-5
tags: 
- grunt
- typescript
- aspnet-5
excerpt: Notes on setting up TypeScript in an ASP.NET 5 solution
---
I didn't find a lot of documentation on how to setup TypeScript in an ASP.NET 5 project. This is how I did it with grunt and ASP.NET 5 Beta 6. If you know of a better method, comments welcome. 

TheTypeScripts are created in a `Scripts` folder off the project root:

![Scripts folder](/assets/img/blog/20150802/sln.png)

Now when the TypeScript compiles the `*.ts` into `*.js`, it is left in these folders which are not served. We need these files placed into `wwwroot`.
Grunt will be used to get the files into their final locations.

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
	  "path": "Scripts/typings",
	  "bundle": "Scripts/typings/tsd.d.ts",
	  "installed": {
	    "angularjs/angular.d.ts": {
	      "commit": "4df20c9706ce6ca27137617770b57f3a0d3f9689"
	    },
	}

Now you can use the `tsd` console application to install type definitions. I ignore these `*.d.ts` files in git. 

### Compile time tasks ###

Add a `grunt.loadNpmTasks("grunt-contrib-copy");`, then a copy task:

      copy: {
	    typescript: {
	    src: 'Scripts/**/*.ts',
	    dest: 'wwwroot/assets/typescript',
	    expand: true,
	    flatten: false
	    }
    },
    
Notice that we aren't copying the JavaScript but the TypeScript files.

Next we add a `grunt.loadNpmTasks("grunt-typescript");` task:

    typescript: {
	    webui: {
			src: ['wwwroot/assets/typescript/**/*.ts'],
			dest: 'wwwroot/app-ts-full.js',
			options: {
			module: 'amd', //or commonjs 
			target: 'es5', //or es3
			sourceMap: true,
			declaration: false
			}
		}
    }

This is compiling and concatenating the TypeScript into a single JavaScript file in our app root: `app-ts-full-js` which we can reference in our `Shared/Layout.cshtml`.

In the options we set `sourceMap=true`. This is why we copied the TypeScript and not simply the compiled JavaScript to `wwwroot`. TypeScript files in `$(projectDir)` can't get served to the browser, they need to be in  `$(projectDir)/wwwroot` to be visible so that we can step through TypeScript source with F12 tools. This method in a double compile since Visual Studio compiles TypeScript but it doesn't take long on my solution.

At this point we now have TypeScript, JavaScript and sourcemaps being copied and compiled to `wwwroot` at compile time. What if we want to simply edit a TypeScript source file and hit F5 in the browser though?

### Another Project Open Task ###

Lets watch the TypeScript source folder with 
    `grunt.loadNpmTasks('grunt-contrib-watch');`

	watch: {
	        typescript: {
	            files: ['Scripts/**/*.ts'],
	            tasks: ['typeScriptChanged']
	        }
	    }

now define the `typeScriptChanged` task as

	grunt.registerTask('typeScriptChanged', ['copy:typescript', 'typescript']);


One final trick is that you will note the `zzApp` folder in my folder structure (see screenshot). This holds `app.ts` which forces my angular modules to register last otherwise I had runtime errors in the browser when the app is trying to load modules that are yet to be parsed in the JavaScript file.  

### TLDR - Complete gruntfile.js

Pulling it all together, here is the final `gruntfile.js`. Notice how the first line is `binding` tasks to Visual Studio events.

	/// <binding AfterBuild='postBuild' ProjectOpened='projectOpen' />
	module.exports = function (grunt) {
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks("grunt-contrib-copy");
    grunt.loadNpmTasks("grunt-typescript");
    grunt.loadNpmTasks("grunt-tsd");

    grunt.initConfig({

	        typescript: {
	            webui: {
	                src: ['wwwroot/assets/typescript/**/*.ts'],
	                dest: 'wwwroot/app-ts-full.js',
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
	            typescript: {
	                src: 'Scripts/**/*.ts',
	                dest: 'wwwroot/assets/typescript',
	                expand: true,
	                flatten: false
	            }
	        },
	        	
	        watch: {
	            typescript: {
	                files: ['Scripts/**/*.ts'],
	                tasks: ['typeScriptChanged']
	            }
	        }
	    });
	    
	    grunt.registerTask('postBuild', ['typeScriptChanged']);
	    grunt.registerTask('projectOpen', ['tsd', 'watch']);
	    grunt.registerTask('typeScriptChanged', ['copy:typescript', 'typescript']);
	};

Now with our JavaScript sourceMaps we can browse to TypeScript source and hit breakpoints in our application. Happy days!
![Scripts folder](/assets/img/blog/20150802/break.png)