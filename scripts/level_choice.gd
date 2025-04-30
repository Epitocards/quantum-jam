class_name levelChoice extends Control

func _ready() -> void:
	self.visible = false
	$HBoxContainer/star1.visible = false
	$HBoxContainer/star2.visible = false
	$HBoxContainer/star3.visible = false

func show_for_score(score : int, name : int) -> void:
	print(score)
	if score < 0:
		$HBoxContainer/star1.visible = false
		$HBoxContainer/star2.visible = false
		$HBoxContainer/star3.visible = false
	else:
		self.visible = true
		$Button.text = "LEVEL " + str(name)
		print($HBoxContainer/star1.visible)
		if score > 0:
			$HBoxContainer/star1.visible = true
		if score > 1:
			$HBoxContainer/star2.visible = true
		if score > 2:
			$HBoxContainer/star3.visible = true
			print("show star 3")
