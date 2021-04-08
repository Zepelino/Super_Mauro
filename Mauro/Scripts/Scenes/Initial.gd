extends Node


var letters: int
var talking: bool = true

var started: bool

func _ready():
	$Tween.interpolate_property(Pixelate.get_node("/root/Pixelate/Pixelate").material, "shader_param/tamanho_multiplo", 100.0, 1.0, 2.0)
	$Tween.interpolate_property(Pixelate.get_node("/root/Pixelate/Pixelate").material, "shader_param/darkness", 1, 0, 2.5)
	$Tween.start()

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		letters = $CanvasLayer/ColorRect/RichTextLabel.get_total_character_count()

func _on_Timer_timeout():
	if talking:
		if letters < $CanvasLayer/ColorRect/RichTextLabel.get_total_character_count():
			letters += 1
		else:
			talking = false
			$CanvasLayer/ColorRect/Timer.wait_time = 5.0
			$CanvasLayer/ColorRect/Timer.start()
		$CanvasLayer/ColorRect/RichTextLabel.visible_characters = letters
		
		
	else:
		Pixelate.get_node("/root/Pixelate/Pixelate").show()
		$Tween.interpolate_property(Pixelate.get_node("/root/Pixelate/Pixelate").material, "shader_param/tamanho_multiplo", 1.0, 100.0, 2.0)
		$Tween.interpolate_property(Pixelate.get_node("/root/Pixelate/Pixelate").material, "shader_param/darkness", 0, 1, 2.5)
		$Tween.start()
		$CanvasLayer/ColorRect/Timer.stop()
	


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		$CanvasLayer/ColorRect.show()
		$CanvasLayer/ColorRect/Timer.start()
		get_tree().paused = true


func _on_Tween_tween_all_completed():
	
	if started:
		get_tree().change_scene_to(load("res://Scenes/Yoshi's Island 1.tscn"))
		get_tree().paused = false
		print("passar")
	else:
		started = true
		Pixelate.get_node("/root/Pixelate/Pixelate").hide()
