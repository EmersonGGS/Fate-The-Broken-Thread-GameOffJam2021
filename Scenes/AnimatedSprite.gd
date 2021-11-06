extends AnimatedSprite

func _ready() -> void:
	var instanceObject = SpriteFrames.new()
	$AnimatedSprite.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
