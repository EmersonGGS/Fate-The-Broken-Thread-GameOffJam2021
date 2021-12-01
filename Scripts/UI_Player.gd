extends Control
onready var ui_healthbar = $UI_HealthBar
onready var healthbarTween = $UI_HealthBar/Tween

signal playerDeath

func UI_health_update(newValue):
	var floatNewValue = float(CharacterState.health); 
	healthbarTween.interpolate_property(ui_healthbar, "rect_scale", ui_healthbar.rect_scale, Vector2(floatNewValue / 100, 1),1)
	healthbarTween.start()
