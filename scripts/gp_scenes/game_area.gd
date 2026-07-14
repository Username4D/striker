extends Node3D

var finished_dice: int = 0
var dice_amount = 0

var reroll_finished_dice = 0
var reroll_dice_amount = 0

var current_seat = 0

func turn():
	$ui_boxes.get_child(current_seat).show_component("your_turn_label", true)
	$roll_button.visible = true
	await $roll_button.pressed
	$roll_button.visible = false
	$ui_boxes.get_child(current_seat).show_component("your_turn_label", false)
	
	finished_dice= 0
	dice_amount = 0
	for i in $dice.get_children():
		i.thrown.connect(func(): finished_dice += 1)
		i.thrown.connect(func(): print("done: ", finished_dice))
		i.throw()
		dice_amount += 1
	while finished_dice != dice_amount:
		await get_tree().process_frame
	
	$ui_boxes.get_child(current_seat).show_component("confirm_reroll", true)
	var do_reroll_callback = await $ui_boxes.get_child(current_seat).do_reroll
	$ui_boxes.get_child(current_seat).show_component("confirm_reroll", false)
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
	
	for i in $ui_boxes.get_children():
		i.show_component("player_card", true)
func _ready() -> void:
	await get_tree().process_frame
	for i in PlayerHandler.players:
		$ui_boxes.get_node(str(i.screen_position)).player = i
		print(i)
	
	for i in $ui_boxes.get_children():
		if i.player == null:
			i.queue_free()
	turn()
