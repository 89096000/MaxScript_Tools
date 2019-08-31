--If this dialog was already created we destroy the previous one
try(destroyDialog FBX_Export) catch()

--In order to save the parameters for each radio button option, we create arrays for them
global staticMeshParameters =#(true,false,false,false,false,false,false,false,false,false,false,false)
global skeletalMeshParameters =#(true,false,false,false,false,false,false,false,false,true,true,true)
global animationParameters =#(false,false,false,false,false,false,false,true,true,false,true,true)

--Main Rollout
rollout FBX_Export "FBX_Export" width:312 height:472
(
	--Upper Group
	label 'lbl_Title' "FBX Export" pos:[128,8] width:56 height:21 align:#left
	button 'btn_Create' "Create Asset" pos:[24,40] width:264 height:32 align:#left
	
	--Radio Butons ( StaticMesh / SkeletalMesh / Animation )
	radiobuttons 'rdo_AssetType' "" pos:[16,104] width:293 height:16 labels:#("Static Mesh", "Skeletal Mesh", "Animation") default:1 columns:3 align:#left
	
	--Export Settings CheckBoxes
	GroupBox 'grp_AssetType'       "Asset Type" pos:[8,80] width:296 height:48 align:#left
	checkbox 'chk_SmthGroups'      "Smoothing Groups" pos:[16,152] width:288 height:16 align:#left
	checkbox 'chk_SplitperVertex'  "Split per-vertex Normals" pos:[16,168] width:288 height:16 align:#left
	checkbox 'chk_TangBinom'       "Tangents and Binomials" pos:[16,184] width:288 height:16 align:#left
	checkbox 'chk_TurboSmooth'     "Turbosmooth" pos:[16,200] width:288 height:16 align:#left
	checkbox 'chk_PreserveInstances' "Preserve Instances" pos:[16,216] width:288 height:16 align:#left
	checkbox 'chk_SelectionSets' "Selection Sets" pos:[16,232] width:288 height:16 align:#left
	checkbox 'chk_ConvertDDtoBones' "Convert Deforming Dummies to bones" pos:[16,248] width:288 height:16 align:#left
	checkbox 'chk_Anim' "Animation" pos:[16,264] width:288 height:16 align:#left
	checkbox 'chk_BakeAnim' "Bake Animation" pos:[16,280] width:288 height:16 align:#left
	checkbox 'chk_Deform' "Deformations" pos:[16,296] width:288 height:16 align:#left
	checkbox 'chk_Skins' "Skins" pos:[16,312] width:288 height:16 align:#left
	checkbox 'chk_Morphs' "Morphs" pos:[16,328] width:288 height:16 align:#left
	
	--Export Folder input / Search
	GroupBox 'grp2' "Export Settings" pos:[8,136] width:296 height:216 align:#left
	edittext 'edt_Export' "" pos:[16,392] width:216 height:24 align:#left
	button 'btn_ExportSearch' "..." pos:[240,392] width:40 height:24 align:#left	
	
	--Lower Confirmation Boxes (Export / SaveConfig)
	GroupBox 'grp_Export' "Export Folder" pos:[8,368] width:296 height:56 align:#left
	button 'btn_Export' "Export" pos:[8,432] width:144 height:32 align:#left
	button 'btn_SaveExport' "Save Export Settings" pos:[160,432] width:144 height:32 align:#left
	
	global objectName
	
	--by default, each time the app is opened, the file path is reseted
	global filePath = undefined
	
	--Dummies are added with global accesibility
	global Root = undefined
	global Geo
	global Joint
	global Rig
	
	--As the Radio Buttons shouldn't change in some cases, we save the previous RadioButton state
	global previousState

	
	on btn_Create pressed  do
	(
	for obj in getCurrentSelection() do 
		(
			--Check of object parent and object SuperClass (not to create an asset without a geometry)
			if obj.parent == undefined and superClassOf obj  as string == "GeometryClass"  then
			(					
				Root = point location: [0,0,0] name: "Root"
				obj.parent = Root	
				objectName = obj.name
				
				--Depending of the radio button configuration the Root name is modified
				case rdo_AssetType.state of 
				(
					1: Root.name =(append "SM_" obj.name )
					2: Root.name =(append "SK_" obj.name )
					3: Root.name =(append "A_" obj.name )
					default: Root.name = obj.name
				)
				--The rest of dummies are added to the asset
				Geo = point location: [0,0,0] name: "Geo"
				Joint = point location: [0,0,0] name: "Joint"
				Rig = point location: [0,0,0] name: "Rig"

				Geo.parent = Root
				Joint.parent = Root
				Rig.parent = Root
			)
		)
	)
	
	on rdo_AssetType changed state do
	(	
		
		if state == 1 do
		(
			--If no Root is found, the user is allowed to select any parameters
			if Root == undefined do CheckBoxByArray staticMeshParameters		
			
			
			for obj in getCurrentSelection() do 
			(
				--If the object selected isn't a root, we dont allow modifications
				if obj.parent != undefined do
				(
					print "To modify already created assets, select the root node"
					FBX_Export.rdo_AssetType.state = previousState					
				)

			--Otherwise the user can modify the root
				if obj.parent == undefined do(
						previousState = state
				CheckBoxByArray staticMeshParameters
				
				if substring	obj.name 1	1 == "S" do							
				obj.name = replace obj.name 1 2 "SM"	

				if substring	obj.name 1	1 == "A" do
				obj.name = replace obj.name 1 1 "SM"						
				)
			)
		)
		
		if state == 2 do
		(
			--If no Root is found, the user is allowed to select any parameters			
			if Root == undefined do CheckBoxByArray skeletalMeshParameters	
				
			for obj in getCurrentSelection() do 
			(
				--If the object selected isn't a root, we dont allow modifications
				if obj.parent != undefined do
				(
					print "To modify already created assets, select the root node"
					FBX_Export.rdo_AssetType.state = previousState						
				)

			--Otherwise the user can modify the root
				if obj.parent == undefined do(
							previousState = state
					CheckBoxByArray skeletalMeshParameters		

					if substring	obj.name 1	1 == "S" do							
					obj.name = replace obj.name 1 2 "SK"	

					if substring	obj.name 1	1 == "A" do
					obj.name = replace obj.name 1 1 "SK"							
				)
			)
		)
		
		if state == 3 do
		(
			--If no Root is found, the user is allowed to select any parameters	
			if Root == undefined do CheckBoxByArray animationParameters			

			for obj in getCurrentSelection() do 
			(
				--If the object selected isn't a root, we dont allow modifications
				if obj.parent != undefined do
				(
					print "To modify already created assets, select the root node"
					FBX_Export.rdo_AssetType.state = previousState					
				)
				
			    --Otherwise the user can modify the root
				if obj.parent == undefined do(
							previousState = state
					CheckBoxByArray animationParameters					

					if substring	obj.name 1	1 == "S" do						
					obj.name = replace obj.name 1 2 "A"
				)
			)
		)
	)
	
	--If the Checkboxes are modifies, the state is saved on the parameter arrays
	on chk_SmthGroups changed state do
(
		if rdo_AssetType.state == 1 do staticMeshParameters[1] =state
		if rdo_AssetType.state == 2 do skeletalMeshParameters[1] = state
		if rdo_AssetType.state == 3 do animationParameters[1] = state
	)
	on chk_SplitperVertex changed state do
(
		if rdo_AssetType.state == 1 do staticMeshParameters[2] = state
		if rdo_AssetType.state == 2 do skeletalMeshParameters[2] = state
		if rdo_AssetType.state == 3 do animationParameters[2] = state
	)
	on chk_TangBinom changed state do
(
		if rdo_AssetType.state == 1 do staticMeshParameters[3] = state
		if rdo_AssetType.state == 2 do skeletalMeshParameters[3] = state
		if rdo_AssetType.state == 3 do animationParameters[3] = state
	)
	on chk_TurboSmooth changed state do
(
		if rdo_AssetType.state == 1 do staticMeshParameters[4] = state
		if rdo_AssetType.state == 2 do skeletalMeshParameters[4] = state
		if rdo_AssetType.state == 3 do animationParameters[4] = state
	)
	on chk_PreserveInstances changed state do
(
		if rdo_AssetType.state == 1 do staticMeshParameters[5] = state
		if rdo_AssetType.state == 2 do skeletalMeshParameters[5] = state
		if rdo_AssetType.state == 3 do animationParameters[5] = state
	)
	on chk_SelectionSets changed state do
(
		if rdo_AssetType.state == 1 do staticMeshParameters[6] = state
		if rdo_AssetType.state == 2 do skeletalMeshParameters[6] = state
		if rdo_AssetType.state == 3 do animationParameters[6] = state
	)
	on chk_ConvertDDtoBones changed state do
(
		if rdo_AssetType.state == 1 do staticMeshParameters[7] = state
		if rdo_AssetType.state == 2 do skeletalMeshParameters[7] = state
		if rdo_AssetType.state == 3 do animationParameters[7] = state
	)
	on chk_Anim changed state do
(
		if rdo_AssetType.state == 1 do staticMeshParameters[8] = state
		if rdo_AssetType.state == 2 do skeletalMeshParameters[8] = state
		if rdo_AssetType.state == 3 do animationParameters[8] = state
	)
	on chk_BakeAnim changed state do
(
		if rdo_AssetType.state == 1 do staticMeshParameters[9] = state
		if rdo_AssetType.state == 2 do skeletalMeshParameters[9] = state
		if rdo_AssetType.state == 3 do animationParameters[9] = state
	)
	on chk_Deform changed state do
(
		if rdo_AssetType.state == 1 do staticMeshParameters[10] = state
		if rdo_AssetType.state == 2 do skeletalMeshParameters[10] = state
		if rdo_AssetType.state == 3 do animationParameters[10] = state
	)
	on chk_Skins changed state do
(
		if rdo_AssetType.state == 1 do staticMeshParameters[11] = state
		if rdo_AssetType.state == 2 do skeletalMeshParameters[11] = state
		if rdo_AssetType.state == 3 do animationParameters[11] = state
	)
	on chk_Morphs changed state do
(
		if rdo_AssetType.state == 1 do staticMeshParameters[12] = state
		if rdo_AssetType.state == 2 do skeletalMeshParameters[12] = state
		if rdo_AssetType.state == 3 do animationParameters[12] = state
	)
	
	on edt_Export entered text do
(  
	
	)
	
	--If the [...] button is pressed, the user can select a save path
	on btn_ExportSearch pressed  do
	(		
		filePath = GetSavePath caption "Save Path: "
		edt_Export.text = filePath
	)
	
	on btn_Export pressed  do
	(
		--In order to save a file, a filepath must be given and there has to be at last one Asset in scene
		if filePath == undefined and Root == undefined do
		print "Export Error: Choose a proper path and make sure there are assets to export"
		
		if filePath != undefined and Root != undefined do
		(		
			for obj in getCurrentSelection() do 
			(
				--Only the selected ROOT NODES will be exported
				if obj.parent != undefined do
				print "Export Error: Make sure to have selected the ROOT NODES to export"
				
				if obj.parent == undefined do
				(
					--If the root node is a Static Mesh
					if substring	obj.name 1	2 == "SM" do
					(
					--The exported elements are saved in an array
					exportableElements = #()
					--The parent of those obj are also saved
					exportableObjParent = obj		
						
						print "Exporting an Static Mesh..."
						CheckBoxByArray staticMeshParameters		
						--EXPORT
						
						--the childs of root are selected
						for childObjs in obj.children do
						(
							--when we reach Geo, it's childs are selected
							if childObjs.name == "Geo" do
							(
								--The objs parent is saved (To restore them after the export)
								exportableObjParent = childObjs
								for grandChildObj in childObjs do
								(
									--The Geo node is not exported
									if grandChildObj.name !=	"Geo" do
									(
									selectMore grandChildObj
									append exportableElements grandChildObj
									grandChildObj.parent = obj										
									)
								)
							)
						)
						
						--The file is saved
						exportFile (filePath + "/" + obj.name) #noPrompt selectedOnly:true using:FBXEXP
	
						--The objs parent are restored
						for exportableElement in exportableElements do
						(
							exportableElement.parent = exportableObjParent
						)
					)
					
					--If the root node is a Skeletal Mesh
					if substring	obj.name 1	2 == "SK" do
					(
					
					--The exported elements are saved in an array
					exportableElements = #()
					exportableObjParent = obj
						
					--The parent of those obj are also saved						
					exportableElements2 = #()
					exportableObjParent2 = obj		
						
						print "Exporting an Static Mesh..."
						CheckBoxByArray staticMeshParameters		
						--EXPORT
						
						--the childs of root are selected
						for childObjs in obj.children do
						(
							--when we reach Geo, it's childs are selected
							if childObjs.name == "Geo" do
							(
								exportableObjParent = childObjs
								for grandChildObj in childObjs do
								(
									
									if grandChildObj.name !=	"Geo" do
									(
									selectMore grandChildObj
									append exportableElements grandChildObj
									grandChildObj.parent = obj										
									)
								)
							)
							--when we reach Joint, it's childs are selected
							if childObjs.name == "Joint" do
							(
								exportableObjParent2 = childObjs
								for grandChildObj in childObjs do
								(
									if grandChildObj.name !=	"Joint" do
									(
									selectMore grandChildObj
									append exportableElements2 grandChildObj
									grandChildObj.parent = obj										
									)
								)
							)
						)
						--The file is saved
						exportFile (filePath + "/" + obj.name) #noPrompt selectedOnly:true using:FBXEXP
						
						--The objects parent are restored
						for exportableElement in exportableElements do
						(
							exportableElement.parent = exportableObjParent
						)
						
						for exportableElement in exportableElements2 do
						(
							exportableElement.parent = exportableObjParent2
						)
					)
					
					if substring	obj.name 1	1 == "A" do
					(
						print "Exporting an Animation..."
						CheckBoxByArray staticMeshParameters		
						--EXPORT
						exportFile (filePath + "/" + obj.name) #noPrompt selectedOnly:true using:FBXEXP						
					)
				)
			)
		)
	)
	on btn_SaveExport pressed  do
(
	
	)
)
createDialog FBX_Export

