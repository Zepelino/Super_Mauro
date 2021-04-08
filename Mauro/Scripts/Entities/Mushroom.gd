extends KinematicBody2D


var dir: = 1
onready var spd: = 95 * global_scale.x
onready var grvt: = 1300
var move: Vector2

func _ready():
	move.y = -500

func _physics_process(delta):
	move.y += grvt * delta
	move.x = dir * spd
	move = move_and_slide(move, Vector2.UP)
	
	if is_on_wall():
		dir *= -1

func _on_Area2D_body_entered(body):
	body._powerup(body.Forms.mushroom)
	queue_free()
