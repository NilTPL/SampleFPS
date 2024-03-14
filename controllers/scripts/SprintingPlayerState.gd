class_name SprintingPlayerState extends PlayerMovementState

@export var _SPEED: float = 7.0
@export var ACCELERATION: float = 0.25
@export var DECELERATION: float = 0.25
@export var TOP_ANIM_SPEED: float = 1.6

func enter() -> void:
	ANIMATIONPLAYER.play("Sprint", 0.5, 1.0)

func exit() -> void:
	ANIMATIONPLAYER.speed_scale = 1.0
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(_SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()

	set_anim_speed(PLAYER.velocity.length())
	
	if Input.is_action_just_released("player_sprint"):
		transition.emit("WalkingPlayerState")

func set_anim_speed(spd) -> void:
	var alpha = remap(spd, 0.0, _SPEED, 0.0, 1.0)
	ANIMATIONPLAYER.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)
