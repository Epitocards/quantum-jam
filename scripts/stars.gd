class_name StarController extends Node

var stars : Array[Star] = []

func _ready() -> void:
	for node in get_children():
		var cast = node as Star
		if cast:
			stars.append(cast)


func star_count(count: int) -> void:
	$Timer.start()
	for i in range(count):
		stars[i].animate_star(true)



func _on_timer_timeout() -> void:
	$star.play()
