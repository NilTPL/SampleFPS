class_name IdlePlayerState

extends PlayerMovementState

@export var _SPEED: float = 5.0
@export var ACCELERATION: float = 0.2
@export var DECELERATION: float = 0.25
@export var TOP_ANIM_SPEED: float = 2.2

func enter() -> void:
	if ANIMATIONPLAYER.is_playing() and ANIMATIONPLAYER.current_animation == "Landing":
		ANIMATIONPLAYER.speed_scale = 1.0
		await  ANIMATIONPLAYER.animation_finished
		ANIMATIONPLAYER.pause()
	else:
		ANIMATIONPLAYER.pause()

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(_SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	
	if Input.is_action_pressed("player_sprint") and PLAYER.is_on_floor() and PLAYER.velocity.length() > 0.0:
		transition.emit("SprintingPlayerState")
	
	if Input.is_action_just_pressed("player_crouch") and PLAYER.is_on_floor():
		transition.emit("CrouchingPlayerState")
	
	if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor() and !Input.is_action_pressed("player_sprint"):
		transition.emit("WalkingPlayerState")
	
	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")
