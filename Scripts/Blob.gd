extends KinematicBody2D

onready var sprite = $EnemySprite
onready var hitbox = $CollisionPolygon2D
onready var idleTime = $IdleTimer
onready var moveTimer = $MovementTimer
onready var frontFloorCheck = $RayChecks/FrontFloorCheckRay
onready var backFloorCheck = $RayChecks/BackFloorCheckRay
onready var playerInFrontRay = $RayChecks/PlayerInFrontRay
onready var playerInBackRay = $RayChecks/PlayerInBackRay
onready var animationPlayer = $AnimationPlayer



var velocity = Vector2.ZERO;

export var enemyScale = 1.3

export var speed = Vector2(150.0, 10.0)
export var gravity = 1000.0;


enum {still,left,right, attack}
onready var state = still

onready var directionFacing = right
var holeInFront = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func enemy_decision ():
	#place holder for logic - 40% to move, 20% to attack
	var movementPercent = 4;
	var decision = round(rand_range(0,8));
	var holeInFront = hole_in_front();
	var holeInBack = hole_in_back();
	
	if holeInFront and holeInBack:
		animationPlayer.play("Idle")
		print ("Idle")
	elif holeInFront:
		if directionFacing == left:
			if decision <= movementPercent*2:
				move_right();
		elif directionFacing == right:
			if decision <= movementPercent*2:
				move_left();
		else: animationPlayer.play("Idle"); print ("Idle")
	elif holeInBack:
		if directionFacing == left:
			if decision <= movementPercent*2:
				move_right();
		elif directionFacing == right:
			if decision <= movementPercent*2:
				move_left();
		else: animationPlayer.play("Idle"); print ("Idle")
		
	var playerDetection = locate_player()
	if playerDetection != null:
		if playerDetection == left:
			move_left();
		elif playerDetection == right:
			move_right(); 
	else:
		if decision <= movementPercent:
			move_left();
			print ("Decision Left")
		elif decision <= movementPercent*2:
			move_right(); 
			print ("Decision Right")
			

	

func move_left():
	if directionFacing == right:
		scale.x = -scale.x
		directionFacing = left
	animationPlayer.play("Walk")
	print ("Walk")
	state = left
	pass

func move_right():
	if directionFacing == left:
		scale.x = -scale.x
		directionFacing = right
	animationPlayer.play("Walk")
	print ("Walk")
	state = right
	pass

func attack():
	animationPlayer.play("Attack")
	state = attack
	pass


func _ready():
	#placeholder for logic
	randomize()
	animationPlayer.play("Idle")
	

var framesToMove = 50
var framesCounted = 0
func _physics_process(delta):
	locate_player()
	velocity.y += delta * gravity
	if is_on_floor():
		velocity.y = 0
	if animationPlayer.current_animation == "Walk":
		var timeStamp = animationPlayer.get_current_animation_position();
#		print (timeStamp)
		if timeStamp >= 0.6 and timeStamp <= 1.3:
			if state == left:
				velocity.x = -speed.x
				velocity.y = 0
			elif state == right:
				velocity.x = speed.x
				velocity.y = 0
		else: velocity.x = 0
	else: velocity.x = 0
	move_and_slide(velocity, Vector2(0, -1))



func _on_DecisionTimer_timeout():
	enemy_decision()
	pass # Replace with function body.


		
	pass # Replace with function body.

func hole_in_front ():
	if !frontFloorCheck.is_colliding():# and is_on_floor():
#		print ("There is a hole here")
		return true
#	print ("No Hole")
	return false

func hole_in_back():
	if !backFloorCheck.is_colliding():# and is_on_floor():
#		print ("There is a hole here")
		return true
#	print ("No Hole")
	return false

	
	
func locate_player():
	if playerInFrontRay.is_colliding():
		if directionFacing == left: return left; else: return right
	elif playerInBackRay.is_colliding():
		if directionFacing == left: return right; else: return left
	return null;

func _on_MovementTimer_timeout():
	
	pass # Replace with function body.



func _on_EnemySprite_frame_changed():
	if state == attack:
		pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != "Death":
		if anim_name == "Idle":
			enemy_decision ()
		else: animationPlayer.play("Idle")
		
	else:
		print("insert function to track death into more global counter")
		queue_free();
		
	pass # Replace with function body.


func _on_PlayerDetector_body_entered(body):
	if body.name == "Player" and animationPlayer.current_animation != "Attack":
		attack();
	pass # Replace with function body.
		
	pass # Replace with function body.


func _on_AttackDetector_body_entered(body):
	if body.name == "Player":
		print ("Placeholder for Damage")
		##
	pass # Replace with function body.
