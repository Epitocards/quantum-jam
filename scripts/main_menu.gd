extends Control

func _on_play_button_pressed() -> void:
	ButtonSfx.play()
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _on_quit_pressed() -> void:
	ButtonSfx.play()
	get_tree().quit()
