extends Node2D

onready var playerSelection = $Menu/PlayerSelection
onready var buttonsSelection = $Menu/Buttons
var menuCurrentChoice = 0;
var menuSelected = true
var optionSelected = false
var aboutSelected = false
signal playPressed

func changeSelection (movement):
	print(playerSelection.get_children())
	playerSelection.get_child(menuCurrentChoice).modulate.a = 0 
	print(playerSelection.get_child(menuCurrentChoice))
#	print ("selection: ",menuSelection)
#	print(playerSelection.get_child(menuSelection).get_name())
	var newSelection = menuCurrentChoice + movement
	if newSelection < 0:
		newSelection = playerSelection.get_child_count()-1
	elif newSelection > playerSelection.get_child_count()-1:
		newSelection = 0
	playerSelection.get_child(newSelection).modulate.a = 1 
	menuCurrentChoice = newSelection
	
	print ("selection: ",menuCurrentChoice)
	print(playerSelection.get_child(menuCurrentChoice).get_name())
	

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_up"):
		if menuSelected:
			changeSelection(-1)
	elif Input.is_action_just_pressed("ui_down"):
		if menuSelected:
			changeSelection(1)
	elif Input.is_action_just_pressed("ui_accept"):
		if menuSelected:
			buttonsSelection.get_child(menuCurrentChoice).emit_signal("pressed")

func ready():
	pass


func _on_Play_pressed():
	emit_signal("playPressed")
	pass # Replace with function body.


func _on_Options_pressed():
	pass # Replace with function body.


func _on_About_pressed():
	pass # Replace with function body.


func _on_BumperAnimation_animation_finished(anim_name):
	if anim_name == "StartingGame":
		get_tree().change_scene("res://Levels/LevelTemplate.tscn")
