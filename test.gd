extends Node


func _on_pressed() -> void:
	var h:DynamicMenu = preload("res://dynamic_menu.tscn").instantiate()
	h.setup($"../MeshInstance3D")
	get_parent().add_child(h)
	
	


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("lclick"):
		var h:DynamicMenu = preload("res://dynamic_menu.tscn").instantiate()
		h.setup(get_parent())
		get_tree().root.add_child(h)
