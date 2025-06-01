extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var inventory_interface: Control = $InventoryUI/InventoryInterface
const TimeBar = preload("res://Scripts/time_bar.gd")
func _ready() -> void:
	var player = $Player
	var book_control = $Book2/Control
	player.book_ui = book_control
	GameState.next_spawn_point_name = "potion"
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
		
