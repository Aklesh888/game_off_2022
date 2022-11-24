extends Area2D

onready var animations = $Sprite

var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var damage = 10

const SPEED = 5

func _ready():
	animations.play("fire")
	

func _physics_process(delta):
	position += SPEED * direction


func _on_fireball_body_entered(body):
	queue_free()


func _on_fireball_area_entered(area):
	queue_free()
