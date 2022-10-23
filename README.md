## GTK+ 3 Glade C Template

The project is meant to be an easy yet minimal starting point for any GTK+ 3 project. Initial setup is just setting your project name and other info in config.mk. Resources are integrated into the executable using GResource. More complete documentation [here.](https://github.com/Trainraider/gtk3-glade-c-template/wiki)

___
### Getting Started:
GTK+ 3.0 library headers and Make are required to build this project. Glade is needed to edit the user interface. GCC or Clang is probably required. This hasn't been tested with Windows and probably isn't portable there yet.

Debian or Ubuntu based linux distro:

```
$ sudo apt install libgtk-3-dev glade
```

The project can be configured in config.mk to set the project's version, name etc. These are then made available to the program as macros, so you never need these things listed in multiple places.

The following macros are available to the C source files:

    VERSION   //The project's version number
	TARGET    //Name without spaces/ executable name
    NAME      //The project's name
    AUTHOR    //Your name
	APP_ID    //Your email/website and app name in reverse url format
	          //  e.g. com.gmail.johndoe.myapp
	APP_PREFIX//APP_ID with forward slashes instead of periods. Used for
	          //  getting resources
			  //  e.g. /com/gmail/johndoe/myapp
    COPYRIGHT //A copyright message e.g. "Copyright (c) 2021"


___
#### To build the project, simply run:

	$ make
___
#### To build a debug version with lots of warnings and protections enabled:

	$ make debug
___
#### To install the resulting application run (as root):

	$ sudo make install
___
#### To uninstall (as root):
	
	$ sudo make uninstall
___
#### You are encouraged to format your code (clang-format required) by running:

	$ make format
___
#### You can clean up project files with:

	$ make clean

___

### Hello World Tutorial:

Edit source/main.c.
At the bottom of the file, add the following lines:

```
void hello_world()
{
    printf("Hello world!");
}
```

* Now open window_main.glade with Glade.
* Click the "Control" button.
* Click GtkButton, then click the blank window in the editor.

* on the "Signals" tab.
In the row that says "clicked", and the column labled "Handler",
type the name of our new function from main.c, hello_world.
* save window_main.glade

* Now from inside the root directory of this project, run:
```
    $ make
    $ ./build/bin/template_app
```
"Hello world!" will print in the terminal every time the window is clicked.

The following more in-depth tutorial was referenced by this project
and is recommended:
https://prognotes.net/gtk-glade-c-programming/

That link died, here's an archived version:
https://web.archive.org/web/20210628084247/https://prognotes.net/gtk-glade-c-programming/
