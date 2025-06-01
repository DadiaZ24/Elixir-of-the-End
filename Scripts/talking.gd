extends Panel

@onready var label = $DialogueLabel
@onready var master_anim = $"../../masterinbed/AnimationPlayer"

var dialogue_lines = [
	"Master: You came... Good. I feared I would not see your face again before the end.",
	"Player: Master, what's happening? The village—everyone—they’re all so weak... and you...",
	"Master: It is the Blight. A sickness older than any of us. It spreads like fire...",
	"Player: No... There must be something we can do!",
	"Master: I tried to hold it off... but my time has run short.",
	"Player: What can I do Master?",
	"Master: There is a way. A potion, lost to time, made from three sacred ingredients.",
	"Master: Read my book.. It contains the help of our predecessors..",
	"Player: I will help you and the village, Master!",
	"Master: Go now, child. Save them... before the Blight takes us all..."
]

var current_line = 0
var typing_speed := 0.03
var is_typing := false
var full_line := ""
var typed_chars := 0
signal dialogue_finished

func start_dialogue():
	current_line = 0
	show()
	_start_typing_next_line()

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			label.text = full_line
			is_typing = false
		else:
			if current_line < dialogue_lines.size():
				_start_typing_next_line()
			else:
				hide()
				emit_signal("dialogue_finished")

func _start_typing_next_line():
	label.text = ""
	full_line = dialogue_lines[current_line]
	current_line += 1
	typed_chars = 0
	is_typing = true
	_type_text()

func _type_text() -> void:
	label.text = ""
	master_anim.play("bigodeAction")
	while typed_chars < full_line.length():
		if not is_typing:
			break
		label.text += full_line[typed_chars]
		typed_chars += 1
		await get_tree().create_timer(typing_speed).timeout
	is_typing = false
	master_anim.stop()
