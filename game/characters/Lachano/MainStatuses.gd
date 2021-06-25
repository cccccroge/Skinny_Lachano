extends Node

signal status_altered

export(int) var BASE_HEALTH
export(int) var BASE_BONE
export(int) var BASE_INTESTINAL_JUICE

export(float) var AUTO_HEAL_THRESHHOLD	# seconds
export(int) var HEAL_SPEED				# health / sec

var status := {}
var max_status := {}
var is_healing := false
onready var timer := $HealTimer

func _ready():
	create_status()
	init_timer()

func _process(delta):
	if is_healing and !status_is_max("health"):
		var health_added = delta * HEAL_SPEED
		alter_status_by("health", health_added)

func create_status():
	max_status = {
		"health": BASE_HEALTH,
		"bone": BASE_BONE,
		"intestinal_juice": BASE_INTESTINAL_JUICE,
	}
	status = {
		"health": BASE_HEALTH,
		"bone": BASE_BONE,
		"intestinal_juice": BASE_INTESTINAL_JUICE,
	}

func init_timer():
	timer.wait_time = AUTO_HEAL_THRESHHOLD
	var _err := timer.connect("timeout", self, "start_healing")

func start_healing():
	if !is_healing:
		is_healing = true

func stop_healing():
	if is_healing:
		is_healing = false

func start_heal_timer():
	timer.start()
	
func stop_heal_timer():
	timer.stop()

func status_is_max(type: String) -> bool:
	return status[type] == max_status[type]

func alter_status_by(type: String, quantity: float):
	var original = status[type]
	status[type] += quantity
	status[type] = clamp(status[type], 0, max_status[type])
	if status[type] != original:
		emit_signal("status_altered")
