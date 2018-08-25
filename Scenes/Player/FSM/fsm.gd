extends Node

#var states_pool = { state_name = state }
onready var current_state = get_node("Idle")
var host

func set( data_host ):
	host = data_host
	
	for i in get_children():
		i.host = host

func update( delta ):
	
	# Ducking kind of
	if Input.is_action_pressed( "ui_down" ):
		host.set_collision_mask_bit( 1, false )
	else:
		host.set_collision_mask_bit( 1, true )
	
	# Chacking if player is in InAir state
	if current_state.name != "Jumping":
		is_in_air()

func is_in_air(delta = 0):
	if !host.is_on_floor():
		if current_state.name != "InAir": change_state( "InAir", delta )
		return true
	else:
		if current_state.name == "InAir": change_state( "Idle", delta )
		return false

func change_state( name, delta = 0 ):
	
	# check if state exist
	if !has_node( name ):
		print(" Cant find ", name, "!")
	
	# exit current state
	current_state.exit()
	
	# change state to new one
	print( "New state : ", current_state.name," --> ", name )
	current_state = get_node( name )

	
	# enter new state
	current_state.enter()
	current_state.update( delta )
	

func has_state():
	pass