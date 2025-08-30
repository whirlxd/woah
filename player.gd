extends CharacterBody2D

const SPEED := 400.0
const ACCEL := 50.0
const AIR_ACCEL := 25.0
const FRICTION := 2000.0
const AIR_FRICTION := 200.0


const JUMP_VELOCITY := -700.0
const MAX_FALL_SPEED := 1200.0
const VARIABLE_JUMP_MULT := 0.7
const MAX_JUMPS := 2


const COYOTE_TIME := 0.15
const JUMP_BUFFER := 0.15
const JUMP_MOMENTUM_BOOST := 150.0
const FAST_FALL_SPEED := 1600.0
const FAST_FALL_MULT := 1.5
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var jumps_left := MAX_JUMPS


@export var death_y: float = 1200.0  

func _physics_process(delta: float) -> void:
	# --- Gravity ---
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > MAX_FALL_SPEED:
			velocity.y = MAX_FALL_SPEED

	if Input.is_action_pressed("ui_down") and velocity.y > 0:
		velocity.y = min(velocity.y * FAST_FALL_MULT, FAST_FALL_SPEED)


	if is_on_floor():
		coyote_timer = COYOTE_TIME
		jumps_left = MAX_JUMPS
	else:
		coyote_timer -= delta


	if Input.is_action_just_pressed("JUMP"):
		jump_buffer_timer = JUMP_BUFFER
	else:
		jump_buffer_timer -= delta
	if jump_buffer_timer > 0 and (coyote_timer > 0 or jumps_left > 0):
		velocity.y = JUMP_VELOCITY
		if Input.get_axis("LEFT", "RIGHT") != 0:
			velocity.x += Input.get_axis("LEFT", "RIGHT") * JUMP_MOMENTUM_BOOST
		jump_buffer_timer = 0
		jumps_left -= 1
		coyote_timer = 0

	if Input.is_action_just_released("JUMP") and velocity.y < 0:
		velocity.y *= VARIABLE_JUMP_MULT

	
	var dir := Input.get_axis("LEFT", "RIGHT")
	if dir != 0:
		var accel = ACCEL if is_on_floor() else AIR_ACCEL
		velocity.x = move_toward(velocity.x, dir * SPEED, accel * delta)
	else:
		var friction = FRICTION if is_on_floor() else AIR_FRICTION
		velocity.x = move_toward(velocity.x, 0, friction * delta)


	move_and_slide()


	if global_position.y > death_y:
		#global_position.y = -500  -> dev
		_restart_game()

func _restart_game():
	get_tree().reload_current_scene()
