extends Label

var time : float
var msec : int
var min : int
var sec: int
var FinalTime : String

func _process(delta):
	time += delta
	msec = fmod(time,1)*100
	sec = fmod(time, 60)
	min = fmod(time, 3600) / 60
	text = str( "%02d" % min,":", "%02d" % sec,":","%03d"%msec)

func stop():
	FinalTime = str( "%02d" % min,":", "%02d" % sec,":","%03d"%msec)
	set_process(false)	
