extends RigidBody2D


func _ready():
	set_linear_velocity(Vector2(50, get_linear_velocity().y))

	set_process_input(true)
	set_fixed_process(true)

func _fixed_process(delta):
	# 0.5235 is approximately 30 degrees. I hardcoded this
	# value to avoid converting from degrees to radians on
	# every frame.
	if get_rot() > 0.5235:
		set_rot(0.5235)
		set_angular_velocity(0)

	if get_linear_velocity().y > 0:
		set_angular_velocity(1.5)

func flap():
	set_linear_velocity(Vector2(get_linear_velocity().x, -150))
	set_angular_velocity(-3)

func _input(event):
	if event.is_action_pressed("flap"):
		flap()