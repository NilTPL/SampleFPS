extends CenterContainer


@export var RETICLE_LINES : Array[Line2D]
@export var PLAYER_CONTROLLER : CharacterBody3D
@export var RETICLE_SPEED : float = 0.25
@export var RETICLE_DISTANCE : float = 2.0
@export var DOT_RADIUS : float = 1.0
@export var DOT_COLOR : Color = Color.WHITE


func _ready():
	queue_redraw()

func _process(delta):
	pass

func _draw():
	draw_circle(Vector2(0,0), DOT_RADIUS, DOT_COLOR)
