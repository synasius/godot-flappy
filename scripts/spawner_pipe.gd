extends Node2D


const scn_pipe = preload('res://scenes/pipe.tscn')
const GROUND_HEIGHT = 56
const OFFSET_X = 65
const OFFSET_Y = 55
const PIPE_WIDTH = 26
const AMOUNT_TO_FILL_VIEW = 3


func _ready():
	go_init_pos()
	for i in range(AMOUNT_TO_FILL_VIEW):
		spawn_and_move()


func spawn_and_move():
	spawn_pipe()
	go_next_pos()


func go_init_pos():
	randomize()

	var init_pos = Vector2()
	init_pos.x = get_viewport_rect().size.width + PIPE_WIDTH/2
	init_pos.y = rand_range(0 + OFFSET_Y, get_viewport_rect().size.height - OFFSET_Y - GROUND_HEIGHT)
	set_pos(init_pos)


func spawn_pipe():
	var new_pipe = scn_pipe.instance()
	new_pipe.set_pos(get_pos())
	# When a new pipe is created we connect its "exit_tree"
	# signal to "spawn_and_move" function.
	# This way a new pipe is created when one dies and spawner
	# is moved to the next position.
	new_pipe.connect("exit_tree", self, "spawn_and_move")
	get_node("container").add_child(new_pipe)


func go_next_pos():
	randomize()

	var next_pos = get_pos()
	next_pos.x += PIPE_WIDTH/2 + OFFSET_X + PIPE_WIDTH/2
	next_pos.y = rand_range(0 + OFFSET_Y, get_viewport_rect().size.height - OFFSET_Y - GROUND_HEIGHT)
	set_pos(next_pos)