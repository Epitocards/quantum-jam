extends Area2D
class_name Enemy 

const TILESIZE = 32

@export var pattern: String
var state: PlayerState.PlayerState
var target_position : Vector2
var dir : Vector2 = Vector2.ZERO
var index : int = 0
var patternSize : int

func _ready() -> void:
	patternSize = pattern.length()
	target_position = global_position
	state = PlayerState.PlayerState.IDLE

func _process(delta: float) -> void:
	pass
	
func move() -> void: 
	patternReader()
	target_position = self.global_position + dir * TILESIZE
	$RayCast2D.target_position = dir * TILESIZE
	$RayCast2D.force_raycast_update()
	if !$RayCast2D.is_colliding():
		state = PlayerState.PlayerState.MOVING
		return
	target_position = global_position
	return

func pause() -> void:
	state = PlayerState.PlayerState.PAUSED
	
func unpause() -> void:
	if self.global_position == target_position:
		state = PlayerState.PlayerState.IDLE
	else:
		state = PlayerState.PlayerState.MOVING

func _physics_process(delta: float) -> void:
	if state == PlayerState.PlayerState.MOVING:
		self.global_position = self.global_position.move_toward(target_position, 2)
		if self.global_position == target_position:
			state = PlayerState.PlayerState.IDLE

func patternReader() -> void:
	var currentDir: String = pattern[index]
	match currentDir:
		"U": 
			dir = Vector2.UP
		"D":
			dir = Vector2.DOWN
		"L":
			dir = Vector2.LEFT
		"R":
			dir = Vector2.RIGHT
		_:
			dir = Vector2.ZERO
	index =  index + 1 if index + 1 < patternSize else 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("movableItem"):
		var movableItem = body.get_parent() as MovableItem
		if dir == -movableItem.current_direction or movableItem.target_position == target_position:
			die()

func die() -> void:
	queue_free()
