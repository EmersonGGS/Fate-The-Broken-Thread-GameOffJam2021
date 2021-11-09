extends Node2D

onready var tileMap = $TileMap
export (int) var maxx = 100
export (int) var maxy = 100
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	make_border ()
	pass # Replace with function body.

func make_border ():
	for i in maxx:
		for j in maxy:
			if j == 0 or j == maxy-1:
				tileMap.set_cell(i,j,0)
			elif i == 0 or i == maxx-1:
				tileMap.set_cell(i,j,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
