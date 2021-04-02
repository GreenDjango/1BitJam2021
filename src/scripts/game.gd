extends Spatial

onready var _viewport = $ViewportContainer/Viewport

func _ready():
	_viewport.size = get_viewport().size
