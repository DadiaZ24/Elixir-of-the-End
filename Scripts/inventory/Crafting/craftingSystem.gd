extends Node

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
