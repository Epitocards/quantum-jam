extends Control

@export_file("*.tscn") var next_room: String

func _ready() -> void:
	visible = false

func show_menu() -> void:
	print("c'est le menu")
	visible = true

func _on_play_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file(next_room)

func _on_restart_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_leave_button_pressed() -> void:
	get_tree().quit()
