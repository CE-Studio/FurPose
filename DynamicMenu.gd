extends Node2D
class_name DynamicMenu

var velocity:Vector2 = Vector2(300, 300)
var held := false
var holdoffset:Vector2
var rect := Rect2()

static var all:Array[DynamicMenu] = []

@onready var vp := get_viewport()
@onready var vbox:VBoxContainer = $PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var scroll:ScrollContainer = $PanelContainer/VBoxContainer/ScrollContainer
@onready var panel:PanelContainer = $PanelContainer
@onready var lbl:Button = $PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/Label

var targvar:Object
var targdict:Array[StringName]
var autopop := false
var cont:Array[CanvasItem]


const supportedtypes = {
	TYPE_STRING: preload("res://editors/pf/eString.tscn"),
	TYPE_STRING_NAME: preload("res://editors/pf/eString.tscn"),
	TYPE_FLOAT: preload("res://editors/pf/eFlt.tscn"),
	TYPE_INT: preload("res://editors/pf/eInt.tscn"),
	TYPE_BOOL: preload("res://editors/pf/eBool.tscn"),
	TYPE_VECTOR2: preload("res://editors/pf/eV2.tscn"),
	TYPE_VECTOR2I: null,
	TYPE_VECTOR3: preload("res://editors/pf/eV3.tscn"),
	TYPE_VECTOR3I: null,
	TYPE_VECTOR4: preload("res://editors/pf/eV4.tscn"),
	TYPE_VECTOR4I: null,
	TYPE_COLOR: null,
	TYPE_CALLABLE: preload("res://editors/pf/eCall.tscn"),
}

func setup(object:Object, dict:Array[StringName] = []) -> void:
	autopop = true
	targvar = object
	if dict == []:
		var k = supportedtypes.keys()
		var h = object.get_property_list()
		for i in h:
			if (i["usage"] & 0b100) and (i["type"] in k):
				targdict.append(i["name"])
	else:
		targdict = dict


func _ready():
	DynamicMenu.all.append(self)
	for i in cont:
		if vbox.get_child_count() > 0:
			vbox.add_child(HSeparator.new())
		vbox.add_child(i)
	if autopop:
		if "name" in targvar:
			if (targvar.name is String) or (targvar.name is StringName):
				lbl.text = targvar.name
		for i in targdict:
			if typeof(targvar[i]) in supportedtypes.keys():
				if is_instance_valid(supportedtypes[typeof(targvar[i])]):
					var h:EditItem = supportedtypes[typeof(targvar[i])].instantiate()
					h.targ = targvar
					h.prop = i
					if vbox.get_child_count() > 0:
						vbox.add_child(HSeparator.new())
					vbox.add_child(h)


func _process(delta):
	rect.position = position
	rect.size = panel.size
	var sr := get_viewport_rect()
	if !held:
		position += velocity * delta
	if position.y < 0:
		position.y = 0
		velocity.y = 0
	elif (position.y + 24) > sr.size.y:
		position.y = sr.size.y - 24
		velocity.y = 0
	if position.x < 0:
		position.x = 0
		velocity.x = 0
	elif (position.x + panel.size.x) > sr.size.x:
		position.x = sr.size.x - panel.size.x
		velocity.x = 0
	velocity = velocity.lerp(Vector2.ZERO, delta * 3)
	skew = lerpf(skew, deg_to_rad(tanh((velocity.x / 50) / 100) * 45), delta * 10)
	scale.y = lerpf(scale.y, clampf(1 - ((velocity.y / 50) / 200), 0.5, 1.5), delta * 10)
	if autopop and (not is_instance_valid(targvar)):
		queue_free()


func _input(event):
	if event is InputEventMouseMotion:
		if held:
			position = event.position + holdoffset
			velocity = event.relative * 50


func _on_label_button_down():
	get_parent().move_child(self, get_parent().get_child_count() - 1)
	held = true
	holdoffset = position - vp.get_mouse_position()


func _on_label_button_up():
	held = false


func _on_v_box_container_child_entered_tree(_node):
	rsize.call_deferred()


func rsize():
	scroll.custom_minimum_size.y = clampf(vbox.size.y + 2, 0, 400) 
	if scroll.custom_minimum_size.y < 400:
		scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	else:
		scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO


func _on_tree_exiting():
	DynamicMenu.all.erase(self)


func _on_min_pressed() -> void:
	scroll.visible = not scroll.visible


func _on_x_pressed() -> void:
	queue_free()
