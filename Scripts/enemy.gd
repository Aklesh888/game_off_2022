extends KinematicBody2D

const SPEED = 50 # speed of player

var velocity = Vector2.ZERO # velocity of enemy
var state = IDLE #default state
var player: Node #reference to player
var direction = Vector2.ZERO
var health = 100

export var playerPath = NodePath()

onready var health_box = $Control/ProgressBar
onready var animations = $AnimatedSprite
onready var fireball_position = $fireball_position
onready var fire_ball = preload("res://Scenes/fireball.tscn")
onready var bullet_cd = $bullet_cooldown
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get('parameters/playback')
onready var agent = $NavigationAgent2D
onready var player1 = get_node(playerPath)
onready var timer = $Timer

enum {
	IDLE,
	ALERT,
	SHOOT,
	HIT,
	CHASE,
	DEATH
}

onready var player_detector = $player_detector

func _ready():
	agent.set_target_location(player1.global_position)
	timer.connect("timeout", self, "update_pathfinding")

func _physics_process(delta):
	if agent.is_navigation_finished():
		return
	movement()
	health_box.value = health

func movement():
	death()
	detect_player_in_area()
	match state:
		IDLE:
			pass
		SHOOT:
			animation_state.travel('attack')
			animation_tree.set("parameters/attack/blend_position", direction)
		HIT:
			state = IDLE
		CHASE:
			animation_tree.set("parameters/run/blend_position", direction)
			direction = global_position.direction_to(agent.get_next_location())
			velocity = direction * SPEED
			velocity = move_and_slide(velocity)
			animation_state.travel('run')
		DEATH:
			queue_free()


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
				player =  get_tree().get_root().find_node('Player', true, false)
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


func death():
	if health <= 0:
		queue_free()


func _on_hurtbox_area_entered(area):
	if area.is_in_group('damage_enemy'): 
		health -= area.damage

func update_pathfinding():
	agent.set_target_location(player1.global_position)
