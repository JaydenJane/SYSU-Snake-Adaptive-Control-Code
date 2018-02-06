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
	simExtCustomUI_hide(mainUI)
	xml= '<ui title="Control Panel" closeable="true" resizeable="false" activate="false" onclose="destroyActionUI">'..controller..[[
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
	simExtCustomUI_hide(mainUI)
	xml= '<ui title="Load File" closeable="true" resizeable="false" activate="false" onclose="destroyLoadFileUI">'..[[
		<group>
			<label style="* {font-size: 20px;}" text="Gesture Mode"/>
	        <group layout="vbox">
				<group layout="hbox">
					<label style="* {font-size: 15px;}" text="ReadFile(.txt)"/>
					<combobox id="41"></combobox>
				</group>
				<group layout="hbox">
					<button text="Open" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="openFile" id="124"/>
					<button text="Simulation" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionSimulate" id="125"/>
					<button text="simulation" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="actionEdit" id="126"/>
				</group>
			</group>
		</group>
	</ui>
	]]
	loadFileUI_index = simExtCustomUI_create(xml)
end

function destroyActionUI()
    -- body
	simExtCustomUI_destroy(createFileUI_index)
	simExtCustomUI_show(mainUI)
end

function destroyLoadFileUI()
    -- body
	simExtCustomUI_destroy(loadFileUI_index)
	simExtCustomUI_show(mainUI)
end

function spinboxChange(uiHandle, id, newValue) --响应spinbox的变化
	changedJoint = id --slider的id在1-20之间
    setValues(newValue, "single", changedJoint)
	simExtCustomUI_setSliderValue(createFileUI_index, id + 20, newValue) --关联slider的变化
end

function sliderChange(uiHandle, id, newValue) ----响应slider的变化
	changedJoint = id - 20 --slider的id在21-40之间
    setValues(newValue, "single", changedJoint)
	simExtCustomUI_setSpinboxValue(createFileUI_index, id - 20, newValue) --关联spinbox的变化
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
			if action[ActionNum][i] ~= currentJointAngle[i] then
				notChange = false
				break
			end
		end
		if notChange == false then
			ActionNum = ActionNum + 1
			action[ActionNum] = {}
			for i=1, jointNum, 1 do
				action[ActionNum][i] = currentJointAngle[i]
			end
			finalActionPoint = ActionNum
		end
    elseif(id == 121) then
		if(ActionNum > 1) then
			ActionNum = ActionNum - 1
			setValues(action[ActionNum])
			for i = 1, jointNum, 1 do
				simExtCustomUI_setSpinboxValue(ui, i, action[ActionNum][i]) --关联spinbox的变化
				simExtCustomUI_setSliderValue(ui, i + 20, action[ActionNum][i]) --关联slider的变化
			end
		end
    elseif(id == 122) then
		if ActionNum < finalActionPoint then
			ActionNum = ActionNum + 1
			setValues(action[ActionNum])
			for i = 1, jointNum, 1 do
				simExtCustomUI_setSpinboxValue(ui, i, action[ActionNum][i]) --关联spinbox的变化
				simExtCustomUI_setSliderValue(ui, i + 20, action[ActionNum][i]) --关联slider的变化
			end
		end
    end
	
	--输出缓存区信息
	for i=1, ActionNum, 1 do
		local s = ""
		for j=1, jointNum, 1 do
			s = s.." "
			s = s..action[i][j]
		end
		print(s)
	end
	print("-------------------------------")
	
    simExtCustomUI_setLabelText(createFileUI_index,41,"Action: "..tostring(ActionNum).."times")
end

function actionSave()
    -- body
    PATH = simFileDialog(sim_filedlg_type_save,"SAVE","","","text file","txt")
	if PATH ~= "" then
	    file = io.open(PATH, "w")
		for i=1, ActionNum, 1 do
			local s = ""
			for j=1, jointNum, 1 do
				s = s..action[i][j]
				s = s.." "
			end
			s = s.."\n"
			file:write(s)
		end
		io.close(file)
	end
end

function openFile()
    -- body
    PATH=simFileDialog(sim_filedlg_type_load,"Search","","","text file","txt")
    print(PATH)
    if(PATH ~= nil) then
        local ItemNum = simExtCustomUI_getComboboxItemCount(loadFileUI_index,41)
        print(ItemNum)
        for i=ItemNum,0,-1 do
            simExtCustomUI_removeComboboxItem(loadFileUI_index,41,i)
        end   
        simExtCustomUI_insertComboboxItem(loadFileUI_index,41,1,PATH)
        ReadFile = PATH
    end
end

function actionSimulate()
    -- body
	ActionCount = 0
	ActionIndex = 0
	for line in io.lines(ReadFile) do
		ActionCount = ActionCount + 1
		ActionAngle[ActionCount] = {}
		for w in string.gmatch(line, "%S+") do
			table.insert(ActionAngle[ActionCount],tonumber(w))
		end
	end
	actionSim = true
end

if (sim_call_type==sim_childscriptcall_initialization) then
	createFileUI_index = 0 --file-creation UI id
	loadFileUI_index = 0 --file-load UI id
	jointNum = 8 --定义关节数
	ActionNum = 1 --执行action的数量
	currentJointAngle = {} --存储当前各个关节的角度值
	finalActionPoint = ActionNum --指向最后一个action的位置
	
	action = {} --每个action都存储每个关节的角度值
	action[ActionNum] = {}
	ActionAngle = {} --改
	next_action_time = 0 --改
	for i = 1, jointNum, 1 do
		action[ActionNum][i] = 0 --初始状态为默认状态{0,0,...,0}
	end
	
	mainUI = simExtCustomUI_create(createMainUI()) -- creat User Interface
	jointHandle={} --获取每个关节的handle
	for i = 1, jointNum, 1 do
		jointHandle[i] = simGetObjectHandle('joint'..(i)) -- robot arm
	end
end


if (sim_call_type==sim_childscriptcall_actuation) then --只有变化的时候才会触发这个线程
	if actionSim then
        if simGetSimulationTime() > next_action_time then 
            ActionIndex = ActionIndex + 1
            if ActionIndex > ActionCount then
                ActionIndex = ActionCount
                actionSim = false
            else
                max_angle_diff = 0
                for i=1, jointNum, 1 do
                    ASdiff = math.abs(jointHandle[i] - ActionAngle[ActionIndex][i])
                    if ASdiff > max_angle_diff then
                        max_angle_diff = ASdiff
                    end
                end
                interval = max_angle_diff / 10            --改
                joint_command = ActionAngle[ActionIndex]
                setValues(joint_command)                 --改
                next_action_time = simGetSimulationTime() + interval
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

