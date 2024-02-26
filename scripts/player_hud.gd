extends Control

@onready var hp_bar: Slider = get_node("status/hp_bar")
@onready var stamina_bar: Slider = get_node("status/stamina_bar")
@onready var mana_bar: Slider = get_node("status/mana_bar")

func _ready():
	_update_hud()

func _update_hud():
	hp_bar.max_value = player_stats.MAX_HP
	stamina_bar.max_value = player_stats.MAX_STAMINA
	mana_bar.max_value = player_stats.MAX_MANA

func _process(delta):
	hp_bar.value = player_stats.hp
	stamina_bar.value = player_stats.stamina
	mana_bar.value = player_stats.mana
