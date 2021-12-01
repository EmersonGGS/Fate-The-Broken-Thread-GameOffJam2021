extends Container
onready var animationPlayer = get_parent().get_node("Control/AnimationPlayer")
onready var tween = $Tween
onready var healthBar = $HealthBar
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	healthBar.value = healthBar.min_value
	update_health(healthBar.max_value,2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_health (newHealth,tweenTime = 0.5):
	tween.interpolate_property(healthBar,"value",healthBar.value,newHealth,tweenTime)
	tween.start()
	
func _on_Enemy_HealthUpdate(newHealth):
	update_health (newHealth)
	pass # Replace with function body.


func _on_Enemy_BossDefeated():
	animationPlayer.play("Win")
	pass # Replace with function body.


func _on_BGMusicPlayer_finished():
	pass # Replace with function body.
