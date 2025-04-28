extends Node2D
class_name Player

const TILESIZE = 32

enum playerState {
	MOVING,
	IDLE,
	CAN_MOVE,
}

@export var other : Player

signal in_endzone(value : bool)

var state : playerState
var target_position : Vector2

var winning : bool = false
var should_send : bool = false

func _ready() -> void:
	state = playerState.IDLE

func _process(delta: float) -> void:
	if state == playerState.MOVING:
		$AnimatedSprite2D.play("moving")
	else:
		$AnimatedSprite2D.play("idle")

func _physics_process(delta: float) -> void:
	if state == playerState.IDLE and other and other.state == playerState.IDLE or state == playerState.CAN_MOVE:
		var direction : Vector2
		if Input.is_action_pressed("up"):
			direction = Vector2.UP
			$AnimatedSprite2D.rotation = deg_to_rad(0)
		elif Input.is_action_pressed("down"):
			direction = Vector2.DOWN
			$AnimatedSprite2D.rotation = deg_to_rad(180)
		elif Input.is_action_pressed("left"):
			direction = Vector2.LEFT
			$AnimatedSprite2D.rotation = deg_to_rad(-90)
		elif Input.is_action_pressed("right"):
			direction = Vector2.RIGHT
			$AnimatedSprite2D.rotation = deg_to_rad(90)
		else:
			state = playerState.IDLE
			return
		target_position = self.global_position + direction * TILESIZE
		$RayCast2D.target_position = direction * TILESIZE
		$RayCast2D.force_raycast_update()
		if !$RayCast2D.is_colliding():
			state = playerState.MOVING
			if other and other.state != playerState.MOVING:
				other.state = playerState.CAN_MOVE
	elif state == playerState.MOVING:
		self.global_position = self.global_position.move_toward(target_position, 2)
		if self.global_position == target_position:
			state = playerState.IDLE
			if should_send:
				print("bisous")
				should_send = false
				in_endzone.emit(winning)

func _on_area_2d_area_entered(area: Area2D) -> void:
	winning = true
	should_send = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	winning = false
	should_send = true
