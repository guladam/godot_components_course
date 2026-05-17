extends Node2D

@export var animation: PackedScene


func _ready() -> void:
	%Tree.create_item().set_text(0, "Children of 'Animations' Node")
	%Button.pressed.connect(_on_button_pressed)
	$Animations.child_order_changed.connect(
		func():
			if not has_node("%Tree"):
				return
			
			%Tree.clear()
			var root: TreeItem = %Tree.create_item()
			root.set_text(0, "Children of 'Animations' Node")
			for child: Node in $Animations.get_children():
				var item: TreeItem = %Tree.create_item(root)
				item.set_text(0, child.name)
	)


func _on_button_pressed() -> void:
	var new_anim: Node2D = animation.instantiate()
	$Animations.add_child(new_anim)
	var x := randi_range($SpawnStart.global_position.x, $SpawnEnd.global_position.x)
	var y := randi_range($SpawnStart.global_position.y, $SpawnEnd.global_position.y)
	new_anim.global_position = Vector2(x, y)
