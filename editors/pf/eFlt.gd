extends EditItem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Label.text = prop
	$PanelContainer/LineEdit.value = targ[prop]


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(targ):
		return
	if not $PanelContainer/LineEdit.has_focus():
		$PanelContainer/LineEdit.value = targ[prop]


func _on_line_edit_value_changed(value: float) -> void:
	if not is_instance_valid(targ):
		return
	if targ[prop] != value:
		targ[prop] = value
