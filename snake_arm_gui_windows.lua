require('snake_arm_global_var')
main_window_xml = '<ui title="MainUI" closeable="false" resizeable="true" activate="false">'.. 
		main_window_render .. "</ui>"

action_edit_from_createFile_xml = '<ui title="Control Panel" closeable="true" resizeable="false"' ..
'activate="false" onclose="destroyCreatFileUI">' .. action_edit_render .. "</ui>" 

load_file_xml= '<ui title="Load File" closeable="true" resizeable="false"'..
  'activate="false" onclose="destroyLoadFileUI">'.. load_file_window_render .. '</ui>'

state_file_xml ='<ui title="Load File" closeable="true" resizeable="false " position="-50,50" placement="relative" '..
  'activate="false" onclose="destroyLoadFileUI">'.. state_file_window_render .. '</ui>'
	
function action_edit_from_loadFile_xml(filename)
	xml= string.format('<ui title="%s" closeable="true" resizeable="false" '..
'	activate="false" onclose="destroyEditFileUI">', filename) .. action_edit_render .. "</ui>" 
	
	return xml
end


function createFileUI()
  simExtCustomUI_hide(mainUI_index)
  currentActionIndex = 1 --??????actionTable???
  actionCount = 1
  finalActionIndex = actionCount
  actionTable = {} --??actionTable???????????
  actionTable[currentActionIndex] = {}
  ResidenceTime = 0; --waiting time
  PATH = ""
  for i = 1, jointNum+1, 1 do
    actionTable[currentActionIndex][i] = 0 --?????????{0,0,...,0}
  end
  actionHistoryIndex = 1
  actionHistory = {} --clear operation history
  table.insert(actionHistory, actionHistoryIndex, clone(actionTable[currentActionIndex]))

  createFileUI_index = simExtCustomUI_create(action_edit_from_createFile_xml) -- file-creation UI
  simExtCustomUI_setSpinboxValue(createFileUI_index, 42 , currentActionIndex)
  reset(createFileUI_index)
end


function loadFileUI()
  simExtCustomUI_hide(mainUI_index)
  actionTable = {} --?????????
  actionCount = 0 --???????Action?
  currentActionIndex = 1 --?????actionTable??
 
  loadFileUI_index = simExtCustomUI_create(load_file_xml)
  simExtCustomUI_setComboboxItems(loadFileUI_index, 41, {}, 0, true)
  if simExtCustomUI_getComboboxItemCount(loadFileUI_index, 41) == 0 then
    simExtCustomUI_setEnabled(loadFileUI_index, 51, false, true)
    simExtCustomUI_setEnabled(loadFileUI_index, 53, false, true)
    simExtCustomUI_setEnabled(loadFileUI_index, 52, false, true)
    simExtCustomUI_setEnabled(loadFileUI_index, 54, false, true)
    simExtCustomUI_setEnabled(loadFileUI_index, 56, false, true)
  end
end


function editFileUI()
  if PATH == nil then
    return
  end
  --stop simulaition
  for i = 1, jointNum, 1 do
  	currentJointAngle[i] = 0
	simSetJointPosition(jointHandle[i], 0)
  end
  currentActionIndex = 1
  actionSim = false

  actionRead(PATH)
  simExtCustomUI_hide(loadFileUI_index)
  currentActionIndex = actionCount --current actionTable index
  finalActionIndex = actionCount --final actionTable index
  actionHistoryIndex = 1
  actionHistory = {} --clear operation history
  table.insert(actionHistory, clone(actionTable[currentActionIndex]))
  editFileUI_index = simExtCustomUI_create(action_edit_from_loadFile_xml(ReadFile)) -- file-edit UI
  for i = 1, jointNum, 1 do
    currentJointAngle[i] = actionTable[currentActionIndex][i] --assign the joint angle as the values in current actionTable
    --simSetJointPosition(jointHandle[i], currentJointAngle[i]*math.pi/180)
    simExtCustomUI_setSpinboxValue(editFileUI_index, i, currentJointAngle[i]) --set spinbox value
    simExtCustomUI_setSliderValue(editFileUI_index, i + 20, currentJointAngle[i]) --set slider value
  end
  simExtCustomUI_setSpinboxValue(editFileUI_index,10,actionTable[currentActionIndex][jointNum+1]) --set the residence time
  simExtCustomUI_setSpinboxValue(editFileUI_index, 42 , currentActionIndex)
  ResidenceTime = actionTable[currentActionIndex][jointNum+1]
end

function destroyCreatFileUI()
    -- body
  reset(createFileUI_index)
  simExtCustomUI_destroy(createFileUI_index)
  simExtCustomUI_show(mainUI_index)
end

function destroyLoadFileUI()
    -- body
  simExtCustomUI_destroy(loadFileUI_index)
  simExtCustomUI_show(mainUI_index)
end

function destroyEditFileUI()
  reset(editFileUI_index)
  simExtCustomUI_destroy(editFileUI_index)
  simExtCustomUI_show(loadFileUI_index)
end
