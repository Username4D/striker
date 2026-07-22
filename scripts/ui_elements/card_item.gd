extends Control

@export var color: Color
@export var color_name: String
@export var row: Dictionary
@export var read_only: bool
@export var has_changed = false
var finished = false
var text = ""

func _ready() -> void:
	if color == Color.BLACK:
		$button.material.set_shader_parameter("black", true)
		$final.material.set_shader_parameter("black", true)
	else:
		$button.material.set_shader_parameter("shift_amount", color.h * 360)
		$final.material.set_shader_parameter("shift_amount", color.h * 360)

func update():
	$button.process_mode = Node.PROCESS_MODE_INHERIT
	finished = false
	$button.add_theme_font_size_override("font_size", 32)
	has_changed = false
	$button.text = str(row[color_name].number)
	$button.modulate.a = 1
	if row[color_name].crossed:
		$button.disabled = true
	
	if row[color_name].set_value != -1:
		$button.button_pressed = true
		$button.text = str(row[color_name].set_value)
		$button.process_mode = Node.PROCESS_MODE_DISABLED
		$button.scale = Vector2(0.5, 0.5)
		$button.add_theme_font_size_override("font_size", 50)
		return
		
	if GameStateHandler.current_dice_set[color_name] > row[color_name].number:
		$button.button_pressed = false
		$button.modulate.a = 0.5
		$button.text = str(row[color_name].number)


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if row[color_name].set_value == -1:
			$button.text = str(GameStateHandler.current_dice_set[color_name]) if GameStateHandler.current_dice_set[color_name] <= row[color_name].number else "0"
	else:
		$button.text = str(row[color_name].number)
	if $button.button_pressed == true and row[color_name].set_value == -1:
		has_changed = true
	else:
		has_changed = false



func _on_button_down() -> void:
	_on_toggled(!$button.button_pressed)


func _on_button_up() -> void:
	_on_toggled($button.button_pressed)

func _process(delta: float) -> void:
	text = $button.text if !finished else $final/final_number.text
	
func finish():
	$button.process_mode = Node.PROCESS_MODE_DISABLED
	if $button.button_pressed == false:
		finished = true
		$final/final_number.text = str(GameStateHandler.current_dice_set[color_name] if GameStateHandler.current_dice_set[color_name] <= row[color_name].number else 0)
		while $button.modulate.a != 1.0:
			$button.modulate.a = move_toward($button.modulate.a, 1.0, get_process_delta_time())
			await get_tree().process_frame
		print("should_play_animation")
		$AnimationPlayer.play("open")
		await get_tree().process_frame
		self.get_parent().get_parent().player.row_states[self.get_parent().get_parent().player.current_row][color_name].set_value = int($final/final_number.text)
