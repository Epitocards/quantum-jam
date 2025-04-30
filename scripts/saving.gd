extends Node

const SAVE_PATH = "res://savegame.sav"

func save(data : Array[int]) -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(data)

func load() -> Array[int]:
	if not FileAccess.file_exists(SAVE_PATH):
		return []
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	return file.get_var(true)
