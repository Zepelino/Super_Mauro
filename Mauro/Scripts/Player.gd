extends KinematicBody2D


var x_axis: float

var max_spd: = 100
var spd: = 0
var accl: = 10
var run: bool

onready var max_spd_run = 160 * global_scale.x
onready var max_spd_wlk = 100 * global_scale.x

onready var grvt: = 20 * global_scale.x
onready var jump_force: = -300 * global_scale.x

var move: Vector2

onready var mirror: = $Node2D

var crounch: bool

var invencible: bool

enum Forms{dead, small, mushroom, fireflower}
var form = Forms.small

func _ready():
	
	$Camera2D.limit_right = get_tree().get_nodes_in_group("Limiter")[0].position.x
	$Camera2D.limit_top = get_tree().get_nodes_in_group("Limiter")[0].position.y
	
	if form == Forms.small:
		set_crounched(true)

func _process(delta):
	if x_axis != 0:
		if sign(spd) > 0:
			mirror.scale.x = 1
		elif sign(spd) < 0:
			mirror.scale.x = -1
	
	max_spd = max_spd_run if run else max_spd_wlk
	
	accl = set_acceleration(delta)
	
	if position.y > 1800:
		get_tree().reload_current_scene()

func set_acceleration(delta: float):
	var acl = 10 if run else 2
	acl *= 5 if is_on_floor() && x_axis == 0 else 1
	acl /= 5 if run && sign(spd) != x_axis && x_axis != 0 else 1
	var final_accl: float
	final_accl = lerp(final_accl, acl, delta * 100)
	return final_accl

func _physics_process(delta):
	
	spd = lerp(spd, max_spd * x_axis, accl * delta) if !crounch || !is_on_floor() else 0
	move = Vector2(spd, move.y)
	move.y += grvt
	
	move.y = jump_force if Input.is_action_just_pressed("Jump") && is_on_floor() && !crounch else move.y
	
	move = move_and_slide_with_snap(move, Vector2.DOWN, Vector2.UP, true)

func set_crounched(crounched: bool):
	if crounched:
		$Crounched.set_deferred("disabled", false)
		$Normal.set_deferred("disabled", true)
		$Node2D/Sprite.scale.y = 0.4
	elif form > Forms.small:
		$Crounched.set_deferred("disabled", true)
		$Normal.set_deferred("disabled", false)
		$Node2D/Sprite.scale.y = 1

func _input(event):
	crounch = Input.is_action_pressed("Down")
	x_axis = (Input.get_action_strength("Right") - Input.get_action_strength("Left"))
	
	run = Input.is_action_pressed("Run") && x_axis != 0
	
	if Input.is_action_just_pressed("Down"):
		set_crounched(true)
	elif Input.is_action_just_released("Down"):
		set_crounched(false)

func _damage():
	if !invencible:
		invencible = true
		$Invencible.start()
		
		form -= 1
		
		if form > 0:
			#ainda não morreu
			set_crounched(form == Forms.small)
		else:
			#morreu
			set_process_input(false)
			crounch = false
			x_axis = 0
			run = false
			move = Vector2(0, jump_force * 0.75)
			set_collision_layer_bit(0, false)
			set_collision_mask_bit(19, false)

func _on_Invencible_timeout():
	invencible = false

func _powerup(power: int):
	if form == Forms.small || power > Forms.mushroom:
		form = power
	set_crounched(false)
