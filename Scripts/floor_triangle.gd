extends Node3D

@onready var ingredient1 = $Ingredient1Area
@onready var ingredient2 = $Ingredient1Area2
@onready var trigger_area = $Ingredient1Area3
@onready var player: CharacterBody3D = $Player
@onready var sound: AudioStreamPlayer3D = $Sound
var cutscene = preload("res://Scenes/EndCutsceneWin.tscn").instantiate()

var player_near_1 = false
var player_near_2 = false
var player_in_trigger = false

var has_delivered_1 = false
var has_delivered_2 = false
var flag = false

func _ready():
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
		if player_near_1 and not has_delivered_1:
			#colocar a verificacao dos itme sno inventario
			has_delivered_1 = true

		if player_near_2 and not has_delivered_2:
			#colocar a verificacao dos itme sno inventario
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
