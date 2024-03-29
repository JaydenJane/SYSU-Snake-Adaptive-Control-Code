-- @param object 要克隆的值
-- @return objectCopy 返回值的副本
--]]
function clone( object )
    local lookup_table = {}
    local function copyObj( object )
        if type( object ) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end

        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs( object ) do
            new_table[copyObj( key )] = copyObj( value )
        end
        return setmetatable( new_table, getmetatable( object ) )
    end
    return copyObj( object )
end

controller = [[
	<group layout="vbox">
		<group layout="hbox">
			<button text="undo" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="124"/>
			<button text="redo" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="125"/>
		</group>
		<group layout="hbox">
			<group layout="vbox">
				<group layout="hbox">
					<label text="8: " style="* {qproperty-alignment: AlignCenter; font-size: 20px}" />
					<spinbox text = '8' minimum="-90" maximum="90" onchange="spinboxChange" style="* {font-size: 20px}" id="8"/>
					<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="28"/>
				</group>
				<group layout="hbox">
					<label text="7: " style="* {qproperty-alignment: AlignCenter; font-size: 20px}" />
					<spinbox text = '7' minimum="-90" maximum="90" onchange="spinboxChange" style="* {font-size: 20px}" id="7"/>
					<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="27"/>
				</group>
				<group layout="hbox">
					<label text="6: " style="* {qproperty-alignment: AlignCenter; font-size: 20px}" />
					<spinbox text = '6' minimum="-90" maximum="90" onchange="spinboxChange" style="* {font-size: 20px}" id="6"/>
					<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="26"/>
				</group>
				<group layout="hbox">
					<label text="5: " style="* {qproperty-alignment: AlignCenter; font-size: 20px}" />
					<spinbox text = '5' minimum="-90" maximum="90" onchange="spinboxChange" style="* {font-size: 20px}" id="5"/>
					<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="25"/>
				</group>
		</group>
		<group layout="vbox">
			<group layout="hbox">
				<label text="4: " style="* {qproperty-alignment: AlignCenter; font-size: 20px}" />
				<spinbox text = '4' minimum="-90" maximum="90" onchange="spinboxChange" style="* {font-size: 20px}" id="4"/>
				<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="24"/>
			</group>
			<group layout="hbox">
				<label text="3: " style="* {qproperty-alignment: AlignCenter; font-size: 20px}" />
				<spinbox text = '3' minimum="-90" maximum="90" onchange="spinboxChange" style="* {font-size: 20px}" id="3"/>
				<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="23"/>
			</group>
			<group layout="hbox">
				<label text="2: " style="* {qproperty-alignment: AlignCenter; font-size: 20px}" />
				<spinbox text = '2' minimum="-90" maximum="90" onchange="spinboxChange" style="* {font-size: 20px}" id="2"/>
				<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="22"/>
			</group>
			<group layout="hbox">
				<label text="1: " style="* {qproperty-alignment: AlignCenter; font-size: 20px}" />
				<spinbox text = '1' minimum="-90" maximum="90" onchange="spinboxChange" style="* {font-size: 20px}" id="1"/>
				<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="21"/>
			</group>
		</group>
	</group>
	</group>
	<group layout="hbox">
		<label text="Residence time( 100 ms ): " style="* {qproperty-alignment: AlignCenter; font-size: 20px}" />
		<spinbox style="* {qproperty-alignment: AlignCenter; font-size: 20px}" minimum="0" maximum="900000" onchange="spinboxChange" id="10"/>
	</group>
	<button text="ALL JOINTS RESET" style="* {font-size: 15px; padding: 5px}" onclick="reset" id="101"/>
]]

