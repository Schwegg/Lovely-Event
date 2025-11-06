extends RefCounted
## a queue for events.[br]
## [color=red]WARNING[/color]: [method LovelyEvent.update] is automatically called
## via [LovelyEvent] global singleton.
class_name EventQueue

var name : String = ""; ## name/ID of [EventQueue].
var is_empty : bool = true; ## shows if [member event_queue] is empty.
var is_looping : bool = false; ## if current event within queue is being run for more than one [method _process].
var is_running : bool = false; ## shows whether [EVENT]s are being run in this queue or not.
var is_essential : bool = false; ## cannot be deleted via [method LovelyEvent.delete_queue] if true.
var event_queue : Array[ EVENT ] = []; ## queue for events.

var ignore_main_queue : bool = false; ## sets whether queue runs along-side the main queue or not.
var runs_while_paused : bool = false; ## sets whether queue runs while [LovelyEvent] is paused.

## checks this [Array] of [Callable]s before updating.[br]
## see: [method EventQueue.add_update_check].
var extra_checks : Array[Callable] = [];


func _init( queue_name : String, run_while_paused : bool = false ) -> void:
	name = queue_name;
	runs_while_paused = run_while_paused;
	if not LovelyEvent.queue_list.has( queue_name ):
		LovelyEvent.queue_list[queue_name] = self;
	else:
		push_error( "EventQueue \"",name,"\" already exists! try a different name!" );


## [Callable] must return bool.
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
	if (not LovelyEvent.pause) or (runs_while_paused and LovelyEvent.pause):
		return true;
	return false;


## alternatively can be queued via [EventQueue] eg.
## [codeblock]
## example_event_queue.queue( EVENT_Example.new() );
## [/codeblock]
## or can be queued via [LovelyEvent] directly eg.
## [codeblock]
## LovelyEvent.queue( EVENT_Example.new(), example_event_queue );
## [/codeblock]
func queue( event : EVENT ) -> void:
	event_queue.append( event );
	is_empty = false;


## [color=red]Warning[/color]: do [b]NOT[/b] call this function, it is automatically
## called automatically via [method LovelyEvent._process] function!
func update( _dt : float ) -> void:
	is_empty = event_queue.is_empty();
	# checks if queue can update
	if not check_can_update(): return;
	is_running = true;
	# if it can, updates
	if not event_queue.is_empty():
		event_queue[0].is_current_event = true;
		var event_return_type : EVENT.RETURNTYPE = event_queue[0].execute( is_looping, _dt );
		if event_return_type == EVENT.RETURNTYPE.UNFINISHED:
			is_looping = true;
			is_running = false;
		elif event_return_type == EVENT.RETURNTYPE.FINISHED: # finished event
			is_looping = false;
			remove_event();
		elif event_return_type == EVENT.RETURNTYPE.ERROR:
			push_error( "error with event of ID \"",event_queue[0].EID,"\" in queue ",name );
			is_looping = false;
			remove_event();
	else:
		is_running = false;


## removes top event from the [member event_queue].
func remove_event() -> void:
	if not event_queue.is_empty():
		event_queue[0].is_current_event = false;
		event_queue.remove_at( 0 );
	is_empty = event_queue.is_empty();
	if not event_queue.is_empty():
		update( LovelyEvent.get_process_delta_time() );


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
