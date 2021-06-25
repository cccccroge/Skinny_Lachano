extends Node

export(int) var BASE_HEALTH
export(int) var BASE_BONE
export(int) var BASE_INTESTINAL_JUICE

var status := {}
onready var timer := $HealTimer


func _init():
	create_status()
	
func create_status():
	status = {
		"health": BASE_HEALTH,
		"bone": BASE_BONE,
		"intestinal_juice": BASE_INTESTINAL_JUICE,
	}
