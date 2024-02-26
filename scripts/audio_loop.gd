extends AudioStreamPlayer3D

@export var looping: bool = true

func _on_finished():
	if looping:
		play()
