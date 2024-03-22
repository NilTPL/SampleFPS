extends CenterContainer


@export var RETICLE_LINES : Array[Line2D]
@export var PLAYER_CONTROLLER : CharacterBody3D
@export var RETICLE_SPEED : float = 0.1
@export var RETICLE_DISTANCE : float = 0.75


func _ready():
	queue_redraw()

func _process(delta):
#	adjust_reticle_lines()
	pass
func _draw():
	pass



func adjust_reticle_lines():
	pass
	var vel = PLAYER_CONTROLLER.get_real_velocity()
	var origin = Vector3(0,0,0)
	var pos = Vector2(0,0)
	var speed = origin.distance_to(vel)

	RETICLE_LINES[0].position = lerp(RETICLE_LINES[0].position, pos + Vector2(-speed * RETICLE_DISTANCE, -speed * RETICLE_DISTANCE), RETICLE_SPEED)
	RETICLE_LINES[1].position = lerp(RETICLE_LINES[1].position, pos + Vector2(speed * RETICLE_DISTANCE, -speed * RETICLE_DISTANCE), RETICLE_SPEED)
	RETICLE_LINES[2].position = lerp(RETICLE_LINES[2].position, pos + Vector2(-speed * RETICLE_DISTANCE, speed * RETICLE_DISTANCE), RETICLE_SPEED)
	RETICLE_LINES[3].position = lerp(RETICLE_LINES[3].position, pos + Vector2(speed * RETICLE_DISTANCE, speed * RETICLE_DISTANCE), RETICLE_SPEED)
