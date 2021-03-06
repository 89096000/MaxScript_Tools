--Si el Rollout ya habia sido creado, destruimos el previo
try(destroyDialog Architecture_generator) catch()

--Par�metro con informacion de el m�dulo de pared seleccionado para crear la habitaci�n
global default_base_wall

--Parametros con la cantidad de m�dulos creados por componente
global wall_amount = 0
global window_amount = 0
global door_amount = 0

-- Parametros para cada modulo por componente
global wall_module_parameters = #()
global window_module_parameters = #()
global door_module_parameters = #()

--Arrays con los objetos creados
global generated_wall_modules= #()
global generated_corner_modules= #()
global generated_window_modules = #()
global generated_door_modules = #()

rollout Architecture_generator "Architecture Generator" width:400 height:840
(
	--Texto informativo en el rollout
	label 'main_label' "Architecture Generator" pos:[152,16] width:112 height:16 align:#left
	label 'lbl_wall_width' "Width" pos:[64,96] width:32 height:16 align:#left	
	label 'lbl_wall_height' "Height" pos:[160,96] width:32 height:16 align:#left
	label 'lbl_wall_length' "Length" pos:[256,96] width:40 height:16 align:#left	
	label 'lbl_wall_modules_created' "Wall Modules Created" pos:[120,152] width:104 height:16 align:#left	
	label 'lbl_window_width' "Frame Thickness" pos:[64,216] width:80 height:16 align:#left
	label 'lbl_window_height' "Frame Height" pos:[216,216] width:69 height:16 align:#left	
	label 'lbl_window_modules_created' "Window Modules Created" pos:[104,272] width:128 height:16 align:#left	
	label 'lbl_door_width' "Support thickness" pos:[64,336] width:88 height:16 align:#left	
	label 'lbl_door_height' "Support Height" pos:[215,336] width:75 height:16 align:#left	
	label 'lbl_door_modules_created' "Door Modules Created" pos:[112,392] width:120 height:16 align:#left	
	label 'lbl_grid_possition_x' "Grid Possition X" pos:[32,520] width:79 height:16 align:#left
	label 'lbl_grid_possition_y' "Grid Possition Y" pos:[32,544] width:79 height:16 align:#left
	label 'lbl_grid_possition_z' "Grid Possition Z" pos:[32,568] width:79 height:16 align:#left
	label 'lbl_room_width' "Room Width" pos:[216,520] width:72 height:16 align:#left
	label 'lbl_room_height' "Room Height" pos:[216,544] width:72 height:16 align:#left	
	label 'lbl86' "3.1 Select modules to swap" pos:[40,696] width:160 height:16 align:#left	
	label 'lbl_base_wall_module' "Base Wall Module" pos:[216,568] width:88 height:15 align:#left	
	
	--Texto para bloques de componentes
	GroupBox 'grp_module' "1. Module Settings" pos:[16,48] width:368 height:440 align:#left
	GroupBox 'grp_wall_module' "1.1 Wall Module Settings" pos:[40,72] width:320 height:104 align:#left
	GroupBox 'grp_window_module' "1.2 Window Module Settings " pos:[40,192] width:320 height:104 align:#left
	GroupBox 'grp_door_module' "1.3 Door Module Settings" pos:[40,312] width:320 height:104 align:#left	
	GroupBox 'grp_room' "2. Room Settings" pos:[16,496] width:368 height:160 align:#left	
	GroupBox 'grp26' "3. Swap Modules" pos:[16,672] width:376 height:144 align:#left	
	GroupBox 'grp27' "3.2 Swap " pos:[32,728] width:344 height:72 align:#left
		
	--Botones de acci�n en el rollout
	button 'btn_add_wall' "Add new Module" pos:[152,120] width:104 height:24 align:#left
	button 'btn_add_window' "Add New Module" pos:[152,240] width:103 height:24 align:#left
	button 'btn_add_door' "Add New Module" pos:[152,360] width:104 height:24 align:#left	
	button 'btn_generate_architecture' "Generate Arquitecture Modules" pos:[112,432] width:168 height:40 align:#left	
	button 'btn_generate_room' "Generate Room" pos:[120,600] width:168 height:40 align:#left	
	button 'btn_swap_wall' "Swap for Wall" pos:[40,744] width:80 height:40 align:#left
	button 'btn_swap_window' "Swap for Window" pos:[168,744] width:80 height:40 align:#left
	button 'btn_swap_door' "Swap for Door" pos:[288,744] width:80 height:40 align:#left
	
	--Textos informativos (no modificables)
	edittext 'edt_wall_amount'  pos:[232,152] width:40 height:16 readOnly:true align:#left text: "0"
	edittext 'edt_window_amount' pos:[232,272] width:40 height:16 readOnly:true align:#left text: "0"
	edittext 'edt_door_amount' pos:[232,392] width:40 height:16 readOnly:true align:#left text: "0"
	
	--Texto modificable por el usuario
	edittext 'edt_base_wall_module' pos:[304,568] width:24 height:15 align:#left text: "1" 
	
	--Spinners con informaci�n sobre los parametros de m�dulos y habitaci�n
	spinner 'spn_wall_width' "" pos:[96,96] width:48 height:16 align:#left range:[0, 9999, 0]
	spinner 'spn_wall_height' "" pos:[192,96] width:48 height:16 align:#left range:[0, 9999, 0]
	spinner 'spn_wall_length' "" pos:[296,96] width:48 height:16  align:#left range:[0, 9999, 0]
	spinner 'spn_window_width' "" pos:[156,216] width:44 height:16 align:#left  range:[0, 9999, 0]
	spinner 'spn_window_height' "" pos:[288,216] width:48 height:16 align:#left  range:[0, 9999, 0]
	spinner 'spn_door_width' "" pos:[155,335] width:43 height:16 align:#left range:[0, 9999, 0]
	spinner 'spn_door_height' "" pos:[293,335] width:45 height:16 align:#left range:[0, 9999, 0]
	spinner 'spn_room_width' "" pos:[288,520] width:88 height:16 align:#left range:[0, 9999, 0]
	spinner 'spn_room_height' "" pos:[288,544] width:88 height:16 align:#left range:[0, 9999, 0]
	spinner 'spn_room_posx' "" pos:[112,520] width:72 height:16 align:#left range:[0, 9999, 0]
	spinner 'spn_room_posy' "" pos:[112,544] width:72 height:16 align:#left range:[0, 9999, 0]
	spinner 'spn_room_posz' "" pos:[112,568] width:72 height:16 align:#left range:[0, 9999, 0]
	
	--Boton para a�adir "Muro"
	on btn_add_wall pressed do
	(
		--Booleano para comprobar si los datos introducidos ya habian sido introducidos previamente
		already_used = false
		
		--Comprobaci�n para evitar parametros vac�os
		if spn_wall_width.value != 0 and spn_wall_height.value != 0 and spn_wall_length.value != 0 do
		(
			--Comprobamos si la combinaci�n de parametros ya fue introducida
			for saved_wall_parameters in wall_module_parameters do
			(
				if saved_wall_parameters[1] == spn_wall_width.value and 
				   saved_wall_parameters[2] == spn_wall_height.value and
				   saved_wall_parameters[3] == spn_wall_length.value do
				   already_used = true
			)
			
			--Guardamos los parametros del componente		
			if already_used == false do
			(
				wall_amount = wall_amount + 1
				edt_wall_amount.text = wall_amount as string
				wall_parameter = #(spn_wall_width.value, spn_wall_height.value, spn_wall_length.value, wall_amount)
				append wall_module_parameters wall_parameter
			)
		)
	)
	
	--Boton para a�adir "Ventana"
	on btn_add_window pressed do
	(
		--Booleano para comprobar si los datos introducidos ya habian sido introducidos previamente
		already_used = false
		
		--Comprobaci�n para evitar parametros vac�os
		if spn_window_width.value != 0 and spn_window_height.value != 0 do
		(
			--Comprobamos si la combinaci�n de parametros ya fue introducida
			for saved_window_parameters in window_module_parameters do
			(
				if saved_window_parameters[1] == spn_window_width.value and 
				   saved_window_parameters[2] == spn_window_height.value do
				   already_used = true
			)

			--Guardamos los parametros del componente	
			if already_used == false do
			(
				window_amount = window_amount + 1
				edt_window_amount.text = window_amount as string
				window_parameter = #(spn_window_width.value, spn_window_height.value, window_amount)
				append window_module_parameters window_parameter			
			)
		)
	)
	
	--Boton para a�adir "Puerta"
	on btn_add_door pressed do
	(
		--Booleano para comprobar si los datos introducidos ya habian sido introducidos previamente
		already_used = false
		
		--Comprobaci�n para evitar parametros vac�os
		if spn_door_width.value != 0 and spn_door_height.value != 0 do
		(
			--Comprobamos si la combinaci�n de parametros ya fue introducida
			for saved_door_parameters in door_module_parameters do
			(
				if saved_door_parameters[1] == spn_door_width.value and 
				   saved_door_parameters[2] == spn_door_height.value do
				   already_used = true
			)
			
			--Guardamos los parametros del componente
			if already_used == false do
			(
				door_amount = door_amount + 1
				edt_door_amount.text = door_amount as string
				door_parameter = #(spn_door_width.value, spn_door_height.value, door_amount)
				append door_module_parameters door_parameter			
			)
		)
	)
	
	--Boton para generar los m�dulos
	on btn_generate_architecture pressed do
	(
		--Si no hay ning�n m�dulo de pared, no realizamos ninguna acci�n
		if wall_amount > 0 do
		(
			--Par�metro con el offset para la colocaci�n de los m�dulos de pared
			wall_spacing_x = 0
			
			--Comprobamos todos los par�metros para m�dulos guardados y los instanciamos
			for saved_wall_parameters in wall_module_parameters do
			(
				--Creamos el objeto con los par�metros introducidos
				newWall = Box()
				newWall.widthsegs = 1	
				newWall.width = saved_wall_parameters[1]
				newWall.height = saved_wall_parameters[2]
				newWall.length = saved_wall_parameters[3]
				newWall.name = "Architecture_Wall_" + saved_wall_parameters[4] as string	
				
				-- Movemos el pivote del objeto
				newWall.pivot = [newWall.min.x, newWall.min.y, newWall.min.z]

				-- Situamos el objeto en la escena y actualizamos el offset
				newWall.pos = [wall_spacing_x ,-80 ,0]
				wall_spacing_x = wall_spacing_x + newWall.width + 2
				
				-- Guardamos el objeto en un array
				append generated_wall_modules newWall
			)
			
			--Par�metro con el offset para la colocaci�n de los m�dulos de esquina
			corner_spacing_x = 0	
			
			--Comprobamos todos los par�metros para m�dulos guardados y los instanciamos		
			for saved_wall_parameters in wall_module_parameters do
			(	
				--Creamos el objeto con los par�metros introducidos
				newCorner = Box()
				newCorner.widthsegs = 1	
				newCorner.width = saved_wall_parameters[3]
				newCorner.height = saved_wall_parameters[2]
				newCorner.length = saved_wall_parameters[3]
				newCorner.name = "Architecture_Corner_" + saved_wall_parameters[4] as string	
				
				-- Movemos el pivote del objeto
				newCorner.pivot = [newCorner.min.x, newCorner.min.y, newCorner.min.z]
				
				-- Situamos el objeto en la escena y actualizamos el offset
				newCorner.pos = [corner_spacing_x ,-60 ,0]
				corner_spacing_x = corner_spacing_x + newCorner.width + 2

				-- Guardamos el objeto en un array
				append generated_corner_modules newCorner
			)
			
			--Si no se han introducido par�metros de ventana no se realizan acciones
			if window_amount > 0 do
			(
				--Offset de colocaci�n de los m�dulos de ventana
				window_spacing_x = 0

				--Comprobamos todos los par�metros para m�dulos guardados y los instanciamos	
				for saved_wall_parameters in wall_module_parameters do
				(
					--Por cada m�dulo de pared, creamos modulos de ventana correspondientes
					for saved_window_parameters in window_module_parameters do
					(

						
						--Creamos el objeto con los par�metros introducidos
						newWindow = Box()
						newWindow.widthsegs = 1		
						newWindow.width = saved_wall_parameters[1]
						newWindow.height = saved_wall_parameters[2]
						newWindow.length = saved_wall_parameters[3]
						newWindow.widthsegs = 3
						newWindow.heightsegs = 3
						newWindow.name = "Architecture_Window_" + saved_window_parameters[3] as string + "_Wall" + saved_wall_parameters[4] as string

						--Movemos el punto de pivote
						newWindow.pivot = [newWindow.min.x, newWindow.min.y, newWindow.min.z]
						
						-- Situamos el objeto en la escena y actualizamos el offset
						newWindow.pos = [window_spacing_x , -40 ,0]
						window_spacing_x = window_spacing_x + newWindow.width + 2		
						
						
						--Configuramos la ventana instanciada
						convertTo newWindow Editable_poly
						polyop.setFaceSelection newWindow #{11, 23}
						newWindow.EditablePoly.delete #Face
						
						select newWindow
						subobjectLevel = 2
						newWindow.EditablePoly.SetSelection #Edge #{25, 28, 31..32, 47, 50, 52..53}
						newWindow.bridgeSelected = 1
						newWindow.EditablePoly.Bridge()
						
						
						--Altura de la ventana maxima
						polyop.moveVert newWindow #{25..32} [0,0,(saved_wall_parameters[2]/3.34)]
						polyop.moveVert newWindow #{17..24} [0,0,-(saved_wall_parameters[2]/3.34)]
						
						--Ancho de la ventana maximo
						polyop.moveVert newWindow #{3, 7, 11, 15, 19, 22, 27, 30} [saved_wall_parameters[1]/3.34,0,0]
						polyop.moveVert newWindow #{2, 6, 10, 14, 18, 23, 26, 31} [-(saved_wall_parameters[1]/3.4),0,0]
						
						--Comprobacion por si los par�metros introducidos por el usuario son erroneos (Si el grosor es mayor al ancho)
						if saved_window_parameters[1] + 1 < saved_wall_parameters[1] do
						(
							polyop.moveVert newWindow #{3, 7, 11, 15, 19, 22, 27, 30} [-saved_window_parameters[1]/2,0,0]
							polyop.moveVert newWindow #{2, 6, 10, 14, 18, 23, 26, 31} [saved_window_parameters[1]/2,0,0]							
						)
						
						--Comprobacion por si los par�metros introducidos por el usuario son erroneos (Si el grosor es mayor al ancho)
					    if saved_window_parameters[2] + 1 < saved_wall_parameters[2] do
						(
							polyop.moveVert newWindow #{25..32} [0,0,-saved_window_parameters[2]/2]
							polyop.moveVert newWindow #{17..24} [0,0,saved_window_parameters[2]/2]						
						)
						
						--Guardamos el objeto creado
						append generated_window_modules newWindow
					)
				)
			)
			
			--Si no hubiesen par�metros de m�dulos de pared, no se realizan acciones
			if door_amount > 0 do
			(
				--offset
				door_spacing_x = 0
				
				--Comprobamos todos los par�metros para m�dulos guardados y los instanciamos	
				for saved_wall_parameters in wall_module_parameters do
				(
					--Por cada m�dulo de pared, creamos modulos de puerta correspondientes
					for saved_door_parameters in door_module_parameters do
					(
						
						--Comprobamos si los parametros del usuario son erroneos
						if saved_wall_parameters[2] - saved_door_parameters[2] <= 0 do
							saved_door_parameters[2] = saved_wall_parameters[2] - 1
						
						--Creamos el objeto
						newDoor = Box()
						newDoor.width = saved_wall_parameters[1]	
						newDoor.height = saved_wall_parameters[2] - saved_door_parameters[2]
						newDoor.length = saved_wall_parameters[3]
						newDoor.name = "Architecture_Door_" + saved_door_parameters[3] as string + "_Wall" + saved_wall_parameters[4] as string
						
						newDoor.pivot = [newDoor.min.x, newDoor.min.y, newDoor.min.z]						
						newDoor.pos = [door_spacing_x , -20 ,saved_door_parameters[2]]
						
						newDoor.widthsegs = 3
						
						--Editamos el objeto
						convertTo newDoor Editable_poly
						
						if saved_door_parameters[1] >= saved_wall_parameters[1] do
						saved_door_parameters[1] = saved_wall_parameters[1] - 1
						
						polyop.moveVert newDoor #{3, 7, 11, 15} [((saved_wall_parameters[1]/3.33) - saved_door_parameters[1]/2 ),0,0]
						polyop.moveVert newDoor #{2, 6, 10, 14} [(-saved_wall_parameters[1]/3.33) +saved_door_parameters[1]/2 ,0,0]
						
						select newDoor
						subobjectLevel = 4
						newDoor.EditablePoly.SetSelection #Face #{1, 3}
						polyop.extrudeFaces newDoor #{1, 3} saved_door_parameters[2]
						
						newDoor.pivot = [newDoor.min.x, newDoor.min.y, newDoor.min.z]	
						door_spacing_x = door_spacing_x + saved_wall_parameters[1] + 2						
							
						--Guardamos el objeto en un array
						append generated_door_modules newDoor
					)
				)
			)
		)
	)
	
	--Bot�n para generar la habitaci�n
	on btn_generate_room pressed do
	(
		if spn_room_width.value > 0 and spn_room_height.value > 0 and generated_wall_modules.count > 0 do 
		(
			--"default_base_wall" Permite seleccionar cual de las paredes creadas ser� la seleccionada como elemento a clonar
			default_base_wall = 1
			
			--Comprobamos si el usuario a seleccionado una pared por defecto inexistente
			if edt_base_wall_module.text as integer <= generated_wall_modules.count and edt_base_wall_module.text as integer > 0 do
			default_base_wall = edt_base_wall_module.text as integer		
			
			--Valores del numero de paredes que cabr�n a lo alto y ancho seg�n el tama�o de pared y componente
			wall_modules_length= 0
			wall_modules_width= 0
			
			--Creamos el suelo de la habitaci�n
			floor_node = box()
			floor_node.length = spn_room_height.value
			floor_node.width = spn_room_width.value
			floor_node.height = 1 
			floor_node.name = "Floor"
			
			--Colocamos el suelo de la habitaci�n
			floor_node.pivot = [floor_node.min.x,floor_node.min.y, floor_node.min.z]	
			floor_node.pos = [spn_room_posx.value + wall_module_parameters[default_base_wall][3] , spn_room_posy.value + wall_module_parameters[default_base_wall][3] ,spn_room_posz.value]		
			
			--Clonamos los nodos de esquina segun la base de pared seleccionada
			cloned_corner_nodes = #()
				for i = 1 to 4 do
				(
					maxOps.cloneNodes generated_corner_modules[default_base_wall] cloneType:#instance newNodes:&nnl #nodialog	
					nnl[1].name = "Corner_" + cloned_corner_nodes.count as string
					append cloned_corner_nodes nnl[1]
				)
			
				--Situamos las esquinas de la habitaci�n
			cloned_corner_nodes[1].pos = [spn_room_posx.value ,spn_room_posy.value ,spn_room_posz.value]
			cloned_corner_nodes[2].pos = [(spn_room_posx.value + spn_room_width.value + wall_module_parameters[default_base_wall][3] ),spn_room_posy.value,spn_room_posz.value]
			cloned_corner_nodes[3].pos = [spn_room_posx.value, (spn_room_posy.value + spn_room_height.value + wall_module_parameters[default_base_wall][3]),spn_room_posz.value]
			cloned_corner_nodes[4].pos = [(spn_room_posx.value + spn_room_width.value + wall_module_parameters[default_base_wall][3]),(spn_room_posy.value + spn_room_height.value + wall_module_parameters[default_base_wall][3]),spn_room_posz.value]
				
			--Calculo el numero de paredes que cabr�n a lo largo y ancho de la habitaci�n	
			wall_modules_width = spn_room_width.value / wall_module_parameters[default_base_wall][1] 
			wall_modules_length = spn_room_height.value / wall_module_parameters[default_base_wall][1] 
			
			--Array con los clones de pared instanciados
			cloned_top_width_wall_nodes = #()
			cloned_bottom_width_wall_nodes = #()
			
				--Offset de posicion de los m�dulos de pared
				position_offset = wall_module_parameters[default_base_wall][3] 
				
				--Array con todos las paredes que cabr�an en la parte HORIZONTAL INFERIOR
				for i = 1 to wall_modules_width do
				(
				--Clonamos, renombramos y guardamos el m�dulo
				maxOps.cloneNodes generated_wall_modules[default_base_wall] cloneType:#instance newNodes:&nnl #nodialog
				nnl[1].name = "Wall_" + default_base_wall as string
				nnl[1].name = (append "M_" nnl[1].name )
				append cloned_bottom_width_wall_nodes nnl[1]
					
				--Situamos el m�dulo y actualizamos su posici�n
				cloned_bottom_width_wall_nodes[i].pos = [spn_room_posx.value + position_offset ,spn_room_posy.value,spn_room_posz.value]
				position_offset = position_offset + wall_module_parameters[default_base_wall][1] 
				)
			
				position_offset = wall_module_parameters[default_base_wall][3] 	
				
				--Array con todos las paredes que cabr�an en la parte HORIZONTAL SUPERIOR		
				for i = 1 to wall_modules_width do
				(	
				--Clonamos, renombramos y guardamos el m�dulo, despues lo situamos y actualizamos el offset
				maxOps.cloneNodes generated_wall_modules[default_base_wall] cloneType:#instance newNodes:&nnl #nodialog
				nnl[1].name = "Wall_" + default_base_wall as string
				nnl[1].name = (append "M_" nnl[1].name )				
				append cloned_top_width_wall_nodes nnl[1]	
				cloned_top_width_wall_nodes[i].pos = [spn_room_posy.value + position_offset ,(spn_room_posy.value + spn_room_height.value  + wall_module_parameters[default_base_wall][3] ) ,spn_room_posz.value]
				position_offset = position_offset + wall_module_parameters[default_base_wall][1] 
				)
				
			--Array con los clones de pared instanciados
			cloned_left_length_wall_nodes = #()
			cloned_right_length_wall_nodes = #()
			
				position_offset = wall_module_parameters[default_base_wall][3] 
				
				--Array con todos las paredes que cabr�an en la parte VERTICAL IZQUIERDA
				for i = 1 to wall_modules_length do
				(
				--Clonamos, renombramos y guardamos el m�dulo, despues lo situamos y actualizamos el offset
				maxOps.cloneNodes generated_wall_modules[default_base_wall] cloneType:#instance newNodes:&nnl #nodialog
				nnl[1].name = "Wall_" + default_base_wall as string
				nnl[1].name = (append "M_" nnl[1].name )
					
				--Rotamos el componente	
				axis_rotation = eulerangles 0 0 90
				rotate nnl[1] axis_rotation
					
				append cloned_left_length_wall_nodes nnl[1]
				cloned_left_length_wall_nodes[i].pos = [spn_room_posx.value + wall_module_parameters[default_base_wall][3], spn_room_posy.value + position_offset ,spn_room_posz.value]
				position_offset = position_offset + wall_module_parameters[default_base_wall][1] 
				)
				
				position_offset = wall_module_parameters[default_base_wall][3] 
				
				--Array con todos las paredes que cabr�an en la parte VERTICAL DERECHA
				for i = 1 to wall_modules_length do
				(
				--Clonamos, renombramos y guardamos el m�dulo, despues lo situamos y actualizamos el offset
				maxOps.cloneNodes generated_wall_modules[default_base_wall] cloneType:#instance newNodes:&nnl #nodialog
				nnl[1].name = "Wall_" + default_base_wall as string
				nnl[1].name = (append "M_" nnl[1].name )
					
				--Rotamos el componente	
				axis_rotation = eulerangles 0 0 90
				rotate nnl[1] axis_rotation
					
				append cloned_right_length_wall_nodes nnl[1]
				cloned_right_length_wall_nodes[i].pos = [(spn_room_posx.value + spn_room_width.value + wall_module_parameters[default_base_wall][3]*2), spn_room_posy.value + position_offset ,spn_room_posz.value]
				position_offset = position_offset + wall_module_parameters[default_base_wall][1] 
				)
		)
	)
	
	--Bot�n que permite cambiar un m�dulo por el m�dulo pared
	on btn_swap_wall pressed do 
	(		
		--Obtengo todos los modulos seleccionados
		for obj in getCurrentSelection() do
		(
			--Compruebo si en efecto son m�dulos
			if substring	obj.name 1	1 == "M" do
			(
				--Clono el m�dulo de pared, lo sit�o y elimino el anterior
				maxOps.cloneNodes generated_wall_modules[default_base_wall] cloneType:#instance newNodes:&nnl #nodialog
				nnl[1].pos = obj.pos
				nnl[1].rotation.z_rotation = obj.rotation.z_rotation
				nnl[1].name = "Wall_" + default_base_wall as string
				nnl[1].name = (append "M_" nnl[1].name )
				delete obj
			)
		)
	)
	
	--Bot�n para cambiar al m�dulo de pared. 
	--NOTA: SI SE HA SELECCIONADO UNA VENTANA Y SE CAMBIA POR VENTANA, SI EXISTE OTRO TIPO QUE ENCAJE, SE COLOCAR� EN SU LUGAR
	on btn_swap_window pressed do 
	(	
		--Comprobamos si el usuario ha creado alguna ventana
		if window_amount > 0 do
		(
			--Obtengo todos los modulos seleccionados
			for obj in getCurrentSelection() do
			(
				--Compruebo si en efecto son m�dulos
				if substring	obj.name 1	1 == "M" do
				(
					--Caso en el cual se seleccione una ventana ya colocada
					if obj.name == "M_Window" and window_amount > 1 do 
					(
						--Recorremos todas las ventanas creadas por el usuario
						for window_module in generated_window_modules do 
						(
							--Para poder comparar (no colocar la misma o una que no quepa) calculamos el volumen de los objetos
							obj_volume = ( obj.max.x - obj.min.x ) * ( obj.max.y - obj.min.y ) * ( obj.max.z - obj.min.z )
							win_volume = ( window_module.max.x - window_module.min.x ) * ( window_module.max.y - window_module.min.y ) * ( window_module.max.z - window_module.min.z )

							--asi como la distancia entre dos vertices (dos ventanas podr�an tener en mismo volumen total y distinto hueco)
							obj_vert_dist = (obj.verts[27].pos.z - obj.verts[1].pos.z)
							win_vert_dist = (window_module.verts[27].pos.z - window_module.verts[1].pos.z)

							if obj_volume as integer == win_volume as integer and obj_vert_dist != win_vert_dist do 
							(
								--Clono el m�dulo de ventana y lo sit�o
								maxOps.cloneNodes window_module cloneType:#instance newNodes:&nnl #nodialog
								nnl[1].pos = obj.pos
								nnl[1].rotation.z_rotation = obj.rotation.z_rotation
								nnl[1].name = "Window"
								nnl[1].name = (append "M_" nnl[1].name )
							)
						)
					)		
				
					--Si el m�dulo era distinto a ventana, coloco la primera ventana v�lida
					if obj.name != "M_Window" do 
					(
						--Clono el m�dulo de ventana y lo sit�o
						maxOps.cloneNodes generated_window_modules[default_base_wall * window_amount] cloneType:#instance newNodes:&nnl #nodialog
						nnl[1].pos = obj.pos
						nnl[1].rotation.z_rotation = obj.rotation.z_rotation
						nnl[1].name = "Window"
						nnl[1].name = (append "M_" nnl[1].name )
					)
					
					--Elimino el anterior m�dulo si fuese necesario
					if obj.name != "M_Window" or window_amount > 1 do
						delete obj
				)
			)			
		)
	)
	
	--Bot�n para cambiar por un m�dulo puerta
	--NOTA: SI SE HA SELECCIONADO UNA PUERTA Y SE CAMBIA POR PUERTA, SI EXISTE OTRO TIPO QUE ENCAJE, SE COLOCAR� EN SU LUGAR
	on btn_swap_door pressed do 
	(
		--Comprobamos si se han creado puertas por el usuario
		if door_amount > 0 do
		(
			--Obtengo todos los modulos seleccionados
			for obj in getCurrentSelection() do
			(
				--Compruebo si en efecto son m�dulos
				if substring	obj.name 1	1 == "M" do
				(
					--Caso en el cual se seleccione una puerta ya colocada
					if obj.name == "M_Door" do 
					(
						--Recorremos todas las puertas creadas por el usuario
						for door_module in generated_door_modules do 
						(
							--Para poder comparar (no colocar la misma o una que no quepa) calculamos el volumen de los objetos
							obj_volume = ( obj.max.x - obj.min.x ) * ( obj.max.y - obj.min.y ) * ( obj.max.z - obj.min.z )
							door_volume = ( door_module.max.x - door_module.min.x ) * ( door_module.max.y - door_module.min.y ) * ( door_module.max.z - door_module.min.z )
								
							--asi como la distancia entre dos vertices (dos puertas podr�an tener en mismo volumen total y distinto hueco)
							obj_vert_dist = (obj.verts[17].pos.z - obj.verts[3].pos.z)
							door_vert_dist = (door_module.verts[17].pos.z - door_module.verts[3].pos.z)
								
							if obj_volume as integer == door_volume as integer and obj_vert_dist != door_vert_dist do 
							(
								--Clono, sit�o y renombro el m�dulo
								maxOps.cloneNodes door_module cloneType:#instance newNodes:&nnl #nodialog
					     		nnl[1].pos = obj.pos
								nnl[1].rotation.z_rotation = obj.rotation.z_rotation
								nnl[1].name = "Door"
								nnl[1].name = (append "M_" nnl[1].name )
							)
						)
					)		
					
					--Si se selecciona un m�dulo que no era puerta
					if obj.name != "M_Door" do 
					(
						--Clono, sit�o y renombro el m�dulo
						maxOps.cloneNodes generated_door_modules[default_base_wall * door_amount] cloneType:#instance newNodes:&nnl #nodialog
						nnl[1].pos = obj.pos
						nnl[1].rotation.z_rotation = obj.rotation.z_rotation
						nnl[1].name = "Door"
						nnl[1].name = (append "M_" nnl[1].name )
					)
					
					--Elimino el anterior m�dulo si fuese necesario
					if obj.name != "M_Door" or door_amount > 1 do
						delete obj
				)
			)	
		)  
	)
)
 createDialog Architecture_generator