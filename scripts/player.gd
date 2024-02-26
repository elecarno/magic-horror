extends CharacterBody3D

# main
var speed: float
const WALK_SPEED: float = 4.0
const SPRINT_SPEED: float = 8.0
const CROUCH_SPEED: float = 1.5
const JUMP_VELOCITY: float = 6.0
const SENSITIVITY: float = 0.005
var grounded: bool = false
var crouched: bool = false

# head bob
const BOB_FREQ: float = 2.0
const BOB_AMP: float = 0.08
var t_bob: float = 0.0

# fov
const BASE_FOV: float = 70.0
const FOV_CHANGE: float = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 19.6

@onready var head: Node3D = get_node("head")
@onready var cam: Camera3D = get_node("head/cam")
@onready var coyote_timer: Timer = get_node("coyote_time")
@onready var col: CollisionShape3D = get_node("col")

@onready var sfx: player_sfx = get_node("head/sfx")

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_node("mesh").visible = false

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		cam.rotate_x(-event.relative.y * SENSITIVITY)
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-70), deg_to_rad(70))

func _physics_process(delta):
	if Input.is_action_just_pressed("esc"):
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# gravity
	if !is_on_floor():
		velocity.y -= gravity * delta
		
	# coyote_time
	if is_on_floor() and !grounded:
		grounded = true
	elif grounded == true and coyote_timer.is_stopped():
		coyote_timer.start()

	# handle jump.
	if Input.is_action_just_pressed("mov_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sfx.play_sfx(2)
		
	# handle crouch
	if Input.is_action_pressed("mov_crouch"):
		col.shape.height = lerp(col.shape.height, 0.5, delta * 4.0)
		crouched = true
	else:
		col.shape.height = lerp(col.shape.height, 1.8, delta * 3.0)
		crouched = false
		
	# handle move speed
	if crouched:
		speed = CROUCH_SPEED
	elif Input.is_action_pressed("mov_sprint") and !crouched:
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# input direction
	var input_dir = Input.get_vector("mov_left", "mov_right", "mov_forward", "mov_backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)

	# head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	cam.transform.origin = _headbob(t_bob)
	
	# sfx
	if direction:
		if cos(t_bob * BOB_FREQ / 2) > 0.9 and !sfx.sfx_footstep_1.playing:
			sfx.play_sfx(0)
		if cos(t_bob * BOB_FREQ / 2) < -0.9 and !sfx.sfx_footstep_2.playing:
			sfx.play_sfx(1)

	# fov
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	cam.fov = lerp(cam.fov, target_fov, delta * 8.0)

	var was_on_floor = is_on_floor()
	move_and_slide()
	
	if is_on_floor() and not was_on_floor:
		sfx.play_sfx(3)
	
func _headbob(time: float) -> Vector3:
	var pos: Vector3 = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	
func _on_coyote_time_timeout():
	grounded = false
