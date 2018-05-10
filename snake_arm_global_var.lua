createFileUI_index = 0 --file-creation UI id
loadFileUI_index = 0 --file-load UI id
editFileUI_index = 0 --file-edit UI id
scanFileUI_index = 0 --file-scan UI id
stateFileUI_index = 0 --file-state UI id
jointNum = 8

currentActionIndex = 1 --??????actionTable???
  currentJointAngle = {} --????????????
  finalActionIndex = currentActionIndex --??????actionTable???
  
  actionTable = {} --actionTable stores all action
  actionHistory = {} --actionHistory stores temporary operation history in each step
  actionHistoryIndex = 1
  actionCount = 0 --count actionTable quantity
  ResidenceTime = 0; --waiting time
  PATH = "" --?????
	mainUI_index = 0
	jointHandle={} --???????handle
	
	
	 actionStartTime = 0
    actionDuration = 0
    isPerformingAction = false

  Joints_handle={-1,-1,-1,-1, -1,-1,-1,-1}
	
	    rosInterfacePresent=false
    messageDeliver = true
		publisher = 0
		publisher2 = 0
    subscriber =0
joy_sub = 0