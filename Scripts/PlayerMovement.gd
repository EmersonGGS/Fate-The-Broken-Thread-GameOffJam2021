extends KinematicBody2D

var velocity = Vector2.ZERO;

export var speed = Vector2(500.0, 500.0)

export var gravity = 1.0;
const JUMPFORCE = -850;

const attackAnimations = [
	"overhandSwing",
	"underhandSwing",
	"stab"
];

const playerStates = {
	"IDLE": "IDLE",
	"ATTACKING": "ATTACKING"
};

var playerState = playerStates.IDLE

onready var animatedSprite = $AnimatedSprite

func _ready():
	$AnimationPlayer.play("idle");

func _physics_process(delta: float) -> void:
	# Attack is taking place
	if Input.is_action_just_pressed("attack") and is_on_floor():
		playerState = playerStates.ATTACKING
		handle_attack()
	elif playerState != playerStates.ATTACKING:
		var direction = getDirection();
		velocity = calculate_move_velocity(velocity, direction, speed)
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMPFORCE
		velocity = move_and_slide(velocity, Vector2.UP)
		handle_animated_sprite_state()

func getDirection() -> Vector2:
	# Movement direction of player, < 0 is moving right, 0 is stationary, < 0 is moving left
	var direction = Input.get_action_strength("right") - Input.get_action_strength("left")


	# Update the direction
	return Vector2(direction, -1.0)

func calculate_move_velocity(linear_velocity: Vector2, speed: Vector2, direction: Vector2) -> Vector2:
	var calculated_velocity = linear_velocity
	
	# Reduce speed control while in the air
	calculated_velocity.x = speed.x * direction.x
	calculated_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		calculated_velocity.y = speed.y * direction.y

	return calculated_velocity

func handle_attack() -> void:
	#var randomNumberGenerator = RandomNumberGenerator.new()
	#var randomAttackAnimation = randomNumberGenerator.randi_range(0, attackAnimations.size);
	#print(randomNumberGenerator)
	if animatedSprite.animation == "stab":
		animatedSprite.animation = "overhandSwing"
	elif animatedSprite.animation == "overhandSwing":
		animatedSprite.animation = "underhandSwing"
	else:
		animatedSprite.animation = "stab"

	if animatedSprite.playing == false:
		animatedSprite.play()

func handle_animated_sprite_state() -> void:
	# Handle animation direction
	# Facing right
	if velocity.x > 0:
		animatedSprite.flip_h = false
	# Facing left
	elif velocity.x < 0:
		animatedSprite.flip_h = true
	
	# Handle animation type
	# Running (on ground)
	if velocity.x != 0 and velocity.y == 0 :
		animatedSprite.animation = "running"

	# Jumping
	elif velocity.y != 0:
		animatedSprite.animation = "falling"

	# Not moving
	else:
		animatedSprite.animation = "idle"

	# If animated sprite is not playing, play it
	if animatedSprite.playing == false:
		animatedSprite.play()


func _on_AnimatedSprite_animation_finished():
	var isAnimationAnAttack = attackAnimations.find(animatedSprite.animation, 0);
	if isAnimationAnAttack > 0:
		playerState = playerStates.IDLE
		print(isAnimationAnAttack)
	pass # Replace with function body.
