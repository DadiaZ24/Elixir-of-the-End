extends Node3D

@onready var area = $Area3D
@onready var area2 = $Area3D2
@onready var area3 = $Area3D3
@onready var sound_player = $AudioStreamPlayer3D

var player_near = false
var player = null

func _ready():
	call_deferred("_setup_connections")
	sound_player.finished.connect(_on_sound_finished)

func _setup_connections():
	area.body_entered.connect(_on_body_entered.bind(area))
	area.body_exited.connect(_on_body_exited.bind(area))
	area2.body_entered.connect(_on_body_entered.bind(area2))
	area2.body_exited.connect(_on_body_exited.bind(area2))
	area3.body_entered.connect(_on_body_entered.bind(area3))
	area3.body_exited.connect(_on_body_exited.bind(area3))

func _on_body_entered(body, entered_area):
	if body.name == "Player":
		player_near = true
		player = body
		
		if entered_area == area:
			sound_player.volume_db = 2
		elif entered_area == area2:
			sound_player.volume_db = 5
		elif entered_area == area3:
			sound_player.volume_db = 6
		
		if not sound_player.playing:
			sound_player.play()

func _on_body_exited(body, exited_area):
	if body.name == "Player":
		player_near = false
		player = null

func _on_sound_finished():
	if player_near:
		sound_player.play()
