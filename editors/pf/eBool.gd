extends EditItem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CheckBox.text = prop
	$CheckBox.set_pressed_no_signal(targ[prop])


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(targ):
		return
	$CheckBox.set_pressed_no_signal(targ[prop])


func _on_check_box_toggled(toggled_on: bool) -> void:
	if not is_instance_valid(targ):
		return
	targ[prop] = toggled_on
