extends StaticBody2D

var spd: = 0
onready var grvt: = 5 * global_scale.x

var inside = null



func _process(delta):
	if $Piranha.position.y < -60:
		spd += grvt
	else:
		spd = 0
		set_process(false)
	$Piranha.move_local_y(spd * delta)
	#$Piranha.position.y = lerp($Piranha.position.y, pos_y, delta * spd)
	if is_instance_valid(inside):
		inside._damage()


func _on_Timer_timeout():
	$Piranha.position.y = -61
	spd = -500
	set_process(true)


func _on_Piranha_body_entered(body):
	inside = body


func _on_Piranha_body_exited(body):
	inside = null
