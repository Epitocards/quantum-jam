extends Control

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _ready() -> void:
	Saving.save([3,2,0])
