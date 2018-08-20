extends "res://Scenes/Player/FSM/SuperStates/direction_state.gd"

func update( delta ):
	var direction = calc_input_direction_x()
	
	if !get_parent().is_in_air():
		get_parent().change_state( "Idle" )
	else:
		# moves player in x direction of movement_speed p/s
		host.motion.x += calc_motion( direction, host.movement_speed )