extends Node

var health = 100
var maxHealth = 100
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func health_update (value):
	health  += value
	if health <= 0:
		health = 0
	elif health > maxHealth:
		health = 100 
		

func player_damage (value):
	health_update (value)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
