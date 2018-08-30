tool
extends EditorPlugin

var dock
var button

func _enter_tree():
	
	add_custom_type( "Tile", "Sprite", preload("res://addons/tileset_generator/Tile.gd"), preload("res://addons/tileset_generator/Texture/icon.png"))
	
	dock = preload("res://addons/tileset_generator/TilesetGenerator.tscn").instance()
	add_control_to_dock( DOCK_SLOT_LEFT_UL, dock )
	dock.connect("generate", self, "do_generate")
	dock.connect("copy_tex", self, "do_copy_tex")
	dock.show()

func _input(event):
	
	if Input.is_action_just_pressed("ui_accept"):
		pass
	
#	if event == InputEventMouseMotion:
#		circle_pos = event.position
#		dock.get_node("TilesetGenerator/Circle").update()

func do_generate( size ):
	var dict_key_array = Array()
	#var dict_val_array = Array()
	
	# Is there any texture to work with ?
	if dock.texture_count != 0:
		dict_key_array = Array(dock.textures.keys())
		#dict_val_array = Array(dock.textures.values())
	else:
		print("Select texture/s")
		return
	
	# Is root a node2D type ?
	if get_editor_interface().get_edited_scene_root().get_class() != "Node2D":
		print("Root node have to be Node2D class !")
		return
	
	# size check !
	if size.x <= 0 || size.y <= 0:
		print("Tile size have to be minimal 1 by 1 px !")
		return
	
	# Making skeleton for tiles ( only if dont exist alredy )
	for i in dict_key_array:
		var tmp_node
		var tmp = i.length()
		
		i.erase( tmp - 4, 4)
		
		# make or finde place to pute tiles baste on texture name
		if !get_editor_interface().get_edited_scene_root().has_node( i + "-tex" ) :
			tmp_node = Node2D.new()
			tmp_node.name = i + "-tex"
			
			get_editor_interface().get_edited_scene_root().add_child( tmp_node )
			tmp_node.set_owner( get_editor_interface().get_edited_scene_root() )
			tmp_node.add_to_group("tex")
			
		else:
			tmp_node = get_editor_interface().get_edited_scene_root().get_node( i + "-tex" )
		
		# Set info abut texture / tiles

		var w  = dock.textures[ i + ".png"].get_width()
		var h  = dock.textures[ i + ".png"].get_height()

		var tileSize = dock.getTileSize()

		var tiles_in_x = w / tileSize.x
		var tiles_in_y = h / tileSize.y

		# Loop thro all tiles
		var tile_id = 0
		var empty = false

		if tmp_node.get_child_count() <= 0:
			empty = true

		for y in range( tiles_in_y ):
			for x in range( tiles_in_x ):

				# what id is it ?
				tile_id = ( y * tiles_in_x ) + x

				# is tile alredy existing ?
				var tile_ready = false
				var tile
				
				# is tile empty ( in texture )
				empty = is_empty( dock.textures[ i + ".png"], x * tileSize.x, y * tileSize.y, tileSize.x, tileSize.y)
				
				if !empty : 
					for i in tmp_node.get_children():
						if i.id == tile_id :
							tile = i
							tile_ready = true
				
					if !tile_ready :
						tile = preload("res://addons/tileset_generator/Tile.gd").new()
						tile_ready = true
						tile.id = tile_id
						
						tile.texture = dock.textures[ i + ".png"]
						tile.region_enabled = true
						tile.region_rect = Rect2(x*tileSize.x,y*tileSize.y,tileSize.x, tileSize.y)
						tile.position.x = (x * tileSize.x )  + (x * 1 )
						tile.position.y = (y * tileSize.y )  + (y * 1 )
						
						tmp_node.add_child( tile )
						tile.set_owner( get_editor_interface().get_edited_scene_root() )

# function to see if tile is empty ( 0 alpha on all pixels )
func is_empty(texture,x,y,w,h):
	var result = true
	var image  = texture.get_data()
	image.lock()
	for xx in range(x,x+w):
		for yy in range(y,y+h):
			
			var pixel = image.get_pixel(xx,yy)
			if pixel.a != 0:
				return false 
	
	image.unlock()
	
	return result

func do_copy_tex():
	for i in dock.get_tree().get_nodes_in_group("tex"):
		
		var name_tmp = i.name
		var tmp = name_tmp.length()
		
		name_tmp.erase( tmp - 4, 4)
		name_tmp += ".png"
		
		if dock.textures.has( i.name):
			print("Dupicate !")
		else:
			#textures[file_name] = load( data.files[0])
			var instance_item = dock.texture_item_packed.instance()
			
			instance_item.get_node("Label").text = name_tmp
			instance_item.connect("clear_item", self, "clear_tex")
			
			dock.get_node("VBoxContainer/CenterContainer/MarginContainer/TextureContainer").add_child( instance_item )
			dock.texture_count += 1

func _exit_tree():
	# free dock
	remove_control_from_docks( dock )
	dock.free()
	
	# free custom type
	remove_custom_type("Tile")