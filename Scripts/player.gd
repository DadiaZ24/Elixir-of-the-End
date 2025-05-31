extends CharacterBody3D

signal toggle_inventory()
@export var inventory_data: InventoryData


const SPEED = 10
const JUMP_VELOCITY = 3
@onready var world_env: WorldEnvironment = $"../WorldEnvironment"
var default_env = preload("res://Resources/DefaultEnv.tres")
var underwater_env = preload("res://Resources/UnderWaterEnv.tres")
@onready var neck: Node3D = $Neck
@onready var camera: Camera3D = $Neck/Camera3D
@onready var footsteps = $Footsteps
@onready var swim = $Swim
@export var water_surface_y: float

var is_inside_water = false
var is_underwater = false
var is_inside_quicksand = false
var quicksand_gravity = Vector3(0, -3.0, 0)
var swim_gravity = Vector3(0, -3.0, 0)
var quicksand_mov_speed = 1.0
var quicksamd_jump_trace = 2.0
var swim_speed = 4.0
var water_drag = 4.0
var swim_up_speed = 2.0
var inventory_is_open := false
var quicksand_drag = 4.0

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory_open"):
		inventory_is_open = !inventory_is_open
		if inventory_is_open:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		toggle_inventory.emit()
		return
		
	if inventory_is_open:
		return
		
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.004)
			camera.rotate_x(-event.relative.y * 0.004)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))


func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	var input_vector = Vector2.ZERO
	var camera_y = camera.global_transform.origin.y
	var currently_submerged = is_inside_water and camera_y < water_surface_y

	if currently_submerged and not is_underwater:
		is_underwater = true
		world_env.environment = underwater_env
	elif not currently_submerged and is_underwater:
		is_underwater = false
		world_env.environment = default_env
	
	if is_inside_quicksand:
		velocity += quicksand_gravity * delta
		if Input.is_action_pressed("ui_up"):
			direction -= neck.global_transform.basis.z
		if Input.is_action_pressed("ui_down"):
			direction += neck.global_transform.basis.z
		if Input.is_action_pressed("ui_right"):
			direction -= neck.global_transform.basis.x
		if Input.is_action_pressed("ui_left"):
			direction += neck.global_transform.basis.x
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = quicksamd_jump_trace
		
		direction = direction.normalized()
		velocity = velocity.lerp(direction * quicksand_mov_speed, quicksand_drag * delta)


	if is_inside_water:
		velocity += swim_gravity * delta
		# Full 3D movement for swimming
		if Input.is_action_pressed("ui_up"):
			direction -= neck.global_transform.basis.z
		if Input.is_action_pressed("ui_down"):
			direction += neck.global_transform.basis.z
		if Input.is_action_pressed("ui_left"):
			direction -= neck.global_transform.basis.x
		if Input.is_action_pressed("ui_right"):
			direction += neck.global_transform.basis.x
		if Input.is_action_pressed("ui_accept"):
			direction += Vector3.UP
		if Input.is_action_pressed("swim_down"):
			direction -= Vector3.UP

		if direction != Vector3.ZERO:
			if not swim.is_playing():
				swim.play()
		else:
			if swim.is_playing():
				swim.stop()
		direction = direction.normalized()

		# Apply smooth swimming movement
		velocity = velocity.lerp(direction * swim_speed, water_drag * delta)

	else:
		swim.stop()
		# Apply gravity when not on the floor
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Jumping
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Ground movement (XZ only)
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var ground_direction = (neck.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		if ground_direction:
			velocity.x = ground_direction.x * SPEED
			velocity.z = ground_direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		# Footsteps
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		if input_vector.length() > 0.1:
			if not footsteps.is_playing():
				footsteps.play()
		else:
			if footsteps.is_playing():
				footsteps.stop()

	move_and_slide()


func _on_water_body_entered(body: Node3D) -> void:
	if body == self:
		is_inside_water = true


func _on_water_body_exited(body: Node3D) -> void:
	if body == self:
		is_inside_water = false
		is_underwater = false
		world_env.environment = default_env


func _on_quick_sand_body_entered(body: Node3D) -> void:
	if body == self:
		is_inside_quicksand = true


func _on_quick_sand_body_exited(body: Node3D) -> void:
	if body == self:
		is_inside_quicksand = false
