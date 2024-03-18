class_name SprintingPlayerState extends PlayerMovementState

@export var _SPEED: float = 7.0
@export var ACCELERATION: float = 0.25
@export var DECELERATION: float = 0.25
#@export var TILT_AMOUNT: float = 0.09
@export var TOP_ANIM_SPEED: float = 1.6
@onready var Camera: Camera3D = %Camera3D
@onready var player_fov: float = 75

func enter() -> void:
	ANIMATIONPLAYER.play("SprintFOV", 0.5, 1.0)
	#set_tilt(PLAYER._current_rotation)
	#ANIMATIONPLAYER.get_animation("Sprint").track_set_key_value(4,0,PLAYER.velocity.length())
	ANIMATIONPLAYER.play("Sprint", 0.5, 1.0)
	

func exit() -> void:
	print("notsprint")
	get_viewport().get_camera_3d().fov = 75
	ANIMATIONPLAYER.speed_scale = 1.0
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(_SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	player_fov = get_viewport().get_camera_3d().fov
	set_anim_speed(PLAYER.velocity.length())
	
	if Input.is_action_just_released("player_sprint"):
		transition.emit("WalkingPlayerState")

func set_anim_speed(spd) -> void:
	var alpha = remap(spd, 0.0, _SPEED, 0.0, 1.0)
	ANIMATIONPLAYER.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)

func _physics_process(delta):
	Global.Debug.add_property("FOV", "%.2f" % player_fov, 4)
#func set_tilt(player_rotation) -> void:
#	var tilt = Vector3.ZERO
#	tilt.z = clamp(TILT_AMOUNT * player_rotation, -0.1, 0.1)
#	if tilt.z == 0.0:
#		tilt.z = 0.05
#	ANIMATIONPLAYER.get_animation("Sprint").track_set_key_value(8,1,tilt)
#	ANIMATIONPLAYER.get_animation("Sprint").track_set_key_value(8,2,tilt)
