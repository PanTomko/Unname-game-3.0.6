extends Area2D

export(String) var conected_path # To what level portal leads to
export(int) var ID # ID of this portal
export(int) var conected_portal # ID of conected portal

var level
var active = false

func _on_PortalLevel_body_entered(body):
	print("HMMM")
	
	if active : 
		level.emit_signal( "change_level_signal", [conected_path, conected_portal] )
		
		active = false
	

func _on_PortalLevel_body_exited(body):
	active = true


func _on_Timer_timeout():
	active = true
