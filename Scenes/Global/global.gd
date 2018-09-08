extends Node

# I hope its just refrence / pointer
var main

func _ready():
	pass

func get_main():
	print( get_tree().get_root().get_node("Main").name )

