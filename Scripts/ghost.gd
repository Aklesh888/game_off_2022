extends KinematicBody2D

const SPEED = 60 # speed of player

var velocity = Vector2.ZERO # velocity of enemy
var state = IDLE #default state
var player: Node #reference to player
var direction = Vector2.ZERO
var health = 100

export var playerPath = NodePath()

onready var animations = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var player_detector = $player_detector
onready var animation_state = animationTree.get("parameters/playback")
onready var health_box = $Control/ProgressBar
onready var agent = $NavigationAgent2D
onready var player1 = get_node(playerPath)
onready var timer = $Timer
onready var audio = $AudioStreamPlayer

enum {
	IDLE,
	ATTACK,
	HIT,
	CHASE,
	DEATH
}
func _ready():
	agent.set_target_location(player1.global_position)
	timer.connect("timeout", self, "update_pathfinding")
	
func _physics_process(delta):
	if agent.is_navigation_finished():
		return
	movement()
	detect_player_in_area()
	health_box.value = health
	if health <= 0:
		state = DEATH
		audio.play()
		animations.play('death')
		animationTree.active = false

func detect_player_in_area():#detects if player is in the area and changes states accordingly  
	var bodies = player_detector.get_overlapping_bodies()
	if bodies != null:
		for body in bodies:
			if body.is_in_group("player"):
				player = body
			if player != null: 
				var player_distance = position.distance_to(player.get_global_position())
				if player_distance <= 50 :
					state = ATTACK
				else:
					state = CHASE
					


func movement():
	match state:
		IDLE:
			animationTree.set("parameters/idle/blend_position", direction)
			animation_state.travel('idle')
		CHASE:
			#print('chase')
			if player != null:
				animation_state.travel('idle')
				direction = global_position.direction_to(agent.get_next_location())
				animationTree.set("parameters/idle/blend_position", direction)
				velocity = direction * SPEED
				velocity = move_and_slide(velocity)
		ATTACK:
			animationTree.set("parameters/attack/blend_position", direction)
			animation_state.travel('attack')
		DEATH:
			pass


func _on_hurt_box_area_entered(area):
	if area.is_in_group('damage_enemy'): 
		health -= area.damage
		state = HIT
		print(health)


func _on_AnimationPlayer_animation_finished(death):
	queue_free()

func update_pathfinding():
	agent.set_target_location(player1.global_position)
