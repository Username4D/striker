extends MeshInstance3D

@export var player: Resource
@export var score: int
@export var has_shown_normal = false
@export var has_shown_bonus = false

signal apply_bonus

func animate_scoreline():
	has_shown_normal = false
	has_shown_bonus = false
	score = player.previous_points
	while score != player.points - player.bonus_points:
		score += 1
		await get_tree().create_timer(0.1).timeout
	has_shown_normal = true
	await apply_bonus
	$star_gain_animation_viewport.play()
	await get_tree().create_timer(1.6).timeout
	while score != player.points:
		score += 1
		await get_tree().create_timer(0.1).timeout
	has_shown_bonus = true

func _process(delta: float) -> void:
	$score.text = str(score)
	if player: $player_name.text = str(player.screen_position)
	self.position.z = move_toward(self.position.z, 1.3 + float(self.get_parent().leaderboard.find(self)) / 5, delta * 0.5)
