extends Area2D

var direction = Vector2.ZERO
var state
var health = 200
var enemy = preload("res://Scenes/skull.tscn")
onready var health_box = $Control/ProgressBar
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
	var enemy_position_x = rand_range(global_position.x - 500, global_position.x )
	var enemy_position_y = rand_range(global_position.y - 500, global_position.y )
	var new_enemy = enemy.instance()
	add_child(new_enemy)
	new_enemy.position = Vector2(enemy_position_x, enemy_position_y)


func _on_Timer_timeout():
	animations.play("attack")

func _on_AnimationPlayer_animation_finished(attack):
	spawner()
	state = idle

func _physics_process(delta):
	health_box.value = health
	if health <= 0:
		queue_free()
	match state:
		idle:
			animations.play("idle")
		attack:
			pass

func _on_AnimationPlayer_animation_started(attack):
	state = attack


func _on_hurtbox_area_entered(area):
	print(health)
	if area.is_in_group('damage_enemy'): 
		health -= area.damage
