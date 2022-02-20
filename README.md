# GDNative Runtime Loader
[![Chat on Discord](https://img.shields.io/discord/853476898071117865?label=chat&logo=discord)](https://discord.gg/6mcdWWBkrr)

Allows for runtime loading of GDNative libraries for Godot 3.4.x.

Useful for making parts of your game/application optional to users. An example of where this would be useful would be making a lip-sync library optional or using a mock library if it's not available.

### Note
This script is really only useful for exported projects that wish to make some features optional. If possible, you should instead rely on CICD to package your game/app appropriately.

## Limitations
* If a library is **unloaded** at runtime, your game/app will probably crash
* The runtime loader must be used to interact with your library

## Quickstart
1. Copy the `addons/gdnative-runtime-library` directory into your addons folder
2. Create a `plugins` folder at your project root (next to your executable for exported projects)
3. Create a new folder for each of your plugins
4. Add a `config.ini` file for each plugin (e.g. `plugins/my_gdnative_lib/config.ini`)
5. Fill out the `config.ini` (see the `example` project for an example. Note that the `dll`s are not checked into this repository, but you can download the exported release for a runnable example)
6. Create a new `gdnative_runtime_loader.gd` file with an optional `path` arg (By default this searches for a `plugins` folder at your project root, but this can be customized)
7. Call `presetup()` in order to parse the libraries
8. If your library has a custom `init` hook, you will need to pass those args now to the library (e.g. `runtime_loader.libraries["my_lib"].add_init_arg(1))` to add an init arg `1` to a library called `my_lib`)
9. Call `setup()` to initialize each library
10. Create classes defined in your library and use them in your game/app (e.g. `runtime_loader.create_class("my_lib", "foo")` to create a class called `Foo` from the `my_lib` library)

## Example
```gdscript
runtime_loader = RuntimeLoader.new("res://example/plugins/" if OS.is_debug_build() else "")
	
runtime_loader.presetup()
runtime_loader.setup()

pinger = runtime_loader.create_class("pinger", "Pinger")
if pinger != null:
    print(pinger.ping())
```

A full example is provided as a release. The `ponger` library is deliberately misconfigured in order to showcase error handling. It is trivial to fix. If you cannot figure out how to fix `ponger`'s configuration, this library is too advanced for you.
