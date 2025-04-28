extends Node2D

var players_in_endzone_count = 0
const PLAYER_COUNT = 2

func _on_player_1_in_endzone(value: bool) -> void:
	if value:
		players_in_endzone_count += 1
		if players_in_endzone_count == PLAYER_COUNT:
			win()
	else:
		players_in_endzone_count -= 1
	print(players_in_endzone_count)

func _on_player_2_in_endzone(value: bool) -> void:
	if value:
		players_in_endzone_count += 1
		if players_in_endzone_count == PLAYER_COUNT:
			win()
	else:
		players_in_endzone_count -= 1
	print(players_in_endzone_count)

func win() -> void:
	print("Daniel victoire")
