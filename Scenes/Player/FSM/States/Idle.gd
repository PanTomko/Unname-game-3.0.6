extends "res://Scenes/Player/FSM/SuperStates/direction_state.gd"

func update( delta ):
	var direction = calc_input_direction_x()
	
	if direction == 0:
		
		# Are we still idle ?
		if get_parent().is_in_air(delta):
			pass
		elif Input.is_action_pressed( "ui_up" ):
			get_parent().change_state( "Jumping", delta )
		else:
			# Yes we are
			pass
	else:
		get_parent().change_state( "Walking", delta )
		#get_parent().current_state.update( delta )
	