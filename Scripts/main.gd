extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var inventory_interface: Control = $InventoryUI/InventoryInterface

func _ready() -> void:
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)

func toggle_inventory_interface() -> void:
	inventory_interface.visible = not inventory_interface.visible
	
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_time_bar_time_out():
	print("Time is up! You lose!")
	#get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
