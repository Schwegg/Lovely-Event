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


## queues self into given [param event_queue].[br]
## if no [param event_queue] is given, sends it to default queue ([member LovelyEvent.main_queue] by default).
func queue( event_queue : EventQueue = null ) -> void:
	LovelyEvent.queue( self, event_queue );


## [b]automatically[/b] called function to execute the event.[br]
## [b]do not call this function manually.[/b]
func execute( _looping : bool, _dt : float ) -> RETURNTYPE:
	# default event does nothing, if not overritten, will throw a fit.
	push_error( EID," event does nothing!" );
	return RETURNTYPE.ERROR;