function createMainUI()
    -- Create the custom UI for climbing up the poll:
  xml= '<ui title="MainUI" closeable="false" resizeable="true" activate="false">'..[[
    <group>
    <label style="* {font-size: 20px;}" text="Function"/>
    <button text="Create file" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="createFileUI"/>
    <button text="Load file" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="loadFileUI"/>
    </group>
    </ui>
  ]]
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

  xml= [[
  <ui title="Control Panel" closeable="true" resizeable="false" activate="false" onclose="destroyCreatFileUI">
    <group>
      <group layout="hbox">
      	<group layout="vbox">
	      	<group layout="hbox">
		        <label style="* {font-size: 20px;max-width: 100px;}" text="Action: " id="41" />
		        <spinbox text = 'action' minimum="1" maximum="99" onchange="spinboxChange" style="* {font-size: 20px}" id="42"/>
		    </group>
		    <group layout="hbox">
		        <button text="move" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="MoveArm" id="121"/>
		        <button text="stop" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="MoveArm" id="122"/>
		    </group>
	    </group>
        <group layout="vbox">
          <group layout="hbox">
            <button text="confirm" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="120"/>
            <button text="insertAction" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="126"/>
            <button text="deleteAction" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="127"/>
          </group>
          <group layout="hbox">
            <button text="Save" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}"
              onclick="actionSave" id="123"/>
          </group>
        </group>
      </group>
    </group>]] ..controller.. [[
  </ui>
  ]]
  createFileUI_index = simExtCustomUI_create(xml) -- file-creation UI
  simExtCustomUI_setSpinboxValue(createFileUI_index, 42 , currentActionIndex)
  simExtCustomUI_setEnabled(createFileUI_index, 124, false, true) --unable undo button
  simExtCustomUI_setEnabled(createFileUI_index, 125, false, true) --unable redo button
  reset(createFileUI_index)
end

function loadFileUI()
  simExtCustomUI_hide(mainUI_index)
  actionTable = {} --?????????
  actionCount = 0 --???????Action?
  currentActionIndex = 1 --?????actionTable??
  xml= '<ui title="Load File" closeable="true" resizeable="false" activate="false" onclose="destroyLoadFileUI">'..[[
    <group>
      <label style="* {font-size: 20px;}" text="LoadFile"/>
          <group layout="vbox">
        <group layout="hbox">
          <label style="* {font-size: 15px; width: 100px;}" text="OpenFile(.txt)"/>
          <combobox id="41" onchange="selectFile"></combobox>
          <button text="Browser" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="browseFile" id="50"/>
        </group>
        <group layout="hbox">
          <button text="Open" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="openFile" id="51"/>
          <button text="Simulation" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionSimulate" id="52"/>
          <button text="Pause" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionSimulate" id="54"/>
          <button text="Continue" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionSimulate" id="56"/>
          <button text="Stop" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionSimulate" id="55"/>
          <button text="Edit" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="editFileUI" id="53"/>
        </group>
      </group>
    </group>
  </ui>
  ]]
  loadFileUI_index = simExtCustomUI_create(xml)
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
  xml= string.format('<ui title="%s" closeable="true" resizeable="false" activate="false" onclose="destroyEditFileUI">',ReadFile)..[[
    <group>
      <group layout="hbox">
      	<group layout="vbox">
	      	<group layout="hbox">
		        <label style="* {font-size: 20px;max-width: 100px;}" text="Action: " id="41" />
		        <spinbox text = 'action' minimum="1" maximum="99" onchange="spinboxChange" style="* {font-size: 20px}" id="42"/>
		    </group>
		    <group layout="hbox">
		        <button text="move" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="MoveArm" id="121"/>
		        <button text="stop" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="MoveArm" id="122" />
		    </group>
	    </group>
        <group layout="vbox">
          <group layout="hbox">
            <button text="confirm" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="120"/>
            <button text="insertAction" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="126"/>
            <button text="deleteAction" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="127"/>
          </group>
          <group layout="hbox">
            <button text="Save" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}"
              onclick="actionSave" id="123"/>
          </group>
        </group>
      </group>
    </group>]]..controller..[[
  </ui>
  ]]
  editFileUI_index = simExtCustomUI_create(xml) -- file-edit UI
  for i = 1, jointNum, 1 do
    currentJointAngle[i] = actionTable[currentActionIndex][i] --assign the joint angle as the values in current actionTable
    --simSetJointPosition(jointHandle[i], currentJointAngle[i]*math.pi/180)
    simExtCustomUI_setSpinboxValue(editFileUI_index, i, currentJointAngle[i]) --set spinbox value
    simExtCustomUI_setSliderValue(editFileUI_index, i + 20, currentJointAngle[i]) --set slider value
  end
  simExtCustomUI_setSpinboxValue(editFileUI_index,10,actionTable[currentActionIndex][jointNum+1]) --set the residence time
  simExtCustomUI_setSpinboxValue(editFileUI_index, 42 , currentActionIndex)
  ResidenceTime = actionTable[currentActionIndex][jointNum+1]
  simExtCustomUI_setEnabled(editFileUI_index, 124, false, true) --unable undo button
  simExtCustomUI_setEnabled(editFileUI_index, 125, false, true) --unable redo button
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

