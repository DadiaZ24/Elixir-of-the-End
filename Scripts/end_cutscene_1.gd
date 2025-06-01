extends Node

@onready var camera: Camera3D = $ZoomCamera
@onready var fade: ColorRect = $Fade
@onready var win_message: Control = $WinMessage

func _ready():
	fade.visible = false
	win_message.visible = false

func start_cutscene():
	var tween = create_tween()  # Create a new tween tied to this node

	var zoom_target_pos = camera.global_position + Vector3(0, 10, 20)
	var zoom_tween = tween.tween_property(camera, "global_position", zoom_target_pos, 4.0)
	if zoom_tween:
		zoom_tween.set_trans(Tween.TRANS_SINE)
		zoom_tween.set_ease(Tween.EASE_OUT)

	await tween.finished  # Wait for zoom to finish

	fade.visible = true
	fade.color.a = 0.0

	var fade_tween = create_tween()  # Create a new tween for fading
	fade_tween.tween_property(fade, "color:a", 1.0, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	await fade_tween.finished  # Wait for fade to finish

	win_message.visible = true
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
