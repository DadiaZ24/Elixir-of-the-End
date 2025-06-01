extends PanelContainer
class_name Inventory

const Slot = preload("res://Scenes/Inventory/Slot.tscn")

@onready var item_grid: GridContainer = $MarginContainer/ItemGrid
@onready var item_grid_craft: GridContainer = $MarginContainer/VBoxContainer/ItemGrid

var current_inventory_data: InventoryData

func get_inventory_data() -> InventoryData:
	return current_inventory_data

func set_inventory_data(inventory_data: InventoryData) -> void:
	current_inventory_data = inventory_data
	inventory_data.inventory_updated.connect(populate_grid)
	populate_grid(inventory_data)

func clear_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.disconnect(populate_grid)

func _ready() -> void:
	var inv_data = preload("res://Scripts/inventory/resources/Inventory.tres")
	populate_grid(inv_data)

func populate_grid(inventory_data: InventoryData) -> void:
	if item_grid:
		for child in item_grid.get_children():
			child.queue_free()
		
		for data in inventory_data.slot_datas:
			var slot = Slot.instantiate()
			item_grid.add_child(slot)
			slot.slot_clicked.connect(inventory_data.on_slot_clicked)
			if data:
				slot.set_slot_data(data)
				
	if item_grid_craft:
		for child in item_grid_craft.get_children():
			child.queue_free()
		
		for data in inventory_data.slot_datas:
			var slot = Slot.instantiate()
			item_grid_craft.add_child(slot)
			
			slot.slot_clicked.connect(inventory_data.on_slot_clicked)
			
			if data:
				slot.set_slot_data(data)
