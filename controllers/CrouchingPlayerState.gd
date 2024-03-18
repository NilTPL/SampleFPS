class_name CrouchingPlayerState extends PlayerMovementState

@export var _SPEED: float = 4.5
@export var ACCELERATION: float = 0.25
@export var DECELERATION: float = 0.25
@export_range(1, 15, 0.1) var CROUCH_SPEED : float = 4.0

@onready var CROUCH_SHAPECAST : ShapeCast3D = %ShapeCast3D


func enter() -> void:
	ANIMATIONPLAYER.speed_scale = 1.0
	ANIMATIONPLAYER.play("standingToCrouch", -1.0, CROUCH_SPEED)
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(_SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()

	if Input.is_action_just_released("player_crouch"):
		uncrouch()

func uncrouch():
	if CROUCH_SHAPECAST.is_colliding() == false and Input.is_action_pressed("player_crouch") == false:
		ANIMATIONPLAYER.play("standingToCrouch", -1.0, -CROUCH_SPEED * 1.5, true)
		if ANIMATIONPLAYER.is_playing():
			await ANIMATIONPLAYER.animation_finished
		transition.emit("IdlePlayerState")
	elif CROUCH_SHAPECAST.is_colliding() == true:
		
		await get_tree().create_timer(0.1).timeout
		uncrouch()
