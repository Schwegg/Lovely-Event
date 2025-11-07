# Lovely Event

A light-weight but flexible **event system** addo-on for Godot based off my original Love2D event system, hence the name!

## Backstory

I've been using different itterations of this addon at the center of my projects since I started gamedev around 2017. it started as a
Love2D script that I ported over to Godot and evolved over time into what it is now. My goal with this project is to help others with
this addon. I hope this addon serves others like it has for me for so many years.
(if you want to see my terrible original Love2D version, you can see it [here](https://github.com/Schwegg/Love2D-Lovely-Event/tree/main)!)

## How to Install

1. Download the repository and move 'addons/lovely_event' folder into your Godot project.
2. Go to 'Project Settings -> Plugins' and check enable on the plugin.

## Basic Rundown

What is an "event system"? Well for this project it refers to a setup of three components:
1. `LovelyEvent` - the singleton global manager which updates and manages queues.
2. `EventQueue` - a queue which holds events and manages the events within itself.
3. `EVENT` - the individual events which populate the queues.

These three components work together to create this plugin/addon.\
`EVENT`s are executed in order and will "loop"/execute every `_process()` call if they aren't finished on first execution.
once an `EVENT` returns "finished", it removes that event from the queue and executes the next event in the queue.

This is helpful for executing things in sequence, but not immediately. In my time I've used it for everything from managing level loading,\
scene transitions, dialogue and basically executing cutscenes.

The main thing that makes this all useful is that the queue waits for a response from the currently executing event. Until it recieves either a\
`EVENT.RETURNTYPE.FINISHED` or `EVENT.RETURNTYPE.ERROR`, it will continuously execute that event every `_process()`.

## Examples

Here's an example from one of my projects, because of how I title these it probably doesn't take much to figure out what each `EVENT`'s functionality is.

```gdscript
func set_level( levelID : String, target_door : String = "" ) -> void:
	if current_level != null:
		# fade to black transition, waits for transition to finish.
		EVENT_fadeOn.new().queue()
	else:
		# starts at black screen
		fade_blank()
	EVENT_setMenu.new( Global._menus.LOADING ).queue()
	EVENT_loadLevel.new( levelID, target_door ).queue()
	EVENT_wait.new( 0.5 ).queue()
	EVENT_setMenu.new( Global._menus.NONE ).queue()
```

That example comes from my level loading manager, specifically a function which you call to change levels.\
Rather than having `yield` or `await` or anything like that, I can simply call a function that queues in a few events and voila,\
I have myself a sequence of events that transitions to a new level!

Or, how about this:

```gdscript
func on_enter() -> void:
	EVENT_actorSetDisabled.new( Global.node_player, true ).queue()
	# fade from black transition, waits for transition to finish.
	EVENT_fadeOff.new( LevelManager._transitions.DEFAULT ).queue()
	EVENT_queueDialogue.new( "test" ).queue()
```

A simple set of events which triggers on entering a level. You can probably figure out what the events entail by their class names.\
All to say, I've included and iterrated on these scripts turned addon over the years and they've helped me make various projects, and I hope it will help you as well.

## The First Step

After [installation](#how-to-install), you're pretty much set up and ready to get going.\
By default, `LovelyEvent` has a single event queue called the "main" event queue. this queue is what events are sent to by default.

To start out, you can call an event via their Class name, eg.

```gdscript
EVENT_print.new( "example text!" ).queue()
```

This queues an event into the event queue. but there's more than one way to queue an event.\
You can queue an event from `EVENT`, `EventQueue` or even from `LovelyEvent`.

```gdscript
# queueing from EVENT
EVENT_example.new().queue()

# queueing from EventQueue
example_queue.queue( EVENT_example.new() )

# queueing from LovelyEvent
LovelyEvent.queue( EVENT_example.new() )
```

By default, calling queue from `LovelyEvent` or `EVENT` sends the event into the default queue, which is `LovelyEvent.main_queue`.\
To specify which queue to send the event to, it's as simple as: 

```gdscript
# queues into the EventQueue "example_queue"
EVENT_example.new().queue( example_queue )

# or from LovelyEvent:
LovelyEvent.queue( EVENT_example.new(), example_queue )
```

## Using LovelyEvent (The Global Singleton)

If you want to replace the default queue `EVENT`s are put into, you can do so by replacing `LovelyQueue.default_queue_check` like this:

```gdscript
func example_queue_check_replacer( new_event : EVENT ) -> bool:
	if in_dialogue:
		dialogue_queue.queue( new_event )
		return true # has queued event, will NOT queue event in default queue
	# has failed check, sends event to LovelyEvent.main_queue
	return false

LovelyEvent.default_queue_check = example_queue_check_replacer
```

This replaces the default check function (which does nothing) and allows you to interject and have events by default queue into a different `EventQueue`.

Can't find that `EventQueue` you created? have no fear! you can call this to get an `EventQueue` by "ID":

```gdscript
LovelyEvent.get_queue_by_ID( "exampleID" )
```

What about pausing events? simple, set `LovelyEvent.pause` to true!

For some reason need to manually delete a queue? `LovelyEvent.delete_queue()` will get that job done for you.

## Creating and Using a Queue

`EventQueue`s are helpful if you need more than just the main queue. Whenever I create projects, I have two queues. first is the main queue, then is the
Dialogue queue, which runs while the player is in dialogue. Separating the queues into two allows me to pause one queue while dialogue is running and still
be able to execute functions without having to clear or distrupt the main queue. Because of this, I added the functionality of having more than one queue.

Let's start with creating an `EventQueue`. There's Three main types.
1. `EventQueue` - basic event queue, runs events in sequence.
2. `LinkedEventQueue` - this queue works the same as the base `EventQueue`, but is "linked" to a node. Once that node no longer exists, it clears and deletes itself from `LovelyEvent.queue_list`.
3. `TempEventQueue` - this is made specifically for when you need a one-off queue to run a set of events that'll delete itself after finishing all events within itself.

Now, let's create a queue!

```gdscript
var queue_example := EventQueue.new( "exampleID", false, false )
```

And there you have it. simply feed it an `ID` and whether it will run while `LovelyEvent.pause` is true and and if it shouldn't pause its queue while `LovelyEvent.main_queue` is running? set that to true!\
But there's more! Don't want your `EventQueue` to be deleted accidentally via `LovelyEvent.delete_queue`? set `EventQueue.is_essential` to be true!

> [!NOTE]
> when creating a new `EventQueue`, it must have a unique ID! otherwise it *will* overwrite any `EventQueue` of the same name!

What if you want to check if something else is running or should stop an event from running? try out:

```gdscript
# all check functions need to return a bool.
func example_check() -> bool:
	if example_thing == true:
		return false
	return true

example_queue.add_update_check( example_check )
```

Now, before every update, it will run this given function, if it returns true it means it passed the check and can `update()`.

Need to remove the current, or a specific event within the `EventQueue`'s queue? `EventQueue.remove_top_event()` and `EventQueue.remove_specific_event()` has you covered.\
Need the entire queue to be cleared? `EventQueue.clear()` exists for that exact reason!

And, finally. If you want to check if an `EventQueue` is currently running or empty..? you guessed it. `EventQueue.is_running` and `EventQueue.is_empty` are, in fact, a thing.

> [!CAUTION]
> The one thing I ask of you. **DO NOT** call `EventQueue.update()`! This function is automatically called from the global singleton `LovelyEvent` within its process event.
> it does not and should not be called outside of that.

## Events! Events! Events!

The heart of the operation, the thing that makes this all fit together... `EVENT`s.

the default `EVENT` class does nothing on its own, however I've bundled in some general-use example `EVENT`s with the addon! These are perfect for learning the basic structure of an event.
Let's take a peek inside `EVENT_wait`!

```gdscript
extends EVENT
## waits X seconds before continuing queue.
class_name EVENT_wait

var wait_time : float

## waits [time] seconds before continuing queue.
func _init( time : float = 1.0 ) -> void:
	wait_time = time
	super._init()


func execute( _looping : bool, _dt : float ) -> RETURNTYPE:
	wait_time = max( wait_time-_dt, 0 )
	return RETURNTYPE.FINISHED if wait_time == 0 else RETURNTYPE.UNFINISHED

```

This is a simple event that perfectly shows the basic structure of an `EVENT` extending class!\
the `_init()` function sets any input parameters **AND** calls `super._init()`.\
the `execute()` function has an input of
 - `_looping` (whether the event is running more than once.)
 - `_dt` (deltatime)
You might also notice the function returns `RETURNTYPE`! this is essential for any event that it returns the outcome!\
Is it `RETURNTYPE.FINISHED`? or maybe it needs more time to run, in that case it'd be `RETURNTYPE.UNFINISHED`.\
ran into an error? that's what `RETURNTYPE.ERROR` is for! keeping events from never ending when encountering an error.

And that's about it! it's quite a simple plugion/addon, but what it lacks in substance it makes up for in what it can achieve.

## Special Thanks

I'd like to thank my friends in some private dev servers for helping me not just with this iteration, but various past iterations of the same idea that eventually brought the project
here. Without their help I wouldn't have been able to make this.

Extremely special thanks to my friend [TreeMitri](https://github.com/TreeMitri) who helped me develop the most recent iteration and is literally the reason why `EVENT`s are no longer just a single function,
but an entire class with its own ernum return type.

Thanks to anyone who actually read all this! I wish you the best of luck and hope these scripts help your future endeavors!


