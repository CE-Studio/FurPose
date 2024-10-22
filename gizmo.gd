extends MeshInstance3D
class_name Gizmo

enum {
	X,
	Y,
	Z
}


static var instance:Gizmo


static func select(selected:Pickable) -> Gizmo:
	if is_instance_valid(instance):
		instance.queue_free()
	instance = Gizmo.new()
	instance.targ = selected
	selected.get_parent().add_child(instance)
	instance.position = selected.position
	return instance


const MX:Mesh = preload("res://obj/gizmos/rotX.obj")
const MY:Mesh = preload("res://obj/gizmos/rotY.obj")
const MZ:Mesh = preload("res://obj/gizmos/rotZ.obj")
const MATX:StandardMaterial3D = preload("res://mats/gizmos/x.tres")
const MATY:StandardMaterial3D = preload("res://mats/gizmos/y.tres")
const MATZ:StandardMaterial3D = preload("res://mats/gizmos/z.tres")


@export var mode:EulerOrder
@export var targ:Pickable
@export var rotval:Vector3


var l1 := Y
var l2 := X
var l3 := Z
var c2 := MeshInstance3D.new()
var c3 := MeshInstance3D.new()
var hx:StaticBody3D = preload("res://obj/gizmos/xhb.tscn").instantiate()
var hy:StaticBody3D = preload("res://obj/gizmos/yhb.tscn").instantiate()
var hz:StaticBody3D = preload("res://obj/gizmos/zhb.tscn").instantiate()
var hasx := true
var hasy := true
var hasz := true


func _ready() -> void:
	if is_instance_valid(targ):
		mode = targ.rotation_order
		if not(&"rotation" in targ.props):
			hasx = false
			hasy = false
			hasz = false
			if &"xRotation" in targ.props:
				hasx = true
			if &"yRotation" in targ.props:
				hasy = true
			if &"zRotation" in targ.props:
				hasz = true
	add_child(c2)
	c2.add_child(c3)
	match mode:
		EULER_ORDER_XYZ:
			l1 = X
			l2 = Y
			l3 = Z
		EULER_ORDER_XZY:
			l1 = X
			l2 = Z
			l3 = Y
		EULER_ORDER_YXZ:
			l1 = Y
			l2 = X
			l3 = Z
		EULER_ORDER_YZX:
			l1 = Y
			l2 = Z
			l3 = X
		EULER_ORDER_ZXY:
			l1 = Z
			l2 = X
			l3 = Y
		EULER_ORDER_ZYX:
			l1 = Z
			l2 = Y
			l3 = X
	match l1:
		X when hasx:
			mesh = MX
			add_child(hx)
			material_override = MATX
		Y when hasy:
			mesh = MY
			add_child(hy)
			material_override = MATY
		Z when hasz:
			mesh = MZ
			add_child(hz)
			material_override = MATZ
	match l2:
		X when hasx:
			c2.mesh = MX
			c2.add_child(hx)
			c2.material_override = MATX
		Y when hasy:
			c2.mesh = MY
			c2.add_child(hy)
			c2.material_override = MATY
		Z when hasz:
			c2.mesh = MZ
			c2.add_child(hz)
			c2.material_override = MATZ
	match l3:
		X when hasx:
			c3.mesh = MX
			c3.add_child(hx)
			c3.material_override = MATX
		Y when hasy:
			c3.mesh = MY
			c3.add_child(hy)
			c3.material_override = MATY
		Z when hasz:
			c3.mesh = MZ
			c3.add_child(hz)
			c3.material_override = MATZ


func _process(delta: float) -> void:
	if is_instance_valid(targ):
		rotval = targ.rotation
		position = targ.position
	match l1:
		X:
			rotation.x = rotval.x
		Y:
			rotation.y = rotval.y
		Z:
			rotation.z = rotval.z
	match l2:
		X:
			c2.rotation.x = rotval.x
		Y:
			c2.rotation.y = rotval.y
		Z:
			c2.rotation.z = rotval.z
	match l3:
		X:
			c3.rotation.x = rotval.x
		Y:
			c3.rotation.y = rotval.y
		Z:
			c3.rotation.z = rotval.z
