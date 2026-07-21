extends Node3D

@export var leaderboard = []

signal update_completed

func update_leaderboard():
	for i in self.get_children():
		i.animate_scoreline()
	while self.get_children().find_custom(func(x): return x.has_shown_normal == false) != -1:
		await get_tree().process_frame
	await get_tree().process_frame
	for i in self.get_children():
		i.apply_bonus.emit()
	while self.get_children().find_custom(func(x): return x.has_shown_bonus == false) != -1:
		await get_tree().process_frame
	update_completed.emit()
func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	for i in PlayerHandler.players:
		self.get_child(PlayerHandler.players.find(i)).player = i
	
	for i in self.get_children():
		if i.player == null:
			i.queue_free()
	await get_tree().process_frame
	leaderboard = self.get_children().duplicate()
func _process(delta: float) -> void:
	leaderboard.sort_custom(func(x, y): return x.score > y.score,)
