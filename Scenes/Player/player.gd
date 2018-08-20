extends KinematicBody2D

# states = "state name" : Object of state type
# current state = state["walk_left"]

enum player_types { NULL, P1, P2 }
var player_type = player_types.NULL

var orientation = Vector2( 0, -1 ) 
const ZERO = Vector2( 0, -1 ) 

var gravity = Vector2( 0, 98*6 )

var movement_speed = 200
var jump_str = 1000

var motion = ZERO
var force = ZERO
var directio

func _ready():
	print("Player _ready.")
	print("  - player_type = ", player_type)
	
	# FSM setup
	get_node("FSM").set( self )
	print("  - FSM seter")

func _physics_process(delta):
	
	if is_on_floor():
		force.y = 0.0
	
	# update FSM
	get_node( "FSM" ).update( delta )
	get_node( "FSM" ).current_state.update( delta )
	
	# applay gravity force
	force += gravity * delta
	
	# final motion + force
	motion += force
	
	# proces motion
	move_and_slide( motion, orientation )
	
	
	
	# clear motion
	motion = ZERO

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

