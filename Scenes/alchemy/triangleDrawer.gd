extends Node2D

@onready var slot1 = $"../RecipeSlot"
@onready var slot2 = $"../RecipeSlot2"
@onready var slot3 = $"../RecipeSlot3"

func _draw():
	var p1 = slot1.global_position
	var p2 = slot2.global_position
	var p3 = slot3.global_position

	draw_line(p1, p2, Color.WHITE, 2)
	draw_line(p2, p3, Color.WHITE, 2)
	draw_line(p3, p1, Color.WHITE, 2)

func _process(delta):
	queue_redraw()
