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
