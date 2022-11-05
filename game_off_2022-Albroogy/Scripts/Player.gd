extends KinematicBody2D

export (int) var speed = 100
var input = Vector2.ZERO
var state = IDLE

enum {
	IDLE,
	MOVE_H,
	MOVE_V,
	ATTACK,
}

onready var animations = $AnimatedSprite
	
func _physics_process(delta):
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	if input.x != 0:
		state = MOVE_H
	elif input.y != 0:
		state = MOVE_V
	else: 
		state = IDLE
	match state:
		IDLE:
			#print('idle')
			animations.play("Idle")
		MOVE_H:
			move_state_H()
		MOVE_V:
			move_state_V()
			
func move_state_H():
	var velocity = Vector2.ZERO
	if input.x == 1:
		animations.flip_h = true
	else: 
		animations.flip_h = false
	animations.play("Run")
	velocity = input.normalized() * speed
	velocity = move_and_slide(velocity)
	
func move_state_V():
	var velocity = Vector2.ZERO
	if input.y == 1:
		animations.play("Down")
	else:
		animations.play("Up")
	velocity = input.normalized() * speed
	velocity = move_and_slide(velocity)
	
	
