extends EditItem


@onready var X:SpinBox = $PanelContainer/HBoxContainer/LineEdit
@onready var Y:SpinBox = $PanelContainer/HBoxContainer/LineEdit2

var ro := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Label.text = prop
	ro = true
	X.value = targ[prop].x
	Y.value = targ[prop].y
	ro = false


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(targ):
		return
	if not (X.has_focus() or Y.has_focus()):
		ro = true
		X.value = targ[prop].x
		Y.value = targ[prop].y
		ro = false


func _on_line_edit_value_changed(value: float) -> void:
	if ro:
		return
	var vec := Vector2(X.value, Y.value)
	if targ[prop] != vec:
		targ[prop] = vec
