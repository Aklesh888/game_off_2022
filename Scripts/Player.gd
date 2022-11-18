extends KinematicBody2D

export (int) var speed = 100
var input = Vector2.ZERO
var state = MOVE
var weapon_state = null
var health = 100
var velocity = Vector2.ZERO
var current_weapon = null 
var weapon_on_hand = false

enum {
	S,
	B
}

enum {
	SWORD_STATE,
	BOW_STATE
}

enum {
	IDLE,
	MOVE,
}

onready var bow_in_hand: Node
onready var sword_in_hand: Node
onready var sword_position = $sword_placement
onready var animations = $AnimatedSprite
onready var weapon_detector = $weapon_detector
onready var health_box = $Health/ProgressBar

onready var sword_symbol = preload("res://Scenes/sword_symbol.tscn")
onready var bow_symbol = preload("res://Scenes/bow_symbol.tscn")
onready var SWORD = preload("res://Scenes/sword.tscn")
onready var BOW = preload("res://Scenes/bow.tscn")
onready var ARROW = preload("res://Scenes/arrow.tscn") 

func _ready():
	sword_position.set_as_toplevel(true)

func _input(event):
	if event.is_action_pressed('pick'):
		weapon_detecting()


func _physics_process(delta):
	health_box.value = health
	if sword_in_hand != null:
		sword_in_hand.look_at(get_global_mouse_position()) 
	if bow_in_hand != null:
		bow_in_hand.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("pick") and current_weapon != null:
		weapon_drop()
	match state:
		IDLE:
			print('idle')
			animations.play("Idle")
		MOVE:
			get_input()
	
	match weapon_state:
		SWORD_STATE:
			sword_attack()
		BOW_STATE:
			bow_attack()
	weapon_state_checker()

func _on_hurtbox_area_entered(area):
	if area.is_in_group('damage'):
		health -= area.damage


func get_input():
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_forward", "move_backward")
	input = input.normalized()
	velocity = input * speed
	velocity = move_and_slide(velocity)


func sword_attack():
	if Input.is_action_just_pressed("shoot"):
		sword_in_hand.hit_box.disabled = false
		sword_in_hand.sword_animation()
		sword_in_hand.previous_position = sword_position.global_position.direction_to(sword_in_hand.global_position)
		sword_in_hand.timer.start()

func bow_attack():
	if bow_in_hand != null:
		if Input.is_action_just_pressed("shoot"):
			bow_in_hand.sprites.frame = 1 

		if Input.is_action_just_released("shoot"):
			bow_in_hand.sprites.frame = 0
			var arrow = ARROW.instance()
			add_child(arrow)
			arrow.direction = global_position.direction_to(get_global_mouse_position())
			arrow.position = bow_in_hand.arrow_position.global_position


func weapon_detecting():
	var weapons = weapon_detector.get_overlapping_areas()
	if weapon_on_hand == false:
		for weapon in weapons:
			if weapon.is_in_group('sword_pickable'):
				var sword = SWORD.instance()
				self.add_child(sword)
				sword.position = sword_position.global_position
				weapon.queue_free()
				current_weapon = S
				sword_in_hand = get_node('../Player/sword')
				weapon_on_hand = true
			elif weapon.is_in_group('bow_pickable'):
				var bow = BOW.instance()
				add_child(bow)
				bow.position = sword_position.global_position
				weapon.queue_free()
				current_weapon = B
				bow_in_hand = $'../Player/bow'
				weapon_on_hand = true

func weapon_state_checker():
	if current_weapon == S:
		weapon_state = SWORD_STATE
	elif current_weapon == B:
		weapon_state = BOW_STATE


func weapon_drop():
	if current_weapon == S:
		var dropped_sword = sword_symbol.instance()
		add_child(dropped_sword)
		dropped_sword.position = global_position
	if current_weapon == B:
		var dropped_bow = bow_symbol.instance()
		add_child(dropped_bow)
		dropped_bow.position = global_position

