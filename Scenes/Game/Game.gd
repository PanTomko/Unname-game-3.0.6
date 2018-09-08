extends Node

func _process(delta):
	if Input.is_action_just_pressed( "ui_cancel" ):
		var main = get_parent()
		main.bring_main_menu()
		main.remove_game()