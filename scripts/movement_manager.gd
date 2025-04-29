extends Node2D

var players : Array[Player] = []
var step_count : int = 0

func _ready() -> void:
	var nodes = get_tree().get_nodes_in_group("player")
	for node in nodes:
		var casted : Player = node as Player
		if (casted):
			players.append(casted)

func player_can_move(p : Player) -> bool:
	return p.state == PlayerState.PlayerState.IDLE

func _physics_process(delta: float) -> void:
	if players.all(player_can_move):
		var direction : Vector2
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
