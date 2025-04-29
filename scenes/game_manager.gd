extends Node2D

var players_in_endzone_count = 0
const PLAYER_COUNT = 2
var players : Array[Player]

func  _ready() -> void:
	var nodes = get_tree().get_nodes_in_group("player")
	for n in nodes:
		(n as Player).in_endzone.connect(_on_player_in_endzone)
		players.append(n as Player)

func _on_player_in_endzone(value: bool) -> void:
	if value:
		players_in_endzone_count += 1
		if players_in_endzone_count == PLAYER_COUNT:
			win()
	else:
		players_in_endzone_count -= 1

func win() -> void:
	for p in players:
		p.pause()
	$WinMenu.show_menu()
