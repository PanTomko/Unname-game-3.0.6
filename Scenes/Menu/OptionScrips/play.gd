extends "res://Scenes/Menu/option.gd"

var active = true

func action():
	if active:
		active = false
		main.bring_game()
		main.change_level_to( ["res://Experiments/LevelExperimental3.tscn",0] )
		main.remove_main_menu()