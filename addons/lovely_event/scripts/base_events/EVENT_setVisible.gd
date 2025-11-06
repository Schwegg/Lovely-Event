extends EVENT
class_name EVENT_setVisible

var n : Node3D
var is_visible : bool

func _init( node : Node3D, visible : bool ) -> void:
	n = node;
	is_visible = visible;
	super._init();


func execute( _looping : bool, _dt : float ) -> RETURNTYPE:
	n.visible = is_visible;
	return RETURNTYPE.FINISHED;


func skip() -> void:
	n.visible = is_visible;
