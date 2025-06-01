extends Node
class_name CraftingManager

signal crafting_result(success: bool, result: ItemData)

@export var recipes: Array[CraftingRecipe] # Drag & drop recipes in the editor

var cooldown := 2.0
var crafting_timer: Timer

var _pending_recipe: CraftingRecipe
var _target_inventory: InventoryData
var _input_inventory: InventoryData


func _ready() -> void:
	var philosophers_stone = preload("res://Scripts/inventory/resources/recipes/philosophers_stone.tres")
	var elixir_imortality = preload("res://Scripts/inventory/resources/recipes/elixir_of_immortality.tres")
	recipes.append(philosophers_stone)
	recipes.append(elixir_imortality)
	crafting_timer = Timer.new()
	crafting_timer.wait_time = cooldown
	crafting_timer.one_shot = true
	crafting_timer.timeout.connect(_on_crafting_cooldown_finished)
	add_child(crafting_timer)

func start_crafting(inputs: Array[SlotData], input_inventory: InventoryData, target_inventory: InventoryData) -> void:
	for recipe in recipes:
		if recipe.matches(inputs):
			_pending_recipe = recipe
			_target_inventory = target_inventory
			_input_inventory = input_inventory
			crafting_timer.start()
			print("Crafting started for: %s" % recipe.output_item.name)
			return

	print("No matching recipe!")
	crafting_result.emit(false, null)

func _on_crafting_cooldown_finished() -> void:
	if _pending_recipe == null:
		return

	var result_item := _pending_recipe.output_item
	var result_quantity := _pending_recipe.output_quantity
	var added := false

	for i in range(_target_inventory.slot_datas.size()):
		var slot := _target_inventory.slot_datas[i]
		if slot and slot.item_data == result_item and slot.quantity < SlotData.MAX_STACK_SIZE:
			var space_left = SlotData.MAX_STACK_SIZE - slot.quantity
			var to_add = min(space_left, result_quantity)
			slot.quantity += to_add
			result_quantity -= to_add
			added = true
		elif slot == null:
			var new_slot := SlotData.new()
			new_slot.item_data = result_item
			var to_add = min(SlotData.MAX_STACK_SIZE, result_quantity)
			new_slot.quantity = to_add
			_target_inventory.slot_datas[i] = new_slot
			result_quantity -= to_add
			added = true

		if result_quantity <= 0:
			break

	if added:
		_target_inventory.inventory_updated.emit(_target_inventory)
		crafting_result.emit(true, _pending_recipe.output_item)
	else:
		print("No space to add crafted item!")
		crafting_result.emit(false, _pending_recipe.output_item)

	_pending_recipe = null
	_target_inventory = null
