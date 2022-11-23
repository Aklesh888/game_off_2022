extends Area2D

const SPEED = 10
var direction = Vector2.ZERO
var damage = 10

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	position += direction * SPEED 
	look_at(position +  direction)


func _on_arrow_area_entered(area):
	queue_free()	
