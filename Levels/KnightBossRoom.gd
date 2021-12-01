extends Node2D
onready var UI_Enemy = $Camera2D/Container
onready var bgMusicPlayer = $BGMusicPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var fightDone = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/Camera2D.current = false
	bgMusicPlayer.play()
	

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BGMusicPlayer_finished():
	if !fightDone:
		bgMusicPlayer.stream = load("res://Audio/Boss_Battle_1_Main.mp3")
		bgMusicPlayer.play(0.0)
		
	print ("1 loop done")
	pass # Replace with function body.


func _on_Enemy_BossDefeated():
	bgMusicPlayer.stream = load("res://Audio/Boss_Battle_1_Ending.mp3")
	bgMusicPlayer.play(0.0)
	fightDone = true
	pass # Replace with function body.
