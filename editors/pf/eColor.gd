extends EditItem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorPickerButton.text = prop
	$ColorPickerButton.color = targ[prop]


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(targ):
		return
	$ColorPickerButton.color = targ[prop]


func _on_color_picker_button_color_changed(color: Color) -> void:
	if not is_instance_valid(targ):
		return
	targ[prop] = color
