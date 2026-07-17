extends AnimationPlayer

@export var next_player_position: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	$player_indicator.look_at(next_player_position)
