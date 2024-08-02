class_name FallingPlayerState extends PlayerMovementState

@export var _SPEED: float = 5.0
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25

func enter() -> void:
	ANIMATIONPLAYER.pause()

func exit() -> void:
	pass

func update(delta: float) -> void:
	PLAYER.update_gravity(delta)
	PLAYER.update_input(_SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()

	if PLAYER.is_on_floor():
		ANIMATIONPLAYER.speed_scale = 1.0
		ANIMATIONPLAYER.play("Landing")
		transition.emit("IdlePlayerState")
