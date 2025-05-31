extends CharacterBody3D

@onready var navigation_agent_3d = $NavigationAgent3D
const SPEED := 5.0
const MIN_DISTANCE := 0.5

func _ready() -> void:
	_generate_new_target()

func _physics_process(delta: float) -> void:
	if navigation_agent_3d.is_navigation_finished() or _is_close_to_target():
		_generate_new_target()

	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()

	velocity = direction * SPEED
	move_and_slide()

func _generate_new_target() -> void:
	var random_position := Vector3.ZERO
	random_position.x = randf_range(-5.0, 5.0)
	random_position.z = randf_range(-5.0, 5.0)
	random_position.y = global_position.y  # mantém a altura atual
	navigation_agent_3d.set_target_position(random_position)

func _is_close_to_target() -> bool:
	return global_position.distance_to(navigation_agent_3d.get_next_path_position()) < MIN_DISTANCE
