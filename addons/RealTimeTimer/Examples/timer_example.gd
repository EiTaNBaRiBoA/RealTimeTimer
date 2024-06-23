extends Node2D

var realTimeTimer : RealTimeTimer = null


## For testing on the Inspector when pausing the timer
@export var pauseTimer : bool = true
##Intervaling the timer
var Interval : bool = true

func _ready() -> void:
	realTimeTimer = RealTimeTimer.new(5,Interval,!pauseTimer)
	realTimeTimer.Timeout.connect(OnComplete)
	realTimeTimer.OnUpdateTimer.connect(PrintSeconds)
	pauseTimer = false
	#realTimeTimer.start_timer() to start the timer
	#realTimeTimer.pause_timer() to pause the timer
	#realTimeTimer.is_paused() to check if the timer is paused
	#realTimeTimer.finish_timer() to force complete an interval or the timer
	#realTimeTimer.is_interval() to check if the timer is intervaling or not
	#realTimeTimer.queue_free() to queue free the timer
	#realTimeTimer.remining_seconds_to_hms() to check remaining in HH:MM:SS format
	#realTimeTimer.remaining_time_sec() to check remaining in Seconds only


func _process(delta: float) -> void:
	if realTimeTimer:
		if pauseTimer:
			realTimeTimer.pause_timer()
		elif realTimeTimer.is_paused():
			realTimeTimer.start_timer()


## called from OnUpdateTimer Signal
func PrintSeconds(seconds : float) -> void:
	print(realTimeTimer.remaining_seconds_to_hms())
	print(realTimeTimer.remaining_time_sec())



## called from Timeout Signal
func OnComplete() -> void:
	if not realTimeTimer.is_interval(): 
		print("After this Signal realTimeTimer will be freed from memory and becomes null")
	else: 
		print("Completed an interval")
	
