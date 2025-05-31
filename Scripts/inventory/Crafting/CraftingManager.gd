extends Node
class_name CraftingManager

@export var inventory: InventoryData
@export var recipes: Array[CraftingRecipe]

func can_craft(recipe: CraftingRecipe) -> bool:
	for input in recipe.inputs:
		if not inventory.has_item(input.item, input.amount):
			return false
	return true

func craft(recipe: CraftingRecipe) -> bool:
	if not can_craft(recipe):
		return false
	for input in recipe.inputs:
		inventory.remove_item(input.item, input.amount)
	inventory.add_item(recipe.output, recipe.output_amount)
	return true

func find_recipe(input_items: Array[SlotData]) -> CraftingRecipe:
	for recipe in recipes:
		if _match_inputs(recipe, input_items):
			return recipe
	return null

func _match_inputs(recipe: CraftingRecipe, input_items: Array[SlotData]) -> bool:
	var required = recipe.inputs.duplicate()
	for item in input_items:
		if item == null:
			continue
		for i in required.size():
			var req = required[i]
			if req.item == item.item_data and item.quantity >= req.amount:
				required.remove_at(i)
				break
	return required.is_empty()
