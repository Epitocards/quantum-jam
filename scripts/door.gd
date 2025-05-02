extends Node
class_name Door

@export var door_id: String = "door"
@export var lock_mode: LockMode = LockMode.KEY

var pressure_count: int = 0
var has_key: bool = false

enum LockMode {
	KEY,
	PRESSURE_PLATE,
	BOTH
}

enum DoorState {
	CLOSEDBARBY,
	OPENHEIMER
}
var state: int = DoorState.CLOSEDBARBY
@onready var collision = $StaticBody2D/CollisionShape2D
@onready var sprite = $Sprite2D

func _ready() -> void:
	if lock_mode == LockMode.KEY or lock_mode == LockMode.BOTH:
		add_to_group("doors")
	if lock_mode == LockMode.PRESSURE_PLATE or lock_mode == LockMode.BOTH:
		add_to_group("pressure_doors")
	
func _on_key_collected(key_id: String) -> void:
	if key_id == door_id and (lock_mode == LockMode.KEY or lock_mode == LockMode.BOTH):
		has_key = true
		if lock_mode != LockMode.BOTH or pressure_count > 0:
			open_door()

func _on_plate_activated(plate_door_id: String) -> void:
	if plate_door_id == door_id and (lock_mode == LockMode.PRESSURE_PLATE or lock_mode == LockMode.BOTH):
		pressure_count += 1
		if lock_mode != LockMode.BOTH or has_key:
			open_door()

func _on_plate_deactivated(plate_door_id: String) -> void:
	if plate_door_id == door_id and (lock_mode == LockMode.PRESSURE_PLATE or lock_mode == LockMode.BOTH):
		pressure_count -= 1
		if pressure_count <= 0:
			pressure_count = 0
		if pressure_count == 0:
			close_door()
		

func open_door() -> void:
	if state == DoorState.CLOSEDBARBY:
		state = DoorState.OPENHEIMER
		collision.set_deferred("disabled", true)
		if has_node("AnimationPlayer"):
			$AnimationPlayer.play("open")
		else:
			sprite.modulate.a = 0.3
			$StaticBody2D.collision_layer = 2

func close_door() -> void:
	if state == DoorState.OPENHEIMER:
		state = DoorState.CLOSEDBARBY
		collision.set_deferred("disabled", false)
		if has_node("AnimationPlayer"):
			$AnimationPlayer.play("close")
		else:
			sprite.modulate.a = 1.0
			$StaticBody2D.collision_layer = 1
	
