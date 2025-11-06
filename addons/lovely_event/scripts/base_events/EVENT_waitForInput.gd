extends EVENT
class_name EVENT_waitForInput

var input : String

func _init( check_input : String = "" ) -> void:
	input = check_input;
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
