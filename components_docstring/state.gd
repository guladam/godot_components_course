class_name State
extends RefCounted
## Abstract base class representing a single state for a finite state machine.
##
## All custom gameplay states must extend this class. Because it inherits from 
## [RefCounted], instances are automatically garbage-collected by the engine the 
## moment they are deselected or replaced inside the [FiniteStateMachine].

## The root execution node this state is controlling (e.g., a CharacterBody2D).
## This is the parent Node of the [FiniteStateMachine] in the SceneTree.
var actor: Node2D


## Called immediately when the state machine transitions into this state.
## Use this to trigger initialization logic, reset timers, or play entrance animations.
func enter() -> void:
	pass


## Called immediately before this state is discarded or replaced.
## Use this to clean up persistent modifications, stop sounds, or clear temporary flags.
func exit() -> void:
	pass


## Virtual method corresponding directly to the engine's [code]_update()[/code] virtual method.
func update(_delta: float) -> void:
	pass


## Virtual method corresponding directly to the the engine's [code]_physics_update()[/code] virtual method.
func physics_update(_delta: float) -> void:
	pass


## Virtual method corresponding directly to the engine's [code]_unhandled_input()[/code] virtual method.
func unhandled_input(_event: InputEvent) -> void:
	pass
