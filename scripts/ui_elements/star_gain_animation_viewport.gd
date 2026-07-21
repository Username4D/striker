extends SubViewport

func change_active_star_count(count: int):
	for i in $star_gain_animation/Control.get_children():
		i.visible = false
	for i in range(0, count):
		$star_gain_animation/Control.get_child(i).visible = true
	

func play():
	$star_gain_animation/AnimationPlayer.play("get_stars")
