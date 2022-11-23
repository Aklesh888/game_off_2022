extends KinematicBody2D

var speed = 80
var health = 100
var direction = Vector2.ZERO
var velocity = Vector2.ZERO

var player: Node 
# Called when the node enters the scene tree for the first time.
onready var death = preload("res://Death.tscn").instance()
onready var animation_tree = $AnimationTree
onready var agent = $NavigationAgent2D
onready var timer = $Timer

func _ready():
	var player = get_tree().get_root().find_node('Player', true, false)
	agent.set_target_location(player.global_position)
	timer.connect("timeout", self, "update_pathfinding")

func _physics_process(delta):
	player = get_tree().get_root().find_node('Player', true, false)
	direction = global_position.direction_to(agent.get_next_location())
	velocity = direction * speed
	move_and_slide(velocity)
	animation_tree.set("parameters/move/blend_position", direction)


func _on_hurtbox_area_entered(area):
	if area.is_in_group('damage_enemy'):
		add_child(death)
		queue_free()

func _on_hit_box_body_entered(body):
	if body.is_in_group('player'):
		add_child(death)
		queue_free()

func update_pathfinding():
	agent.set_target_location(player.global_position)


	
