@icon("interactable_2d.svg")
class_name Interactable2D
extends Area2D
## A 2D spatial target that forwards interaction triggers from an [Interactor2D].
##
## Acts as a signal bridge component. Connect the [signal interacted] signal 
## in the Godot Inspector to execute custom logic on the owning scene or parent node.

## Emitted when an [Interactor2D] successfully activates this target.
## Passes the player or entity node that initiated the interaction.
signal interacted(initiator: Node2D)


## Called by an [Interactor2D] when the player triggers the interaction input action.
func interact(initiator: Node2D) -> void:
	if not monitorable:
		return

	interacted.emit(initiator)
