class_name WalkingPlayerState

extends State
@export var ANIMATION : AnimationPlayer
@export var TOP_ANIM_SPEED : float = 2.2

func enter() -> void:
	ANIMATION.play("Walking", -1.0, 1.0)
	Global.player._SPEED = Global.player.SPEED_DEFAULT
	

func update(delta):
	set_anim_speed(Global.player.velocity.length())
	if Global.player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")

func set_anim_speed(spd):
	var alpha = remap(spd, 0.0, Global.player.SPEED_DEFAULT, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)

func _input(event) -> void:
	if event.is_action_pressed("player_sprint") and Global.player.is_on_floor():
		transition.emit("SprintingPlayerState")
