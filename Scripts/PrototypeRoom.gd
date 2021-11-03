extends Node2D
onready var backdrop = $Background

export (int) var max_movement_speed
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

##Checks input and applies force to background to move background and keep character
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		backdrop.add_force(backdrop.position, Vector2(-1,0))
#		if backdrop.applied_force <= Vector2(-max_movement_speed,0):
#			backdrop.applied_force = Vector2(-max_movement_speed,0)
	elif Input.is_action_pressed("ui_left"):
		backdrop.add_force(backdrop.position, Vector2(1,0))
#		if backdrop.applied_force >= Vector2(max_movement_speed,0):
#			backdrop.applied_force = Vector2(max_movement_speed,0)
	print (backdrop.applied_force)
#	pass
