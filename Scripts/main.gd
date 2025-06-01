extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var inventory_interface: Control = $InventoryUI/InventoryInterface

func _ready() -> void:
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	
	for node in get_tree().get_nodes_in_group("crafting_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if external_inventory_owner:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()


#func _on_time_bar_time_out():
		#var cutscene = preload("res://Scenes/EndCutscene1.tscn").instantiate()
		#get_tree().get_root().add_child(cutscene)
		#player.set_enabled(false)  # Optional: freeze player
		#await get_tree().create_timer(0.1).timeout  # Wait for node to enter tree
		#cutscene.start_cutscene()
	#get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
