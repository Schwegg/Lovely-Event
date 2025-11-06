extends EventQueue
class_name LinkedEventQueue

var link : Node;


func _init( queue_name : String, linked_node : Node, run_while_paused : bool = false ) -> void:
	link = linked_node;
	super._init( queue_name, run_while_paused );


func update( _dt : float ) -> void:
	if link == null:
		LovelyEvent.remove_queue( self );
		return;
	super.update( _dt );
