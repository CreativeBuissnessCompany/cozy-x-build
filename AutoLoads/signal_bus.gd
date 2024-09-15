# SignalBus.gd 
class_name SignalBus extends Node


# Signals 

# Called from newly loaded locations I.E. Farm, InsideHouse, Etc .
# Sent to universe.gd 
signal location_loaded
# UI for Objects with inventory, From Object to UIRoot
signal open_object_with_inventory
