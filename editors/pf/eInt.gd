extends EditItem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = prop
	$LineEdit.value = targ[prop]
