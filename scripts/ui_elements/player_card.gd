extends Control

@export var player: Resource
@export var finished = false

@export var interactable = false

signal finish_card

var changes = 0

func update():
	$HFlowContainer.position.x = 0
	$finish_button.visible = false
	self.modulate.a = 1
	finished = false
	changes = 0
	for i in $HFlowContainer.get_children():
		i.color_name = i.name
		i.row = player.row_states[player.current_row]
		i.read_only = !interactable
		i.update()
	
	$finish_button.visible = interactable
	if !interactable: self.process_mode = Node.PROCESS_MODE_DISABLED
	
	var children = $HFlowContainer.get_children()
	children.sort_custom(func(a, b): return a.row[a.color_name].number > b.row[b.color_name].number)
	
	for i in range(children.size()):
		$HFlowContainer.move_child(children[i], i)
	


func finalize():
	changes = 0
	for i in player.row_states[player.current_row]:
		var dice_state = player.row_states[player.current_row][i]
		if $HFlowContainer.get_node(i).has_changed:
			dice_state.set_value = GameStateHandler.current_dice_set[$HFlowContainer.get_node(i).color_name] if $HFlowContainer.get_node(i).text != "0" else 0

func _on_finish_button_pressed() -> void:
	finalize()
	finished = true
	var is_every_finished = true
	for i in player.row_states[player.current_row]:
		if player.row_states[player.current_row][i].set_value == -1: is_every_finished = false
	if is_every_finished: finish_card.emit()
	$HFlowContainer.position.x = 32
	$finish_button.visible = false
	for i in $HFlowContainer.get_children():
		i.read_only = true

func _process(delta: float) -> void:
	if !finished:
		var should_be_visible = false
		for i in $HFlowContainer.get_children():
			if i.has_changed: should_be_visible = true
		if should_be_visible != $finish_button.visible: $finish_button.visible = should_be_visible
	else:
		$finish_button.visible = false
func finish():
	for i in $HFlowContainer.get_children():
		i.finish()
		await get_tree().process_frame
		finalize()
		await get_tree().process_frame
		
		
