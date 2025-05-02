extends Control

func _ready() -> void:
	var i = 0
	var data = Saving.load()
	for choice in $PanelContainer/HBoxContainer.get_children():
		if data.size() <= i:
			(choice as levelChoice).show_for_score(-1, i)
		else:
			(choice as levelChoice).show_for_score(data[i], i+1)
		i += 1


func _on_leave_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
