extends StaticBody3D

@onready var area = $Area3D
@onready var flower_mesh = $Flower
@onready var flower_scene = preload("res://Scenes/assets/flower.tscn")
@onready var normal_material = flower_mesh.get_surface_override_material(0)

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
		flower_mesh.set_surface_override_material(0, normal_material)

func _process(delta):
	if not player_near:
		return

	if Input.is_action_just_pressed("ui_interact"):
		var camera = get_node("/root/Main/Player/Neck/Camera3D")
		var ray = camera.get_node("InteractRay")
		queue_free()
		
