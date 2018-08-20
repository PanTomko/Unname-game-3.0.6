extends "res://Scenes/Player/FSM/SuperStates/direction_state.gd"

func update( delta ):
	var direction = calc_input_direction_x()
	
	# moves player in x direction of movement_speed p/s
	if direction != 0:
		
		if get_parent().is_in_air(delta):
			pass
		elif Input.is_action_pressed( "ui_up" ):
			get_parent().change_state( "Jumping" )
		else:
			host.motion.x += calc_motion( direction, host.movement_speed )
		
	else:
		get_parent().change_state( "Idle" )