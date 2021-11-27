extends Node2D

onready var playerSelection = $Menu/PlayerSelection
onready var buttonsSelection = $Menu/Buttons
onready var menu = $Menu
onready var aboutText = $AboutScrollBar/AboutText
onready var aboutScrollContainer = $AboutScrollBar
onready var aboutScrollBar = $AboutScrollBar.get_v_scrollbar()

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
		elif aboutSelected:
			pass
	elif Input.is_action_just_pressed("ui_down"):
		if menuSelected:
			changeSelection(1)
		elif aboutSelected:
			pass
	elif Input.is_action_just_pressed("ui_accept"):
		if menuSelected:
			buttonsSelection.get_child(menuCurrentChoice).emit_signal("pressed")
			
		elif aboutSelected:
			back_to_menu();

func _ready():
	load_ReadMe()
	pass

func _draw():
	
	pass
	
func load_ReadMe ():
	var README = File.new()
	README.open("res://README", File.READ)
	var text = ""
	while !README.eof_reached():
		text += str(README.get_line()) + "\n"
	aboutText.text = text

func _on_Play_pressed():
	emit_signal("playPressed")
	pass # Replace with function body.


func _on_Options_pressed():
	
	pass # Replace with function body.


func _on_About_pressed():
	menu.hide()
	aboutText.show()
	update_selection(2)
	pass # Replace with function body.

func back_to_menu ():
	update_selection (0);
	menu.show()
#	optionMenu.hide()
	aboutText.hide()
	
func update_selection (choice):
	if choice == 0:
		menuSelected = true
		optionSelected = false
		aboutSelected = false
	elif choice == 1:
		menuSelected = false
		optionSelected = true
		aboutSelected = false
	elif choice == 2:
		menuSelected = false
		optionSelected = false
		aboutSelected = true

func _on_BumperAnimation_animation_finished(anim_name):
	if anim_name == "StartingGame":
		get_tree().change_scene("res://Levels/LevelTemplate.tscn")
