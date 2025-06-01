extends Control

func _ready() -> void:
	visible = false
	
func get_if_visible() -> bool:
	return visible

func open():
	visible=true

func close():
	visible=false

func toogle():
	visible=!visible
