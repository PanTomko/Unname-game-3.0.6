extends Node

#var states_pool = { state_name = state }
onready var current_state = get_node("Idle")
var host

func set( data_host ):
	host = data_host
	
	for i in get_children():
		i.host = host

func update( delta ):
	pass

func is_in_air(delta = 0):
	if !host.is_on_floor():
		if current_state.name != "InAir": change_state( "InAir", delta )
		return true
	else:
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