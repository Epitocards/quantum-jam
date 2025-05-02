class_name StarController extends Node

@export var stars : Array[Star] = []




func star_count(count: int) -> void:
	for i in range(count):
		stars[i].animate_star(true)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
