extends StaticBody3D

@onready var area = $Area3D
@onready var rock_mesh = $Rock3
@onready var rock_scene = preload("res://Scenes/assets/rock_3.tscn")
@onready var rock_tres = preload("res://Scripts/inventory/resources/Ingredients/gem.tres")
@onready var normal_material = rock_mesh.get_surface_override_material(0)

var player_near = false
var player = null

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_near = true
		player = body

func _on_body_exited(body):
	if body.name == "Player":
		player_near = false
		player = null
		rock_mesh.set_surface_override_material(0, normal_material)

func _process(delta):
	if not player_near:
		return

	if Input.is_action_just_pressed("ui_interact"):
		#INVENTORY ADD LOGIC
		var inventory_data = player.inventory_data
		if inventory_data:
			var new_slot_data := SlotData.new()
			new_slot_data.item_data = rock_tres
			new_slot_data.quantity = 1

			var inserted := false
			for i in range(inventory_data.slot_datas.size()):
				var existing = inventory_data.slot_datas[i]
				if existing == null:
					inventory_data.slot_datas[i] = new_slot_data
					inserted = true
					break
				elif existing.can_merge_with(new_slot_data):
					existing.fully_merge_with(new_slot_data)
					inserted = true
					break

			if inserted:
				inventory_data.inventory_updated.emit(inventory_data)
				queue_free()
			else:
				print("No room in inventory!")
				
		var camera = get_node("/root/Main/Player/Neck/Camera3D")
		var ray = camera.get_node("InteractRay")
		queue_free()
		
