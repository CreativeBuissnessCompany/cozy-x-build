extends Sprite2D


@export var assets_options: Array[Texture2D]



enum ASSET {ONE, TWO, THREE}

@export var switch_asset_to: ASSET = ASSET.ONE:
	set(value):
		switch_asset_to = value
		switch_asset()




func _ready() -> void:
#	switch_asset()
	pass
	
func switch_asset():
	print("poop")
	await Engine.get_main_loop().process_frame
	self.texture = assets_options[switch_asset_to]
