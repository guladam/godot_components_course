@icon("interactable_2d.svg")
class_name Interactable2D
extends Area2D

signal interacted(initiator: Node2D)


func interact(initiator: Node2D) -> void:
	if not monitorable:
		return

	interacted.emit(initiator)
