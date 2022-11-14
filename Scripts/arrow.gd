extends Area2D

const SPEED = 10
var direction = Vector2.ZERO

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	position += direction * SPEED 
	look_at(position +  direction)
