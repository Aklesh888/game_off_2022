extends Area2D

var direction = Vector2.ZERO
var state
var enemy = preload("res://Scenes/skeleton.tscn")
onready var timer = $Timer
onready var animations = $AnimationPlayer

enum{
	attack,
	idle
}

func _ready():
	randomize()
	state = idle

func spawner():
	enemies()
	enemies()

func enemies():
	var enemy_position_x = rand_range(global_position.x - 100, global_position.x + 100)
	var enemy_position_y = rand_range(global_position.y - 100, global_position.y + 100)
	var new_enemy = enemy.instance()
	add_child(new_enemy)
	new_enemy.position = Vector2(enemy_position_x, enemy_position_y)


func _on_Timer_timeout():
	animations.play("attack")

func _on_AnimationPlayer_animation_finished(attack):
	spawner()
	state = idle

func _physics_process(delta):
	match state:
		idle:
			animations.play("idle")
			print('idle')
		attack:
			print('attack')


func _on_AnimationPlayer_animation_started(attack):
	state = attack

func direction_checker():
	pass
