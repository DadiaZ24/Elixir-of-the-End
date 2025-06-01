extends Area3D

@onready var transition = $"../Transition"
@onready var colorRect = $"../Transition/ColorRect"

var main_scene := load("res://Scenes/main.tscn")

var has_triggered = false

func _ready():
	connect("body_entered", _on_body_entered)
	transition.connect("animation_finished", _on_animation_finished)

func _on_body_entered(body):
	if has_triggered:
		return
	if body.name == "Player":
		if GameState.ending == true:
			var cutscene = preload("res://Scenes/EndCutscene1.tscn").instantiate()
			get_tree().get_root().add_child(cutscene)
			await get_tree().create_timer(0.1).timeout  # Wait for node to enter tree
			cutscene.start_cutscene()
		body.set_enabled(false)
		colorRect.visible = true;
		has_triggered = true
		transition.play("fade_out")

func _on_animation_finished(anim_name):

	if anim_name == "fade_out":
		colorRect.visible = false;
		if GameState.next_spawn_point_name == "master":
			GameState.next_spawn_point_name = "SpawnPointOutsideMaster"
		elif GameState.next_spawn_point_name == "potion":
			GameState.next_spawn_point_name = "SpawnPointOutsidePotion"
		get_tree().change_scene_to_packed(main_scene)
