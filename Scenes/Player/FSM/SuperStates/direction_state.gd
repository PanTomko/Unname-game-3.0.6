extends "res://Scenes/Player/FSM/SuperStates/state.gd"

# calculate motion vector
func calc_motion(direction, movement_speed):
	return direction * movement_speed

# returns direction
func calc_input_direction_x():
	
	var direction = 0
	
	if Input.is_action_pressed( "ui_left" ):
		direction = -1
	elif Input.is_action_pressed( "ui_right" ):
		direction = 1
	else:
		direction = 0
	
	return direction