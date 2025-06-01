extends Panel

@onready var quest_panel = $"."
@onready var quest_container = $VBoxContainer
@onready var quest_finished = $QuestFinished

var quest_steps = [
	{ "text": "Find the Philosopher's Stone", "completed": false },
	{ "text": "Find the Potion of Everlasting Life", "completed": false },
	{ "text": "???", "completed": false, "secret": true }
]

func _ready():
	# Garante que o painel continua visível se já tiveres progresso
	if quest_steps.any(func(s): return s["completed"]):
		visible = true
		populate_quests()
	else:
		visible = false

func all_required_quests_completed() -> bool:
	for step in quest_steps:
		if not step.get("secret", false) and not step["completed"]:
			return false
	return true

func reveal_secret_quest():
	for step in quest_steps:
		if step.get("secret", false):
			step["text"] = "Make the Ultimate Decision.."
			break
	populate_quests()

func populate_quests():
	# Limpa os antigos
	for child in quest_container.get_children():
		child.queue_free()

	# Adiciona novamente
	for step in quest_steps:
		if step.get("secret", false) and not step["completed"]:
			continue
		var checkbox = CheckBox.new()
		checkbox.text = step["text"]
		checkbox.button_pressed = step["completed"]
		checkbox.disabled = true
		quest_container.add_child(checkbox)

func complete_quest(index: int):
	if index >= 0 and index < quest_steps.size():
		quest_steps[index]["completed"] = true
		visible = true  # mostra o painel se for a primeira vez
		populate_quests()
		quest_finished.play()

		if all_required_quests_completed():
			reveal_secret_quest()
