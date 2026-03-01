extends Node2D

@onready var flame_parents := [
	$Flames/FlameSpawn1,
	$Flames/FlameSpawn2,
	$Flames/FlameSpawn3,
	$Flames/FlameSpawn4,
	$Flames/FlameSpawn5
]
var flames := 0


func _ready() -> void:
	%Button.pressed.connect(
		func() -> void:
			if not visible:
				return
			
			if flames == 5:
				flames = 0
				for flame_parent: Node in flame_parents:
					flame_parent.get_child(0).queue_free()
			
			$SceneSpawner.spawn(flame_parents[flames])
			flames += 1
	)
