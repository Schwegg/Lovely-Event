extends EVENT
class_name EVENT_wait

var wait_time : float = 0.0;


func _init( time : float ) -> void:
	wait_time = time;
	super._init();


func execute( _looping : bool, _dt : float ) -> RETURNTYPE:
	wait_time = max( wait_time-_dt, 0 );
	return RETURNTYPE.FINISHED if wait_time == 0 else RETURNTYPE.UNFINISHED;
