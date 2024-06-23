# RealTimeTimer - A Godot Timer Utility

This Godot tool provides a `RealTimeTimer` class for managing timers in your projects. It offers features like pausing, resuming, interval timers, and retrieving the remaining time.

## Features

- **Pause and Resume:** Easily pause and resume the timer whenever needed.
- **Interval Timers:** Set up timers that repeat at specified intervals.
- **Time Tracking:** Retrieve the remaining time in seconds or formatted as HH:MM:SS.
- **Signals:** Receive notifications on timeout and timer updates.
- **Easy Integration:** Simple to use and integrate into your Godot projects.

## Installation

1. **Clone the repository:**  Clone or download the RealTimeTimer project from GitHub.
2. **Copy to your project:** Copy the `addons/RealTimeTimer` folder from the cloned repository into the `addons` folder of your Godot project. If your project doesn't have an `addons` folder, create one.
3. **Instantiate RealTimeTimer:** In your Godot scenes or scripts, create a new instance of the `RealTimeTimer` class. 
4. **Learn from Example:**  Refer to the provided `time_example.gd` script in the `addons/RealTimeTimer` folder for a demonstration of how to use the `RealTimeTimer` class.

## Usage

```gdscript
extends Node2D

# Declare a RealTimeTimer variable
var realTimeTimer: RealTimeTimer = null

func _ready() -> void:
	# Create a new RealTimeTimer with a duration of 5 seconds, 
	# interval enabled, and auto-start enabled.
	realTimeTimer = RealTimeTimer.new(5, true, true)

	# Connect to signals to handle timer events
	realTimeTimer.Timeout.connect(OnComplete)
	realTimeTimer.OnUpdateTimer.connect(PrintSeconds)

# Signal handler for timer completion
func OnComplete() -> void:
	if not realTimeTimer.is_interval(): 
		print("Timer completed. RealTimeTimer will be freed from memory.")
	else: 
		print("Interval completed.")

# Signal handler for timer updates (every second)
func PrintSeconds(seconds: float) -> void:
	print("Remaining time:", realTimeTimer.remining_seconds_to_hms())

# Start the timer (if not auto-started)
# realTimeTimer.start_timer() 

# Pause the timer
# realTimeTimer.pause_timer()

# Check if the timer is paused
# realTimeTimer.is_paused() 

# Force complete an interval or the timer
# realTimeTimer.finish_timer()

# Check if the timer is interval-based
# realTimeTimer.is_interval()

# Free the timer from memory
# realTimeTimer.queue_free() 
```

## Methods

- `start_timer()`: Starts or resumes the timer.
- `pause_timer()`: Pauses the timer.
- `is_paused()`: Returns `true` if the timer is paused, `false` otherwise.
- `is_interval()`: Returns `true` if the timer is set to interval mode, `false` otherwise.
- `remaining_time_sec()`: Returns the remaining time in seconds as an integer.
- `remining_seconds_to_hms()`: Returns the remaining time formatted as HH:MM:SS.
- `finish_timer()`: Forces the timer to complete, triggering the timeout signal.
- `queue_free()`: Frees the timer from memory.

## Signals

- `Timeout()`: Emitted when the timer completes, either a single run or an interval.
- `OnUpdateTimer(seconds: float)`: Emitted every second, providing the remaining time in seconds.

## Examples

### Simple Countdown Timer

```gdscript
var timer = RealTimeTimer.new(10)
timer.Timeout.connect(func(): print("Time's up!"))
timer.start_timer()
```

### Interval Timer

```gdscript
var timer = RealTimeTimer.new(2, true)
timer.Timeout.connect(func(): print("Interval elapsed!"))
timer.start_timer()
```
## License
This asset is provided under the [MIT License](LICENSE).
