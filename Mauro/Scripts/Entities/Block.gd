extends StaticBody2D

var empty: bool
export(PackedScene) var powerup

func _on_Area2D_body_entered(body):
	if !empty:
		empty = true
		var a = powerup.instance()
		a.global_position = global_position + Vector2(0, -22)
		get_tree().get_nodes_in_group("Main")[0].get_node("Entities").call_deferred("add_child", a)
