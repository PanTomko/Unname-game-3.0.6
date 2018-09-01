extends Node

# signals


# Thread for loading levels
var T1 = Thread.new()
var Mutex1 = Mutex.new()
var T1_loading_done = false

# Data
var current_level = null
var loaded_level = null

var new_level = false
var new_level_data

var player = preload("res://Scenes/Player/Player.tscn").instance()

func _ready():
	change_level_to( ["res://Experiments/LevelExperimental.tscn",0] )
	
	#get_node("CurrentLevelContainer").add_child( player )
	#do_change_level_to( ["res://Experiments/LevelExperimental.tscn",0] )
	pass

func load_level( path ):
	print(" -- T1 : loading level : ", path)
	loaded_level = load( path ).instance()
	
	if loaded_level != null:
		print(" -- T1 : loading over : ", loaded_level)
		
		Mutex1.lock()
		T1_loading_done = true
		Mutex1.unlock()

func is_loading_done():
	
	Mutex1.lock()
	var resul = T1_loading_done
	Mutex1.unlock()
	
	return resul

func clear_loaded_level():
	
	Mutex1.lock()
	
	print("Main : clear loaded level : ", loaded_level)
	
	T1_loading_done = false
	loaded_level = null
	
	Mutex1.unlock()
	


func clear_current_level():
	print("Main : clear current level")
	if current_level != null:
		
		get_node("CurrentLevelContainer").remove_child( player )
		
		current_level.queue_free()
		current_level = null

func clear_rest():
	get_node("CurrentLevelContainer").remove_child( player )

func set_loaded_level():
	# data[0] - path
	# data[1] - portal id
	Mutex1.lock()
	print("Main : set loaded level : ", loaded_level )
	current_level = loaded_level
	Mutex1.unlock()
	

	current_level.connect( "change_level_signal", self, "change_level_to")
	get_node("CurrentLevelContainer").add_child( current_level )
	
	
	player.position = current_level.get_portal_position( new_level_data[1] )
	get_node("CurrentLevelContainer").add_child( player )
	
#	load_level( data[0] )
#
#	current_level = loaded_level
#	loaded_level = null
#
#	get_node("CurrentLevelContainer").add_child( current_level )
#	current_level.connect( "change_level_signal", self, "do_change_level_to")
#
#
#
#
#
#	get_node("CurrentLevelContainer").add_child( player )
#	player.position = current_level.get_portal_position( data[1] )
	pass

func change_level_to(data):
	
	if is_loading_done(): 
		print("Can't start T1, T1 is alredy active !")
		return
	
	print("Main : change level to : ", data[0])
	new_level_data = data
	
	T1.start( self, "load_level", data[0] )
	$GUI.transition_fade_out()
#	if T1.is_active(): T1.wait_to_finish()
#
#	clear_rest()
#	clear_level( current_level )
#
#	T1.start( self, "change_level_to", [data[0],data[1]] )

func _on_GUI_transition_out_done():
	clear_current_level()
	new_level = true

func _process(delta):
	if new_level and is_loading_done():
		set_loaded_level()
		clear_loaded_level()
		$GUI.transition_fade_in()
		new_level = false
		
		T1.wait_to_finish()
	
	if Input.is_action_just_pressed( "ui_accept" ):
		change_level_to( ["res://Experiments/LevelExperimental.tscn",0] )
