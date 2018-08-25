# Transition to Idle // InAir

extends "res://Scenes/Player/FSM/SuperStates/direction_state.gd"

var animation_time = 0.0
var pressing = true

func exit():
	animation_time = 0.0
	pressing = true

func enter():
	host.force.y = host.jump_str * host.orientation.y

func update( delta ):
	
	var direction = calc_input_direction_x()

	if animation_time < 0.3 and host.force.y != 0:
		if animation_time < 1.0 and Input.is_action_pressed("ui_up") and pressing:
			host.force.y += host.jump_str * host.orientation.y * delta * host.jump_acceleration_scale
		else:
			pressing = false
			
		host.motion.x += calc_motion( direction, host.movement_speed )
		animation_time += delta
	else:
		if host.force.y == 0:
			get_parent().change_state( "Idle" )
		elif get_parent().is_in_air():
			pass


