tool
extends Button

var button_cout = 0

func _ready():
	connect( "pressed", self, "pressed_generate")

func pressed_generate():
	var size = Vector2( int(get_node("../../VBoxContainer/HBoxContainer/X_parametr").text), int(get_node("../../VBoxContainer/HBoxContainer/Y_parametr").text))
	get_parent().get_parent().get_parent().emit_signal( "generate", size )
