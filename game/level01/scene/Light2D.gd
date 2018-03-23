extends Light2D

export(int) var V

func _ready():
	set_process(true)

func _process(delta):
	self.position = get_global_mouse_position()
