extends CanvasLayer

const STAGE_GAME = "res://stages/game_stage.tscn"
const STAGE_MENU = "res://stages/menu_stage.tscn"

signal stage_changed

var is_changing = false


func _ready():
	pass


func change_stage(stage_path):
	if is_changing:
		return

	is_changing = true
	get_tree().get_root().set_disable_input(true)

	# fade to black
	get_node("anim").play("fade_in")
	audio_player.play("sfx_swooshing")
	yield(get_node("anim"), "finished")

	# change scene
	get_tree().change_scene(stage_path)
	emit_signal("stage_changed")

	# fade from black
	get_node("anim").play("fade_out")
	yield(get_node("anim"), "finished")

	is_changing = false
	get_tree().get_root().set_disable_input(false)