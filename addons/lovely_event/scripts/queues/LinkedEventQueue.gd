extends EventQueue
class_name LinkedEventQueue

var link : Node;


func _init( queue_name : String, linked_node : Node, run_while_paused : bool = false,  run_while_main_queue_runs : bool = false ) -> void:
	link = linked_node;
	super._init( queue_name, run_while_paused, run_while_main_queue_runs );


func update( _dt : float ) -> void:
	if is_essential:
		push_error( "LinkedEventQueue cannot be essential! use EventQueue instead!" );
		is_essential = false;
	if link == null:
		LovelyEvent.remove_queue( self );
		return;
	super.update( _dt );
