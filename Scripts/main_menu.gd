extends Control

@onready var transition = $Transition
@onready var colorRect = $Transition/ColorRect
#func _ready():
	#$playButton.grab_click_focus()

func _on_play_button_pressed():
	colorRect.visible = true;
	transition.play("fade_in")

func _on_transition_animation_finished(anim_name):
	colorRect.visible = false;
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
