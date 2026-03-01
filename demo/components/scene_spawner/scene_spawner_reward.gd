extends GPUParticles2D

const LVL1 := preload("res://demo/components/scene_spawner/scene_spawner_reward_particle1.tres")
const LVL2 := preload("res://demo/components/scene_spawner/scene_spawner_reward_particle2.tres")
const LVL3 := preload("res://demo/components/scene_spawner/scene_spawner_reward_particle3.tres")

@export var level := 1


func _ready() -> void:
	amount = level * 10 + 10
	
	match level:
		1:
			texture.region.position = Vector2(896, 320)
			process_material = LVL1
		2:
			texture.region.position = Vector2(896, 192)
			process_material = LVL2
		3:
			texture.region.position = Vector2(896, 128)
			process_material = LVL3
	
	emitting = true
	finished.connect(queue_free)
