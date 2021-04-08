extends Area2D

onready var spd: = 200 * global_scale.x
var y_spd: float

var inside = null

var spawn: bool
var dead: bool

onready var grvt = 20 * global_scale.x

func _ready():
	set_process(false)
	set_physics_process(false)

func _process(delta):
	if is_instance_valid(inside):
		inside._damage()

func _physics_process(delta):
	if !dead:
		move_local_x(-spd * delta)
	else:
		y_spd += grvt
		move_local_y(y_spd * delta)

func _on_Head_body_entered(body):
	if !inside:
		$Head.queue_free()
		dead = true
		y_spd = -900
		body.move.y = body.jump_force


func _on_Bullet_Bill_body_entered(body):
	inside = body

func _on_Bullet_Bill_body_exited(body):
	inside = null

func _on_VisibilityNotifier2D_screen_entered():
	if !spawn:
		$AudioStreamPlayer2D.play()
		set_process(true)
		set_physics_process(true)
		spawn = true

func _on_VisibilityNotifier2D_screen_exited():
	if position.x < get_tree().get_nodes_in_group("Player")[0].position.x:
		queue_free()
