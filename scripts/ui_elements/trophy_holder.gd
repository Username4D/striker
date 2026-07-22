extends MeshInstance3D

@export var player_name: String
@export var leaderboard_position: int

func _process(delta: float) -> void:
	$player_name.text = player_name
	$position_label.text = str(leaderboard_position)
