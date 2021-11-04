extends KinematicBody2D

var velocity = Vector2.ZERO;

export var speed = Vector2(300.0, 1000.0)

export var gravity = 3000.0;

func _ready():
	$AnimationPlayer.play("Idle")
	

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("space"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta: float) -> void:
		get_input()
		velocity.y += gravity * delta
		velocity.y = max(velocity.y, speed.y)
		velocity = move_and_slide(velocity)

