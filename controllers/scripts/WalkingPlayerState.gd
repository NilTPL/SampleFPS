class_name WalkingPlayerState 

extends PlayerMovementState

@export var _SPEED: float = 5.5
@export var ACCELERATION: float = 0.3
@export var DECELERATION: float = 0.25
@export var TOP_ANIM_SPEED : float = 2.2

func enter() -> void:
	ANIMATIONPLAYER.play("Walking", -1.0, 1.0)
	
func exit() -> void:
	ANIMATIONPLAYER.speed_scale = 1.0

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(_SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	
	set_anim_speed(PLAYER.velocity.length())
	
	if Input.is_action_pressed("player_sprint") and PLAYER.is_on_floor():
		transition.emit("SprintingPlayerState")
	if Input.is_action_pressed("player_crouch"):
		transition.emit("CrouchingPlayerState")
	
	if PLAYER.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")

func set_anim_speed(spd):
	var alpha = remap(spd, 0.0, _SPEED, 0.0, 1.0)
	ANIMATIONPLAYER.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)
