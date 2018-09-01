extends CanvasLayer

signal transition_out_done
signal transition_in_done

func _ready(): pass

func transition_fade_out():
	$Transition.fade_out()

func transition_fade_in():
	$Transition.fade_in()