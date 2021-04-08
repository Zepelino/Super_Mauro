extends KinematicBody2D

var dir: = -1
onready var spd: = 25 * global_scale.x

var move: Vector2
onready var grvt = 20 * global_scale.x

var life: = 2
var inside = null

var dmg_time: float = 0

const col_pos = [Vector2(0, 12), Vector2(0, 9.75), Vector2(0, 3.5)]

func _process(delta):
	$Node2D.scale.x = dir
	
	if dmg_time > 0:
		dmg_time -= delta
		
	elif is_instance_valid(inside):
		inside._damage()

func _physics_process(delta):
	move.y += grvt
	move.x = spd * dir
	
	move = move_and_slide_with_snap(move, Vector2.DOWN, Vector2.UP, false, 4, 0)
	
	if is_on_floor() && (is_on_wall() || $Node2D/RayCast2D.get_collider() == null):
		dir *= -1

func _damage(all:= false):
	
	life -= 1
	$Node2D/Sprite.scale.y /= 2
	$CollisionShape2D.shape.extents.y /= 2
	if life > 0:
		$CollisionShape2D.position = col_pos[life]
		$Body.position = col_pos[life]
		$Head.position = col_pos[life] + Vector2(0, $CollisionShape2D.shape.extents.y)
	
	if all || life <= 0:
		life = 0
		$Die.start()
		$Node2D/Sprite.scale.y = 0.25
		
		set_process(false)
		set_physics_process(false)

func _on_Head_body_entered(body):
	if life > 0 && !inside:
		dmg_time = 0.05
		body.move.y = body.jump_force
		_damage()


func _on_Die_timeout():
	queue_free()

func _on_Body_body_entered(body):
	inside = body

func _on_Body_body_exited(body):
	inside = null
