class_name PlayerMovementState

extends State

var PLAYER: Player
var ANIMATIONPLAYER: AnimationPlayer

func _ready() -> void:
	await owner.ready
	PLAYER = owner as Player
	ANIMATIONPLAYER = PLAYER.ANIMATIONPLAYER

func _process(delta: float) -> void:
	pass