--Function to check by array
fn CheckBoxByArray inputArray= (
	
			FBX_Export.chk_SmthGroups.checked = inputArray[1]
			FBXExporterSetParam "SmoothingGroups" inputArray[1]
	
			FBX_Export.chk_SplitperVertex.checked = inputArray[2]
			FBXExporterSetParam "NormalsPerPoly" inputArray[2]	
	
			FBX_Export.chk_TangBinom.checked = inputArray[3]
			FBXExporterSetParam "TangentSpaceExport" inputArray[3]	
	
			FBX_Export.chk_TurboSmooth.checked = inputArray[4]
			FBXExporterSetParam "SmoothMeshExport"  inputArray[4]	
	
			FBX_Export.chk_PreserveInstances.checked = inputArray[5]
			FBXExporterSetParam "Preserveinstances" inputArray[5]	
	
			FBX_Export.chk_SelectionSets.checked = inputArray[6]
			FBXExporterSetParam "SelectionSetExport" inputArray[6]	
	
			FBX_Export.chk_ConvertDDtoBones.checked = inputArray[7]
			FBXExporterSetParam "GeomAsBones" inputArray[7]	
	
			FBX_Export.chk_Anim.checked = inputArray[8]
			FBXExporterSetParam "Animation" inputArray[8]	
	
			FBX_Export.chk_BakeAnim.checked = inputArray[9]
			FBXExporterSetParam "BakeAnimation" inputArray[9]
	
			FBX_Export.chk_Deform.checked = inputArray[10]
			
			
			FBX_Export.chk_Skins.checked = inputArray[11]
			FBXExporterSetParam "Skin" inputArray[11]	
			
			FBX_Export.chk_Morphs.checked = inputArray[12]
			FBXExporterSetParam "Shape" inputArray[12]	
	)

--Default parameters are selected
CheckBoxByArray staticMeshParameters	