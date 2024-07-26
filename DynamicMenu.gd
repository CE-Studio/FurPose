extends Node2D
class_name DynamicMenu

var velocity:Vector2 = Vector2(300, 300)
var held := false
var holdoffset:Vector2
var rect := Rect2()

static var all:Array[DynamicMenu] = []

@onready var vp := get_viewport()
@onready var vbox:VBoxContainer = $PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var panel:PanelContainer = $PanelContainer


func _ready():
	DynamicMenu.all.append(self)


func _process(delta):
	rect.position = position
	rect.size = panel.size
	if !held:
		position += velocity * delta
	velocity = velocity.lerp(Vector2.ZERO, delta * 3)
	skew = lerpf(skew, deg_to_rad(tanh((velocity.x / 50) / 100) * 45), delta * 10)
	scale.y = lerpf(scale.y, clampf(1 - ((velocity.y / 50) / 200), 0.5, 1.5), delta * 10)


func _input(event):
	if event is InputEventMouseMotion:
		if held:
			position = event.position + holdoffset
			velocity = event.relative * 50


func _on_label_button_down():
	held = true
	holdoffset = position - vp.get_mouse_position()


func _on_label_button_up():
	held = false


func _on_v_box_container_child_entered_tree(_node):
	rsize.call_deferred()


func rsize():
	panel.custom_minimum_size.y = clampf(vbox.size.y + 40, 0, 400) 


func _on_tree_exiting():
	DynamicMenu.all.erase(self)
