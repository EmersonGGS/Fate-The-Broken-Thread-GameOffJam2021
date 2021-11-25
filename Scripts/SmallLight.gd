extends Node2D

onready var animation = $AnimationPlayer
#var lightDict = {
#	candleStick = {
#		sprite = "CandleStick",
#		light = $LightModels/CandleLight,
#	},
#	crescentLight = {
#		sprite = "CrescentLight",
#		light = $LightModels/CrescentLight,
#	},
#	lanternLight = {
#		sprite = "Lantern",
#		light = $LightModels/LanternLight,
#	}
#}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var arrayOfLightTypes = []
# Called when the node enters the scene tree for the first time.
func _ready():
	build_light()
	pass # Replace with function body.

func build_light ():
	var lightList = animation.get_animation_list()
	var randChoice = SeedGenerator.rng.randi_range(0,lightList.size()-1)
	animation.play(lightList[randChoice])
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	
	pass # Replace with function body.
