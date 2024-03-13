extends CharacterBody3D

@export var is_enabled_crouch_toggling: bool = false

@export var ANIMATIONPLAYER: AnimationPlayer
@export var CROUCH_SHAPECAST : Node3D
@export var mouse_sensitivity: float = 0.1
@export_range(1, 20, 0.1) var CROUCHING_SPEED: float = 15.0

@export var SPEED_DEFAULT: float = 5.5
@export var SPEED_CROUCH: float = 2.5
@export var SPEED_SPRINT: float = 7.0
@export var JUMP_VELOCITY: float = 3.5
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25

@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER : Camera3D
@export var _mouse_sensitivity : float = 0.5

var _mouse_input : bool = false
var _mouse_rotation : Vector3
var _rotation_input : float
var _tilt_input : float
var _player_rotation : Vector3
var _camera_rotation : Vector3
var _SPEED : float
var is_crouching : bool = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _input(event):
	#exit button - esc
	if event.is_action_pressed("exit"):
			get_tree().quit()
	# if crouch is on a toggle, handle crouching
	if is_enabled_crouch_toggling and event.is_action_pressed("player_crouch"):
		if is_crouching: # if already crouched, check for collision and act accordingly
			if !CROUCH_SHAPECAST.is_colliding():
				movementStateChange("uncrouch")
			elif CROUCH_SHAPECAST.is_colliding():
				uncrouch_check() # check collision for as long as uncrouch attempt is sent
		elif !is_crouching:# if not already crouched, crouch
			movementStateChange("crouch") 
	# if crouch isn't on a toggle, handle crouching
	if !is_enabled_crouch_toggling:
		if Input.is_action_just_pressed("player_crouch"):
			
			if !is_crouching: # if not already crouched, slow down and crouch
				movementStateChange("crouch")
				_SPEED = SPEED_CROUCH
		if Input.is_action_just_released("player_crouch"): # if uncrouch attempted, check collision
			if !CROUCH_SHAPECAST.is_colliding():
				movementStateChange("uncrouch")
				_SPEED = SPEED_DEFAULT # uncrouch and speed back up
			elif CROUCH_SHAPECAST.is_colliding():
				uncrouch_check() # check collision for crouch attempt
	
func _unhandled_input(event):
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * _mouse_sensitivity
		_tilt_input = -event.relative.y * _mouse_sensitivity

func _update_camera(delta):
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0, _mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)
	
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	_rotation_input = 0.0
	_tilt_input = 0.0
func _ready():
	
	Global.player = self
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	CROUCH_SHAPECAST.add_exception($".")
	
	_SPEED = SPEED_DEFAULT
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	Global.Debug.add_property("MovementSpeed", _SPEED, 1)
	Global.Debug.add_property("FPS", Global.Debug.frames_per_second, 2)
	Global.Debug.add_property("is_crouching", is_crouching, 3)
	Global.Debug.add_property("velocity", velocity.length(), 4)
	
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	_update_camera(delta)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("player_move_left", "player_move_right", "player_move_forward", "player_move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * _SPEED, ACCELERATION)
		velocity.z = lerp(velocity.z, direction.z * _SPEED, ACCELERATION)
	else:
		var vel = Vector2(velocity.x,velocity.z)
		var temp = move_toward(Vector2(velocity.x,velocity.z).length(), 0, DECELERATION)
		velocity.x = vel.normalized().x * temp
		velocity.z = vel.normalized().y * temp

	move_and_slide()

func movementStateChange(changeType):
	match changeType:
		"crouch":
			$AnimationPlayer.play("standingToCrouch", -1, CROUCHING_SPEED)
			is_crouching = true
			changeCollisionShapeTo("crouching")
			
		"uncrouch":
			$AnimationPlayer.play("standingToCrouch", -1, -CROUCHING_SPEED, true)
			is_crouching = false
			changeCollisionShapeTo("standing")
			


#Change collision shapes for standing, crouch, crawl
func changeCollisionShapeTo(shape):
	match shape:
		"crouching":
			#Disabled == false is enabled!
			$CrouchingCollisionShape3DCylinder.disabled = false
			$StandingCollisionShape3DCylinder.disabled = true
		"standing":
			#Disabled == false is enabled!
			$StandingCollisionShape3DCylinder.disabled = false
			$CrouchingCollisionShape3DCylinder.disabled = true

func setMovementSpeed(state):
	match state:
		"default":
			_SPEED = SPEED_DEFAULT
		"crouching":
			_SPEED = SPEED_CROUCH

func uncrouch_check():
	if !Input.is_action_pressed("player_crouch"):
		if !CROUCH_SHAPECAST.is_colliding():
			movementStateChange("uncrouch")
		elif CROUCH_SHAPECAST.is_colliding():
			await get_tree().create_timer(0.1).timeout
			uncrouch_check()

