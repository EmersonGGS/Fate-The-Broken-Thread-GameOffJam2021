extends Control
onready var textureTween = $Tween

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var textureRect1
var textureRect2
var textureRect3
var startingPoint
var endingPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	make_triplecate()
	move_clouds()
	pass # Replace with function body.

func make_triplecate():
	textureRect1 = $TextureRect
	textureRect2 = $TextureRect2
	textureRect3 = $TextureRect3
	startingPoint = textureRect3.rect_position.x
	endingPoint = textureRect1.rect_position.x-textureRect1.rect_size.x


var timeValue = 100
func move_clouds():
	textureTween.interpolate_property(textureRect1,"rect_position:x",textureRect1.rect_position.x,endingPoint,timeValue)
	$Tween2.interpolate_property(textureRect2,"rect_position:x",textureRect2.rect_position.x,endingPoint,timeValue*2)
	$Tween3.interpolate_property(textureRect3,"rect_position:x",textureRect3.rect_position.x,endingPoint,timeValue*3)
	textureTween.start()
	$Tween2.start()
	$Tween3.start()
	

func _on_Tween_tween_completed(object, key):
	textureTween.interpolate_property(textureRect1,"rect_position:x",textureRect3.rect_position.x+textureRect3.rect_size.x-25,endingPoint,timeValue*3)
	textureTween.start()
	print ("Zoom1 pos:", textureRect1.rect_position.x)
	pass # Replace with function body.


func _on_Tween2_tween_completed(object, key):
	$Tween2.interpolate_property(textureRect2,"rect_position:x",textureRect1.rect_position.x+textureRect1.rect_size.x-5,endingPoint,timeValue*3)
	$Tween2.start()
	print ("Zoom2 pos:", textureRect2.rect_position.x)
	pass # Replace with function body.


func _on_Tween3_tween_completed(object, key):
	$Tween3.interpolate_property(textureRect3,"rect_position:x",textureRect2.rect_position.x+textureRect2.rect_size.x-5,endingPoint,timeValue*3)
	$Tween3.start()
	print ("Zoom3 pos:", textureRect3.rect_position.x)
