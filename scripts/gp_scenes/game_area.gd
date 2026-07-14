extends Node3D

var finished_dice: int = 0
var dice_amount = 0

var reroll_finished_dice = 0
var reroll_dice_amount = 0

func turn():
	$roll_button.visible = true
	await $roll_button.pressed
	$roll_button.visible = false
	
	finished_dice= 0
	dice_amount = 0
	for i in $dice.get_children():
		i.thrown.connect(func(): finished_dice += 1)
		i.thrown.connect(func(): print("done: ", finished_dice))
		i.throw()
		dice_amount += 1
	while finished_dice != dice_amount:
		await get_tree().process_frame
	
	$confirm_reroll.visible = true
	var do_reroll_callback = await $confirm_reroll.do_reroll
	$confirm_reroll.visible = false
	if do_reroll_callback:
		reroll_finished_dice = 0
		reroll_dice_amount = 0
		for i in $dice.get_children():
			if i.number != 1:
				i.thrown.connect(func(): reroll_finished_dice += 1)
				i.throw()
				reroll_dice_amount += 1
		while reroll_finished_dice != reroll_dice_amount:
			await get_tree().process_frame
	
	GameStateHandler.current_dice_set = {}
	for i in $dice.get_children():
		GameStateHandler.current_dice_set[i.name] = i.number
	
	$player_card.visible = true
	$player_card.update()
func _ready() -> void:
	turn()
