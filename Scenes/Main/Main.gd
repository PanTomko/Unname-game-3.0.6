extends Node

# signals


# Thread for loading levels
var T1 = Thread.new()
var Mutex1 = Mutex.new()
var T1_loading_done = false

# Main data
enum game_staes { NULL, GAME, MAIN_MENU }
var game_stae = NULL

# Data game
var game = preload("res://Scenes/Game/Game.tscn")
var game_laded = false # need to be done !

var current_level = null
var current_portal_id = -1
var loaded_level = null

var new_level = false
var new_level_data

# Data menu
var main_menu = preload("res://Scenes/Menu/Menu.tscn")

var player = preload("res://Scenes/Player/Player.tscn").instance()

func _ready():
	
	player.connect( "player_took_damage", self, "respawn_player")
	player.connect( "player_zero_life", self, "reset_player")
	
	bring_main_menu()
	#bring_game()
	#change_level_to( ["res://Experiments/LevelExperimental3.tscn",0] )
	pass

func reset_player():
	player.get_node("Health").health = player.get_node("Health").max_health
	change_level_to( ["res://Experiments/LevelExperimental.tscn",0] )

func respawn_player():
	player.position = current_level.get_portal_position( current_portal_id )

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
		
		get_node("Game/CurrentLevelContainer").remove_child( player )
		
		current_level.queue_free()
		current_level = null

func clear_rest():
	get_node("Game/CurrentLevelContainer").remove_child( player )

func set_loaded_level():
	# data[0] - path
	# data[1] - portal id
	Mutex1.lock()
	print("Main : set loaded level : ", loaded_level )
	current_level = loaded_level
	current_portal_id = new_level_data[1]
	Mutex1.unlock()
	
	current_level.connect( "change_level_signal", self, "change_level_to")
	get_node("Game/CurrentLevelContainer").add_child( current_level )
	
	player.position = current_level.get_portal_position( new_level_data[1] )
	player.set_camera( current_level.get_min_pos(), current_level.get_max_pos() )
	get_node("Game/CurrentLevelContainer").add_child( player )

func change_level_to(data):
	
	if is_loading_done(): 
		print("Can't start T1, T1 is alredy active !")
		return
	
	print("Main : change level to : ", data[0])
	new_level_data = data
	
	T1.start( self, "load_level", data[0] )
	get_node("Game/GUI").transition_fade_out()

func _on_GUI_transition_out_done():
	clear_current_level()
	new_level = true

func bring_game():
	
	game_stae = game_staes.GAME
	
	new_level = false
	
	var new_game = game.instance()
	add_child( new_game )
	new_game.get_node("GUI").connect( "transition_out_done", self, "_on_GUI_transition_out_done" )

func bring_main_menu():
	game_stae = game_staes.MAIN_MENU
	
	var new_main_menu = main_menu.instance()
	add_child( new_main_menu )

func remove_main_menu():
	get_node("Menu").queue_free()

func remove_game():
	if T1.is_active(): T1.wait_to_finish()

	clear_current_level()
	clear_loaded_level()
	
	current_level = null
	loaded_level = null
	
	get_node("Game").queue_free()

func _process(delta):
	if new_level and is_loading_done() and game_stae == GAME:
		set_loaded_level()
		clear_loaded_level()
		get_node("Game/GUI").transition_fade_in()
		new_level = false
		
		T1.wait_to_finish()
	
	if Input.is_action_just_pressed( "ui_accept" ) and game_stae == GAME:
		player.get_node( "Health" ).take_damage()
