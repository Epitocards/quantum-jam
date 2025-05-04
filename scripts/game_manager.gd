extends Node2D

@export var level_index : int
@export var star_threshold : Vector2i

var players_in_endzone_count = 0
var players : Array[Player]
var enemies: Array[Enemy]
var step_count : int = 0
var direction : Vector2
var pausing = false
var canpause = true

func  _ready() -> void:
	var nodes = get_tree().get_nodes_in_group("player")
	for node in nodes:
		var casted : Player = node as Player
		if (casted):
			casted.in_endzone.connect(_on_player_in_endzone)
			players.append(casted)
			
	nodes = get_tree().get_nodes_in_group("enemy")
	for node in nodes: 
		var casted : Enemy = node as Enemy
		if casted: 
			enemies.append(casted)
	$UI/PauseMenu.unpause.connect(unpause)
	


func _on_player_in_endzone(value: bool) -> void:
	if value:
		players_in_endzone_count += 1
		$portal.play()
		if players_in_endzone_count == players.size():
			win()
	else:
		players_in_endzone_count -= 1

func win() -> void:
	print(step_count)
	var data = Saving.load()
	var score = get_score()
	while data.size() < level_index:
		print("padding save data, should not be possible")
		data.append(-1)
	if score > data[level_index - 1]:
		data[level_index - 1] = score
	if data.size() == level_index:
		data.append(0)
	if data[level_index] < 0:
		data[level_index] = 0
	Saving.save(data)
	for p in players:
		p.pause()
	$UI/WinMenu.show_menu(score)
	canpause = false

func get_score() -> int:
	if step_count <= star_threshold.x:
		return 3
	elif step_count <= star_threshold.y:
		return 2
	else:
		return 1

func player_can_move(p : Player) -> bool:
	return p.state == PlayerState.PlayerState.IDLE

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("pause"):
		if canpause:
			if pausing:
				pausing = false
				unpause()
			else:
				pausing = true
				pause()
	
	if players.all(player_can_move):
		if Input.is_action_pressed("up"):
			direction = Vector2.UP
		elif Input.is_action_pressed("down"):
			direction = Vector2.DOWN
		elif Input.is_action_pressed("left"):
			direction = Vector2.LEFT
		elif Input.is_action_pressed("right"):
			direction = Vector2.RIGHT
		else:
			return
		var count_step = false
		for p in players:
			var buffer = p.move(direction)
			count_step = count_step or buffer
		for e in enemies:
			if count_step and e:
				e.move()
		if count_step:
			if has_node("ConnectionVisualizer"):
				$ConnectionVisualizer.visible = false
			step_count += 1

func pause() -> void:
	for p in players:
		p.pause()
	$UI/PauseMenu.show_menu()

func unpause() -> void:
	for p in players:
		p.unpause()
	$UI/PauseMenu.visible = false
