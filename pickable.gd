extends Node
class_name Pickable


@export var props:Array[StringName]
@export var highlightMat:Material
@export var defaultMat:Material
@export var spawnGizmo := true
@export var changeColor := false
@export var color := Color("#6d6d6d"):
	set(value):
		color = value
		vmat.albedo_color = value
		if color.a < 1:
			vmat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		else:
			vmat.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
@export var colorBackface := false
@export var colorIncludeSelf := false


var vmat := StandardMaterial3D.new()


var xRotation:
	get:
		return self.rotation.x
	set(value):
		xRotation = value
		self.rotation.x = value
var yRotation:
	get:
		return self.rotation.y
	set(value):
		yRotation = value
		self.rotation.y = value
var zRotation:
	get:
		return self.rotation.z
	set(value):
		zRotation = value
		self.rotation.z = value


func _ready() -> void:
	vmat.albedo_color = color
	if colorBackface:
		vmat.cull_mode = BaseMaterial3D.CULL_DISABLED
	if changeColor:
		if colorIncludeSelf:
			setmat(self, vmat)
		else:
			for i in get_children():
				setmat(i, vmat)
	for i in get_children():
		if i is StaticBody3D:
			i.input_event.connect(_on_input_event)
			i.mouse_entered.connect(_on_static_body_3d_mouse_entered)
			i.mouse_exited.connect(_on_static_body_3d_mouse_exited)


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("lclick"):
		get_viewport().set_input_as_handled()
		if is_instance_valid(Gizmo.instance) and (Gizmo.instance.targ == self):
			var h:DynamicMenu = preload("res://dynamic_menu.tscn").instantiate()
			h.setup(self, props)
			get_tree().root.add_child(h)
		else:
			Gizmo.select(self)


func delete() -> void:
	queue_free()


func setmat(obj:Node, mat:Material) -> void:
	for i in obj.get_children():
		setmat(i, mat)
	if not obj.is_in_group(&"noRecolor"):
		if obj is Pickable:
			obj.defaultMat = mat
		if obj is MeshInstance3D:
			obj["surface_material_override/0"] = mat


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
