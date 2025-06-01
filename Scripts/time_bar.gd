extends ProgressBar

@onready var time_label = $TimeLabel  # Reference to the child Label

var total_time := 900.0  # 15 minutes
var current_time := total_time
var timer_active := false

signal time_out

func _ready():
	# Initialize label
	time_label.text = format_time(current_time)
	visible = false  # Hide until tutorial ends

func _process(delta):
	if timer_active:
		current_time -= delta
		current_time = clamp(current_time, 0.0, total_time)
		value = current_time

		# Update label text
		time_label.text = "Time Left: %s" % format_time(current_time)

		if current_time <= 0.0:
			timer_active = false
			emit_signal("time_out")

func format_time(seconds: float) -> String:
	var mins = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [mins, secs]
