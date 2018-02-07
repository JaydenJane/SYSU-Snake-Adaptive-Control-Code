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
			<label text="Residence time(s): " style="* {qproperty-alignment: AlignCenter}" />
			<spinbox text = '0' minimum="0" maximum="9000" onchange="spinboxChange" id="10"/>
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
	currentActionIndex = 1 --指向当前一个action的位置
	action = {} --每个action都存储每个关节的角度值
	action[currentActionIndex] = {}
	ResidenceTime = 0; --停留时间
	PATH = ""
	for i = 1, jointNum+1, 1 do
		action[currentActionIndex][i] = 0 --初始状态为默认状态{0,0,...,0}
	end
	xml= '<ui title="Control Panel" closeable="true" resizeable="false" activate="false" onclose="destroyCreatFileUI">'..controller..[[
		<group>
			<label style="* {font-size: 20px;}" text="Operation"/>
			<group layout="hbox">
				<label style="* {font-size: 15px;}" text="Action: 1 times" id="41"/>
				<button text="Confirm" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="120"/>
				<button text="Undo" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="121"/>
				<button text="Redo" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="122"/>
				<button text="Save" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionSave" id="123"/>
			</group>
		</group>
	</ui>
	]]
	createFileUI_index = simExtCustomUI_create(xml) -- file-creation UI
	reset(createFileUI_index)
end

function loadFileUI()
	simExtCustomUI_hide(mainUI_index)
	action = {} --从文件读出来的角度
	actionCount = 0 --从文件中读到的Action数
	currentActionIndex = 1 --当前仿真的action下标
	xml= '<ui title="Load File" closeable="true" resizeable="false" activate="false" onclose="destroyLoadFileUI">'..[[
		<group>
			<label style="* {font-size: 20px;}" text="Gesture Mode"/>
	        <group layout="vbox">
				<group layout="hbox">
					<label style="* {font-size: 15px; width: 100px;}" text="ReadFile(.txt)"/>
					<combobox id="41" onchange="selectFile"></combobox>
				</group>
				<group layout="hbox">
					<button text="Open" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="openFile" id="124"/>
					<button text="Simulation" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionSimulate" id="125"/>
					<button text="Edit" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="editFileUI" id="126"/>
				</group>
			</group>
		</group>
	</ui>
	]]
	loadFileUI_index = simExtCustomUI_create(xml)
end

function editFileUI()
	if PATH == nil then
		return
	end
	actionRead(PATH)
	simExtCustomUI_hide(loadFileUI_index)
	currentActionIndex = actionCount --指向当前一个action的位置
	xml= string.format('<ui title="%s" closeable="true" resizeable="false" activate="false" onclose="destroyEditFileUI">',ReadFile)..controller..[[
		<group>
			<label style="* {font-size: 20px;}" text="Operation"/>
			<group layout="hbox">]]..
				string.format('<label style="* {font-size: 15px;}" text="Action: %d times" id="41"/>', actionCount)..[[
				<button text="Confirm" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="120"/>
				<button text="Undo" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="121"/>
				<button text="Redo" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionOperate" id="122"/>
				<button text="Save" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionSave" id="123"/>
			</group>
		</group>
	</ui>
	]]
	editFileUI_index = simExtCustomUI_create(xml) -- file-edit UI
	for i = 1, jointNum, 1 do
		currentJointAngle[i] = action[currentActionIndex][i]
		simSetJointPosition(jointHandle[i], currentJointAngle[i]*math.pi/180)
		simExtCustomUI_setSpinboxValue(editFileUI_index, i, currentJointAngle[i]) --关联spinbox的变化
		simExtCustomUI_setSliderValue(editFileUI_index, i + 20, currentJointAngle[i]) --关联slider的变化
	end
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

function spinboxChange(ui, id, newValue) --响应spinbox的变化
	if(id == 10) then
		ResidenceTime = newValue
	else			
		changedJoint = id --slider的id在1-20之间
	    setValues(newValue, "single", changedJoint)
		simExtCustomUI_setSliderValue(ui, id + 20, newValue) --关联slider的变化
	end
end

function sliderChange(ui, id, newValue) ----响应slider的变化
	changedJoint = id - 20 --slider的id在21-40之间
    setValues(newValue, "single", changedJoint)
	simExtCustomUI_setSpinboxValue(ui, id - 20, newValue) --关联spinbox的变化
end

function setValues(newAngles, changedNum, changedJoint) --调整关节位置
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

