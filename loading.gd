extends Node

onready var T1 = Thread.new()

signal on_load_done

func _ready():
	connect( "on_load_done", self, "set_load")
	T1.start(self, "load_long", 10)
	print("Noice1")

func load_long( data ):
	lol()
	call_deferred()
	print("Noice3")
	#emit_signal("on_load_done")
	pass

func lol():
	yield( get_tree().create_timer(5.0), "timeout")
	print("Noice2")

func set_load():
	print("Noice")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
