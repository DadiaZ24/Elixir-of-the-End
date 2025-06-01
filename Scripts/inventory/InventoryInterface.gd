extends Control


var grabbed_slot_data: SlotData
var external_inventory_owner
@onready var player_inventory: PanelContainer = $PlayerInventory
@onready var grabbed_slot: PanelContainer = $GrabbedSlot
@onready var crafting_inventory: PanelContainer = $Crafting
@onready var craft_button: Button = $Crafting/MarginContainer/VBoxContainer/Button
@onready var crafting_manager: CraftingManager = preload("res://Scripts/inventory/Crafting/CraftingManager.gd").new()
signal crafting_completed(success: bool)


func _ready() -> void:
	add_child(crafting_manager)
	crafting_manager.crafting_result.connect(_on_crafting_result)
	craft_button.pressed.connect(_on_craft_button_pressed)
	
func _on_craft_button_pressed() -> void:
	var inventory_script := crafting_inventory as Inventory
	var player_inventory_script := player_inventory as Inventory
	var input_data := inventory_script.get_inventory_data()
	
	if input_data == null:
		print("ERROR: crafting inventory data is null")
		return

	var input_slots: Array[SlotData] = []
	for data in input_data.slot_datas:
		if data:
			input_slots.append(data)

	if input_slots.size() != 3:
		print("NOT 3 INGREDIENTS")
		return

	var player_data := player_inventory_script.get_inventory_data()
	# Don't clear yet, crafting manager will do it.
	crafting_manager.start_crafting(input_slots, input_data, player_data)
	
	
func _on_crafting_result(success: bool, result: ItemData) -> void:
	if success:
		print("Crafted: %s" % result.name)

		# Clear crafting input slots on success:
		var inventory_script := crafting_inventory as Inventory
		var input_data := inventory_script.get_inventory_data()
		if input_data:
			for i in range(input_data.slot_datas.size()):
				input_data.slot_datas[i] = null
			input_data.inventory_updated.emit(input_data)
		clear_external_inventory()
		crafting_completed.emit(success)
	else:
		print("Crafting failed.")


func _physics_process(_delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5,5)

func set_external_inventory(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	var inventory_data = external_inventory_owner.inventory_data
	
	inventory_data.inventory_interact.connect(on_inventory_interact)
	crafting_inventory.set_inventory_data(inventory_data)
	
	crafting_inventory.show()

func clear_external_inventory() -> void:
	if external_inventory_owner:
		var inventory_data = external_inventory_owner.inventory_data
	
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
		crafting_inventory.clear_inventory_data(inventory_data)
	
		crafting_inventory.hide()
		external_inventory_owner = null

func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)

func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		[null, MOUSE_BUTTON_RIGHT]:
			pass
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
	
	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
