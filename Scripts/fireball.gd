extends Node2D

onready var animations = $Sprite

var velocity = Vector2.ZERO
var direction = Vector2.ZERO

const SPEED = 5

func _ready():
	animations.play("fire")
	

func _physics_process(delta):
	
	position += SPEED * direction
