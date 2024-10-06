extends EditItem


@onready var X:SpinBox = $PanelContainer/HBoxContainer/LineEdit
@onready var Y:SpinBox = $PanelContainer/HBoxContainer/LineEdit2
@onready var Z:SpinBox = $PanelContainer/HBoxContainer/LineEdit3
@onready var uni:CheckBox = $HBoxContainer/PanelContainer/CheckBox

var ro := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Label.text = prop
	ro = true
	X.value = targ[prop].x
	Y.value = targ[prop].y
	Z.value = targ[prop].z
	ro = false
	if prop == "scale":
		uni.button_pressed = true


func _physics_process(_delta: float) -> void:
	if not (X.has_focus() or Y.has_focus() or Z.has_focus()):
		ro = true
		X.value = targ[prop].x
		Y.value = targ[prop].y
		Z.value = targ[prop].z
		ro = false


func _on_line_edit_value_changed(value: float) -> void:
	if ro:
		return
	var vec:Vector3
	if uni.button_pressed:
		vec = Vector3(X.value, X.value, X.value)
	else:
		vec = Vector3(X.value, Y.value, Z.value)
	if targ[prop] != vec:
		targ[prop] = vec


func _on_check_box_toggled(toggled_on: bool) -> void:
	$PanelContainer/HBoxContainer/LineEdit2.editable = not toggled_on
	$PanelContainer/HBoxContainer/LineEdit3.editable = not toggled_on
