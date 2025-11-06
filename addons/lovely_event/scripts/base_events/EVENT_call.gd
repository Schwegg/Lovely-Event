extends EVENT
class_name EVENT_call

var call_function : Callable;
var call_vars;

func _init( function : Callable, variables = null ) -> void:
	call_function = function;
	call_vars = variables
	super._init();


func execute( _looping : bool, _dt : float ) -> RETURNTYPE:
	if call_vars != null:
		call_function.callv( call_vars );
	else:
		call_function.call();
	return RETURNTYPE.FINISHED;


func skip() -> void:
	if call_vars != null:
		call_function.callv( call_vars );
	else:
		call_function.call();
