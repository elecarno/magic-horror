class_name player_sfx
extends Node3D

@export var footsteps_forest_1: Array = []
@export var footsteps_forest_2: Array = []
@export var footsteps_sprint_forest_1: Array = []
@export var footsteps_sprint_forest_2: Array = []
@export var jump_forest: Array = []
@export var land_forest: Array = []

@onready var sfx_footstep_1: AudioStreamPlayer3D = get_node("footstep_1")
@onready var sfx_footstep_2: AudioStreamPlayer3D = get_node("footstep_2")
@onready var sfx_jump: AudioStreamPlayer3D = get_node("jump")
@onready var sfx_land: AudioStreamPlayer3D = get_node("land")

func play_sfx(idx: int, arg: String = "N/A"):
	randomize()
	sfx_footstep_1.pitch_scale = randf_range(0.9, 1.1)
	sfx_footstep_2.pitch_scale = randf_range(0.9, 1.1)
	if arg == "sprint":
		sfx_footstep_1.stream = footsteps_forest_1.pick_random()
		sfx_footstep_1.volume_db = 0
		sfx_footstep_2.stream = footsteps_forest_2.pick_random()
		sfx_footstep_2.volume_db = 0
	else:
		sfx_footstep_1.stream = footsteps_sprint_forest_1.pick_random()
		sfx_footstep_1.volume_db = -12
		sfx_footstep_2.stream = footsteps_sprint_forest_2.pick_random()
		sfx_footstep_1.volume_db = -12
	sfx_jump.pitch_scale = randf_range(0.9, 1.1)
	sfx_jump.stream = jump_forest.pick_random()
	sfx_land.pitch_scale = randf_range(0.9, 1.1)
	sfx_land.stream = land_forest.pick_random()
	match idx:
		0: sfx_footstep_1.play()
		1: sfx_footstep_2.play()
		2: sfx_jump.play()
		3: sfx_land.play()
