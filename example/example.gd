extends CanvasLayer

var RuntimeLoader = preload("res://addons/gdnative-runtime-loader/gdnative_runtime_loader.gd")

onready var label: Label = $CenterContainer/Label

var runtime_loader

var pinger
var ponger

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	runtime_loader = RuntimeLoader.new("res://example/plugins/" if OS.is_debug_build() else "")
	
	runtime_loader.presetup()
	runtime_loader.setup()
	
	pinger = runtime_loader.create_class("pinger", "Pinger")
	if pinger != null:
		print(pinger.ping())
	
	ponger = runtime_loader.create_class("ponger", "Ponger")
	if ponger != null:
		print(ponger.ping())

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		runtime_loader.cleanup()
		runtime_loader.presetup()
		runtime_loader.setup()
		_setup()
	
	label.text = ("Ticks msec: %s\nUnix time: %s" %
		[str(pinger.count_up_msec()) if pinger != null else "pinger not loaded",
		str(ponger.count_up_unix_time()) if ponger != null else "ponger not loaded"])

###############################################################################
# Connections                                                                 #
###############################################################################

###############################################################################
# Private functions                                                           #
###############################################################################

func _setup() -> void:
	pinger = runtime_loader.create_class("pinger", "Pinger")
	if pinger != null:
		print(pinger.ping())
	
	ponger = runtime_loader.create_class("ponger", "Ponger")
	if ponger != null:
		print(ponger.ping())

###############################################################################
# Public functions                                                            #
###############################################################################
