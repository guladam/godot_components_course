extends Node2D

@onready var character_juicer: Juicer = %CharacterJuicer
@onready var target_juicer: Juicer = %TargetJuicer
@onready var button_juicer: Juicer = %ButtonJuicer
@onready var bubble_juicer: Juicer = %BubbleJuicer

@onready var pop_in_text_button: Button = %PopInTextButton
@onready var pop_out_text_button: Button = %PopOutTextButton
@onready var bounce_target_button: Button = %BounceTargetButton
@onready var squash_and_stretch_button: Button = %SquashAndStretchButton
@onready var juice_button: Button = %JuiceButton


func _ready() -> void:
	squash_and_stretch_button.pressed.connect(character_juicer.play.bind("squash_and_stretch"))
	bounce_target_button.pressed.connect(target_juicer.play.bind("bounce", true))
	juice_button.pressed.connect(_on_juice_button_pressed)
	pop_in_text_button.pressed.connect(bubble_juicer.play.bind("pop_in"))
	pop_out_text_button.pressed.connect(bubble_juicer.play.bind("pop_out"))


func _on_juice_button_pressed() -> void:
	button_juicer.play("highlight")
	await button_juicer.group_tween_finished
	button_juicer.play("reset")
	
