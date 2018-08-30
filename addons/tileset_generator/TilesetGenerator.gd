tool
extends CenterContainer

signal generate( size )
signal copy_tex
signal gen_set

# data
var texture_item_packed = preload("res://addons/tileset_generator/TextureItem.tscn")
var textures = {}
var texture_count = 0

func _ready():
	connect( "gen_set", self, "do_gen_setup")
	connect( "copy_tex", self, "do_copy_tex")

func can_drop_data(position, data):
	return true

func do_copy_tex():
	# Scene root have to be Node2D
	if get_tree().get_edited_scene_root().get_class() != "Node2D":
		print( "Scene have to be Node2D Class !" )
		return
	
	# loop thro all sub noddse and look for -tex 
	for i in get_tree().get_edited_scene_root().get_children():
		var node_name = i.name # get name
		
		if node_name.find("-tex"):
			add_item_tex( i.get_child( 0 ).texture.resource_path )

func drop_data(pos, data):
	add_item_tex( data.files[0] )
#	get_node("VBoxContainer/TextureRect").texture = instance_item.texture

func add_item_tex( load_path ):
		
	var file_name = ""
	var start_pos =  load_path.length() - 1
	
	while (true):
		
		if load_path[start_pos] == "/":
			file_name = load_path.substr(start_pos + 1, load_path.length() - 1)
			break
			
		start_pos -= 1
	
	if textures.has(file_name):
		print("Dupicate texture : " + file_name)
	else:
		textures[file_name] = load( load_path)
		var instance_item = texture_item_packed.instance()
		
		instance_item.get_node("Label").text = file_name
		instance_item.connect("clear_item", self, "clear_tex")
		
		get_node("VBoxContainer/CenterContainer/MarginContainer/TextureContainer").add_child( instance_item )
		texture_count += 1
		print("Add texture : " + file_name)

func generate_auto():
	var root = get_tree().get_edited_scene_root()
	for i in root.get_children():
		for ii in i.get_children():
			if ii.will_export == true:
				
				# generate body
				if ii.gen_body && get_node("VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/gen_body").pressed:
					var new_body = StaticBody2D.new()
					ii.add_child( new_body )
					new_body.set_owner( root )
					
				# generate shape
				if ii.gen_polygon_shape && get_node("VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/gen_shape"):
					if ii.has_node("StaticBody2D"):
						var new_shape = CollisionPolygon2D.new()
						ii.get_node("StaticBody2D").add_child( new_shape )
						new_shape.set_owner( root )
				
				# generate navigation [ UNDER WORK !]
				

func do_gen_setup():
	get_node("VBoxContainer/Buttons2/FileDialog").popup()

