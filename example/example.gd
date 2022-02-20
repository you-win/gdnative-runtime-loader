extends CanvasLayer

var Hotloader = preload("res://addons/gdnative_hotloader/gdnative_hotloader.gd")

onready var label: Label = $CenterContainer/Label

var hotloader

var pinger
var ponger

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	hotloader = Hotloader.new("res://example/plugins/" if OS.is_debug_build() else "")
	
	hotloader.presetup()
	hotloader.setup()
	
	pinger = hotloader.create_class("pinger", "Pinger")
	if pinger != null:
		print(pinger.ping())
	
	ponger = hotloader.create_class("ponger", "Ponger")
	if ponger != null:
		print(ponger.ping())

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		hotloader.cleanup()
		hotloader.presetup()
		hotloader.setup()
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
	pinger = hotloader.create_class("pinger", "Pinger")
	if pinger != null:
		print(pinger.ping())
	
	ponger = hotloader.create_class("ponger", "Ponger")
	if ponger != null:
		print(ponger.ping())

###############################################################################
# Public functions                                                            #
###############################################################################
