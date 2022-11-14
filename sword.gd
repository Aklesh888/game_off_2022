extends Node2D


onready var animations = $AnimationPlayer



func sword_animation():
#	var tween = create_tween().set_trans(Tween.TRANS_QUINT)
#	var rotation = global_position.direction_to(get_global_mouse_position())
#	tween.interpolate_value(self, "position", global_position,  )
	pass


func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		sword_animation()

func attack():
	pass
