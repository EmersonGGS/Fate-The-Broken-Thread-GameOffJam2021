extends KinematicBody2D

var velocity = Vector2.ZERO;

export var speed = Vector2(300.0, 1000.0)

export var gravity = 1.0;
const JUMPFORCE = -1200;

onready var animatedSprite = $AnimatedSprite

func _physics_process(delta: float) -> void:
		var direction = getDirection();
		velocity = calculate_move_velocity(velocity, direction, speed)
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMPFORCE
		velocity = move_and_slide(velocity, Vector2.UP)

func getDirection() -> Vector2:
	# Movement direction of player, < 0 is moving right, 0 is stationary, < 0 is moving left
	var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	# Handle animation direction
	# Running right
	if direction > 0 :
		animatedSprite.animation = "Running"
		animatedSprite.flip_h = false

	# Running left
	elif direction < 0:
		animatedSprite.animation = "Running"
		animatedSprite.flip_h = true

	# Not moving
	else:
		animatedSprite.animation = "Idle"

	# If animated sprite is not playing, play it
	if animatedSprite.playing == false:
		animatedSprite.play()
		
	# Update the direction
	return Vector2(direction, -1.0)

func calculate_move_velocity(linear_velocity: Vector2, speed: Vector2, direction: Vector2) -> Vector2:
	var calculated_velocity = linear_velocity
	calculated_velocity.x = speed.x * direction.x
	calculated_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		calculated_velocity.y = speed.y * direction.y

	return calculated_velocity
