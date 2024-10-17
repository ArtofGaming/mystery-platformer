extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var time_jump_held = 0.0
var double_jump_used = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif is_on_wall_only():
		velocity += (get_gravity() * 0.75) * delta
		double_jump_used = false
	elif is_on_floor():
		double_jump_used = false


	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or not double_jump_used):
		time_jump_held += delta
		if time_jump_held <= 0.1:
			velocity.y = JUMP_VELOCITY / 2
		else:
			velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			double_jump_used = true
	elif Input.is_action_just_released("ui_accept"):
		time_jump_held = 0


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		#print(velocity)
		if Input.is_action_pressed("ui_down"):
			velocity.x = move_toward(velocity.x, 0, SPEED / 2)
		elif Input.is_action_just_pressed("dash"):
			print("dashed")
			velocity.x = velocity.x * 10
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	move_and_slide()
