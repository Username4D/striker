extends Resource

class_name DiceState

@export var number: int
@export var set_value: int = -1
@export var crossed = false

func _init(_number: int) -> void:
	number = _number
