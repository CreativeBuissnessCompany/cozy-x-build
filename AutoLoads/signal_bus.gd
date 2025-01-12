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
# From use_or_drop.gd # Change to "drop"
signal drop()
# From use_or_drop.gd
signal use_item()
# From item_slot.gd
signal seed_selected()
# To QuestManager from NPC?
signal quest_given()
# To QuestUI
signal quest_update()
# From Quest resource to QuestManager
signal quest_completed()
	



func on_quest_given():
	print("Signalbus.on_quest_given()")
#	print(Dialogic.VAR.quest_name)
	var quest_name: String = Dialogic.VAR.quest_name
	quest_given.emit(quest_name)