extends Node

var max_health = 3
var health = max_health

func take_damage():
	health -= 1
	
	print(health)
	
	if health == 0:
		get_parent().emit_signal( "player_zero_life")
		return
	
	get_parent().emit_signal( "player_took_damage")
	
	