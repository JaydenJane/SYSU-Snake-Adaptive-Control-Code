controller = [[
	<group>
		<label style="* {font-size: 20px;}" text="Robot controller"/>
		<group layout="hbox">
			<group>
				<group layout="hbox">
					<label text="Joint_8: " style="* {qproperty-alignment: AlignCenter}" />
					<spinbox text = '8' minimum="-90" maximum="90" onchange="spinboxChange" id="8"/>
					<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="28"/>
				</group>
				<group layout="hbox">
					<label text="Joint_7: " style="* {qproperty-alignment: AlignCenter}" />
					<spinbox text = '7' minimum="-90" maximum="90" onchange="spinboxChange" id="7"/>
					<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="27"/>
				</group>
				<group layout="hbox">
					<label text="Joint_6: " style="* {qproperty-alignment: AlignCenter}" />
					<spinbox text = '6' minimum="-90" maximum="90" onchange="spinboxChange" id="6"/>
					<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="26"/>
				</group>
				<group layout="hbox">
					<label text="Joint_5: " style="* {qproperty-alignment: AlignCenter}" />
					<spinbox text = '5' minimum="-90" maximum="90" onchange="spinboxChange" id="5"/>
					<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="25"/>
				</group>
			</group>
			<group>
				<group layout="hbox">
					<label text="Joint_4: " style="* {qproperty-alignment: AlignCenter}" />
					<spinbox text = '4' minimum="-90" maximum="90" onchange="spinboxChange" id="4"/> 
					<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="24"/>
				</group>
				<group layout="hbox">
					<label text="Joint_3: " style="* {qproperty-alignment: AlignCenter}" />
					<spinbox text = '3' minimum="-90" maximum="90" onchange="spinboxChange" id="3"/>
					<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="23"/>
				</group>
				<group layout="hbox">
					<label text="Joint_2: " style="* {qproperty-alignment: AlignCenter}" />
					<spinbox text = '2' minimum="-90" maximum="90" onchange="spinboxChange" id="2"/> 
					<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="22"/>
				</group>
				<group layout="hbox">
					<label text="Joint_1: " style="* {qproperty-alignment: AlignCenter}" />
					<spinbox text = '1' minimum="-90" maximum="90" onchange="spinboxChange" id="1"/>
					<hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="21"/>
				</group>
			</group>
		</group>
		<group layout="hbox">
			<label text="Residence time( 100 ms ): " style="* {qproperty-alignment: AlignCenter; font-size: 20px}" />
			<spinbox style="* {qproperty-alignment: AlignCenter; font-size: 20px}" text = '0' minimum="0" maximum="900000" onchange="spinboxChange" id="10"/>
		</group>
		<button text="ALL JOINTS RESET" style="* {font-size: 15px; padding: 5px}" onclick="reset" id="101"/>
	</group>
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
	currentActionIndex = 1 --??????action???
	action = {} --??action???????????
	action[currentActionIndex] = {}
	ResidenceTime = 0; --停留时间
	PATH = ""
	for i = 1, jointNum+1, 1 do
		action[currentActionIndex][i] = 0 --?????????{0,0,...,0}
	end
	xml= [[
	<ui title="Control Panel" closeable="true" resizeable="false" activate="false" onclose="destroyCreatFileUI">
		<group>
			<label style="* {font-size: 25px;}" text="Actions Design"/>
			<group layout="hbox">
				<label style="* {font-size: 20px; max-width: 100px}" text="Action: 1" id="41"/>
				<group layout="vbox">
					<group layout="hbox">
						<button text="Confirm" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="120"/>
						<button text="Undo" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="121"/>
						<button text="Redo" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="122"/>
					</group>
					<button text="Save" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionSave" id="123"/>
				</group>
			</group>
		</group>]] ..controller.. [[
	</ui>
	]]
	createFileUI_index = simExtCustomUI_create(xml) -- file-creation UI
	simExtCustomUI_setEnabled(createFileUI_index, 121, false, true)
	simExtCustomUI_setEnabled(createFileUI_index, 122, false, true)
	reset(createFileUI_index)
end

function loadFileUI()
	simExtCustomUI_hide(mainUI_index)
	action = {} --?????????
	actionCount = 0 --???????Action?
	currentActionIndex = 1 --?????action??
	xml= '<ui title="Load File" closeable="true" resizeable="false" activate="false" onclose="destroyLoadFileUI">'..[[
		<group>
			<label style="* {font-size: 20px;}" text="LoadFile"/>
	        <group layout="vbox">
				<group layout="hbox">
					<label style="* {font-size: 15px; width: 100px;}" text="OpenFile(.txt)"/>
					<combobox id="41" onchange="selectFile"></combobox>
					<button text="Browser" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="browseFile" id="124"/>
				</group>
				<group layout="hbox">
					<button text="Open" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="openFile" id="127"/>
					<button text="Simulation" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionSimulate" id="125"/>
					<button text="Edit" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="editFileUI" id="126"/>
				</group>
			</group>
		</group>
	</ui>
	]]
	loadFileUI_index = simExtCustomUI_create(xml)
	simExtCustomUI_setComboboxItems(loadFileUI_index, 41, loadFilehistory, 0, true)
	if simExtCustomUI_getComboboxItemCount(loadFileUI_index, 41) == 0 then
		simExtCustomUI_setEnabled(loadFileUI_index, 127, false, true)
		simExtCustomUI_setEnabled(loadFileUI_index, 126, false, true)
		simExtCustomUI_setEnabled(loadFileUI_index, 125, false, true)
	end
end

function editFileUI()
	if PATH == nil then
		return
	end
	actionRead(PATH)
	simExtCustomUI_hide(loadFileUI_index)
	currentActionIndex = actionCount --??????action???
	finalActionIndex = actionCount
	xml= string.format('<ui title="%s" closeable="true" resizeable="false" activate="false" onclose="destroyEditFileUI">',ReadFile)..[[
		<group>
			<label style="* {font-size: 20px;}" text="Operation"/>
			<group layout="hbox">]]..
				string.format('<label style="* {font-size: 20px;max-width: 100px;}" text="Action: %d" id="41" />', actionCount)..[[
				<group layout="vbox">
					<group layout="hbox">
						<button text="Confirm" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="120"/>
						<button text="Undo" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="121"/>
						<button text="Redo" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="122"/>
					</group>
					<button text="Save" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionSave" id="123"/>
				</group>
			</group>
		</group>]]..controller..[[
	</ui>
	]]
	editFileUI_index = simExtCustomUI_create(xml) -- file-edit UI
	for i = 1, jointNum, 1 do
		currentJointAngle[i] = action[currentActionIndex][i]
		simSetJointPosition(jointHandle[i], currentJointAngle[i]*math.pi/180)
		simExtCustomUI_setSpinboxValue(editFileUI_index, i, currentJointAngle[i]) --??spinbox???
		simExtCustomUI_setSliderValue(editFileUI_index, i + 20, currentJointAngle[i]) --??slider???
	end
	simExtCustomUI_setSpinboxValue(editFileUI_index,10,action[currentActionIndex][jointNum+1])
	simExtCustomUI_setEnabled(editFileUI_index, 121, true, true)
	simExtCustomUI_setEnabled(editFileUI_index, 122, false, true)
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
	else			
		changedJoint = id --slider的id在1-20之间
	    setValues(newValue, "single", changedJoint)
		simExtCustomUI_setSliderValue(ui, id + 20, newValue) --关联slider的变化
	end
end

function sliderChange(ui, id, newValue) ----??slider???
	changedJoint = id - 20 --slider?id?21-40??
    setValues(newValue, "single", changedJoint)
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
			if action[currentActionIndex][i] ~= currentJointAngle[i] then
				notChange = false
				break
			end
		end
		if notChange == false then
			currentActionIndex = currentActionIndex + 1
			action[currentActionIndex] = {}
			for i=1, jointNum, 1 do
				action[currentActionIndex][i] = currentJointAngle[i]
			end
			action[currentActionIndex][jointNum+1] = ResidenceTime --停留时间保留
			finalActionIndex = currentActionIndex
		end
		if(currentActionIndex > 1) then
			simExtCustomUI_setEnabled(ui,121,true,true)
		else
			simExtCustomUI_setEnabled(ui,121,false,true)
		end
    elseif(id == 121) then --undo operation
		if(currentActionIndex > 1) then
			simExtCustomUI_setEnabled(ui,121,true,true)
			simExtCustomUI_setEnabled(ui,122,true,true)
			currentActionIndex = currentActionIndex - 1
			setValues(action[currentActionIndex])
			for i = 1, jointNum, 1 do
				simExtCustomUI_setSpinboxValue(ui, i, action[currentActionIndex][i]) --关联spinbox的变化
				simExtCustomUI_setSliderValue(ui, i + 20, action[currentActionIndex][i]) --关联slider的变化
			end
			simExtCustomUI_setSpinboxValue(ui,10,action[currentActionIndex][jointNum+1])
		end
		if(currentActionIndex == 1) then
			simExtCustomUI_setEnabled(ui,121,false,true)
		end
    elseif(id == 122) then --redo operation
		if currentActionIndex < finalActionIndex then
			simExtCustomUI_setEnabled(ui,121,true,true)
			simExtCustomUI_setEnabled(ui,122,true,true)
			currentActionIndex = currentActionIndex + 1
			setValues(action[currentActionIndex])
			for i = 1, jointNum, 1 do
				simExtCustomUI_setSpinboxValue(ui, i, action[currentActionIndex][i]) --关联spinbox的变化
				simExtCustomUI_setSliderValue(ui, i + 20, action[currentActionIndex][i]) --关联slider的变化
			end
			simExtCustomUI_setSpinboxValue(ui,10,action[currentActionIndex][jointNum+1])
		end
		if currentActionIndex == finalActionIndex then
			simExtCustomUI_setEnabled(ui,122,false,true)
		end
    end
	
	--输出缓存区信息
	for i=1, currentActionIndex, 1 do
		local s = ""
		for j=1, jointNum, 1 do
			s = s.." "
			s = s..action[i][j]
		end
		print(s.."\nResidenceTime:"..action[i][jointNum+1])
	end
	print("-------------------------------")
	
    simExtCustomUI_setLabelText(ui,41,"Action: "..tostring(currentActionIndex))
end

function actionSave()
    -- body
	if PATH == "" then
		PATH = simFileDialog(sim_filedlg_type_save,"SAVE","","","text file","txt")
	end
	print(PATH)
	print("currentActionIndex", currentActionIndex)
	if PATH ~= nil then
	    file = io.open(PATH, "w")
		for i=1, currentActionIndex, 1 do
			local s = ""
			for j=1, jointNum, 1 do
				s = s..action[i][j]
				s = s.." "
			end
			s = s..action[i][jointNum+1].."\n"
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
		action[actionCount] = {}
		for w in string.gmatch(line, "%S+") do --读入数据
			table.insert(action[actionCount],tonumber(w))
		end
		fileContents = fileContents..line.."\n"
	end
	if checkDataFormat() == false then
		openFile()
	end
end

function browseFile()
    -- body
    PATH=simFileDialog(sim_filedlg_type_load,"Search","","","text file","txt")
	loadFilehistory[loadFileNum] = PATH
    loadFileNum = loadFileNum + 1
    if(PATH ~= nil) then
        simExtCustomUI_insertComboboxItem(loadFileUI_index,41,0,PATH) -- insert in the first position
		ReadFile = simExtCustomUI_getComboboxItemText(loadFileUI_index,41,0) -- default reading
		actionRead(ReadFile)
    else
		print("Cancel!")
	end
	if simExtCustomUI_getComboboxItemCount(loadFileUI_index, 41) ~= 0 then
		simExtCustomUI_setEnabled(loadFileUI_index, 127, true, true)
	end
end

function openFile()
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

function actionSimulate()
    -- body
	currentActionIndex = 1 --?????action??
	actionSim = true
end

function delay(n)
	for i = 1, n, 1 do
		for j = 1, n, 1 do
		
		end
	end
end

function checkDataFormat()
	simExtCustomUI_setEnabled(loadFileUI_index, 126, false, true)
	simExtCustomUI_setEnabled(loadFileUI_index, 125, false, true)
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
	simExtCustomUI_setEnabled(loadFileUI_index, 126, true, true)
	simExtCustomUI_setEnabled(loadFileUI_index, 125, true, true)
	return true
end

if (sim_call_type==sim_childscriptcall_initialization) then
	createFileUI_index = 0 --file-creation UI id
	loadFileUI_index = 0 --file-load UI id
	editFileUI_index = 0 --file-edit UI id
	scanFileUI_index = 0 --file-scan UI id
	jointNum = 8 --?????
	loadFileNum = 1
	loadFilehistory = {}
	
	currentJointAngle = {} --????????????
	finalActionIndex = currentActionIndex --??????action???
	currentActionIndex = 1 --??????action???
	action = {} --??action???????????
	actionCount = 0 --???????Action?
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
            joint_command = action[currentActionIndex]
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
                simExtRosInterface_publish(publisher,{data=joint_position})
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

-- Following not really needed in a simulation script (i.e. automatically shut down at simulation end):
    if rosInterfacePresent then
        simExtRosInterface_shutdownPublisher(publisher)
        simExtRosInterface_shutdownSubscriber(subscriber)
    end
	
end