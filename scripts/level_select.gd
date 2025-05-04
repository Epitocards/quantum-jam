extends Control

func _ready() -> void:
	var data = Saving.load()
	var children = $PanelContainer/HFlowContainer.get_children()
	for i in range(children.size()):
		if data.size() <= i:
			break
		(children[i] as levelChoice).show_for_score(data[i], i+1)
		if data[i] == 0 and i < children.size() - 1:
			(children[i+1] as levelChoice).show_for_score(-2, i+2)
			break
	if GameMusic.playing:
		GameMusic.stop()
		Music.play()


func _on_leave_button_pressed() -> void:
	ButtonSfx.play()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
