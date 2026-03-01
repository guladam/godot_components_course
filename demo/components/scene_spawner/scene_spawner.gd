extends Node2D

@onready var demos := [
	$FlamesDemo, 
	$ProjectileDemo, 
	$RewardDemo
]


func _ready() -> void:
	%TabBar.tab_changed.connect(_on_tab_changed)


func _on_tab_changed(idx: int) -> void:
	demos[0].hide()
	demos[1].hide()
	demos[2].hide()
	demos[idx].show()
	%Button.disabled = idx == 1
	
	match idx:
		0: %Button.text = "Spawn Flame"
		1: %Button.text = "Space to fire arrow"
		2: %Button.text = "Get Reward"
