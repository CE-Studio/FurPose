extends Node


@export var props:Array[StringName]
@export var highlightMat:Material
@export var defaultMat:Material


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("lclick"):
		get_viewport().set_input_as_handled()
		var h:DynamicMenu = preload("res://dynamic_menu.tscn").instantiate()
		h.setup(self, props)
		#h.setup(get_parent(), ["rotation_degrees", "position", "scale"])
		get_tree().root.add_child(h)


func _on_static_body_3d_mouse_entered() -> void:
	self["surface_material_override/0"] = highlightMat


func _on_static_body_3d_mouse_exited() -> void:
	self["surface_material_override/0"] = defaultMat
