extends Camera2D

onready var bird = utils.get_main_node().get_node("bird")


func _ready():
	set_fixed_process(true)


func _fixed_process(delta):
	set_pos(Vector2(bird.get_pos().x, get_pos().y))


func get_total_pos():
	""" Returns the position of the camera with the offset """
	return get_pos() + get_offset()