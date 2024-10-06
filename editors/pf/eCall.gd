extends EditItem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CheckBox.text = prop


func _on_check_box_pressed() -> void:
	targ[prop].call()
