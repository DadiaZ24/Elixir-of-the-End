extends Area3D

@onready var transition = $"../Transition"
@onready var colorRect = $"../Transition/ColorRect"

const MASTER_TENT_SCENE := preload("res://Scenes/master_tent.tscn")

var has_triggered = false

func _ready():
	connect("body_entered", _on_body_entered)
	transition.connect("animation_finished", _on_animation_finished)

func _on_body_entered(body):
	if has_triggered:
		return
	if body.name == "Player":
		body.set_enabled(false)
		colorRect.visible = true;
		has_triggered = true
		transition.play("fade_in")

func _on_animation_finished(anim_name):
	if anim_name == "fade_in":
		colorRect.visible = false;
		get_tree().change_scene_to_packed(MASTER_TENT_SCENE)
