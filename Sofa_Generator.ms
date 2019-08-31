try(destroyDialog objectResizerRollout) catch()
rollout objectResizerRollout "Object Resizer Tool" width:208 height:328
(
	
	label 'titleBoxCreator' "Creador de Sofás" pos:[64,8] width:88 height:21 align:#left
	
	--Spinner de valores del sofa
	spinner 'sofaHeight' "Sofa - Alto "   pos:[8,72] width:140 height:16 enabled:true range:[5,30,10] align:#left
	spinner 'sofaLength' "Sofa - Largo"   pos:[8,96] width:134 height:16 enabled:true range:[1,25,10] align:#left	
	spinner 'sofaWidth'  "Sofa - Ancho"   pos:[8,48] width:130 height:16 enabled:true range:[20,100,50] align:#left
	
	--Spinner de valores del respaldo
	spinner 'backWidth'  "Respaldo - Ancho" pos:[8,257] width:107 height:16 enabled:true range:[0,100,20] type:#float align:#left
	spinner 'backHeight' "Respaldo - Alto"  pos:[8,232] width:120 height:16 enabled:true range:[0,20,10] align:#left
	spinner 'backLength' "Respaldo - Largo" pos:[8,209] width:111 height:16 enabled:true range:[0,10,1] type:#float align:#left
	
	--Spinner de valores del reposa brazos
	spinner 'armLength' "Brazo - Largo" pos:[8,176] width:129 height:16 enabled:true range:[0,50,15] align:#left
	spinner 'armWidth'  "Brazo - Ancho" pos:[8,128] width:125 height:16 enabled:true range:[0,15,3] align:#left
	spinner 'armHeight' "Brazo - Alto " pos:[8,152] width:135 height:16 enabled:true range:[0,20,4] align:#left
	
	--Boton para crear el sofá
	button 'btn2' "Crear Sofa" pos:[72,280] width:72 height:40 align:#left

	on btn2 pressed do
	(
		--Destruimos todos los elementos previos creados
		delete $*
		
		--Creamos el objeto base
		newDefaultSofa = Box()
		newDefaultSofa.widthsegs = 5
		newDefaultSofa.lengthsegs = 3
	
		--Configuramos los parametros base con las variables indicadas
		newDefaultSofa.width =  sofaWidth.value
		newDefaultSofa.height = sofaHeight.value
		newDefaultSofa.length = 20
	
		convertTo newDefaultSofa Editable_poly
		
		--Ajustamos el tamaño de los reposabrazos
		if armWidth.value*2 > (sofaWidth.value - 10) do armWidth.value = sofaWidth.value/2 - 5
		polyop.moveVert newDefaultSofa #{2, 8, 14, 20, 26, 32, 38, 44} [-(sofaWidth.value / 6) ,0,0]
		polyop.moveVert newDefaultSofa #{3, 9, 15, 21, 27, 33, 39, 45} [-(sofaWidth.value / 3) + armWidth.value ,0,0]
		polyop.moveVert newDefaultSofa #{4, 10, 16, 22, 28, 34, 40, 46} [(sofaWidth.value / 3) - armWidth.value ,0,0]
		polyop.moveVert newDefaultSofa #{5, 11, 17, 23, 29, 35, 41, 47} [(sofaWidth.value / 6) , 0,0]
		
		--Ajustamos el largo del sofa
		polyop.moveVert newDefaultSofa #{1..6, 25..30} [0,-sofaLength.value + 10,0]	

		--Si el ancho o largo del brazo es < 0, no elevamos el mismo
		if (armWidth.value <= 0  or armLength.value <= 0  ) do armHeight.value = 0
		polyop.extrudeFaces newDefaultSofa #{22, 24} armHeight.value
		polyop.moveVert newDefaultSofa #{7..12, 31..36, 49..50, 53..54} [0,5,0]
		
		--Evaluamos los limites del reposabrazos y ajustamos los valores maximos
		if armLength.value + 5 > sofaLength.value do armLength.value = sofaLength.value - 1
		polyop.moveVert newDefaultSofa #{7..12, 31..36, 49..50, 53..54} [0,-armLength.value,0]	
		polyop.moveVert newDefaultSofa #{19..24, 43..48} [0,-6.5 ,0]	
		
		--Evaluamos y extruimos los reposabrazos
		if armWidth.value <= 0 do armHeight.value = 0	
		polyop.extrudeFaces newDefaultSofa #{39..43} backLength.value		
		
		--Evaluamos y extruimos el respaldo
		if (backWidth.value <= 0 ) do backHeight.value = 0
		polyop.extrudeFaces newDefaultSofa #{59} backHeight.value
	
		--Ajustamos el ancho relativo de los reposabrazos respecto al respaldo
		polyop.moveVert newDefaultSofa #{45, 61, 69, 72} [-armWidth.value,0,0]	
		polyop.moveVert newDefaultSofa #{46, 62, 70..71} [armWidth.value,0,0]	
		
		--Ajustamos el valor minimo del respaldo segun la formula de las proporciones del sofa
		polyop.moveVert newDefaultSofa #{45, 61, 69, 72} [sofaWidth.value/2.5 + sofaWidth.value/33.3 ,0,0]	
		polyop.moveVert newDefaultSofa #{46, 62, 70..71} [-(sofawidth.value/2.5 + sofaWidth.value/33.3),0,0]	
		
		--Ajustamos el valor minimo del respaldo segun la formula de las proporciones del sofa
		if (backWidth.value > (sofaWidth.value/2 - sofaWidth.value/20)) do backWidth.value = (sofaWidth.value/2 - sofaWidth.value/20)
		polyop.moveVert newDefaultSofa #{45, 61, 69, 72} [-backWidth.value ,0,0]	
		polyop.moveVert newDefaultSofa #{46, 62, 70..71} [backWidth.value,0,0]	
	)
)
createDialog objectResizerRollout