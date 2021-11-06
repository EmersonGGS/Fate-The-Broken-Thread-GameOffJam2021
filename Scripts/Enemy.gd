extends KinematicBody2D

onready var sprite = $EnemySprite
onready var hitbox = $CollisionPolygon2D


var velocity = Vector2.ZERO;

export var speed = Vector2(300.0, 1000.0)
export var gravity = 1000.0;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
		var direction = getDirection();
		velocity = calculate_move_velocity(velocity, direction, speed)
		velocity = move_and_slide(velocity, Vector2.UP)

func getDirection() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		-1.0
	)
func calculate_move_velocity(linear_velocity: Vector2, speed: Vector2, direction: Vector2) -> Vector2:
	var calculated_velocity = linear_velocity
	calculated_velocity.x = speed.x * direction.x
	calculated_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		calculated_velocity.y = speed.y * direction.y
	print(calculated_velocity)
	return calculated_velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
