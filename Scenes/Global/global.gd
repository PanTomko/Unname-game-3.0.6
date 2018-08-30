extends Node

# Here will teak place of :
# - loading levels
# - bringing / removing Menu
# - handling puse
# - teak care of all time loded data ( player )

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func load_level( path ):
	#var new_level = load( path ).instance()
	yield( get_tree().create_timer(5.0), "timeout")
	print("Loaded")
