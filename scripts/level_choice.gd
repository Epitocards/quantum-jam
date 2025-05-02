class_name levelChoice extends Control

@export_file("*.tscn") var level

func _ready() -> void:
	self.visible = false
	$HBoxContainer/star1.visible = false
	$HBoxContainer/star2.visible = false
	$HBoxContainer/star3.visible = false

func show_for_score(score : int, name : int) -> void:
	if score < 0:
		$HBoxContainer/star1.visible = false
		$HBoxContainer/star2.visible = false
		$HBoxContainer/star3.visible = false
	else:
		self.visible = true
		$Button.text = "LEVEL " + str(name)
		if score > 0:
			$HBoxContainer/star1.visible = true
		if score > 1:
			$HBoxContainer/star2.visible = true
		if score > 2:
			$HBoxContainer/star3.visible = true


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(level)
