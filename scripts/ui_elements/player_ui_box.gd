extends Control

@export var player: Resource
signal do_reroll(reroll: bool)


func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	if player:
		$player_card.player = player
	$confirm_reroll.do_reroll.connect(func(x): do_reroll.emit(x))


func show_component(component_name: String, show: bool):
	self.get_node(component_name).visible = show
	if self.get_node(component_name).has_method("update"): self.get_node(component_name).update()
	
