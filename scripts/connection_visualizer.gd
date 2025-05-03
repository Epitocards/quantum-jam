extends Node2D
class_name ConnectionVisualizer

@export var show_connections: bool = true
@export var single_connection_color: Color = Color(1, 0, 0, 0.7)
@export var combined_connection_color: Color = Color(0, 1, 0, 0.7)
@export var line_width: float = 2.0
@export var draw_in_game: bool = false
@export var line_z_index: int = 100
@export var update_interval: float = 2.0

var door_connections = {}
var timer: Timer

func _ready() -> void:
	z_index = line_z_index
	
	timer = Timer.new()
	timer.wait_time = update_interval
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	
	await get_tree().process_frame
	build_connections()
	connect_key_signals()

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint() or draw_in_game:
		if show_connections:
			draw_all_connections()

func _on_timer_timeout() -> void:
	build_connections()
	connect_key_signals()

func connect_key_signals() -> void:
	var keys = get_tree().get_nodes_in_group("keys")
	for key in keys:
		if key is Key and not key.is_connected("key_collected", _on_key_collected):
			key.key_collected.connect(_on_key_collected)

func _on_key_collected(key_id: String) -> void:
	await get_tree().process_frame
	build_connections()

func build_connections() -> void:
	door_connections.clear()
	var doors = get_tree().get_nodes_in_group("doors") + get_tree().get_nodes_in_group("pressure_doors")
	doors = filter_unique_nodes(doors)
	
	var keys = get_tree().get_nodes_in_group("keys")
	var pressure_plates = get_tree().get_nodes_in_group("pressure_plates")
	
	for door in doors:
		if door is Door:
			var door_id = door.door_id
			var lock_mode = door.lock_mode
			if not door_connections.has(door_id):
				door_connections[door_id] = {
					"doors": [door],
					"lock_mode": lock_mode,
					"keys": [],
					"plates": []
				}
			else:
				door_connections[door_id]["doors"].append(door)
				if door_connections[door_id]["lock_mode"] != lock_mode:
					door_connections[door_id]["lock_mode"] = Door.LockMode.BOTH
	
	for key in keys:
		if key is Key:
			var key_id = key.key_id
			for door_id in door_connections.keys():
				if key_id == door_id:
					door_connections[door_id]["keys"].append(key)
	
	for plate in pressure_plates:
		if plate is PressurePlate:
			var plate_door_id = plate.door_id
			for door_id in door_connections.keys():
				if plate_door_id == door_id:
					door_connections[door_id]["plates"].append(plate)
					
func filter_unique_nodes(nodes: Array) -> Array:
	var unique_nodes = []
	var path_set = {}
	
	for node in nodes:
		var path = node.get_path()
		if not path_set.has(path):
			path_set[path] = true
			unique_nodes.append(node)
			
	return unique_nodes

func draw_all_connections() -> void:
	for door_id in door_connections:
		var connection = door_connections[door_id]
		var doors = connection["doors"]
		var lock_mode = connection["lock_mode"]
		var keys = connection["keys"]
		var plates = connection["plates"]
		
		var valid_doors = []
		for door in doors:
			if is_instance_valid(door) and door.is_inside_tree():
				valid_doors.append(door)
				
		var valid_keys = []
		for key in keys:
			if is_instance_valid(key) and key.is_inside_tree():
				valid_keys.append(key)
				
		var valid_plates = []
		for plate in plates:
			if is_instance_valid(plate) and plate.is_inside_tree():
				valid_plates.append(plate)
		
		if valid_doors.size() == 0:
			continue
			
		match lock_mode:
			Door.LockMode.KEY:
				for key in valid_keys:
					for door in valid_doors:
						draw_line(door.global_position, key.global_position, single_connection_color, line_width)
					
			Door.LockMode.PRESSURE_PLATE:
				for plate in valid_plates:
					for door in valid_doors:
						draw_line(door.global_position, plate.global_position, single_connection_color, line_width)
					
			Door.LockMode.BOTH:
				for key in valid_keys:
					for plate in valid_plates:
						draw_line(key.global_position, plate.global_position, combined_connection_color, line_width)
				
				for door in valid_doors:
					for key in valid_keys:
						draw_line(door.global_position, key.global_position, single_connection_color, line_width)
					for plate in valid_plates:
						draw_line(door.global_position, plate.global_position, single_connection_color, line_width)

func setup_groups() -> void:
	var nodes = get_tree().get_nodes_in_group("setup_groups")
	
	for node in nodes:
		if node is Door:
			node.add_to_group("doors")
			if node.lock_mode == Door.LockMode.PRESSURE_PLATE or node.lock_mode == Door.LockMode.BOTH:
				node.add_to_group("pressure_doors")
		elif node is Key:
			node.add_to_group("keys")
		elif node is PressurePlate:
			node.add_to_group("pressure_plates")
