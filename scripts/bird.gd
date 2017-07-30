extends RigidBody2D

onready var state = FlyingState.new(self)

var speed = 50

const STATE_FLYING = 0
const STATE_FLAPPING = 1
const STATE_HIT = 2
const STATE_GROUNDED = 3

signal state_changed


func _ready():
	set_process_input(true)
	set_fixed_process(true)

	connect("body_enter", self, "_on_body_enter")


func _fixed_process(delta):
	state.update(delta)


func _input(event):
	state.input(event)


func _on_body_enter(other_body):
	if state.has_method("on_body_enter"):
		state.on_body_enter(other_body)


func set_state(new_state):
	state.exit()

	if new_state == STATE_FLYING:
		state = FlyingState.new(self)
	elif new_state == STATE_FLAPPING:
		state = FlappingState.new(self)
	elif new_state == STATE_HIT:
		state = HitState.new(self)
	elif new_state == STATE_GROUNDED:
		state = GroundedState.new(self)

	emit_signal("state_changed", self)


func get_state():
	return state.id


# States
class FlyingState:
	var id = STATE_FLYING
	var bird
	var prev_gravity_scale

	func _init(bird):
		self.bird = bird
		bird.set_linear_velocity(Vector2(bird.speed, bird.get_linear_velocity().y))
		bird.get_node("anim").play("flying")
		# save the current gravity scale so we can restore it when we
		# exit from flying state.
		prev_gravity_scale = bird.get_gravity_scale()
		bird.set_gravity_scale(0)

	func update(delta):
		pass

	func input(event):
		pass

	func exit():
		bird.set_gravity_scale(prev_gravity_scale)
		bird.get_node("anim").stop()
		bird.get_node("anim_sprite").set_pos(Vector2(0, 0))


class FlappingState:
	var id = STATE_FLAPPING
	var bird

	func _init(bird):
		self.bird = bird
		bird.set_linear_velocity(Vector2(bird.speed, bird.get_linear_velocity().y))
		flap()

	func update(delta):
		# 0.5235 is approximately 30 degrees. I hardcoded this
		# value to avoid converting from degrees to radians on
		# every frame.
		if bird.get_rot() > 0.5235:
			bird.set_rot(0.5235)
			bird.set_angular_velocity(0)

		if bird.get_linear_velocity().y > 0:
			bird.set_angular_velocity(1.5)

	func input(event):
		if event.is_action_pressed("flap"):
			flap()

	func on_body_enter(other_body):
		if other_body.is_in_group(game.GROUP_PIPES):
			bird.set_state(bird.STATE_HIT)
		elif other_body.is_in_group(game.GROUP_GROUNDS):
			bird.set_state(bird.STATE_GROUNDED)

	func flap():
		bird.set_linear_velocity(Vector2(bird.get_linear_velocity().x, -150))
		bird.set_angular_velocity(-3)
		bird.get_node("anim").play("flap")

	func exit():
		pass


class HitState:
	var id = STATE_HIT
	var bird

	func _init(bird):
		self.bird = bird

		# stop any movement
		bird.set_linear_velocity(Vector2(0, 0))
		bird.set_angular_velocity(2)

		# we add a collision exception with the object we collided with,
		# which is a pipe, so that the bird can fall to the ground,
		# otherwise it could be blocked by the pipe itself.
		var other_body = bird.get_colliding_bodies()[0]
		bird.add_collision_exception_with(other_body)

	func update(delta):
		pass

	func input(event):
		pass

	func on_body_enter(other_body):
		if other_body.is_in_group(game.GROUP_GROUNDS):
			bird.set_state(bird.STATE_GROUNDED)

	func exit():
		pass


class GroundedState:
	var id = STATE_GROUNDED
	var bird

	func _init(bird):
		self.bird = bird
		# stop any movement
		bird.set_linear_velocity(Vector2(0, 0))
		bird.set_angular_velocity(0)

	func update(delta):
		pass

	func input(event):
		pass

	func exit():
		pass