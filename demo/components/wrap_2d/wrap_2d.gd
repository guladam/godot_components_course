extends Node2D

var char_speed := 200
var character_dir := Vector2.ZERO
var ball_pos: Vector2
var ball_impulse := Vector2(500, 0)
var ball_offset := Vector2(32, 0)
var flying_creature_dir := Vector2.ZERO
var fly_speed := 250


func _ready() -> void:
	ball_pos = $Ball.global_position
	
	%CharLeft.pressed.connect(func(): character_dir = Vector2.LEFT)
	%CharStop.pressed.connect(func(): character_dir = Vector2.ZERO)
	%CharRight.pressed.connect(func(): character_dir = Vector2.RIGHT)
	%BallLeft.pressed.connect(func(): $Ball.apply_impulse(-ball_impulse, -ball_offset))
	%BallReset.pressed.connect(_reset_ball)
	%BallRight.pressed.connect(func(): $Ball.apply_impulse(ball_impulse, ball_offset))
	%EnemyUp.pressed.connect(func(): flying_creature_dir = Vector2.UP)
	%EnemyStop.pressed.connect(func(): flying_creature_dir = Vector2.ZERO)
	%EnemyDown.pressed.connect(func(): flying_creature_dir = Vector2.DOWN)


func _physics_process(delta: float) -> void:
	if character_dir != Vector2.ZERO:
		$Character/AnimatedSprite2D.play("run")
		$Character/AnimatedSprite2D.flip_h = character_dir == Vector2.LEFT
		$Character.velocity = character_dir * char_speed
		$Character.move_and_slide()
	else:
		$Character/AnimatedSprite2D.play("idle")
		$Character.velocity = Vector2.ZERO
	
	if flying_creature_dir !=  Vector2.ZERO:
		$FlyingCreature.play("fly")
		$FlyingCreature.position += flying_creature_dir * fly_speed * delta
	else:
		$FlyingCreature.play("idle")


func _reset_ball() -> void:
	var state := PhysicsServer2D.body_get_direct_state($Ball.get_rid())
	if state:
		var xform = state.transform
		xform.origin = ball_pos
		state.transform = xform
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0
