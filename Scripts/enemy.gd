extends KinematicBody2D

const SPEED = 50 # speed of player

var velocity = Vector2.ZERO # velocity of enemy
var state = IDLE #default state
var player: Node #reference to player
var direction = Vector2.ZERO
var health = 100

onready var health_box = $Control/ProgressBar
onready var animations = $AnimatedSprite
onready var fireball_position = $fireball_position
onready var fire_ball = preload("res://Scenes/fireball.tscn")
onready var bullet_cd = $bullet_cooldown

enum {
	IDLE,
	ALERT,
	SHOOT,
	HIT,
	CHASE,
	DEATH
}

onready var player_detector = $player_detector

func _physics_process(delta):
	movement()
	health_box.value = health

func movement():
	death()
	attack_frame()
	detect_player_in_area()
	match state:
		IDLE:
			animations.play("Idle")
		SHOOT:
			animations.play("Attack")
			if player.global_position.x >= global_position.x:
				animations.flip_h = false
			elif player.global_position.x <= global_position.x:
				animations.flip_h = true
		HIT:
			animations.play("Hit")
			state = IDLE
		CHASE:
			#print('chase')
			animations.play("Run")
			direction = (player.global_position - position).normalized()
			velocity = direction * SPEED
			velocity = move_and_slide(velocity)
		DEATH:
			queue_free()
			print('dead')
			

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
				player = $'/root/OtherWorld_Scene/Player'
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

func attack_frame():
	if animations.animation == 'attack' and animations.frame == 8:
		shoot()

func death():
	if health <= 0:
		queue_free()

func _on_AnimatedSprite_animation_finished():
	pass # Replace with function body.


func _on_hurtbox_area_entered(area):
	if area.is_in_group('damage_enemy'): 
		health -= area.damage
		state = HIT
		print(health)
