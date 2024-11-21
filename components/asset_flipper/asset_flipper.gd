extends Sprite2D



enum ASSET {ONE, TWO, THREE}
@export var switch_asset_to: ASSET = ASSET.ONE:
	set(value):
		switch_asset_to = value
		switch_asset()

@export var assets_options: Array[Texture2D]



func _ready() -> void:
#	switch_asset()
	pass
	
func switch_asset():
	print("poop")

	self.texture = assets_options[switch_asset_to]
