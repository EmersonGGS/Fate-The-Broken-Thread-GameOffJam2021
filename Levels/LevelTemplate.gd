extends Node2D

var PlayerHealth = 100

#array of enemy types to have available to load (could also be used 
onready var enemies = [preload("res://Scenes/Blob.tscn").instance()]
# Called when the node enters the scene tree for the first time.
func _ready():
	var slime = enemies[0].duplicate()
	add_child(slime);
	slime.position = Vector2(300,500)
	
	
	pass # Replace withfunction body.
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