function reset(ui) --重置为初始状态
	for i = 1, jointNum, 1 do
		currentJointAngle[i] = 0
		simSetJointPosition(jointHandle[i], 0)
		simExtCustomUI_setSpinboxValue(ui, i, 0) --关联spinbox的变化
		simExtCustomUI_setSliderValue(ui, i + 20, 0) --关联slider的变化
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
    elseif(id == 121) then --undo operation
		if(currentActionIndex > 1) then
			currentActionIndex = currentActionIndex - 1
			setValues(action[currentActionIndex])
			for i = 1, jointNum, 1 do
				simExtCustomUI_setSpinboxValue(ui, i, action[currentActionIndex][i]) --关联spinbox的变化
				simExtCustomUI_setSliderValue(ui, i + 20, action[currentActionIndex][i]) --关联slider的变化
			end
		end
    elseif(id == 122) then --redo operation
		if currentActionIndex < finalActionIndex then
			currentActionIndex = currentActionIndex + 1
			setValues(action[currentActionIndex])
			for i = 1, jointNum, 1 do
				simExtCustomUI_setSpinboxValue(ui, i, action[currentActionIndex][i]) --关联spinbox的变化
				simExtCustomUI_setSliderValue(ui, i + 20, action[currentActionIndex][i]) --关联slider的变化
			end
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
	
    simExtCustomUI_setLabelText(ui,41,"Action: "..tostring(currentActionIndex).."times")
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
	end
	print("save success")
end

function actionRead(ReadFile)
	print(ReadFile)
	actionCount = 0
	for line in io.lines(ReadFile) do
		actionCount = actionCount + 1
		action[actionCount] = {}
		for w in string.gmatch(line, "%S+") do
			table.insert(action[actionCount],tonumber(w))
		end
	end
end

function openFile()
    -- body
    PATH=simFileDialog(sim_filedlg_type_load,"Search","","","text file","txt")
    if(PATH ~= nil) then
        simExtCustomUI_insertComboboxItem(loadFileUI_index,41,0,PATH) 
		ReadFile = simExtCustomUI_getComboboxItemText(loadFileUI_index,41,0)
		actionRead(ReadFile)
    end
end

function selectFile(ui, id, selected)
	ReadFile = simExtCustomUI_getComboboxItemText(loadFileUI_index,41,selected)
	actionRead(ReadFile)
end

function actionSimulate()
    -- body
	currentActionIndex = 1 --当前仿真的action下标
	actionSim = true
end

function delay(n)
	for i = 1, n, 1 do
		for j = 1, n, 1 do
		
		end
	end
end

if (sim_call_type==sim_childscriptcall_initialization) then
	createFileUI_index = 0 --file-creation UI id
	loadFileUI_index = 0 --file-load UI id
	editFileUI_index = 0 --file-edit UI id
	jointNum = 8 --定义关节数
	
	currentJointAngle = {} --存储当前各个关节的角度值
	finalActionIndex = currentActionIndex --指向最后一个action的位置
	currentActionIndex = 1 --指向当前一个action的位置
	action = {} --每个action都存储每个关节的角度值
	actionCount = 0 --从文件中读到的Action数
	PATH = "" --文件的路径
	mainUI_index = simExtCustomUI_create(createMainUI()) -- creat User Interface
	
	jointHandle={} --获取每个关节的handle
	for i = 1, jointNum, 1 do
		jointHandle[i] = simGetObjectHandle('joint'..(i)) -- robot arm
	end 

	next_action_time = 0
end


if (sim_call_type==sim_childscriptcall_actuation) then --只有变化的时候才会触发这个线程
	if actionSim then
		if(simGetSimulationTime() > next_action_time) then
			if currentActionIndex > actionCount then
				currentActionIndex = actionCount
				actionSim = false
			else
				joint_command = action[currentActionIndex]
				print(currentActionIndex)
				setValues(joint_command)
				start = simGetSimulationTime()
				print("starttime:"..start)
				next_action_time = start + action[currentActionIndex][jointNum+1]+2
				print("period:"..action[currentActionIndex][jointNum+1])
				print("next_action_time:"..next_action_time)
				currentActionIndex = currentActionIndex + 1
			end
		end
	end
end


if (sim_call_type==sim_childscriptcall_sensing) then

    -- Put your main SENSING code here

end


if (sim_call_type==sim_childscriptcall_cleanup) then

    -- Following not really needed in a simulation script (i.e. automatically shut down at simulation end):
	
end

