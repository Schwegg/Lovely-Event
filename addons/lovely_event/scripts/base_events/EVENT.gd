extends RefCounted
## [color=red]Warning![/color] does nothing by default when instantiated.[br]
## must add [method EVENT.queue] after/with event eg.
## [codeblock]
## EVENT_Example.new().queue( example_event_queue );
## [/codeblock]
## or:
## [codeblock]
## var event = EVENT_Example.new();
## event.queue( example_event_queue );
## [/codeblock]
## [code]example_event_queue[/code] can be [Null] as well to send to
## default queue, [member LovelyEvent.main_queue].
class_name EVENT

## return type for [method execute] function.
enum RETURNTYPE { FINISHED, UNFINISHED, ERROR }

## event ID, generated automatically via class name
var EID : String;
var is_current_event : bool = false;


func _init() -> void:
	# gets name of the current event script
	EID = get_script().get_global_name();


## alternatively can be called via [EVENT] eg.
## [codeblock]
## EVENT_Example.new().queue();
## [/codeblock]
## or can be queued via [LovelyEvent] directly eg.
## [codeblock]
## LovelyEvent.queue( EVENT_Example.new(), example_event_queue );
## [/codeblock]
func queue( event_queue : EventQueue = null ) -> void:
	LovelyEvent.queue( self, event_queue );


## automatically called function to execute the event.
## [color=red]do NOT call this function manually.[/color]
func execute( _looping : bool, _dt : float ) -> RETURNTYPE:
	# default event does nothing, if not overritten, will throw a fit.
	push_error( EID," event does nothing!" );
	return RETURNTYPE.ERROR;
