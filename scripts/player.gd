extends Node2D
class_name Player

const TILESIZE = 32

signal in_endzone(value : bool)

var state : PlayerState.PlayerState
var target_position : Vector2

var winning : bool = false
var sliding : bool = false 
var should_send : bool = false
var dir : Vector2 = Vector2.ZERO

func _ready() -> void:
	state = PlayerState.PlayerState.IDLE

func _process(_delta: float) -> void:
	if state == PlayerState.PlayerState.MOVING:
		$AnimatedSprite2D.play("moving")
	else:
		$AnimatedSprite2D.play("idle")

func move(direction : Vector2) -> bool:
	dir = direction
	if direction == Vector2.LEFT:
		$AnimatedSprite2D.flip_h = false
	elif direction == Vector2.RIGHT:
		$AnimatedSprite2D.flip_h = true
	target_position = self.global_position + direction * TILESIZE
	$RayCast2D.target_position = direction * TILESIZE
	$RayCast2D.force_raycast_update()
	if !$RayCast2D.is_colliding():
		state = PlayerState.PlayerState.MOVING
		return true
	else:
		var collider = $RayCast2D.get_collider()
		if collider and collider.get_parent() is MovableItem:
			var box = collider.get_parent() as MovableItem
			if box.try_push(direction):
				state = PlayerState.PlayerState.MOVING
				return true
	return false

func pause() -> void:
	state = PlayerState.PlayerState.PAUSED

func _physics_process(_delta: float) -> void:
	if state == PlayerState.PlayerState.MOVING:
		self.global_position = self.global_position.move_toward(target_position, 2)
		if self.global_position == target_position:
			state = PlayerState.PlayerState.IDLE
			if should_send:
				should_send = false
				in_endzone.emit(winning)
			if sliding:
				sliding = false
				self.move(dir)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("endzone"):
		winning = true
		should_send = true
	if area.is_in_group("slippery_grounds"):
		sliding = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("endzone"):
		winning = false
		should_send = true
