@tool
extends EditorPlugin


func _enable_plugin() -> void:
	add_autoload_singleton( "LovelyEvent", "res://addons/lovely_event/scripts/LovelyEvent.gd" );
	pass


func _disable_plugin() -> void:
	remove_autoload_singleton( "LovelyEvent" );
	pass
