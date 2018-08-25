extends "res://Scenes/Player/FSM/SuperStates/direction_state.gd"

# if or not is in this state is check in state machine updated

func update( delta ):
	var direction = calc_input_direction_x()
	host.motion.x += calc_motion( direction, host.movement_speed )