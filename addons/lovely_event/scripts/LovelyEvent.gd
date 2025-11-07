extends Node

## just an error message for internal use.
const err_couldntFindQueueOfID = "couldn't find event queue of ID \"%s\"";
## just an error message for internal use.
const err_cannotDeleteEssentialQueue = "cannot delete essential event queue. if you want to delete this queue, set the queue's is_essential var to false.";

var main_queue : EventQueue;
var queue_list : Dictionary[String,EventQueue] = {};

var pause_all : bool = false;

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
	default_queue_check = func() -> bool: return false;


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
	if event_queue == null:
		var has_queued_event : bool = default_queue_check.call( new_event );
		if not has_queued_event:
			main_queue.queue( new_event );
	else:
		event_queue.queue( new_event );


func get_queue_by_ID( queue_id : String ) -> EventQueue:
	if queue_list.has( queue_id ):
		return queue_list[queue_id];
	push_error( err_couldntFindQueueOfID % queue_id );
	return null;

## deletes queue from [member queue_list], unless [EventQueue].is_essential is true.
func delete_queue( event_queue : EventQueue ) -> void:
	if not event_queue.is_essential:
		event_queue.clear();
		queue_list.erase( event_queue );
	else:
		push_error( err_cannotDeleteEssentialQueue );


func delete_queue_by_ID( queue_id : String ) -> void:
	if queue_list.has( queue_id ):
		var event_queue = queue_list[queue_id];
		if not event_queue.is_essential:
			event_queue.clear();
			queue_list.erase( event_queue );
		else:
			push_error( err_cannotDeleteEssentialQueue );
	else:
		push_error( err_couldntFindQueueOfID % queue_id );
