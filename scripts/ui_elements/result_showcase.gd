extends Node3D

signal showcase_completed

func show_animation():
	var leaderboard = PlayerHandler.players.duplicate()
	leaderboard.sort_custom(func(x, y): return x.points > y.points)
	$trophy_holder.player_name = str(leaderboard[0].screen_position)
	$trophy_holder2.player_name = str(leaderboard[1].screen_position)
	$trophy_holder3.player_name = str(leaderboard[2].screen_position)
	$AnimationPlayer.play("show_winners")
	await $continue.pressed
	$AnimationPlayer.play("end")
	await $AnimationPlayer.animation_finished
	showcase_completed.emit()
