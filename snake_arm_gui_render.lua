angle_spinbox_render = [[
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

main_window_render = [[
    <group>
    <label style="* {font-size: 20px;}" text="Function"/>
    <button text="Create file" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="createFileUI"/>
    <button text="Load file" style="* {font-size: 15px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="loadFileUI"/>
    </group>
  ]]



action_edit_render = [[
   
      <group layout="hbox">
      	<group layout="vbox">
	      	<group layout="hbox">
		        <label style="* {font-size: 20px;max-width: 100px;}" text="Action: " id="41" />
		        <spinbox text = 'action' minimum="1" maximum="99" onchange="spinboxChange" style="* {font-size: 20px}" id="42"/>
		    </group>
		    <group layout="hbox">
		        <button text="move" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="MoveArm" id="121"/>
		        <button text="stop" style="* {font-size: 20px;margin-left: 10px; margin-right: 10px; padding: 5px}" onclick="StopArm" id="122"/>
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
    ]] ..angle_spinbox_render
  

load_file_window_render = [[
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
	]]
	
  

  

