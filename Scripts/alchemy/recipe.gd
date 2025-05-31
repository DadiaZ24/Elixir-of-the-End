extends Node2D

@export var item: Item = null
@onready var recipe = item.recipe

func check():
	var flag = []

	for i in range(recipe.size()):
		flag.append(get_child(i).check())

func _on_craft_pressed():
	var inventory = get_tree().current_scene.find_child("Inventory")

	for i in recipe:
		inventory.remove_item(i)
	inventory.add_item(item)
