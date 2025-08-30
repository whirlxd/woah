extends Camera2D

@export var lock_y: bool = true
var start_y: float

func _ready() -> void:
	start_y = global_position.y

func _process(delta: float) -> void:
	if lock_y:
		global_position.y = start_y
