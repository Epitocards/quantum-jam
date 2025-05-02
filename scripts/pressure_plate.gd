extends Node2D
class_name PressurePlate

@export var door_id: String = "door"

signal plate_activated(door_id: String)
signal plate_deactivated(door_id: String)

var is_activated: bool = false

@onready var sprite = $Sprite2D

func _ready() -> void:
	var doors = get_tree().get_nodes_in_group("pressure_doors")
	for door in doors:
		if door is Door:
			self.plate_activated.connect(door._on_plate_activated)
			self.plate_deactivated.connect(door._on_plate_deactivated)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent() is MovableItem:
		activate()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.get_parent() is MovableItem:
		var still_activated = false
		var bodies = $Area2D.get_overlapping_bodies()
		for overlapping_body in bodies:
			var over_body = overlapping_body.get_parent()
			if over_body is MovableItem:
				still_activated = true
				break
		if not still_activated:
			deactivate()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		activate()


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		var still_activated = false
		var bodies = $Area2D.get_overlapping_bodies()
		for overlapping_body in bodies:
			var over_body = overlapping_body.get_parent()
			if over_body.is_in_group("player"):
				still_activated = true
				break
		if not still_activated:
			deactivate()


func activate() -> void:
	if not is_activated:
		is_activated = true
		sprite.modulate = Color(0.5, 0.5, 0.5)
		if has_node("AnimationPlayer"):
			$AnimationPlayer.play("press")
		plate_activated.emit(door_id)

func deactivate() -> void:
	if is_activated:
		is_activated = false
		sprite.modulate = Color(1,1,1)
		if has_node("AnimationPlayer"):
			$AnimationPlayer.play("press")
		plate_deactivated.emit(door_id)
