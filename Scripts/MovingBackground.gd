extends Node2D
onready var groundTile = $Ground
onready var groundTween = $Ground/Tween
onready var animationPlayer = $PlayerAnimation
onready var bumperAnimation = $BumperAnimation
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var nextTile = Vector2(11,0)

var gridPos
var groundMoving = true
# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("run")
	gridPos = groundTile.position
	_on_Tween_tween_all_completed()
	
	pass # Replace with function body.

func animate_ground (newPos):
	groundTween.interpolate_property(groundTile,"position",groundTile.position,groundTile.position-newPos,.4)
	groundTween.start()
	
func update_tile ():
	var listOfArrays = groundTile.get_used_cells()
	groundTile.set_cellv (listOfArrays[0],-1)
	groundTile.set_cellv (nextTile,0)
	nextTile += Vector2(1,0)

func _on_Tween_tween_all_completed():
	if groundMoving:
		update_tile ()
		animate_ground(groundTile.cell_size*groundTile.scale*Vector2(1,0))
	
	pass # Replace with function body.


func _on_StartMenu_playPressed():
	bumperAnimation.play("StartingGame")
	pass # Replace with function body.




func _on_PlayerAnimation_animation_started(anim_name):
	if anim_name == "idle":
		groundMoving = false
		groundTween.stop_all()
	pass # Replace with function body.
