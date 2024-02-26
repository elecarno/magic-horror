extends Area3D

@export var damage: float = 25.0

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_stats.take_damage(damage)
