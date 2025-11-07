@tool
extends EditorPlugin


func _enable_plugin() -> void:
	var node_icon = preload( "res://addons/lovely_event/node-icon.svg" );
	# evemt scripts
	var event = preload( "res://addons/lovely_event/scripts/base_events/EVENT.gd" );
	var event_call = preload( "res://addons/lovely_event/scripts/base_events/EVENT_call.gd" );
	var event_print = preload( "res://addons/lovely_event/scripts/base_events/EVENT_print.gd" );
	var event_setVisible = preload( "res://addons/lovely_event/scripts/base_events/EVENT_setVisible.gd" );
	var event_wait = preload( "res://addons/lovely_event/scripts/base_events/EVENT_wait.gd" );
	var event_waitForInput = preload( "res://addons/lovely_event/scripts/base_events/EVENT_waitForInput.gd" );
	var event_waitFrame = preload( "res://addons/lovely_event/scripts/base_events/EVENT_waitFrame.gd" );
	# queue scripts
	var q_event_queue = preload( "res://addons/lovely_event/scripts/queues/EventQueue.gd" );
	var q_linked_event_queue = preload( "res://addons/lovely_event/scripts/queues/LinkedEventQueue.gd" );
	var q_temp_event_queue = preload( "res://addons/lovely_event/scripts/queues/TempEventQueue.gd" );
	# adding as types: events
	add_custom_type( "EVENT", "RefCounted", event, node_icon );
	add_custom_type( "EVENT_call", "EVENT", event_call, node_icon );
	add_custom_type( "EVENT_print", "EVENT", event_print, node_icon );
	add_custom_type( "EVENT_setVisible", "EVENT", event_setVisible, node_icon );
	add_custom_type( "EVENT_wait", "EVENT", event_wait, node_icon );
	add_custom_type( "EVENT_waitForInput", "EVENT", event_waitForInput, node_icon );
	add_custom_type( "EVENT_waitFrame", "EVENT", event_waitFrame, node_icon );
	# adding as types: queues
	add_custom_type( "EventQueue", "RefCounted", q_event_queue, node_icon );
	add_custom_type( "LinkedEventQueue", "EventQueue", q_linked_event_queue, node_icon );
	add_custom_type( "TempEventQueue", "RefCounted", q_temp_event_queue, node_icon );
	# add singleton
	add_autoload_singleton( "LovelyEvent", "res://addons/lovely_event/scripts/LovelyEvent.gd" );
	print("LovelyEvent: be sure to check the github repository for documentation!");


func _disable_plugin() -> void:
	# removes events
	remove_custom_type( "EVENT" );
	remove_custom_type( "EVENT_call" );
	remove_custom_type( "EVENT_print" );
	remove_custom_type( "EVENT_setVisible" );
	remove_custom_type( "EVENT_wait" );
	remove_custom_type( "EVENT_waitForInput" );
	remove_custom_type( "EVENT_waitFrame" );
	# removes queues
	remove_custom_type( "EventQueue" );
	remove_custom_type( "LinkedEventQueue" );
	remove_custom_type( "TempEventQueue" );
	# removes singleton
	remove_autoload_singleton( "LovelyEvent" );
