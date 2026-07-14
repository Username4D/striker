extends Button

@export var color: Color
@export var color_name: String
@export var row: Dictionary

func _ready() -> void:
	if color == Color.BLACK:
		material.set_shader_parameter("black", true)
	else:
		material.set_shader_parameter("shift_amount", color.h * 360)

func update():
	text = str(row[color_name].number)
	if row[color_name].crossed:
		self.disabled = true
	
	if GameStateHandler.current_dice_set[color_name] > row[color_name].number or row[color_name].set_value != -1:
		self.button_pressed = row[color_name].set_value != -1
		self.modulate.a = 0.5 if row[color_name].set_value == -1 else 1.0
		text = str(row[color_name].set_value) if row[color_name].set_value != -1 else str(row[color_name].number)
		self.process_mode = Node.PROCESS_MODE_DISABLED
