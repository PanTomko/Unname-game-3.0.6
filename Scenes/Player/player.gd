extends KinematicBody2D

# states = "state name" : Object of state type
# current state = state["walk_left"]

enum player_types { NULL, P1, P2 }
var player_type = player_types.NULL

var orientation = Vector2( 0, -1 ) 
const ZERO = Vector2( 0, -1 ) 
var gravity = Vector2( 0, 98*10 )

# Jumping state needs
var movement_speed = 200
var jump_str = 300
var jump_acceleration_time = 1
var jump_acceleration_scale = 3.5

var can_jump = false
var can_double_jump = false

# For physic simulation
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
		can_jump = true
		can_double_jump = true
		force.y = 0.0
	
	if is_on_ceiling():
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
	

func set_camera(min_pos, max_pos):
	
	get_node("Camera2D").limit_left = min_pos.x
	get_node("Camera2D").limit_top = min_pos.y
	
	get_node("Camera2D").limit_right = max_pos.x
	get_node("Camera2D").limit_bottom = max_pos.y