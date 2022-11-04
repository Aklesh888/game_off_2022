extends KinematicBody2D

signal body_in_detector
var speed = 100 # speed of player
var velocity = Vector2.ZERO # velocity of enemy
var state = IDLE #default state
var player: Node #reference to player
enum {
	IDLE,
	ALERT,
	SHOOT,
	HIT,
	CHASE
}
onready var eye = $player_detector/eye
onready var player_detector = $player_detector

func _physics_process(delta):
	movement()


func movement():
	detect_player_in_area()
	match state:
		IDLE:
			print('idle')
		ALERT:
			print('alert')
		SHOOT:
			shoot()
			print('shoot')
		HIT:
			print('hit')
		CHASE:
			print('chase')

func shoot():
	pass

func detect_player_in_area():#detects if player is in the area and changes states accordingly  
	var bodies = player_detector.get_overlapping_bodies()
	print(bodies)
	if bodies != null:
		for body in bodies:
			if body.is_in_group("player"):
				player = body
			if player != null: 
				var player_distance = position.distance_to(player.get_global_position())
				if player_distance <= 120 :
					state = CHASE
				else:
					state = ALERT
					


func _on_player_detector_body_exited(body):
	state = IDLE
