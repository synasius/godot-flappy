extends Node

const GROUP_PIPES = "pipes"
const GROUP_GROUNDS = "grounds"
const GROUP_BIRDS = "birds"

const MEDAL_BRONZE = 1
const MEDAL_SILVER = 2
const MEDAL_GOLD = 3
const MEDAL_PLATINUM = 4

var score_current = 0 setget _set_score_current
var score_best = 0 setget _set_score_best


signal score_current_changed
signal score_best_changed


func _ready():
	stage_manager.connect("stage_changed", self, "_on_stage_changed")


func _on_stage_changed():
	score_current = 0


func _set_score_current(new_value):
	score_current = new_value
	emit_signal("score_current_changed")


func _set_score_best(new_value):
	if score_best < new_value:
		score_best = new_value
		emit_signal("score_best_changed")