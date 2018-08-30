tool
extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect( "pressed", self, "em_gen_set")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func em_gen_set():
	get_parent().get_parent().get_parent().emit_signal( "gen_set" )