extends Control
onready var ui_healthbar = $UI_HealthBar
onready var healthbarTween = $UI_HealthBar/Tween

signal playerDeath
var health = 100
var maxHealth = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	UI_health_update(25.00)
	pass # Replace with function body.

func UI_health_update(newValue):
	healthbarTween.interpolate_property(ui_healthbar, "rect_scale", ui_healthbar.rect_scale, Vector2(newValue / 100, 1),1)
	healthbarTween.start()

func player_death():
	emit_signal("playerDeath")
