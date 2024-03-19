class_name IdlePlayerState

extends PlayerMovementState

@export var _SPEED: float = 5.0
@export var ACCELERATION: float = 0.2
@export var DECELERATION: float = 0.25
@export var TOP_ANIM_SPEED: float = 2.2

func enter() -> void:
	
	if get_viewport().get_camera_3d().fov > 75:
		pass
	ANIMATIONPLAYER.pause()

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(_SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
		
	set_animation_speed(PLAYER.velocity.length())
	
	
	if Input.is_action_pressed("player_sprint") and PLAYER.is_on_floor() and PLAYER.velocity.length() > 0.0:
		transition.emit("SprintingPlayerState")
	
	if Input.is_action_just_pressed("player_crouch") and PLAYER.is_on_floor():
		transition.emit("CrouchingPlayerState")
	
	if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor() and !Input.is_action_pressed("player_sprint"):
		transition.emit("WalkingPlayerState")

func set_animation_speed(spd):
	var alpha = remap(spd, 0.0, _SPEED, 0.0, 1.0)
	ANIMATIONPLAYER.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)
