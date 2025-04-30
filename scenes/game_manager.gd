extends Node2D

var players_in_endzone_count = 0
var players : Array[Player]
var step_count : int = 0
var direction : Vector2

func  _ready() -> void:
	var nodes = get_tree().get_nodes_in_group("player")
	for node in nodes:
		var casted : Player = node as Player
		if (casted):
			casted.in_endzone.connect(_on_player_in_endzone)
			players.append(casted)

func _on_player_in_endzone(value: bool) -> void:
	if value:
		players_in_endzone_count += 1
		if players_in_endzone_count == players.size():
			win()
	else:
		players_in_endzone_count -= 1

func win() -> void:
	for p in players:
		p.pause()
	$UI/WinMenu.show_menu()

func player_can_move(p : Player) -> bool:
	return p.state == PlayerState.PlayerState.IDLE

func _physics_process(delta: float) -> void:
	if players.all(player_can_move):
		if Input.is_action_pressed("up"):
			direction = Vector2.UP
		elif Input.is_action_pressed("down"):
			direction = Vector2.DOWN
		elif Input.is_action_pressed("left"):
			direction = Vector2.LEFT
		elif Input.is_action_pressed("right"):
			direction = Vector2.RIGHT
		elif Input.is_action_just_pressed("reload"):
			get_tree().reload_current_scene()
		else:
			return
		var count_step = true
		for p in players:
			var buffer = p.move(direction)
			count_step = count_step and buffer
		if count_step:
			step_count += 1
