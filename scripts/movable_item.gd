extends Node2D
class_name MovableItem

const TILESIZE = 32
var state: PlayerState.PlayerState = PlayerState.PlayerState.IDLE
var target_position : Vector2
var current_direction : Vector2

@onready var ray_cast = $RayCast2D

func _ready() -> void:
	target_position = global_position

func _physics_process(_delta: float) -> void:
	if state == PlayerState.PlayerState.MOVING:
		global_position = global_position.move_toward(target_position, 2)
		if global_position == target_position:
			state = PlayerState.PlayerState.IDLE

func try_push(push_direction: Vector2) -> bool:
	if state != PlayerState.PlayerState.IDLE:
		return false
	ray_cast.target_position = push_direction * TILESIZE
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		return false
	current_direction = push_direction
	target_position = global_position + push_direction * TILESIZE
	state = PlayerState.PlayerState.MOVING
	return true
