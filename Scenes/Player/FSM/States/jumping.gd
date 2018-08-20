extends "res://Scenes/Player/FSM/SuperStates/direction_state.gd"

var animation_time = 0.0

func exit():
	animation_time = 0.0

func enter():
	animation_time = 0.0
	host.force.y = -300
	pass

func update( delta ):
	
	var direction = calc_input_direction_x()

	if animation_time < 0.3 and host.force.y != 0:
		if animation_time < 0.2 and Input.is_action_pressed("ui_up") :
			host.force.y -= host.jump_str * delta 
			print("as")
			
		host.motion.x += calc_motion( direction, host.movement_speed )
		animation_time += delta
	else:
		if host.force.y == 0:
			get_parent().change_state( "Idle" )
		elif get_parent().is_in_air():
			pass


