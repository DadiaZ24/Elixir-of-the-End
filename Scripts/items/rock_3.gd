extends StaticBody3D

@onready var area = $Area3D
@onready var rock_mesh = $Rock3
@onready var rock_scene = preload("res://Scenes/assets/rock_3.tscn")
@onready var normal_material = rock_mesh.get_surface_override_material(0)

var player_near = false

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_near = true

func _on_body_exited(body):
	if body.name == "Player":
		player_near = false
		rock_mesh.set_surface_override_material(0, normal_material)

func _process(delta):
	if not player_near:
		return

	if Input.is_action_just_pressed("interact"):
		var camera = get_node("/root/Main/Player/Neck/Camera3D")
		var ray = camera.get_node("InteractRay")
		queue_free()
		
