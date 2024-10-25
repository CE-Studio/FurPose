extends EditItem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = prop
	$LineEdit.text = targ[prop]


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(targ):
		return
	if not $LineEdit.has_focus():
		$LineEdit.text = targ[prop]


func _on_line_edit_text_submitted(new_text: String) -> void:
	if not is_instance_valid(targ):
		return
	targ[prop] = new_text


func _on_line_edit_focus_exited() -> void:
	if not is_instance_valid(targ):
		return
	targ[prop] = $LineEdit.text
