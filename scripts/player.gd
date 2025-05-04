extends Node2D
class_name Player

const TILESIZE = 32

signal in_endzone(value : bool)

var state : PlayerState.PlayerState
var target_position : Vector2

var winning : bool = false
var sliding : bool = false 
var should_send : bool = false
var dir : Vector2 = Vector2.DOWN
var paused : bool = false

func _ready() -> void:
	state = PlayerState.PlayerState.IDLE
	target_position = global_position

func _process(delta: float) -> void:
	if paused:
		$AnimatedSprite2D.pause()
		return
	if dir == Vector2.DOWN:
		if state == PlayerState.PlayerState.IDLE:
			$AnimatedSprite2D.play("idle_down")
		else:
			$AnimatedSprite2D.play("walk_down")
	elif dir == Vector2.UP:
		if state == PlayerState.PlayerState.IDLE:
			$AnimatedSprite2D.play("idle_up")
		else:
			$AnimatedSprite2D.play("walk_up")
	elif dir == Vector2.LEFT:
		if state == PlayerState.PlayerState.IDLE:
			$AnimatedSprite2D.play("idle_left")
		else:
			$AnimatedSprite2D.play("walk_left")
	elif dir == Vector2.RIGHT:
		if state == PlayerState.PlayerState.IDLE:
			$AnimatedSprite2D.play("idle_right")
		else:
			$AnimatedSprite2D.play("walk_right")

func move(direction : Vector2) -> bool:
	dir = direction
	target_position = self.global_position + direction * TILESIZE
	$RayCast2D.target_position = direction * TILESIZE
	$RayCast2D.force_raycast_update()
	if !$RayCast2D.is_colliding():
		state = PlayerState.PlayerState.MOVING
		$footsteps.play()
		return true
	else:
		var collider = $RayCast2D.get_collider()
		if collider and collider.get_parent() is MovableItem:
			var box = collider.get_parent() as MovableItem
			if box.try_push(direction):
				state = PlayerState.PlayerState.MOVING
				$footsteps.play()
				return true
	target_position = global_position
	return false

func pause() -> void:
	state = PlayerState.PlayerState.PAUSED
	paused = true

func unpause() -> void:
	if self.global_position == target_position:
		state = PlayerState.PlayerState.IDLE
	else:
		state = PlayerState.PlayerState.MOVING
	paused = false

func _physics_process(delta: float) -> void:
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
	if area.is_in_group("enemy"):
		var enemy = area as Enemy
		if dir == -enemy.dir or enemy.target_position == target_position:
			die()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("endzone"):
		winning = false
		should_send = true

func die() -> void:
	$AnimationPlayer.play("death")
	state = PlayerState.PlayerState.PAUSED

func reload() -> void:
	get_tree().reload_current_scene()
	
