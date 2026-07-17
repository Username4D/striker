extends Node3D

var finished_dice: int = 0
var dice_amount = 0

var reroll_finished_dice = 0
var reroll_dice_amount = 0

var current_seat = 0

func dice_add(): finished_dice += 1
func redice_add(): reroll_finished_dice += 1 

func turn():
	$ui_boxes.get_child(current_seat).show_component("your_turn_label", true)
	$roll_button.visible = true
	await $roll_button.pressed
	$roll_button.visible = false
	$ui_boxes.get_child(current_seat).show_component("your_turn_label", false)
	
	finished_dice = 0
	dice_amount = 0
	for i in $dice.get_children():
		i.thrown.connect(dice_add)
		i.throw()
		dice_amount += 1
	while finished_dice != dice_amount:
		await get_tree().process_frame
	
	for i in $dice.get_children():
		i.thrown.disconnect(dice_add)
	
	GameStateHandler.current_dice_set = {}
	for i in $dice.get_children():
		GameStateHandler.current_dice_set[i.name] = i.number
	
	$ui_boxes.get_child(current_seat).show_component("confirm_reroll", true)
	$ui_boxes.get_child(current_seat).show_component("player_card", true, false)
	var do_reroll_callback = await $ui_boxes.get_child(current_seat).do_reroll
	$ui_boxes.get_child(current_seat).show_component("confirm_reroll", false)
	$ui_boxes.get_child(current_seat).show_component("player_card", false)
	if do_reroll_callback:
		reroll_finished_dice = 0
		reroll_dice_amount = 0
		for i in $dice.get_children():
			if i.number != 1:
				i.thrown.connect(redice_add)
				i.throw()
				reroll_dice_amount += 1
			else:
				i.freeze = true
		while reroll_finished_dice != reroll_dice_amount:
			await get_tree().process_frame
		for i in $dice.get_children():
			i.thrown.disconnect(redice_add)
	
	GameStateHandler.current_dice_set = {}
	for i in $dice.get_children():
		GameStateHandler.current_dice_set[i.name] = i.number
	
	for i in $ui_boxes.get_children():
		i.show_component("player_card", true)
	
	await get_tree().process_frame
	while !check_all($ui_boxes.get_children(), "card_finished"):
		await get_tree().process_frame
	
	current_seat += 1
	if current_seat >= $ui_boxes.get_child_count():
		current_seat = 0
	
	for i in $ui_boxes.get_children():
		i.show_component("player_card", false)
	
	$"popups/next turn".next_player_position = $ui_boxes.get_child(current_seat).pointer_position
	$"popups/next turn".play("next_turn")
	await $"popups/next turn".animation_finished
	turn()
	
func _ready() -> void:
	await get_tree().process_frame
	for i in PlayerHandler.players:
		$ui_boxes.get_node(str(i.screen_position)).player = i
		print(i)
	
	for i in $ui_boxes.get_children():
		if i.player == null:
			i.queue_free()
	turn()

func check_all(node_array: Array[Node], property_name):
	for i in node_array:
		if property_name in i:
			if i.get(property_name) == false: return false
	return true
	
