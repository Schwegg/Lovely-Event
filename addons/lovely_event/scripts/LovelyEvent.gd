extends Node

var main_queue : EventQueue;
var queue_list : Dictionary[String,EventQueue] = {};

var pause : bool = false;

## does nothing by default.[br]
## set with [Callable] to replace.
## queues event to main_queue if not specified.[br][br]
## MUST return a [bool] (true if event has been queued, false if not).[br]
## takes [EVENT] variable type as one and only parameter.[br][br]
## example function:
## [codeblock]
## func example_queue_check( new_event : EVENT ) -> bool:
##     if Global.in_dialogue: # example check.
##         dialogue_queue.queue_event( new_event ); # queues event.
##         return true; # has queue'd event.
##     # has failed check, so has not queue'd event.
##     return false;
## [/codeblock]
var default_queue_check : Callable;


func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS;
	default_queue_check = default_queue_check_func;


func _ready() -> void:
	main_queue = EventQueue.new( "main_queue", true );
	main_queue.ignore_main_queue = true;
	main_queue.is_essential = true;


func _process( _dt : float ) -> void:
	for event_id in queue_list:
		var event_queue : EventQueue = queue_list[event_id];
		if not event_queue.is_running and not event_queue.is_empty:
			event_queue.update( _dt );

## queues the [param new_event] into the given [param event_queue].
## if no queue is given, calls [member LovelyEvent.default_queue_check] to
## check for the default queue to send [param new_event] to, which is 
## [member main_queue] by default.
func queue( new_event : EVENT, event_queue : EventQueue = null ) -> void:
	if queue == null:
		var has_queued_event : bool = default_queue_check.call( new_event );
		if not has_queued_event:
			main_queue.queue( new_event );
	else:
		event_queue.queue( new_event );


## does nothing by default. expected to be replaced via replacing [member LovelyEvent.default_queue_check].
func default_queue_check_func( _new_event : EVENT ) -> bool:
	return false;

## deletes queue from [member queue_list], unless [EventQueue].is_essential is true.
func delete_queue( event_queue : EventQueue ) -> void:
	if not event_queue.is_essential:
		event_queue.clear();
		queue_list.erase( event_queue );
	else:
		push_error( "tried to remove/delete one of main queues, pls do not." );
