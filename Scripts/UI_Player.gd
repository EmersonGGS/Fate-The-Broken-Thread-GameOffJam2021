extends Control
onready var ui_healthbar = $UI_HealthBar
onready var healthbarTween = $UI_HealthBar/Tween

signal playerDeath
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health = 100
var maxHealth = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	UI_health_update(25)
	pass # Replace with function body.



func UI_health_update(newValue):
	healthbarTween.interpolate_property(ui_healthbar, "value",ui_healthbar.value,newValue,1)
	healthbarTween.start()

func player_death():
	emit_signal("playerDeath")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
