extends RefCounted
## a queue for events.[br]
## [color=red]WARNING[/color]: [method LovelyEvent.update] is automatically called
## via [LovelyEvent] global singleton.
class_name EventQueue

## just an error message for internal use.
const err_queueOfIDExists = "EventQueue \"%s\" already exists! try a different name!";

var name : String = ""; ## name/ID of [EventQueue].
var pause : bool = false; ## pauses the specified [EventQueue].
var is_empty : bool = true; ## shows if [member event_queue] is empty.
var is_looping : bool = false; ## if current event within queue is being run for more than one [method _process].
var is_running : bool = false; ## shows whether [EVENT]s are being run in this queue or not.
var is_essential : bool = false; ## cannot be deleted via [method LovelyEvent.delete_queue] if true.
var event_queue : Array[ EVENT ] = []; ## queue for events.

var ignore_main_queue : bool = false; ## sets whether queue runs along-side the main queue or not.
var runs_while_pause_all : bool = false; ## sets whether queue runs while [LovelyEvent] is paused.

## checks this [Array] of [Callable]s before updating.[br]
## see: [method EventQueue.add_update_check].
var extra_checks : Array[Callable] = [];


func _init( queue_ID : String, run_while_pause_all : bool = false, run_with_main_queue : bool = false ) -> void:
	name = queue_ID;
	runs_while_pause_all = run_while_pause_all;
	ignore_main_queue = run_with_main_queue;
	if not LovelyEvent.queue_list.has( queue_ID ):
		LovelyEvent.queue_list[queue_ID] = self;
	else:
		push_error( err_queueOfIDExists % name );


## [Callable] must return [code]bool[/code].
## used before the update process to check if queue should be updated.
func add_update_check( check_func : Callable ) -> void:
	extra_checks.append( check_func );


## used internally to check if [EventQueue] can be updated or not.
func check_can_update() -> bool:
	if check_main_queue_check() and check_pause_check():
		return true;
	for check in extra_checks:
		if check.call():
			return true;
	is_running = false;
	return false;


## internal check for [method EventQueue.check_can_update].
func check_main_queue_check() -> bool:
	if ignore_main_queue or ( not ignore_main_queue and not LovelyEvent.main_queue.is_running ):
		return true;
	return false;


## internal check for [method EventQueue.check_can_update].
func check_pause_check() -> bool:
	if not pause:
		return true;
	if (not LovelyEvent.pause) or (runs_while_pause_all and LovelyEvent.pause):
		return true;
	return false;


## adds [param event] to end of queue.
func queue( event : EVENT ) -> void:
	event_queue.append( event );
	is_empty = false;


## [b]HEY![/b] do [b]NOT[/b] call this function,
## it's called automatically via [method LovelyEvent._process] function!
func update( _dt : float ) -> void:
	is_empty = event_queue.is_empty();
	# checks if empty first.
	if not event_queue.is_empty():
		# checks if queue can update
		if not check_can_update(): return;
		# if it can, updates
		is_running = true;
		event_queue[0].is_current_event = true;
		var event_return_type : EVENT.RETURNTYPE = event_queue[0].execute( is_looping, _dt );
		if event_return_type == EVENT.RETURNTYPE.UNFINISHED:
			is_looping = true;
			is_running = false;
		elif event_return_type == EVENT.RETURNTYPE.FINISHED: # finished event
			is_looping = false;
			remove_top_event();
		elif event_return_type == EVENT.RETURNTYPE.ERROR:
			push_error( "error with event of ID \"",event_queue[0].EID,"\" in queue ",name );
			is_looping = false;
			remove_top_event();
		else:
			push_error( "EVENTs should always return an EVENT.RETURNTYPE! please do this!" );
			is_looping = false;
			remove_top_event();
	else:
		is_running = false;


## removes top event from the [member event_queue].
func remove_top_event() -> void:
	if not event_queue.is_empty():
		event_queue[0].is_current_event = false;
		event_queue.remove_at( 0 );
	is_empty = event_queue.is_empty();
	if not is_empty:
		update( LovelyEvent.get_process_delta_time() );
	else:
		is_running = false;


## removes specific event from the [member event_queue].
func remove_specific_event( event : EVENT ) -> void:
	if event_queue.has( event ):
		if event.is_current_event: event.is_current_event = false;
		event_queue.erase( event );
	is_empty = event_queue.is_empty();


## empties/clears the [member event_queue].
func clear() -> void:
	for event in event_queue:
		event.is_current_event = false;
	event_queue.clear();
	is_empty = true;
	is_running = false;


func delete() -> void:
	if not is_essential:
		LovelyEvent.delete_queue( self );
	else:
		push_error( LovelyEvent.err_cannotDeleteEssentialQueue );
