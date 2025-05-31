extends Resource

class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)
@export var slot_datas: Array[SlotData]


func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if slot_data:
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null

func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	var return_slot_data: SlotData
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
	
	inventory_updated.emit(self)
	return return_slot_data

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if not slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
		
	inventory_updated.emit(self)
	
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null

func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)


func has_item(item: ItemData, amount: int) -> bool:
	var total = 0
	for slot in slot_datas:
		if slot and slot.item_data == item:
			total += slot.quantity
	return total >= amount

func remove_item(item: ItemData, amount: int) -> void:
	for i in slot_datas.size():
		var slot = slot_datas[i]
		if slot and slot.item_data == item:
			var to_remove = min(slot.quantity, amount)
			slot.quantity -= to_remove
			amount -= to_remove
			if slot.quantity <= 0:
				slot_datas[i] = null
			if amount <= 0:
				break
	inventory_updated.emit(self)

func add_item(item: ItemData, amount: int) -> void:
	for i in slot_datas.size():
		var slot = slot_datas[i]
		if slot and slot.item_data == item and slot.quantity < SlotData.MAX_STACK_SIZE:
			var space = SlotData.MAX_STACK_SIZE - slot.quantity
			var to_add = min(space, amount)
			slot.quantity += to_add
			amount -= to_add
			if amount <= 0:
				break
	if amount > 0:
		for i in slot_datas.size():
			if not slot_datas[i]:
				var new_slot = SlotData.new()
				new_slot.item_data = item
				new_slot.quantity = amount
				slot_datas[i] = new_slot
				break
	inventory_updated.emit(self)