function spinboxChange(ui, id, newValue) --??spinbox???
  if(id == 10) then
    ResidenceTime = newValue
  elseif(id == 42) then
  	actionHistoryIndex = 1
    actionHistory = {} --clear operation history
    if(newValue > finalActionIndex) then 
    	newValue = finalActionIndex
    	simExtCustomUI_setSpinboxValue(ui, 42 , finalActionIndex)
    end
	currentActionIndex = newValue
	--setValues(actionTable[currentActionIndex])
	for i = 1, jointNum, 1 do
		simExtCustomUI_setSpinboxValue(ui, i, actionTable[currentActionIndex][i]) --关联spinbox的变化
		simExtCustomUI_setSliderValue(ui, i + 20, actionTable[currentActionIndex][i]) --关联slider的变化
	end
	simExtCustomUI_setSpinboxValue(ui,10,actionTable[currentActionIndex][jointNum+1])
	ResidenceTime = actionTable[currentActionIndex][jointNum+1]
	simExtCustomUI_setEnabled(ui,124,false,true)
	simExtCustomUI_setEnabled(ui,125,false,true)
    table.insert(actionHistory, clone(actionTable[currentActionIndex]))
  else
    changedJoint = id --slider的id在1-20之间
    --setValues(newValue, "single", changedJoint)
    simExtCustomUI_setSliderValue(ui, id + 20, newValue) --关联slider的变化
  end
end

function sliderChange(ui, id, newValue) ----??slider???
  changedJoint = id - 20 --slider?id?21-40??
  --setValues(newValue, "single", changedJoint)
  simExtCustomUI_setSpinboxValue(ui, id - 20, newValue) --??spinbox???
end

function setValues(newAngles, changedNum, changedJoint) --??????
  if changedNum == "single" then
    simSetJointPosition(jointHandle[changedJoint], newAngles*math.pi/180)
    currentJointAngle[changedJoint] = newAngles
  else
    for i = 1, jointNum, 1 do
      simSetJointPosition(jointHandle[i], newAngles[i]*math.pi/180)
      currentJointAngle[i] = newAngles[i]
    end
  end
end

function MoveArm(ui)
	-- body
	for i = 1, jointNum , 1 do
		simSetJointPosition(jointHandle[i], simExtCustomUI_getSpinboxValue(ui,i)*math.pi/180)
		currentJointAngle[i] = simExtCustomUI_getSpinboxValue(ui,i)
	end
end

function reset(ui) --???????
  for i = 1, jointNum, 1 do
    currentJointAngle[i] = 0
    simSetJointPosition(jointHandle[i], 0)
    simExtCustomUI_setSpinboxValue(ui, i, 0) --??spinbox???
    simExtCustomUI_setSliderValue(ui, i + 20, 0) --??slider???
  end
end

