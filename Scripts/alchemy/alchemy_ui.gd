extends CanvasLayer

var recipes = [
	{ "ingredients": ["Lizard Blood", "Human Hair", "Something in the water"], "result": "Elixir of immortality" },
	{ "ingredients": ["Mineral", "Gem", "Cactus Flower"], "result": "Philosopher's Stone" },]

func check_combination():
	var ingredients: Array[String] = []

	for slot in $Panel/InputSlots.get_children():
		if slot.has_method("get_item_name"):
			var item = slot.get_item_name()
			if item != "":
				ingredients.append(item)

	ingredients.sort()

	for recipe in recipes:
		var recipe_ingredients = recipe["ingredients"].duplicate()
		recipe_ingredients.sort()
		if recipe_ingredients == ingredients:
			$Panel/ResultSlot.set_result(recipe["result"])
			return

	$Panel/ResultSlot.clear()
