extends Node

var host # Root for ST ( like Player, Monster, Zombie, Elevator etc. )

func _ready():
	add_to_group( "state" )

func enter():
	pass

func exit():
	pass

func update( delta ):
	pass

func input( event ):
	pass
