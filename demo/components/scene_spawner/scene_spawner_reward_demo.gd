extends Node2D

var level := 1


func _ready() -> void:
	%Button.pressed.connect(
		func() -> void:
			if not visible:
				return

			var reward: Node = $SceneSpawner.instantiate()
			reward.level = level
			$SpawnPosition.add_child(reward)
	)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		level = wrapi(level + 1, 1, 4)
		$Text/LevelLabel.text = "Press Space to toggle the Level!\nCurrent Level: %s" % level
