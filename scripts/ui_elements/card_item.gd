extends Button

@export var color: Color
@export var color_name: String
@export var row: Dictionary
@export var read_only: bool
@export var has_changed = false

func _ready() -> void:
	if color == Color.BLACK:
		material.set_shader_parameter("black", true)
	else:
		material.set_shader_parameter("shift_amount", color.h * 360)

func update():
	text = str(row[color_name].number)
	if row[color_name].crossed:
		self.disabled = true
	
	if row[color_name].set_value != -1:
		self.button_pressed = true
		text = str(row[color_name].set_value)
		self.process_mode = Node.PROCESS_MODE_DISABLED
		
	if GameStateHandler.current_dice_set[color_name] > row[color_name].number:
		self.button_pressed = false
		self.modulate.a = 0.5
		text = str(row[color_name].number)
		self.process_mode = Node.PROCESS_MODE_DISABLED


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if row[color_name].set_value == -1:
			text = str(GameStateHandler.current_dice_set[color_name])
	else:
		text = str(row[color_name].number)
	if self.button_pressed == true and row[color_name].set_value == -1:
		has_changed = true
	else:
		has_changed = false



func _on_button_down() -> void:
	_on_toggled(!button_pressed)


func _on_button_up() -> void:
	_on_toggled(button_pressed)
