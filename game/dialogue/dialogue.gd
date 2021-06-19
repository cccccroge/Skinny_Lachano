extends Node2D

# sentences format 
# {
#	"sentences" : [
#		"text1", "text2", .... 	
#	]
# }

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var fd : File
var textLabel : RichTextLabel
var sentences #Variant
var nextCount = 0

func _init():
	textLabel = get_node("Background/RichTextLabel")
	textLabel.bbcode_enabled = true;
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _enter_tree():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# 讀對話檔案
func setDialogScript(path):
	fd = File.new()
	fd.open(path, _File.READ)
	
	var parseRes = JSON.parse(fd.get_as_text())
	fd.close()
	
	if(parseRes.error != OK):
		print("[Debug] : " + sentences.error_string)
	
	sentences = parseRes.result['sentences']
	
func nextSentence():
	
	textLabel.bbcode_text = sentences[nextCount]
	nextCount = nextCount + 1
