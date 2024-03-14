class_name IdlePlayerState

extends PlayerMovementState

@export var _SPEED: float = 5.0
@export var ACCELERATION: float = 0.2
@export var DECELERATION: float = 0.25

func enter() -> void:
	ANIMATIONPLAYER.pause()

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(_SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	
	if Input.is_action_just_pressed("player_crouch") and PLAYER.is_on_floor():
		transition.emit("CrouchingPlayerState")
	
	if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor():
		transition.emit("WalkingPlayerState")
