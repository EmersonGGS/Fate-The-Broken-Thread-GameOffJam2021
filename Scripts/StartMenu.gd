extends Node2D

onready var playerSelection = $Menu/PlayerSelection
onready var mainSelection = $Menu/Main
onready var optionSelection = $Menu/Options
onready var menu = $Menu
onready var aboutText = $AboutScrollBar/AboutText
onready var aboutScrollContainer = $AboutScrollBar
onready var aboutScrollBar = $AboutScrollBar.get_v_scrollbar()
onready var backgroundMusicPlayer = $BGMusicPlayer
onready var soundEffectMusicPlayer = $SFXPlayer

onready var musicButton = $Menu/Options/Music
onready var soundEffectButton = $Menu/Options/SoundEffects
onready var musicVolumeSlider = $Menu/Options/MusicVolume
onready var soundEffectVolumeSlider = $Menu/Options/SoundEffectsVolume

var menuCurrentChoice = 0;
var menuSelected = true
var optionSelected = false
var aboutSelected = false
signal playPressed
var animationPlaying = false
var skipConfirmation = false

func changeSelection (movement):
	print(playerSelection.get_children())
	playerSelection.get_child(menuCurrentChoice).modulate.a = 0 
	print(playerSelection.get_child(menuCurrentChoice))
#	print ("selection: ",menuSelection)
#	print(playerSelection.get_child(menuSelection).get_name())
	var newSelection = menuCurrentChoice + movement
	if menuSelected:
		if newSelection < 0:
			newSelection = mainSelection.get_child_count()-1
		elif newSelection > mainSelection.get_child_count()-1:
			newSelection = 0
	elif optionSelected:
		if newSelection < 0:
			newSelection = optionSelection.get_child_count()-1
		elif newSelection > optionSelection.get_child_count()-1:
			newSelection = 0
	playerSelection.get_child(newSelection).modulate.a = 1 
	menuCurrentChoice = newSelection
	
	print ("selection: ",menuCurrentChoice)
	print(playerSelection.get_child(menuCurrentChoice).get_name())
	

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_up"):
		if menuSelected or optionSelected:
			changeSelection(-1)
		elif aboutSelected:
			pass
	elif Input.is_action_just_pressed("ui_down"):
		if menuSelected or optionSelected:
			changeSelection(1)
		elif aboutSelected:
			pass
	
	elif Input.is_action_just_pressed("ui_left"):
		if optionSelected:
			var highlightedChoice = optionSelection.get_child(menuCurrentChoice)
			if highlightedChoice is HSlider:
				highlightedChoice.value -= highlightedChoice.step
		
	elif Input.is_action_just_pressed("ui_right"):
		if optionSelected:
			var highlightedChoice = optionSelection.get_child(menuCurrentChoice)
			if highlightedChoice is HSlider:
				highlightedChoice.value += highlightedChoice.step
				
	elif Input.is_action_just_pressed("ui_accept"):
		if menuSelected:
			mainSelection.get_child(menuCurrentChoice).emit_signal("pressed")
		
		elif optionSelected:
			var highlightedChoice = optionSelection.get_child(menuCurrentChoice)
			if menuCurrentChoice == optionSelection.get_child_count()-1:
				highlightedChoice.emit_signal("pressed")
			elif highlightedChoice is LinkButton:
				highlightedChoice.pressed = !highlightedChoice.pressed
				highlightedChoice.emit_signal("toggled")
		if animationPlaying:
			skip_confirmation();
		elif aboutSelected:
			update_selection (0)
			menuCurrentChoice = 2
			reset_choice_orbs(menuCurrentChoice)
			aboutScrollContainer.hide()
			menu.show()
			
	elif Input.is_action_just_pressed("attack"):
		if aboutSelected:
			update_selection (0)
			menuCurrentChoice = 2
			reset_choice_orbs(menuCurrentChoice)
			aboutScrollContainer.hide()
			menu.show()
		if animationPlaying:
			skip_confirmation();

func _ready():
	load_ReadMe()
	play_menu_music()
	set_volumes()
	pass

func play_menu_music():
	backgroundMusicPlayer.play(3.0)
#	backgroundMusicPlayer.seek(3.0)
#	backgroundMusicPlayer.playing = true
	print ("Music Player Position ",backgroundMusicPlayer.get_playback_position())
func set_volumes():
	musicButton.pressed = GlobalSound.musicPlaying
	musicVolumeSlider.value = GlobalSound.musicVolume
	soundEffectButton.pressed = GlobalSound.soundPlaying
	soundEffectVolumeSlider.value = GlobalSound.soundVolume
	
	
func load_ReadMe ():
	var README = File.new()
	README.open("res://README", File.READ)
	var text = ""
	while !README.eof_reached():
		text += str(README.get_line()) + "\n"
	aboutText.text = text

func _on_Play_pressed():
	animationPlaying = true
	emit_signal("playPressed")
	
	pass # Replace with function body.
func skip_confirmation ():
	if !skipConfirmation:
		$StartingText/Skip.show();
		skipConfirmation = true
	else:_on_MovingBackground_startNewGame();

func _on_Options_pressed():
	mainSelection.hide()
	optionSelection.show()
	update_selection(1)
	menuCurrentChoice = 0
	reset_choice_orbs(menuCurrentChoice)
	pass # Replace with function body.


func _on_About_pressed():
	menu.hide()
	aboutScrollContainer.show()
	update_selection(2)
	pass # Replace with function body.

func back_to_menu ():
	update_selection (0);
	menu.show()
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



func _on_BackgroundMusic_finished():
	backgroundMusicPlayer.play(0.0)
	pass # Replace with function body.

	
func _on_MusicVolume_value_changed(value):
	GlobalSound.update_music(GlobalSound.musicPlaying,value)
	pass # Replace with function body.


func _on_SoundEffectsVolume_value_changed(value):
	GlobalSound.update_sound(GlobalSound.soundPlaying,value)
	pass # Replace with function body.


func _on_Music_toggled(button_pressed):
	GlobalSound.update_music(button_pressed)
	if button_pressed:musicButton.text = "Music: ON"
	else:musicButton.text = "Music: OFF"
	


func _on_SoundEffects_toggled(button_pressed):
	GlobalSound.update_sound(button_pressed)
	if button_pressed:soundEffectButton.text = "SFX: ON"
	else:soundEffectButton.text = "SFX: OFF"
	pass # Replace with function body.


func _on_Back_pressed():
	update_selection (0)
	menuCurrentChoice = 1
	reset_choice_orbs(menuCurrentChoice)
	optionSelection.hide()
	mainSelection.show()
	
func reset_choice_orbs (value):
	for i in playerSelection.get_child_count():
		if i == value:
			playerSelection.get_child(i).modulate.a = 1 
		else:playerSelection.get_child(i).modulate.a = 0 
	pass # Replace with function body.



func _on_MovingBackground_startNewGame():
	get_tree().change_scene("res://Levels/LevelTemplate.tscn")
	pass # Replace with function body.
