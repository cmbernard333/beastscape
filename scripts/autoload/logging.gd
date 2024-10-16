# Logger

###
## Logger singleton that allows anywhere in the code to log
## 1 - ERROR - something really bad happened and we need to know
## 2 - WARNING - something unusual happened, but not fatal
## 3 - INFO - general logging - try NOT to log every frame
## 4 - DEBUG - probably log most frames
## 5 - TRACE - log every frame
###

extends Node

@export var log_level: int = 1

func log_print(level: int, input_string: String, args: Array):
	if log_level >= level:
		print(input_string % args)
