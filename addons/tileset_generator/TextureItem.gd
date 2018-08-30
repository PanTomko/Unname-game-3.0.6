tool
extends HBoxContainer

signal clear_item( key )

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Delete_pressed():
	emit_signal( "clear_item", get_node("Label").text)
	queue_free()
