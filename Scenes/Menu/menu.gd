extends MarginContainer

# Data

var current_position = 0

func _ready():
	set_position(0)

func _process(delta):
	
	if Input.is_action_just_pressed( "ui_accept" ):
		get_node( "Options" ).get_child( current_position ).action()
	
	if Input.is_action_just_pressed( "ui_down" ) :
		set_position( current_position + 1 )
	elif Input.is_action_just_pressed( "ui_up" ) :
		set_position( current_position - 1 )

func set_position( pos ):
	if pos >= 0 and pos < get_node( "Options" ).get_child_count() :
		
		get_node( "Options" ).get_child( current_position ).modulate = Color( "#ffffff" )
		get_node( "Options" ).get_child( pos ).modulate = Color( "#40c35d" )
		
		current_position = pos