func do_gen_set( save_dir ):
	if save_dir == null or save_dir  == "":
		print( "Directory dont exist !" )
		return
	
	if get_tree().get_edited_scene_root().get_class() != "Node2D":
		print( "Scene have to be Node2D Class !" )
		return
	
	for i in get_tree().get_edited_scene_root().get_children():
		
		
		# data
		var res_textures = []
		var res_id = 0
		var data_res = ""
		
		var sub_res = []
		var data_sub = ""
		var sub_id = 0
		
		var data_tiles = "[resource]\n\n"
		var data_head = ""
		
		# get file name
		var node_name = i.name
		var tmp = node_name.length()
		node_name.erase( tmp - 4, 4)
		
		# make file
		var file = File.new()
		file.open( save_dir + "/" + node_name + "-tileset.tres", File.WRITE )
		
		# make hader 
		var load_steps = 1 # starting form 1 becuse you alwasy have nodes as tile [resource]
		var load_format = 2
		
		# loop childrens
		var tile_id = 0
		
		print("making : " + save_dir + "/" + node_name + "-tileset.tres")
		
		# all tiles in texture
		for ii in i.get_children():
			
			if ii.will_export == false:
				continue
			
			var have_shape = false
			var shape_node
			
			# some shapes ?
			if ii.get_child_count() > 0:
				if ii.get_child( 0 ).get_child_count() > 0:
					have_shape = true
					shape_node = ii.get_child( 0 ).get_child( 0 )
					
					# print type
					if !sub_res.has( shape_node ):
						
						sub_id += 1
						load_steps +=1
						sub_res.push_back( shape_node )
						
						if shape_node.get_class() == "CollisionPolygon2D":
							data_sub += '[sub_resource type="ConvexPolygonShape2D" id=' + str(sub_id) + "]\n\n"
							data_sub += "custom_solver_bias = 0.0\n"
							data_sub += 'points = PoolVector2Array( '
							for i in shape_node.polygon:
								data_sub += str(i.x) + ", " + str(i.y) + ", " 
							data_sub += ")\n\n"
						elif shape_node.get_class() == "CollisionShape2D":
							data_sub += '[sub_resource type="CircleShape2D" id=' + str(sub_id) + "]\n\n"
							data_sub += "custom_solver_bias = 0.0\n"
							data_sub += "radius = " + str(float(shape_node.shape.radius)) + "\n\n"
			
			# some new textures ?
			if !res_textures.has( ii.texture ):
				res_textures.push_back( ii.texture )
				res_id += 1
				load_steps += 1
				var tex_path = ii.texture.resource_path
				data_res += '[ext_resource path="' + tex_path + '" type="Texture" id=' + str(res_id) + ']'
			
			
			# tile name
			data_tiles += str(tile_id) + "/name = " + '"' + ii.name + '"' + "\n"
			
			# tile tex
			data_tiles += str(tile_id) + "/texture = ExtResource( " + str( res_textures.find( ii.texture ) + 1 ) + " )" + "\n"
			
			# tile tex offset
			data_tiles += str(tile_id) + "/tex_offset = Vector2" + str(ii.offset) + "\n"
			
			# tile color module
			data_tiles += str(tile_id) + "/modulate = Color( " + str(ii.modulate) + " )\n"
			
			# tile region
			data_tiles += str(tile_id) + "/region = Rect2" + str(ii.region_rect) + "\n"
			
			# tile mode
			# data_tiles += str(tile_id) + "/tile_mode = 0\n"
			data_tiles += str(tile_id) + "/is_autotile = false\n"
			
			# tile occluder_offset
			var tileSize = getTileSize() / 2
			data_tiles += str(tile_id) + "/occluder_offset = Vector2" + str(tileSize) + "\n"
			data_tiles += str(tile_id) + "/navigation_offset = Vector2" + str(tileSize) + "\n"
			
			# time shapes [ UNDER WORK !]
			if have_shape == false:
				data_tiles += str(tile_id) + "/shapes = [  ]\n"
			else:
				if shape_node.get_class() == "CollisionPolygon2D" || shape_node.get_class() == "CollisionShape2D":
					data_tiles += str(tile_id) + "/shapes = [ {\n"
					data_tiles += '"autotile_coord": Vector2( 0, 0 ),\n'
					data_tiles += '"one_way": ' + str(shape_node.one_way_collision) + ",\n"
					data_tiles += '"shape": SubResource(' + str(sub_res.find(shape_node) + 1) + '),\n'
					data_tiles += '"shape_transform": Transform2D( 1, 0, 0, 1, ' + str(tileSize.x) + ", " + str(tileSize.y) +' )\n'
					data_tiles += "} ]\n"
			
			# tile z-index (3.1)
			#data_tiles += str(tile_id) + "/z_index = " + str( ii.z_index ) + "\n"
			
			# tile on last
			tile_id += 1
		
		# save tile data !!!
		file.store_line( '[gd_resource type="TileSet" load_steps=' + str(load_steps) + ' format=' + str(load_format) + ']')
		file.store_line("")
		
		file.store_string( data_res + "\n\n" )
		file.store_string( data_sub )
		file.store_string( data_tiles )
		
		# close file
		file.close()

func getTileSize():
	var x = int(get_node("VBoxContainer/VBoxContainer/HBoxContainer/X_parametr").text)
	var y = int(get_node("VBoxContainer/VBoxContainer/HBoxContainer/Y_parametr").text)
	return Vector2( x, y )

func clear_tex( key ):
	textures.erase( key )
	texture_count -= 1
	print(textures)

func _on_FileDialog_confirmed():
	do_gen_set( get_node("VBoxContainer/Buttons2/FileDialog").current_dir )
