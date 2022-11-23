extends Node2D

onready var timer = $Timer
onready var hit_box = $CollisionShape2D
var previous_position = Vector2.ZERO
var damage = 20

func sword_animation():
	var tween = create_tween().set_trans(Tween.TRANS_QUINT)
	var new_position = global_position.direction_to(get_global_mouse_position()) * 18
	tween.tween_property(self, "position", new_position, 0.2)
	tween.tween_property(self, "position", previous_position, 0.2)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		sword_animation()

func _process(delta):
	set_as_toplevel(false)
	look_at(get_global_mouse_position())

func _on_Timer_timeout():
	hit_box.disabled = true
