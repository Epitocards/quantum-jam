extends Node
class_name Door

@export var door_id: String = "door"

enum DoorState {
	CLOSEDBARBY,
	OPENHEIMER
}
var state: int = DoorState.CLOSEDBARBY
@onready var collision = $StaticBody2D/CollisionShape2D

func _ready() -> void:
	add_to_group("doors")
	
func _on_key_collected(key_id: String) -> void:
	print("OPENING DANIEL")
	if key_id == door_id and state == DoorState.CLOSEDBARBY:
		open_door()

func open_door() -> void:
	state = DoorState.OPENHEIMER
	collision.set_deferred("disable", true)
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("open")
	else:
		state = DoorState.OPENHEIMER
		queue_free()
