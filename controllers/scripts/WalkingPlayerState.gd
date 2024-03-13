class_name WalkingPlayerState

extends State
@export var ANIMATION : AnimationPlayer

func enter() -> void:
	ANIMATION.play("Walking", -1.0,1.0)

func update(delta):
	if Global.player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")
