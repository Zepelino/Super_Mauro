extends Node

var started: bool

func _ready():
	get_tree().paused = false
	$Tween.interpolate_property(Pixelate.get_node("/root/Pixelate/Pixelate").material, "shader_param/tamanho_multiplo", 100.0, 1.0, 2.0)
	$Tween.interpolate_property(Pixelate.get_node("/root/Pixelate/Pixelate").material, "shader_param/darkness", 1, 0, 2.5)
	$Tween.start()
	$AnimationPlayer.get_animation("Pole").set_loop(true)
	$AnimationPlayer.play("Pole")
	


func _process(delta):
	$ParallaxBackground/ParallaxLayer4.motion_offset.x -= delta * 20


func _on_Pole_body_entered(body):
	get_tree().get_nodes_in_group("Player")[0].set_process(false)
	get_tree().get_nodes_in_group("Player")[0].set_physics_process(false)
	$AnimationPlayer.queue_free()
	$Scenario/Pole/Pole_Pole.queue_free()
	
	Pixelate.get_node("/root/Pixelate/Pixelate").show()
	$Tween.interpolate_property(Pixelate.get_node("/root/Pixelate/Pixelate").material, "shader_param/tamanho_multiplo", 1.0, 100.0, 2.0)
	$Tween.interpolate_property(Pixelate.get_node("/root/Pixelate/Pixelate").material, "shader_param/darkness", 0, 1, 2.5)
	$Tween.start()
	
	get_tree().paused = true


func _on_Tween_tween_all_completed():
	
	if started:
		print("passar")
		get_tree().paused = false
	else:
		started = true
		Pixelate.get_node("/root/Pixelate/Pixelate").hide()
		
