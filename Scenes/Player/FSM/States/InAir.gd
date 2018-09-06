extends "res://Scenes/Player/FSM/SuperStates/direction_state.gd"

# if or not is in this state is check in state machine updated

func update( delta ):
	if Input.is_action_just_pressed( "ui_up" ) and (host.can_jump or host.can_double_jump):
		get_parent().change_state( "Jumping" )
		return
	
	var direction = calc_input_direction_x()
	host.motion.x += calc_motion( direction, host.movement_speed )