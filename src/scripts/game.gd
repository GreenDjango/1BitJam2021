extends Spatial

onready var _viewport : Viewport = $ViewportContainer/Viewport

func _ready():
	_viewport.size = get_viewport().size

