extends Node
class_name Key

@export var key_id: String = "door"

signal key_collected(key_id: String)

func _ready() -> void:
	var doors = get_tree().get_nodes_in_group("doors")
	for door in doors:
		if door is Door:
			self.key_collected.connect(door._on_key_collected)

func collect() -> void:
	key_collected.emit(key_id)
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("collect")
	else:
		await get_tree().create_timer(0.1).timeout
		queue_free()

func _on_animation_finished() -> void:
	queue_free()

func _on_area_2d_area_entered(body: Node2D) -> void:
	var player = body.get_parent() as Player
	if player.is_in_group("player"):
		collect()
