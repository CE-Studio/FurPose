extends ScrollContainer


@export var items:Array[PackedScene]
@export var names:Array[String]
@export var icons:Array[Texture2D]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in items.size():
		var b := Button.new()
		b.tooltip_text = names[i]
		b.pressed.connect(spawn.bind(items[i]))
		b.icon = icons[i]
		$VBoxContainer.add_child(b)
		
		
func spawn(n:PackedScene) -> void:
	$"../../../../World".add_child(n.instantiate(), true)
