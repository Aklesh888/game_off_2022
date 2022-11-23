extends KinematicBody2D

var speed = 1
var health = 100
var direction = Vector2.ZERO
var velocity = Vector2.ZERO

var player: Node 
# Called when the node enters the scene tree for the first time.

onready var animation_tree = $AnimationTree


func _physics_process(delta):
	var player = get_tree().get_root().find_node('Player', true, false)
	direction = global_position.direction_to(player.global_position).normalized()
	velocity = direction * speed
	move_and_collide(velocity)
	animation_tree.set("parameters/move/blend_position", direction)


func _on_hurtbox_area_entered(area):
	if area.is_in_group('damage_enemy'):
		queue_free()



func _on_hit_box_body_entered(body):
	if body.is_in_group('player'):
		queue_free()
