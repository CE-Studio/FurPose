extends EditItem


@onready var X:SpinBox = $PanelContainer/HBoxContainer/LineEdit
@onready var Y:SpinBox = $PanelContainer/HBoxContainer/LineEdit2
@onready var Z:SpinBox = $PanelContainer/HBoxContainer/LineEdit3
@onready var W:SpinBox = $PanelContainer/HBoxContainer/LineEdit4

var ro := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Label.text = prop
	ro = true
	X.value = targ[prop].x
	Y.value = targ[prop].y
	Z.value = targ[prop].z
	W.value = targ[prop].w
	ro = false


func _physics_process(_delta: float) -> void:
	if not (X.has_focus() or Y.has_focus() or Z.has_focus()):
		ro = true
		X.value = targ[prop].x
		Y.value = targ[prop].y
		Z.value = targ[prop].z
		W.value = targ[prop].w
		ro = false


func _on_line_edit_value_changed(value: float) -> void:
	if ro:
		return
	var vec := Vector4(X.value, Y.value, Z.value, W.value)
	if targ[prop] != vec:
		targ[prop] = vec
