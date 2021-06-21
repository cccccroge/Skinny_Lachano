extends Node2D

onready var health_progress_bar := $UiLayer/VBoxContainer2/HBoxContainer/HealthBar
onready var bone_progress_bar := $UiLayer/VBoxContainer2/HBoxContainer2/BoneBar
onready var intestinal_progress_bar := $UiLayer/VBoxContainer2/HBoxContainer3/IntestinalBar
onready var decre_health_btn := $UiLayer/VBoxContainer/DecreHealthBtn
onready var incre_health_btn := $UiLayer/VBoxContainer/IncreHealthBtn
onready var lachano_status := $ViewportContainer/Viewport/Obstacles/Lachano/MainStatuses
onready var shaded_scene := $SceneLayer/ShadedScene

func _ready():
	init_status_ui()
	connect_signals()

func init_status_ui():
	health_progress_bar.min_value = 0
	health_progress_bar.max_value = lachano_status.max_status["health"]
	bone_progress_bar.min_value = 0
	bone_progress_bar.max_value = lachano_status.max_status["bone"]
	intestinal_progress_bar.min_value = 0
	intestinal_progress_bar.max_value = \
		lachano_status.max_status["intestinal_juice"]
	update_progress_bars()

func connect_signals():
	var _err
	_err = decre_health_btn.connect("button_down", \
		lachano_status, "alter_status_by", ["health", -5])
	_err = incre_health_btn.connect("button_down", \
		lachano_status, "alter_status_by", ["health", 5])
	_err = lachano_status.connect("status_altered", \
		self, "update_progress_bars")
	_err = lachano_status.connect("status_altered", \
		self, "update_low_health_shader")

func update_progress_bars():
	health_progress_bar.value = lachano_status.status["health"]
	bone_progress_bar.value = lachano_status.status["bone"]
	intestinal_progress_bar.value = lachano_status.status["intestinal_juice"]

func update_low_health_shader():
	var health_percent = \
		lachano_status.status["health"] /lachano_status.max_status["health"]
	var intensity = 1 - health_percent
	shaded_scene.material.set_shader_param("overall_intensity", intensity)
