extends Resource
class_name CraftingRecipe

@export var name: String
@export var input_items: Array[ItemData]
@export var output_item: ItemData
@export var output_quantity: int = 1

func matches(input: Array[SlotData]) -> bool:
	var required = input_items.duplicate()
	for slot in input:
		if slot == null or not required.has(slot.item_data):
			return false
		required.erase(slot.item_data)
	return required.is_empty()
