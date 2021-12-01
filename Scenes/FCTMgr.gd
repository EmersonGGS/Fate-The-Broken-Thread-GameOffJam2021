extends Node2D

var FCT = preload("res://Scenes/FCT.tscn");

export var travel = Vector2(0, -80)
export var duration = 2
export var spread = PI/2

func show_value(value, crit=false, shouldScale=false):
	var fct = FCT.instance();
	print(shouldScale)
	print(scale)
	if (shouldScale):
		scale.x = - scale.x
	else:
		scale.x = - scale.x
		
	add_child(fct);
	print(scale)
	fct.show_value(str(value), travel, duration, spread, crit)
