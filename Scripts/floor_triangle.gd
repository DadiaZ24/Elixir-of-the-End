extends Node3D
@onready var ingredient1 = $Ingredient1Area
@onready var ingredient2 = $Ingredient1Area2
@onready var trigger_area = $Ingredient1Area3
@onready var red_rock = $Ingredient1Area/red_rock
@onready var elixir = $Ingredient1Area2/elixir

@onready var sound: AudioStreamPlayer3D = $Sound
var cutscene = preload("res://Scenes/EndCutsceneWin.tscn").instantiate()

@onready var player: Node
var player_near_1 = false
var player_near_2 = false
var player_in_trigger = false
var has_delivered_1 = false
var has_delivered_2 = false
var flag = false
@export var ingredient_1_data: ItemData = preload("res://Scripts/inventory/resources/final_product/philosophers_stone.tres")
@export var ingredient_2_data: ItemData = preload("res://Scripts/inventory/resources/final_product/elixir_of_immortality.tres")
func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]  # Assuming there's only one player
	ingredient1.body_entered.connect(_on_ingredient1_entered)
	ingredient1.body_exited.connect(_on_ingredient1_exited)
	
	ingredient2.body_entered.connect(_on_ingredient2_entered)
	ingredient2.body_exited.connect(_on_ingredient2_exited)
	trigger_area.body_entered.connect(_on_trigger_area_entered)
	trigger_area.body_exited.connect(_on_trigger_area_exited)
func _on_ingredient1_entered(body):
	if body.name == "Player":
		player_near_1 = true
func _on_ingredient1_exited(body):
	if body.name == "Player":
		player_near_1 = false
func _on_ingredient2_entered(body):
	if body.name == "Player":
		player_near_2 = true
func _on_ingredient2_exited(body):
	if body.name == "Player":
		player_near_2 = false
func _on_trigger_area_entered(body):
	if body.name == "Player":
		player_in_trigger = true
		check_activation()
func _on_trigger_area_exited(body):
	if body.name == "Player":
		player_in_trigger = false
func _process(delta):
	if Input.is_action_just_pressed("ui_interact"):
		var inventory_data: InventoryData = player.inventory_data
		if player_near_1 and not has_delivered_1:
			if inventory_data.has_item(ingredient_1_data):
				print("ESTOU CA")
				inventory_data.remove_item(ingredient_1_data)
				has_delivered_1 = true
				print("Entregou ingrediente 1!")
				red_rock.visible = true
				red_rock.set_collision_layer_value(1, true)
				has_delivered_1 = true
		if player_near_2 and not has_delivered_2:
			if inventory_data.has_item(ingredient_2_data):
				inventory_data.remove_item(ingredient_2_data)
				has_delivered_2 = true
				print("Entregou ingrediente 2!")
				elixir.visible = true
				elixir.set_collision_layer_value(1, true)
				has_delivered_2 = true
		check_activation()
func check_activation():
	if has_delivered_1 and has_delivered_2:
		GameState.ending = true
	if has_delivered_1 and has_delivered_2 and player_in_trigger and flag == false:
		sound.play()
		flag = true
		get_tree().get_root().add_child(cutscene)
		await get_tree().create_timer(2).timeout  # Wait for node to enter tree
		cutscene.start_cutscene()
