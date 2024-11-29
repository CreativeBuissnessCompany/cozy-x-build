# 						camera.gd
extends Camera2D






func _ready() -> void:
	
#	print("Camera is Ready ...")
	update_camera_bounds()
	Signalbus.camera_limits.connect(update_camera_bounds)
	
	pass

	


func update_camera_bounds():
	# TESTING 
#	print(GameData.camera_bounds[0])
#	print(GameData.camera_bounds[1])
#	print(GameData.camera_bounds[2])
#	print(GameData.camera_bounds[3])
	
	if GameData.camera_bounds == Vector4i(0,0,0,0):
		print("Camera Bounds not set in root of Level/Location ....")
		return
	else:
#		print("Camera updated, Camera Bounds are set")
		
		self.limit_left = GameData.camera_bounds[0]
		self.limit_top = GameData.camera_bounds[1]
		self.limit_right = GameData.camera_bounds[2]
		self.limit_bottom = GameData.camera_bounds[3]
		
		
	
	
	