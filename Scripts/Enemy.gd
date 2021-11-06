extends KinematicBody2D

onready var sprite = $EnemySprite
onready var hitbox = $CollisionPolygon2D
onready var idleTime = $IdleTimer
onready var moveTimer = $MovementTimer



var velocity = Vector2.ZERO;

export var enemyScale = 1.3

export var speed = Vector2(95.0, 10.0)
export var gravity = 1000.0;


enum {still,left,right, attack}
onready var state = still
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func enemy_decision ():
	#place holder for logic - 40% to move, 20% to attack
	var decision = round(rand_range(0,10))
	if decision <= 4:
		move_left();
	elif decision <= 8:
		move_right();
	else:
		attack();
	pass
	

func move_left():
	if scale.x > 0:
		scale.x = -scale.x
	sprite.play("Moving")
	state = left
	pass

func move_right():
	if scale.x < 0:
		scale.x = -scale.x
	sprite.play("Moving")
	state = right
	pass

func attack():
	sprite.play("Attack")
	state = attack
	pass


func _ready():
	#placeholder for logic
	randomize()
	
	var animationState = sprite.animation
	if animationState == "Standing":
#		print ("SUCCESS")
		pass
	pass # Replace with function body.

var framesToMove = 50
var framesCounted = 0
func _physics_process(delta):
	velocity.y += delta * gravity
	if is_on_floor():
		velocity.y = 0
		if framesCounted == 0 and state == still:
			velocity.x = 0
#			print("On Floor and Still")
	if state == left and framesCounted < framesToMove:
		velocity.x = -speed.x
#		velocity.y += -speed.y
		framesCounted += 1
	elif state == right and framesCounted < framesToMove:
		velocity.x = speed.x
#		velocity.y += -speed.y
		framesCounted += 1
	elif state == attack:
		pass
	else:
		state = still
		framesCounted = 0;
		sprite.play("Standing")
	print (velocity)
	move_and_slide(velocity, Vector2(0, -1))



func _on_DecisionTimer_timeout():
	enemy_decision()
	pass # Replace with function body.


		
	pass # Replace with function body.



func _on_MovementTimer_timeout():
	
	pass # Replace with function body.
