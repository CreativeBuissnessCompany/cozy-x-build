# SignalBus.gd 
class_name SignalBus extends Node


# Signals 

# Called from newly loaded locations I.E. Farm, InsideHouse, Etc .
# Sent to universe.gd 
signal location_loaded
# UI for Objects with inventory, From Object to UIRoot
signal open_object_with_inventory # Vending Machine....
# Object with DialogBox 
signal object_with_dialogbox
# Day change...
signal day_change
# Item Clicked
signal item_clicked
# Watered for Seeds
signal watered
# Emit SFX
signal sfx(audio_file)
# When UI Opens ... go where? ///
signal ui_open()
# Time to delete SeedToCrop Scene in farm.gd - TML...
signal delete_crop()
signal crop_ready()
# Scene with Camera Limits ready ... 
# Variable & Signal not in BaseScene, But in root scene of location ...
signal camera_limits()
# SeedToCrop and Farm 
signal harvest()
# Currency, From Player to HUD ...
signal currency()
# From use_or_drop.gd
signal use_or_drop()
# From item_slot.gd
signal seed_selected()