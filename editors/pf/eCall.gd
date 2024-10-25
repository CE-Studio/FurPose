extends EditItem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CheckBox.text = prop


func _on_check_box_pressed() -> void:
	if not is_instance_valid(targ):
		return
	targ[prop].call()
