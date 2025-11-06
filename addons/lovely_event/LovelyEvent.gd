@tool
extends EditorPlugin


func _enable_plugin() -> void:
	add_autoload_singleton( "EventSystem", "res://addons/lovely_event/scripts/EventSystem.gd" );
	pass


func _disable_plugin() -> void:
	remove_autoload_singleton( "EventSystem" );
	pass
