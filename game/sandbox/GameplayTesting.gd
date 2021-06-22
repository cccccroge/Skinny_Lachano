extends Node2D

onready var health_progress_bar := $UiLayer/VBoxContainer2/HBoxContainer/HealthBar
onready var bone_progress_bar := $UiLayer/VBoxContainer2/HBoxContainer2/BoneBar
onready var intestinal_progress_bar := $UiLayer/VBoxContainer2/HBoxContainer3/IntestinalBar
onready var decre_health_btn := $UiLayer/VBoxContainer/DecreHealthBtn
onready var incre_health_btn := $UiLayer/VBoxContainer/IncreHealthBtn
onready var decre_bone_btn := $UiLayer/VBoxContainer/DecreBoneBtn
onready var incre_bone_btn := $UiLayer/VBoxContainer/IncreBoneBtn
onready var vel_label := $UiLayer/VBoxContainer2/HBoxContainer4/Label2
onready var lachano := $ViewportContainer/Viewport/Obstacles/Lachano
onready var lachano_status := $ViewportContainer/Viewport/Obstacles/Lachano/MainStatuses
onready var shaded_scene := $SceneLayer/ShadedScene
onready var ui_layer := $UiLayer 

func _ready():
	init_status_ui()
	connect_signals()
	toggle_hack_menu()

func _unhandled_input(event):
	if event is InputEventKey and \
		event.pressed and event.scancode == KEY_ESCAPE:
		toggle_hack_menu()

func init_status_ui():
	health_progress_bar.min_value = 0
	health_progress_bar.max_value = lachano_status.max_status["health"]
	bone_progress_bar.min_value = 0
	bone_progress_bar.max_value = lachano_status.max_status["bone"]
	intestinal_progress_bar.min_value = 0
	intestinal_progress_bar.max_value = \
		lachano_status.max_status["intestinal_juice"]
	update_status_bar()

func connect_signals():
	var _err
	_err = decre_health_btn.connect("button_down", \
		lachano_status, "alter_status_by", ["health", -5])
	_err = incre_health_btn.connect("button_down", \
		lachano_status, "alter_status_by", ["health", 5])
	_err = decre_bone_btn.connect("button_down", \
		lachano_status, "alter_status_by", ["bone", -2.5])
	_err = incre_bone_btn.connect("button_down", \
		lachano_status, "alter_status_by", ["bone", 2.5])
	_err = lachano_status.connect("status_altered", \
		self, "update_status_bar")
	_err = lachano_status.connect("status_altered", \
		self, "update_low_health_shader")
	_err = lachano.connect("vel_changed", self, "update_vel_label")

func update_status_bar():
	health_progress_bar.value = lachano_status.status["health"]
	bone_progress_bar.value = lachano_status.status["bone"]
	intestinal_progress_bar.value = lachano_status.status["intestinal_juice"]
	vel_label.text = String(lachano.vel)

func update_vel_label(vel):
	vel_label.text = String(vel)

func update_low_health_shader():
	var health_percent = \
		lachano_status.status["health"] /lachano_status.max_status["health"]
	var intensity = 1 - health_percent
	shaded_scene.material.set_shader_param("overall_intensity", intensity)

func toggle_hack_menu():
	if ui_layer.get_parent() == null:
		add_child(ui_layer)
	else:
		remove_child(ui_layer)
