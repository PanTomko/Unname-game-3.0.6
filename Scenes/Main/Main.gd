extends Node

# signals
signal loading_over

# Thread for loading levels
onready var T1 = Thread.new()

# Data
var current_level = null
var loaded_level

var player = preload("res://Scenes/Player/Player.tscn").instance()

func load_level( path ):
	loaded_level = load( path ).instance()

func clear_level( level ):
	if level != null:
		level.queue_free()

func change_level_to( data):
	# data[0] - path
	# data[1] - portal id
	print("Change")
	load_level( data[0] )
	clear_level( current_level )
	
	current_level = loaded_level
	loaded_level = null
	
	current_level.connect( "change_level_signal", self, "change_level_to")
	get_node("CurrentLevelContainer").add_child( current_level )
	player.position = current_level.get_portal_position( data[1] )

func _ready():
	get_node("CurrentLevelContainer").add_child( player )
	T1.start( self, "change_level_to", ["res://Experiments/LevelExperimental.tscn",0] )