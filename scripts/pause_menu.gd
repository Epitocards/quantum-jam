extends Control

@export_file("*.tscn") var next_room: String

signal unpause

func _ready() -> void:
	visible = false

func show_menu() -> void:
	visible = true

func _on_play_button_pressed() -> void:
	ButtonSfx.play()
	unpause.emit()

func _on_restart_button_pressed() -> void:
	ButtonSfx.play()
	get_tree().reload_current_scene()

func _on_leave_button_pressed() -> void:
	ButtonSfx.play()
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
