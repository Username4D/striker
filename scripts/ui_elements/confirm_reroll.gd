extends Control

signal do_reroll(reroll: bool)

func _on_yes_button_pressed() -> void:
	do_reroll.emit(true)

func _on_no_button_pressed() -> void:
	do_reroll.emit(false)
