extends Control

@onready var input_slots: Array = [$InputSlot1, $InputSlot2]
@onready var output_slot = $OutputSlot
@onready var craft_button = $CraftButton
@onready var popup_error = $ErrorPopup
@onready var timer = $CraftTimer

@export var crafting_manager: CraftingManager
var current_recipe: CraftingRecipe

func _ready():
	craft_button.pressed.connect(_on_craft_pressed)
	timer.timeout.connect(_on_crafting_finished)

func _on_craft_pressed():
	var input_data := []
	for slot in input_slots:
		input_data.append(slot.get_slot_data())
	
	current_recipe = crafting_manager.find_recipe(input_data)
	
	if current_recipe:
		timer.start(10.0)
	else:
		popup_error.popup_centered()

func _on_crafting_finished():
	if current_recipe:
		# Crafting logic modifies inventory
		var success = crafting_manager.craft(current_recipe)
		if success:
			var new_data = SlotData.new()
			new_data.item_data = current_recipe.output
			new_data.quantity = current_recipe.output_amount
			output_slot.set_slot_data(new_data)
			# Clear input slots
			for slot in input_slots:
				slot.clear()
		else:
			popup_error.popup_centered()
