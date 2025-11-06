extends EventQueue
class_name TempEventQueue

var has_had_an_event : bool = false;


func update( _dt : float ) -> void:
	can_i_delete_myself_now();
	# checks if any events have populated this queue, at all. if so, yes. you may delete yourself.
	if event_queue.size() > 0: has_had_an_event = true;
	super.update( _dt );


func can_i_delete_myself_now() -> void:
	if has_had_an_event and is_empty:
		# I WAS MADE FOR THIIIIIS!!
		EventSystem.remove_queue( self );
