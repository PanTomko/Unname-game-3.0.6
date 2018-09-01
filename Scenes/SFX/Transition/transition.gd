extends ColorRect

var cutoff = 0.0

export(Texture) var fade_out_texture
export(Texture) var fade_in_texture

func _ready(): pass

func _process(delta):
	material.set( "shader_param/cutoff", cutoff )

func fade_out():
	cutoff = 0.0
	material.set( "shader_param/filter", fade_out_texture )
	$Tween.interpolate_property( self, "cutoff", 0.0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN )
	$Tween.start()

func fade_in():
	cutoff = 1.0
	material.set( "shader_param/filter", fade_in_texture )
	$Tween.interpolate_property( self, "cutoff", 1.0, 0.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN )
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	if cutoff == 1.0:
		get_parent().emit_signal( "transition_out_done" )
	else:
		get_parent().emit_signal( "transition_in_done" )
