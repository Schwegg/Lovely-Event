extends EVENT
## waits for user input of given
class_name EVENT_waitForInput

var input : String

## checks for [param action], will not continue queue until [param action] is pressed.[br][br]
## NOTE: if no [param action] is given, will check/accept any input.
func _init( action : StringName = "" ) -> void:
	input = action;
	super._init();


func execute( _looping : bool, _dt : float ) -> RETURNTYPE:
	if _looping:
		if input == "":
			if Input.is_anything_pressed():
				return RETURNTYPE.FINISHED;
		else:
			if InputMap.has_action( input ):
				if Input.is_action_just_pressed( input ):
					return RETURNTYPE.FINISHED;
			else:
				push_error( EID,": input action \"",input,"\" does not exist!" );
				return RETURNTYPE.ERROR;
	return RETURNTYPE.UNFINISHED;
