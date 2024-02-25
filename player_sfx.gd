class_name player_sfx
extends Node3D

@export var footsteps_forest_1: Array = []
@export var footsteps_forest_2: Array = []

@onready var sfx_footstep_1: AudioStreamPlayer3D = get_node("footstep_1")
@onready var sfx_footstep_2: AudioStreamPlayer3D = get_node("footstep_2")

func play_sfx(idx: int):
	randomize()
	sfx_footstep_1.pitch_scale = randf_range(0.9, 1.1)
	sfx_footstep_1.stream = footsteps_forest_1.pick_random()
	sfx_footstep_2.pitch_scale = randf_range(0.9, 1.1)
	sfx_footstep_2.stream = footsteps_forest_2.pick_random()
	match idx:
		0: sfx_footstep_1.play()
		1: sfx_footstep_2.play()
