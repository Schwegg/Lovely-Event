extends EVENT
## waits X frames before continuing queue.
class_name EVENT_waitFrames

var frames_run : int = 0;
var frame_wait : int;

## waits [param frames_to_wait] frames before continuing queue.
func _init( frames_to_wait : int = 1 ) -> void:
	frame_wait = frames_to_wait;
	RenderingServer.frame_post_draw.connect( updated_frame );
	super._init();


func execute( _looping : bool, _dt : float ) -> RETURNTYPE:
	if frames_run >= frame_wait:
		return RETURNTYPE.FINISHED;
	return RETURNTYPE.UNFINISHED;


func updated_frame() -> void:
	if is_current_event:
		frames_run += 1;
