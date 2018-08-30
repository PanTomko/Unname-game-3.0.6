extends Area2D

export(String) var conected_path # To what level portal leads to
export(int) var ID # ID of this portal
export(int) var conected_portal # ID of conected portal

var level

func _on_PortalLevel_body_entered(body):
	level.emit_signal( "change_level_signal", [conected_path, conected_portal] )
