extends Panel

@export var player: Resource
signal do_reroll(reroll: bool)


func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	if player:
		$player_card.player = player
	$confirm_reroll.do_reroll.connect(func(x): do_reroll.emit(x))


func show_component(component_name: String, show_c: bool, _interactable: bool = true):
	var comp = self.get_node(component_name)
	if "interactable" in comp: comp.interactable = _interactable
	comp.visible = show_c
	comp.process_mode = Node.PROCESS_MODE_INHERIT
	if comp.has_method("update"): comp.update()
	var should_show = false
	for i in self.get_children():
		if i.visible == true: should_show = true
	self.visible = should_show
