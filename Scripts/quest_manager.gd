extends CanvasLayer

@onready var quest_panel = $"QuestPanel"
@onready var quest_container = quest_panel.get_node("VBoxContainer")
@onready var quest_finished = quest_panel.get_node("QuestFinished")

var quest_steps = [
	{ "text": "Find the Philosopher's Stone", "completed": false },
	{ "text": "Find the Potion of Everlasting Life", "completed": false },
	{ "text": "???", "completed": false, "secret": true }
]

func _ready():
	visible = false

func all_required_quests_completed() -> bool:
	for step in quest_steps:
		if not step.get("secret", false) and not step["completed"]:
			return false
	return true

func reveal_secret_quest():
	# Reveal the hidden quest and refresh UI
	for step in quest_steps:
		if step.get("secret", false):
			step["text"] = "Make the Ultimate Decision.."
			break
	populate_quests()


func populate_quests():
	quest_container.clear()  # Clear any previous checkboxes

	for step in quest_steps:
		if step.get("secret", false) and not step["completed"]:
			continue
		var checkbox = CheckBox.new()
		checkbox.text = step["text"]
		checkbox.pressed = step["completed"]
		checkbox.disabled = true
		quest_container.add_child(checkbox)

func complete_quest(index: int):
	if index >= 0 and index < quest_steps.size():
		quest_steps[index]["completed"] = true
		var checkbox = quest_container.get_child(index)
		if checkbox:
			checkbox.pressed = true
			quest_finished.play()
		if all_required_quests_completed():
			reveal_secret_quest()
