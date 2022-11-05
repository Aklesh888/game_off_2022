extends KinematicBody2D

const SPEED = 30 # speed of player

var velocity = Vector2.ZERO # velocity of enemy
var state = IDLE #default state
var player: Node #reference to player
var direction = Vector2.ZERO

onready var animations = $AnimatedSprite
onready var fireball_position = $fireball_position
onready var fire_ball = preload("res://Scenes/fireball.tscn")
onready var bullet_cd = $bullet_cooldown

enum {
	IDLE,
	ALERT,
	SHOOT,
	HIT,
	CHASE
}

onready var player_detector = $player_detector

func _physics_process(delta):
	movement()
	

func movement():
	detect_player_in_area()
	match state:
		IDLE:
			#print('idle')
			animations.play("Idle")
		ALERT:
			print('alert')
		SHOOT:
			animations.play("Attack")
			if player.global_position.x >= position.x:
				animations.flip_h = false
			elif player.global_position.x <= position.x:
				animations.flip_h = true
			#print('shoot')
		
		HIT:
			print('hit')
		CHASE:
			#print('chase')
			animations.play("Run")
			direction = (player.global_position - position).normalized()
			velocity = direction * SPEED
			velocity = move_and_slide(velocity)


func shoot(): #fires a fireball
	var FIREBALL = fire_ball.instance()
	add_child(FIREBALL)
	FIREBALL.global_position = fireball_position.global_position
	FIREBALL.direction = global_position.direction_to(player.global_position)
	FIREBALL.look_at(player.global_position)

func detect_player_in_area():#detects if player is in the area and changes states accordingly  
	var bodies = player_detector.get_overlapping_bodies()
	if bodies != null:
		for body in bodies:
			if body.is_in_group("player"):
				player = body
			if player != null: 
				var player_distance = position.distance_to(player.get_global_position())
				if player_distance <= 150 :
					state = SHOOT
				else:
					state = CHASE
					


func _on_player_detector_body_exited(body):
	state = IDLE


func _on_bullet_cooldown_timeout():
	if state == SHOOT:
		shoot()

		



		
