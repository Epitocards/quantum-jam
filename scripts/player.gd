extends AnimatedSprite2D
class_name Player

const TILESIZE = 32

enum playerState {
	MOVING,
	IDLE,
	CAN_MOVE,
}

@export var other : Player

var state : playerState
var target_position : Vector2

func _ready() -> void:
	state = playerState.IDLE

func _physics_process(delta: float) -> void:
	if state == playerState.IDLE and other and other.state == playerState.IDLE or state == playerState.CAN_MOVE:
		var direction : Vector2
		if Input.is_action_pressed("up"):
			direction = Vector2.UP
		elif Input.is_action_pressed("down"):
			direction = Vector2.DOWN
		elif Input.is_action_pressed("left"):
			direction = Vector2.LEFT
		elif Input.is_action_pressed("right"):
			direction = Vector2.RIGHT
		target_position = self.global_position + direction * TILESIZE
		$RayCast2D.target_position = direction * TILESIZE
		$RayCast2D.force_raycast_update()
		if !$RayCast2D.is_colliding():
			state = playerState.MOVING
			if other and other.state != playerState.MOVING:
				other.state = playerState.CAN_MOVE
	elif state == playerState.MOVING:
		self.global_position = self.global_position.move_toward(target_position, 0.5)
		if self.global_position == target_position:
			state = playerState.IDLE
