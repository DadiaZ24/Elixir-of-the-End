extends CanvasLayer

#tutorial
@onready var tutorial_panel = $"TutorialPanel"
@onready var tutorial_label = tutorial_panel.get_node("Label")
@onready var tutorial_finished = $"QuestFinished"

var tutorial_steps = [
	{"text": "Press [b]W[/b] to move forward", "action": "ui_up"},
	{"text": "Press [b]S[/b] to move backward", "action": "ui_down"},
	{"text": "Press [b]A[/b] to move left", "action": "ui_left"},
	{"text": "Press [b]D[/b] to move right", "action": "ui_right"},
	{"text": "Move your [b]mouse[/b] to look around", "action": "mouse_move"},
	{"text": "Press [b]Space[/b] to jump", "action": "ui_accept"},
	{"text": "Press [b]SHIFT[/b] to sprint", "action": "ui_sprint"},
	{"text": "[color=lime][b]Tutorial Complete! Go talk to your master.[/b][/color]", "action": ""}
]

var current_step = 0
var tutorial_active = true
var mouse_move_detected := false

func is_action_allowed(action_name: String) -> bool:
	if not tutorial_active:
		return true
	return tutorial_steps[current_step]["action"] == action_name


func _ready():
	show_current_tutorial_step()

func _process(_delta):
	if GameState.tutorial_completed:
		queue_free()
		return
	show_current_tutorial_step()

	var current_action = tutorial_steps[current_step]["action"]

	if current_action == "mouse_move":
		if mouse_move_detected:
			mouse_move_detected = false
			current_step += 1
			show_current_tutorial_step()
	elif current_action != "":
		if Input.is_action_just_pressed(current_action):
			current_step += 1
			show_current_tutorial_step()

func show_current_tutorial_step():
	if current_step >= tutorial_steps.size():
		tutorial_panel.visible = false
		tutorial_active = false
		return

	tutorial_label.bbcode_text = tutorial_steps[current_step]["text"]
	tutorial_panel.visible = true

	if tutorial_steps[current_step]["action"] == "":
		tutorial_active = false
		GameState.tutorial_completed = true
		await get_tree().create_timer(3.0).timeout
		tutorial_finished.play()
		tutorial_panel.visible = false
		var time_bar = get_node("/root/Main/UI/TimeBar")
		time_bar.visible = true
		time_bar.timer_active = true
	
func _unhandled_input(event):
	if not tutorial_active:
		return

	if tutorial_steps[current_step]["action"] == "mouse_move":
		if event is InputEventMouseMotion:
			# You can set a threshold if needed
			if event.relative.length() > 10.0:
				mouse_move_detected = true
