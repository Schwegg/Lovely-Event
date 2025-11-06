extends EVENT
class_name EVENT_print

var print_text : String;


func _init( ...args ) -> void:
	for v in args:
		print_text += str(v);
	super._init();


func execute( _looping : bool, _dt : float ) -> RETURNTYPE:
	print( print_text );
	return RETURNTYPE.FINISHED;


func skip() -> void:
	print( print_text );