function actionOperate(ui,id)
  if(id == 120) then --confirm operation
    notChange = true
    for i = 1, jointNum, 1 do
      if actionTable[currentActionIndex][i] ~= simExtCustomUI_getSpinboxValue(ui,i) then
        notChange = false
        break
      end
      if(actionTable[currentActionIndex][jointNum+1] ~= ResidenceTime) then
      	notChange = false
      end
    end
    if notChange == false then
      for i=1, jointNum, 1 do
        actionTable[currentActionIndex][i] = simExtCustomUI_getSpinboxValue(ui,i)
      end
      actionTable[currentActionIndex][jointNum+1] = ResidenceTime --停留时间保留

      local historyChange = false
      for i = 1, jointNum , 1 do
      	if actionHistory[actionHistoryIndex][i] ~= simExtCustomUI_getSpinboxValue(ui,i) then
      		historyChange = true
      		break
      	end
      	if actionHistory[actionHistoryIndex][jointNum+1] ~= ResidenceTime then
      		historyChange = true
      	end
      end

      if historyChange == true then
      	actionHistoryIndex = actionHistoryIndex + 1
      	table.insert(actionHistory, actionHistoryIndex, clone(actionTable[currentActionIndex]))
      	while(table.maxn(actionHistory) > actionHistoryIndex) do
        	table.remove(actionHistory, actionHistoryIndex + 1)
      	end
      end

      if(actionHistoryIndex < #actionHistory and actionHistoryIndex > 1) then
      	simExtCustomUI_setEnabled(ui,125,true,true)
      	simExtCustomUI_setEnabled(ui,124,true,true)
      elseif(actionHistoryIndex == 1) then
      	simExtCustomUI_setEnabled(ui,125,true,true)
      	simExtCustomUI_setEnabled(ui,124,false,true)
      elseif(actionHistoryIndex == #actionHistory) then
      	simExtCustomUI_setEnabled(ui,125,false,true)
      	simExtCustomUI_setEnabled(ui,124,true,true)
      end
      -- for j = 1, table.maxn(actionHistory), 1 do
      --   for i = 1, jointNum + 1, 1 do
      --     print("value" .. i .. " " .. actionHistory[j][i] .. " ")
      --   end
      --   print("\n")
      -- end
    end
  elseif(id == 124) then --undo operation
    simExtCustomUI_setEnabled(ui,125,true,true)
    if(actionHistoryIndex - 1 == 1) then
      simExtCustomUI_setEnabled(ui,124,false,true)
    end
    actionHistoryIndex = actionHistoryIndex - 1
    --setValues(actionHistory[actionHistoryIndex])
    for i = 1, jointNum, 1 do
      simExtCustomUI_setSpinboxValue(ui, i, actionHistory[actionHistoryIndex][i]) --关联spinbox的变化
      simExtCustomUI_setSliderValue(ui, i + 20, actionHistory[actionHistoryIndex][i]) --关联slider的变化
    end
    simExtCustomUI_setSpinboxValue(ui,10,actionHistory[actionHistoryIndex][jointNum+1])
    ResidenceTime = actionTable[currentActionIndex][jointNum+1]
  elseif(id == 125) then --redo operation
    simExtCustomUI_setEnabled(ui,124,true,true)
    if(actionHistoryIndex + 1 == table.maxn(actionHistory)) then
      simExtCustomUI_setEnabled(ui,125,false,true)
    end
    actionHistoryIndex = actionHistoryIndex + 1
    --setValues(actionHistory[actionHistoryIndex])
    for i = 1, jointNum, 1 do
      simExtCustomUI_setSpinboxValue(ui, i, actionHistory[actionHistoryIndex][i]) --关联spinbox的变化
      simExtCustomUI_setSliderValue(ui, i + 20, actionHistory[actionHistoryIndex][i]) --关联slider的变化
    end
    simExtCustomUI_setSpinboxValue(ui,10,actionHistory[actionHistoryIndex][jointNum+1])
    ResidenceTime = actionTable[currentActionIndex][jointNum+1]
  elseif(id == 126) then --insertAction operation
  	actionHistoryIndex = 1
	actionHistory = {} --clear operation history
	actionCount = actionCount + 1
	newAction = {0, 0, 0, 0, 0, 0, 0, 0, 0}
	table.insert(actionHistory, actionHistoryIndex, clone(newAction))
	currentActionIndex = currentActionIndex + 1
	finalActionIndex = finalActionIndex + 1
	table.insert(actionTable, currentActionIndex, newAction)
	--setValues(newAction)
    for i = 1, jointNum, 1 do
      simExtCustomUI_setSpinboxValue(ui, i, actionTable[currentActionIndex][i]) --关联spinbox的变化
      simExtCustomUI_setSliderValue(ui, i + 20, actionTable[currentActionIndex][i]) --关联slider的变化
    end
    simExtCustomUI_setSpinboxValue(ui,10,actionTable[currentActionIndex][jointNum+1])
    ResidenceTime = actionTable[currentActionIndex][jointNum+1]
    simExtCustomUI_setEnabled(ui,124,false,true)
    simExtCustomUI_setEnabled(ui,125,false,true)
   elseif(id == 127) then --deleteAction operation
   	table.remove(actionTable, currentActionIndex)
   	if(currentActionIndex > 1) then 
   		currentActionIndex = currentActionIndex - 1
   	end
   	finalActionIndex = finalActionIndex - 1
   	for i = 1, jointNum, 1 do
   		simExtCustomUI_setSpinboxValue(ui, i, actionTable[currentActionIndex][i]) --关联spinbox的变化
   		simExtCustomUI_setSliderValue(ui, i + 20, actionTable[currentActionIndex][i]) --关联slider的变化
    end
    simExtCustomUI_setEnabled(ui,124,false,true)
    simExtCustomUI_setEnabled(ui,125,false,true)
  end
  --output the actionTable buffer
  --for i=1, currentActionIndex, 1 do
  --  local s = ""
  --  for j=1, jointNum, 1 do
  --    s = s.." "
  --    s = s..actionTable[i][j]
  --  end
  --  print(s.."\nResidenceTime:"..actionTable[i][jointNum+1])
  --end
  --print("-------------------------------")

  --simExtCustomUI_setLabelText(ui,41,"Action: "..tostring(currentActionIndex))
  simExtCustomUI_setSpinboxValue(ui, 42 , currentActionIndex)
end

function actionSave()
    -- body
  if PATH == "" then
    PATH = simFileDialog(sim_filedlg_type_save,"SAVE","","","text file","txt")
  end
  print(PATH)
  if PATH ~= nil then
      file = io.open(PATH, "w")
    for i=1, actionCount, 1 do
      local s = ""
      for j=1, jointNum, 1 do
        s = s..actionTable[i][j]
        s = s.." "
      end
      s = s..actionTable[i][jointNum+1].."\n"
      file:write(s)
    end
    io.close(file)
    print("SAVE SUCCESS!")
  else
    print("SAVE Failed!")
  end
end

function actionRead(ReadFile)
  print(ReadFile)
  actionCount = 0
  fileContents = ""
  for line in io.lines(ReadFile) do
    actionCount = actionCount + 1
    actionTable[actionCount] = {}
    for w in string.gmatch(line, "%S+") do --读入数据
      table.insert(actionTable[actionCount],tonumber(w))
    end
    fileContents = fileContents..line.."\n"
  end
end

function browseFile()
    -- body
    if(histroyFile ~= nil) then
      PATH=simFileDialog(sim_filedlg_type_load,"Search",histroyFile,"","text file","txt")
    else
      PATH=simFileDialog(sim_filedlg_type_load,"Search","","","text file","txt")
    end
    if(PATH ~= nil) then
      histroyFile = PATH
      file = io.open("histroyPath.txt", "w")
      file:write(histroyFile)
      io.close()
      simExtCustomUI_insertComboboxItem(loadFileUI_index,41,0,PATH) -- insert in the first position
      simExtCustomUI_removeComboboxItem(loadFileUI_index,41,1)
    else
    print("Cancel!")
  end
  simExtCustomUI_setEnabled(loadFileUI_index, 53, false, true)
  simExtCustomUI_setEnabled(loadFileUI_index, 52, false, true)
  if simExtCustomUI_getComboboxItemCount(loadFileUI_index, 41) ~= 0 then
    simExtCustomUI_setEnabled(loadFileUI_index, 51, true, true)
  end
end

function openFile()
  ReadFile = simExtCustomUI_getComboboxItemText(loadFileUI_index,41,0) -- default reading
  actionRead(ReadFile)
  xml='<ui title="Scan File" closeable="true" resizeable="false" activate="false">'..[[
    <group layout="vbox">
      <label enabled="true" style="* {min-width: 360px; height: 500px}" id="128" />
    </group>
  </ui>
  ]]
  scanFileUI_index = simExtCustomUI_create(xml)
  if checkDataFormat() then
    labelContents = fileContents .. "\n Data format Correct!"
  else
    labelContents = fileContents .. "\n Data format Error!"
  end
  simExtCustomUI_setLabelText(scanFileUI_index, 128, labelContents, true)
end

function selectFile(ui, id, selected)
  ReadFile = simExtCustomUI_getComboboxItemText(loadFileUI_index,41,selected)
  PATH = ReadFile
  actionRead(ReadFile)
end

function actionSimulate(ui,id)
    -- body
  if(id == 52) then
    currentActionIndex = 1
    for i = 1, jointNum, 1 do
      currentJointAngle[i] = 0
      simSetJointPosition(jointHandle[i], 0)
    end
    actionSim = true
    simStartSimulation()
    simExtCustomUI_setEnabled(loadFileUI_index, 56, false, true)
    simExtCustomUI_setEnabled(loadFileUI_index, 54, true, true)
  elseif(id == 54) then
    actionSim = false
    simPauseSimulation()
    simExtCustomUI_setEnabled(loadFileUI_index, 54, false, true)
    simExtCustomUI_setEnabled(loadFileUI_index, 56, true, true)
  elseif(id == 56) then
    actionSim = true
    simStartSimulation()
    simExtCustomUI_setEnabled(loadFileUI_index, 56, false, true)
    simExtCustomUI_setEnabled(loadFileUI_index, 54, true, true)
  elseif(id == 55) then
    for i = 1, jointNum, 1 do
      currentJointAngle[i] = 0
      simSetJointPosition(jointHandle[i], 0)
    end
    simExtCustomUI_setEnabled(loadFileUI_index, 54, false, true)
    simExtCustomUI_setEnabled(loadFileUI_index, 56, false, true)
    currentActionIndex = 1
    actionSim = false
  end
end

function checkDataFormat()
  simExtCustomUI_setEnabled(loadFileUI_index, 53, false, true)
  simExtCustomUI_setEnabled(loadFileUI_index, 52, false, true)
  currentLine = 1
  nextLine = 1
  while nextLine ~= nil do
    nextLine = string.find(fileContents, "\n", currentLine)
    if nextLine == nil then
      break
    end
    --print("nextLine: ", nextLine)
    subs = string.sub(fileContents, currentLine, nextLine)
    --print("subs: ", subs)
    dataCnt = 0
    for value in string.gmatch(subs, "%S+") do --check what?
      if tonumber(value) < -90 and tonumber(value) > 90 and datacnt < 8 then
        print("Data overflow error!")
        return false
      end
      dataCnt = dataCnt + 1
    end
    --print("dataCnt: ", dataCnt)
    if dataCnt ~= 9 and dataCnt ~= 0 then
      print("Data format error!")
      return false
    end
    currentLine = nextLine + 1
    --print("currentLine: ", currentLine)
  end
  print("Data format correct!")
  simExtCustomUI_setEnabled(loadFileUI_index, 53, true, true)
  simExtCustomUI_setEnabled(loadFileUI_index, 52, true, true)
  return true
end

if (sim_call_type==sim_childscriptcall_initialization) then
  createFileUI_index = 0 --file-creation UI id
  loadFileUI_index = 0 --file-load UI id
  editFileUI_index = 0 --file-edit UI id
  scanFileUI_index = 0 --file-scan UI id
  jointNum = 8
  histroy = io.open("histroyPath.txt","a+")
  io.input(histroy)
  histroyFile = io.read()
  io.close(histroy)
  print(histroyFile)

  currentJointAngle = {} --????????????
  finalActionIndex = currentActionIndex --??????actionTable???
  currentActionIndex = 1 --??????actionTable???
  actionTable = {} --actionTable stores all action
  actionHistory = {} --actionHistory stores temporary operation history in each step
  actionHistoryIndex = 1
  actionCount = 0 --count actionTable quantity
  ResidenceTime = 0; --waiting time
  PATH = "" --?????
  mainUI_index = simExtCustomUI_create(createMainUI()) -- creat User Interface

  jointHandle={} --???????handle
  for i = 1, jointNum, 1 do
    jointHandle[i] = simGetObjectHandle('joint'..(i)) -- robot arm
  end

    actionStartTime = 0
    actionDuration = 0
    isPerformingAction = false

  Joints_handle={-1,-1,-1,-1, -1,-1,-1,-1}

    for i=1,8,1 do
        Joints_handle[i]=simGetObjectHandle('joint'..(i)) -- robot arm
    end

-- Check if the required RosInterface is there:
    moduleName=0
    index=0
    rosInterfacePresent=false
    messageDeliver = true
    while moduleName do
        moduleName=simGetModuleName(index)
        if (moduleName=='RosInterface') then
            rosInterfacePresent=true
        end
        index=index+1
    end

    -- Prepare the float32 publisher and subscriber (we subscribe to the topic we advertise):
    if rosInterfacePresent then
        publisher=simExtRosInterface_advertise('/all_joint_position','std_msgs/Int32MultiArray')
        subscriber=simExtRosInterface_subscribe('/sonar', 'std_msgs/Float32', 'sonarMessage_cb')
        joy_sub = simExtRosInterface_subscribe('/joy', 'sensor_msgs/Joy', 'joy_cb')
    end
end


if (sim_call_type==sim_childscriptcall_actuation) then --???????????????
     if isPerformingAction then
        if (simGetSimulationTime () - actionStartTime)*10 > actionDuration then
            isPerformingAction = false
        end

     end

     if not isPerformingAction then
        if actionSim then
            joint_command = actionTable[currentActionIndex]
            currentActionIndex = currentActionIndex + 1
            if currentActionIndex > actionCount then
                currentActionIndex = actionCount
                actionSim = false
            end
            setValues(joint_command)
            actionStartTime = simGetSimulationTime ()
            actionDuration = joint_command[jointNum+1]
            isPerformingAction = true
            joint_position = {0, 0, 0, 0, 0, 0, 0, 0}
            ceil = {0, 0, 0, 0, 0, 0, 0, 0}
            -- get current position
            for i=1,jointNum,1 do
                joint_position[i] = simGetJointPosition(Joints_handle[i])*180/math.pi+90
                joint_position[i],ceil[i] = math.modf(joint_position[i])
            end
            -- publish joint positions
            if rosInterfacePresent then
            	if messageDeliver then
                	simExtRosInterface_publish(publisher,{data=joint_position})
                end
            end
    --delay(2000)
        end
    end
end


if (sim_call_type==sim_childscriptcall_sensing) then

    -- Put your main SENSING code here

end


if (sim_call_type==sim_childscriptcall_cleanup) then

    -- Following not really needed in a simulation script (i.e. automatically shut down at simulation end):

-- 	Following not really needed in a simulation script (i.e. automatically shut down at simulation end):
    if rosInterfacePresent then
        simExtRosInterface_shutdownPublisher(publisher)
        simExtRosInterface_shutdownSubscriber(subscriber)
    end

end