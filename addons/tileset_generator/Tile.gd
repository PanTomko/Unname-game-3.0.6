tool
extends Sprite

export var will_export = true setget set_will_export
export var gen_body = true
export var gen_polygon_shape = true

export(int) var id

func _ready():
	region_enabled = true

func set_will_export( value ):
	if value:
		modulate = Color( "#ffffff" )
	else:
		modulate = Color( "#000000" )
	
	will_export = value

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
