extends "res://addons/gut/test.gd"

# https://github.com/bitwes/Gut/wiki/Quick-Start

###############################################################################
# Builtin functions                                                           #
###############################################################################

func before_all():
	pass

func before_each():
	pass

func after_each():
	pass

func after_all():
	pass

###############################################################################
# Utils                                                                       #
###############################################################################

###############################################################################
# Tests                                                                       #
###############################################################################

const LOADER := preload("res://addons/gdnative-runtime-loader/gdnative_runtime_loader.gd")

const TEST_PLUGINS_PATH := "res://tests/test_plugins/"

func test_scan():
	var test_plugins_path := ProjectSettings.globalize_path(TEST_PLUGINS_PATH)

	# Using constructor
	var loader0 = LOADER.new(test_plugins_path)
	
	assert_eq(loader0.scan(), OK)

	assert_true(loader0.libraries.has("pinger"))
	
	var pinger_lib = loader0.libraries["pinger"]

	assert_false(pinger_lib.is_initialized)
	assert_eq(pinger_lib.native_classes.size(), 1)
	assert_true(pinger_lib.native_classes.has("Pinger"))
	assert_true(pinger_lib.native_classes["Pinger"] is NativeScript)

	var lib_names = loader0.get_library_names()

	assert_eq(lib_names.size(), 1)
	assert_eq(lib_names[0], "pinger")

	# Ponger is not configured properly
	assert_false(loader0.libraries.has("ponger"))
	
	# Changing search path after construction
	var loader1 = LOADER.new()
	loader1.search_path = test_plugins_path

	assert_eq(loader1.scan(), OK)

	assert_true(loader1.libraries.has("pinger"))

	assert_false(loader1.libraries["pinger"].is_initialized)

func test_process_folder():
	var loader = LOADER.new()

	assert_eq(
		loader.process_folder(ProjectSettings.globalize_path("res://tests/test_plugins/pinger/")),
		OK
	)
	assert_true(loader.libraries.has("pinger"))
	
	var pinger_lib = loader.libraries["pinger"]

	assert_false(pinger_lib.is_initialized)
	assert_eq(pinger_lib.native_classes.size(), 1)
	assert_true(pinger_lib.native_classes.has("Pinger"))
	assert_true(pinger_lib.native_classes["Pinger"] is NativeScript)

# We can only run this test once. Unloading and reloading binaries at runtime tends to cause
# a hard crash
func test_setup_and_run():
	# We cannot automatically test setting up and using a library using github actions because
	# the required binaries are not checked into git. We could commit the binaries but that's
	# extremely bad practice
	var env = OS.get_environment("TEST_ENV")
	if env == null or env.empty():
		return
	
	var loader = LOADER.new(ProjectSettings.globalize_path(TEST_PLUGINS_PATH))
	
	assert_eq(loader.scan(), OK)
	
	assert_false(loader.libraries["pinger"].is_initialized)
	
	loader.setup()
	
	assert_true(loader.libraries["pinger"].is_initialized)

	var pinger = loader.create_class("pinger", "Pinger")

	assert_not_null(pinger)
	assert_not_null(pinger.count_up_msec())
	
	var unsafe_pinger = loader.create_class_unsafe("pinger", "Pinger")
	
	assert_has_method(unsafe_pinger, "ping")
	assert_has_method(unsafe_pinger, "count_up_msec")
	
	loader.cleanup()
	
	assert_eq(loader.libraries.size(), 0)
	
	var bad_pinger = loader.create_class("pinger", "Pinger")
	
	assert_null(bad_pinger)
