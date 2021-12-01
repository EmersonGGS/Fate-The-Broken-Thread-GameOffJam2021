extends KinematicBody2D

# Exports
export var speed = Vector2(500.0, 500.0)
export var gravity = 1.0;
export var fogOnViewer = true
# Constants
const JUMPFORCE = -950;

# Player attack options
const attackAnimations = [
	"overhand",
	"stab",
	"heavyAttack"
];

# Player state options
const playerStates = {
	"IDLE": "IDLE",
	"ATTACKING": "ATTACKING"
};

# Variables
var velocity = Vector2.ZERO;

# Current player state
var playerState = playerStates.IDLE

# Attack animation index
var playerAttackIndex = 0;
var playerAttackInProgress = false;

# Sprite/animation variables
var characterSprite;
var characterSpriteAnimationPlayer;
var audioStreamPlayer;

# Sounds
var attackImpactSound = preload("../Assets/Audio/attack_impact.wav");
var keySound = preload("../Assets/Audio/key_pickup.wav");
var doorSound = preload("../Assets/Audio/open_door.wav");
var deathSound = preload("../Assets/Audio/player_dies.wav");

var attackTimneout;

func _ready():
	if fogOnViewer:
		$Fog.show()
	set_physics_process(true)
	audioStreamPlayer = $AudioStreamPlayer2D
	characterSprite = $CharacterSprite
	characterSpriteAnimationPlayer = $CharacterSpriteAnimationPlayer
	characterSpriteAnimationPlayer.play("idle");

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
		velocity = move_and_slide(velocity, Vector2.UP,true,4,.78,false)
		handle_animated_sprite_state()
	if Input.is_action_just_pressed("Block"):
		#debug, teleport character to mouse location
		self.position = get_global_mouse_position()


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
#	print(playerAttackIndex)
	#	Player is starting to attack
	if !playerAttackInProgress or $attackTimer.time_left > 0:
		$attackTimer.stop()
		characterSpriteAnimationPlayer.play(attackAnimations[playerAttackIndex]);
		playerAttackInProgress = true;
		if playerAttackIndex == (attackAnimations.size() - 1):
			playerAttackIndex = 0
		else:
			playerAttackIndex += 1

func handle_animated_sprite_state() -> void:
	# Handle animation direction
	# Facing right
	if velocity.x > 0:
		characterSprite.flip_h = false;
	# Facing left
	elif velocity.x < 0:
		characterSprite.flip_h = true;
	
	# Handle animation type
	# Running (on ground)
	if velocity.x != 0 and velocity.y == 0 :
		characterSpriteAnimationPlayer.play("run");
		
	# Initial jump off the ground
	elif Input.is_action_just_pressed("jump") and is_on_floor():
		characterSpriteAnimationPlayer.play("jumpUp")
	
	# Falling
	elif velocity.y != 0:
		characterSpriteAnimationPlayer.play("falling")

	# Not moving (idle)
	else:
		characterSpriteAnimationPlayer.play("idle");


func _on_CharacterSpriteAnimationPlayer_animation_finished(anim_name):
#	print(anim_name)
	var isAnimationAnAttack = attackAnimations.find(anim_name, 0);
	if isAnimationAnAttack >= 0:
#		print('Starting attack combo timer...')
		$attackTimer.start()

func clear_player_state():
#	print('clearing player state')
	playerAttackInProgress = false;
	playerState = playerStates.IDLE;
	playerAttackIndex = 0;

func dealDamageToEnemy(body):
	if (body.has_method("recieve_damage") && !body.isDead):
		var rng = RandomNumberGenerator.new()
		rng.randomize();
		var num = rng.randi_range(4, 12)
		var crit = num > 9;
		body.recieve_damage(num, crit);
		audioStreamPlayer.stream = attackImpactSound;
		audioStreamPlayer.play();
		
		
func recieve_damage(damage, crit):
	CharacterState.health = clamp(CharacterState.health - damage,0,100);
	$UI_Player.UI_health_update(CharacterState.health)
	# function called from player or other damage causing nodes when detection is called
	if (CharacterState.health <= 0):
		set_physics_process(false)
		audioStreamPlayer.volume_db = 0.0
		audioStreamPlayer.stream = deathSound;
		audioStreamPlayer.play();
		characterSpriteAnimationPlayer.play("death");
		print(' Oh no... ')

func _on_attackTimer_timeout():
	$attackTimer.stop();
	clear_player_state();

func _on_WorldGeneration_set_spawn_point(spawnPoint):
	position = spawnPoint;

func _on_AttackArea_area_entered(area):
	if (area.name == "HitBox"):
		dealDamageToEnemy(area.get_parent());

func _on_PickUpArea_body_entered(body):
	print("_on_PickUpArea_body_entered let me pick it up", body.name);
	if(body.name == 'Key'):
		CharacterState.foundKey = true;
		audioStreamPlayer.volume_db = 0.0
		audioStreamPlayer.stream = keySound;
		audioStreamPlayer.play();
		body.get_parent().queue_free()
	elif(body.name == 'Door' && CharacterState.foundKey):
		audioStreamPlayer.volume_db = 0.0
		audioStreamPlayer.stream = doorSound;
		audioStreamPlayer.play();
		set_physics_process(false);
		characterSpriteAnimationPlayer.play("idle");
		yield(get_tree().create_timer(1.2), "timeout")
		get_tree().change_scene("res://Levels/KnightBossRoom.tscn");
