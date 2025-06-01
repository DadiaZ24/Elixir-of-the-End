extends Area3D

@onready var transition = $"../Transition"
@onready var colorRect = $"../Transition/ColorRect"
@onready var teleport_target = $"../TeleportTarget"
@onready var look_target = $"../LookTarget"
@onready var talk = $"../MasterTalking"
@onready var cutscene = $"../DialoguePanel"

const MASTER_TENT_SCENE := preload("res://Scenes/master_tent.tscn")

var has_triggered = false
var player = null

func _ready():
	connect("body_entered", _on_body_entered)
	transition.connect("animation_finished", _on_animation_finished)

func _on_body_entered(body):
	if has_triggered or GameState.master_cutscene_played:
		return
	if body.name == "Player":
		has_triggered = true
		GameState.master_cutscene_played = true
		player = body
		player.set_enabled(false)
		colorRect.visible = true;
		has_triggered = true
		transition.play("fade_in")

func _on_animation_finished(anim_name):
	if anim_name == "fade_in":
		colorRect.visible = false;
		player.global_transform.origin = teleport_target.global_transform.origin
		player.look_at(look_target.global_transform.origin, Vector3.UP)
		await start_cutscene(player)

func start_cutscene(player):
	talk.play()
	cutscene.start_dialogue()
	await cutscene.dialogue_finished
	talk.stop()
	player.set_enabled(true)
