@tool
extends EditorPlugin


func _enable_plugin() -> void:
	add_autoload_singleton( "LovelyEvent", "res://addons/lovely_event/scripts/LovelyEvent.gd" );
	print("LovelyEvent: be sure to check the github repository for documentation!");


func _disable_plugin() -> void:
	remove_autoload_singleton( "LovelyEvent" );
