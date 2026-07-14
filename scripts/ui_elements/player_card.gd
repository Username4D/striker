extends Control

@export var player: Resource
@export var finished = false

func update():
	for i in $HFlowContainer.get_children():
		i.color_name = i.name
		i.row = player.row_states[player.current_row]
		i.update()

func _ready() -> void:
	player = PlayerHandler.player

func finalize():
	for i in player.row_states[player.current_row]:
		var dice_state = player.row_states[player.current_row][i]
		if $HFlowContainer.get_node(i).button_pressed:
			dice_state.set_value = GameStateHandler.current_dice_set[$HFlowContainer.get_node(i).color_name]

func _on_finish_button_pressed() -> void:
	finalize()
	finished = true
	self.modulate.a = 0.8
	$HFlowContainer.position.x = 32
	$finish_button.visible = false
	self.process_mode = Node.PROCESS_MODE_DISABLED
