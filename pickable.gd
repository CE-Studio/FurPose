extends Node
class_name Pickable


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


func delete() -> void:
	queue_free()


func makeDuplicate() -> void:
	var h = self.duplicate()
	get_parent().add_child(h, true)
	h.set_owner(get_parent())
	h.position.z += 1


func align_with_y(xform:Transform3D, new_y:Vector3) -> Transform3D:
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform


func snapToSurface() -> void:
	$RayCast3D.force_raycast_update()
	if $RayCast3D.is_colliding():
		self.global_transform = align_with_y(self.global_transform, $RayCast3D.get_collision_normal())
		print($RayCast3D.get_collision_point())
		self.global_position = $RayCast3D.get_collision_point()
		print(self.global_position)


func _on_static_body_3d_mouse_entered() -> void:
	self["surface_material_override/0"] = highlightMat


func _on_static_body_3d_mouse_exited() -> void:
	self["surface_material_override/0"] = defaultMat