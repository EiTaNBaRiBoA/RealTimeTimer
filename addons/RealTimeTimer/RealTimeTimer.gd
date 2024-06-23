class_name RealTimeTimer
signal Timeout()
signal OnUpdateTimer(seconds : float)

var realTimeModel : RealTimeModel = RealTimeModel.new()
var timer : Timer = Timer.new()


func _init(durationInSec : int,interval : bool = false,autoStart : bool = false) -> void:
	_setup(durationInSec,interval)
	call_deferred("_setupUpdateSeconds")
	if not autoStart: pause_timer()
	else: start_timer()


## To Start Or Resume The timer
func start_timer() -> void:
	if is_paused(): 
		_unpause()
		timer.set_paused(false)
		OnUpdateTimer.emit(_remaining_time_sec())
	


## To pause the timer
func pause_timer() -> void:
	if not is_paused(): 
		_pause()
		timer.set_paused(true)
		


## To force complete an interval or the timer
func is_paused() -> bool: return realTimeModel.isPaused

## To check if the timer is intervaling or not
func is_interval() -> bool: return realTimeModel.interval

## To check remaining in Seconds only format
func remaining_time_sec() -> int: return _remaining_time_sec()


## to check remaining in HH:MM:SS format
func remaining_seconds_to_hms():
	var seconds = remaining_time_sec()
	var hours = seconds / 3600
	var minutes = (seconds % 3600) / 60
	var remaining_seconds = seconds % 60
	return "%02d:%02d:%02d" % [hours, minutes, remaining_seconds]


## To force complete the timer or interval of the timer
func finish_timer() -> void:
	_complete()

## To destroy the object
func queue_free() -> void:
		realTimeModel.unreference()
		timer.queue_free()
		unreference()


#region Private Methods

## Updates time elapse
func _updateSeconds() -> void:
	if _remaining_time_sec() <= 0:
		_complete()
	OnUpdateTimer.emit(_remaining_time_sec())

func _setupUpdateSeconds() -> void:
	Engine.get_main_loop().root.add_child(timer)
	timer.one_shot = false
	timer.autostart = true
	timer.set_wait_time(1.0)
	timer.timeout.connect(_updateSeconds)
	timer.start()



## gets time elapsed
func _get_time_elapsed() -> int: 
	return (Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system())
								- realTimeModel.startTimeUnix
								- _pause_duration_sec()) # get current time elapsed including all paused timer


## Call this function to get the Remaining Seconds
func _remaining_time_sec() -> int: 
	var timeRemain = realTimeModel.timerDuration - _get_time_elapsed()
	if timeRemain <= 0 : 
		return 0
	else: return timeRemain  ## return 0 if less than 0 otherwise the remaining



func _setup(durationInSec : int = 0, interval : bool = false) -> void:
	realTimeModel.startTimeUnix = Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system())
	realTimeModel.timerDuration = durationInSec
	realTimeModel.interval = interval


func _pause() -> void:
	realTimeModel.pauseTimeUnix = Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system())
	realTimeModel.isPaused = true


## unpausing adds to the pauseTimeDuration to be later calculated in the pause_duration_sec() for get_time_elapsed()
func _unpause() -> void:
	realTimeModel.isPaused = false
	realTimeModel.pauseTimeDuration += Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system()) - realTimeModel.pauseTimeUnix
	realTimeModel.pauseTimeUnix = 0



func _complete() -> void:
	if not realTimeModel.interval:
		Timeout.emit()
		realTimeModel.unreference()
		timer.queue_free()
		unreference()
	else:
		Timeout.emit()
		realTimeModel.startTimeUnix = Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system())
		realTimeModel.pauseTimeDuration = 0
		realTimeModel.isPaused = false



## Returns the pausing duration in the timer
func _pause_duration_sec() -> int:
	if is_paused():
		return realTimeModel.pauseTimeDuration +  Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system()) - realTimeModel.pauseTimeUnix
	else:
		return realTimeModel.pauseTimeDuration

#endregion
