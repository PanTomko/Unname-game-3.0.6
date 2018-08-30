extends Node2D

# Siganls

signal change_level_signal(path, id)

#Player entred or iteracted with portal level or teleport to other level
# 

# Data

var main

func _ready():
	# conect portal levels
	for i in get_node( "PoralLevels" ).get_children():
		i.level = self 

func get_portal_position( portal_ID ):
	for i in get_node("PoralLevels").get_children():
		if i.ID == portal_ID:
			return i.get_node("Position2D").global_position