extends EVENT
## sets node visibilty on execution.
class_name EVENT_setVisible

# 2D and 3D nodes have visible property, but both are extentions of different base classes,
# so just going with Node.
var n : Node;
var is_visible : bool;

## sets [param node]'s visilibty to [param visible] on execute.
func _init( node : Node, visible : bool ) -> void:
	n = node;
	is_visible = visible;
	super._init();


func execute( _looping : bool, _dt : float ) -> RETURNTYPE:
	if n.visible != null:
		n.visible = is_visible;
		return RETURNTYPE.FINISHED;
	else:
		push_error( "node \"",n,"\" has no property named visible. make sure it extends either CanvasItem or Node3D." );
		return RETURNTYPE.ERROR;
