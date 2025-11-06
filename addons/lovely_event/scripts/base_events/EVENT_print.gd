extends EVENT
## prints out text to the console on execution.
class_name EVENT_print

var print_text : String;

## prints out [param args] as a string to the console on execute.
func _init( ...args ) -> void:
	for v in args:
		print_text += str(v);
	super._init();


func execute( _looping : bool, _dt : float ) -> RETURNTYPE:
	print( print_text );
	return RETURNTYPE.FINISHED;
