extends "res://Scenes/Player/FSM/SuperStates/direction_state.gd"

# Transition to Jumping // Idle // InAir

func update( delta ):
	var direction = calc_input_direction_x()
	
	# moves player in x direction of movement_speed p/s
	if direction != 0:
		if Input.is_action_just_pressed( "ui_up" ) and (host.can_jump or host.can_double_jump):
			get_parent().change_state( "Jumping" )
		else:
			host.motion.x += calc_motion( direction, host.movement_speed )
		
	else:
		get_parent().change_state( "Idle" )
