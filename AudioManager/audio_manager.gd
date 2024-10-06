extends Node

@onready var sfx_player: AudioStreamPlayer = $SfxPlayer


func _ready() -> void:
	
	# Takes audio_var from Scenetrigger.....
	Signalbus.connect("sfx", _on_sfx)
	


func _on_sfx(audio_file) ->void:
	sfx_player.stream = audio_file
	sfx_player.play()
	print(" Signal Received.......Playing .....")
