local moduloDatos = require(script.Parent.Datos_Comportidos)

--------------------------------------
-------------- SERVICIOS -------------
--------------------------------------
local ReplicatedStorage = moduloDatos.Module_obtenerValor("ReplicatedStorage")
local Lighting = moduloDatos.Module_obtenerValor("Lighting")
local UserInputService = moduloDatos.Module_obtenerValor("UserInputService")
local TweenService = moduloDatos.Module_obtenerValor("TweenService")
local Players = moduloDatos.Module_obtenerValor("Players")
local SCP_096_Scramble  = game.Workspace.SCPs.SCP_096.Scramble.Particles

--------------------------------------
------------- UBICACIONES ------------
--------------------------------------
local localPlayer = moduloDatos.Module_obtenerValor("localPlayer")
local interfazCompletaEspecial = moduloDatos.Module_obtenerValor("interfazCompletaVisionEspecial")
local carpetaEventosLocales = moduloDatos.Module_obtenerValor("carpetaEventosLocales")
local listaHabilidades = moduloDatos.Module_obtenerValor("interfazLimitada").Interfaz_Dinero_Habilidades.Habilidades
local colorAmarillo = moduloDatos.Module_obtenerValor("colorAmarillo")
local colorNegro = moduloDatos.Module_obtenerValor("colorNegro")
local colorVerde = moduloDatos.Module_obtenerValor("colorVerde")
local visionColorCorrectionEffect = Lighting:WaitForChild("visualEffect") -- Efecto visual NVG y Termica

--------------------------------------
---------------- OTROS ---------------
--------------------------------------
local remoteEventNVGAnimationEquip = ReplicatedStorage:WaitForChild("AnimacionNVG")
local CarpetaSCPJugables = ReplicatedStorage:WaitForChild("SCP_Local_Jugador") -- Acceder correctamente a SCP_Local_Jugador
local RemoteEventNVGAnimation = ReplicatedStorage:WaitForChild("AnimacionNVG") -- Ejecuta la animacion de la NVG
local ACSNVG = carpetaEventosLocales:WaitForChild("ACSNVG") -- Activa o desactiva las funciones NVG que tiene ACS
local sonidoNVG = script.SonidoActivar
local Noise = interfazCompletaEspecial.Noise -- Efecto vision nocturna 1
local Overlay = interfazCompletaEspecial.Overlay -- Efecto vision nocturna 2
local exposureOriginal = Lighting.ExposureCompensation
local info = TweenInfo.new(.5,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut)

--------------------------------------
------------ VALORES BOLT  -----------
--------------------------------------
local NVGActiva = false -- Vision nocturna activa
local VTActiva = false -- Vision termica activa
local VSActiva = false -- Vision especila activa
local visionInvisible = false -- Si no tiene casco o elemento visible la vision especial
local procesando = false -- Indica que se esta ejecutando un proceso
local apagar = false
local configurar = false
local procesandoTecla = false

--------------------------------------
------------ VALORES NIL  ------------
--------------------------------------
local modeloHelmet = nil -- Guarda el modelo del helmet
local configuracionNVG = nil -- Guarda la configuracion de la vision nocturna
local conexionVTNuevoJugador = nil
local conexionVTSalidaJugador = nil
local conexionTemporal = nil
local conexionTeclaNVG = nil
local conexionBotonNVG = nil
local conexionTeclaVT = nil
local conexionBotonVT = nil
local conexionTeclaVS = nil
local conexionBotonVS = nil

--------------------------------------
--------------- ARRAYS ---------------
--------------------------------------
local modulo = {}
local typeOfVision = {} -- Guarda el tipo de vision
local conexionesJugadoresVT = {}
local animacionVisualVS_On = {}
local animacionVisualVS_Off = {}
local animacionVisualNVG_On = {}
local animacionVisualNVG_Off = {}
local NVG_GUI_Effect = { -- Efectos vision nocturna al estar activa
	dark = {
		src = {
			460199742,
			460199916,
			460200108,
			460200265,
			460200379,
			460200555,
		},
	},

	light = {
		src = {
			460107714,
			460107818,
			460107958,
			460108053,
			460108179,
			460108373
		},	
	},
}
local animacionVTOn = { -- Animacion de activacion de la termica
	TweenService:Create(visionColorCorrectionEffect,info,{Saturation = -1, TintColor = Color3.fromRGB(125, 108, 84)}),
}
local animacionVTOff = { -- Animacion al desactivar la termica
	TweenService:Create(visionColorCorrectionEffect,info,{Saturation = 0, TintColor = Color3.fromRGB(255, 255, 255)}),
}

--------------------------------------
------------ CARGAR VISION -----------
--------------------------------------
function cargarVision(esPeticion) -- Cargar o descargar vision nocturna
	typeOfVision = moduloDatos.Module_obtenerValor("typeOfVision")
	modeloHelmet = localPlayer.Character:FindFirstChild("Helmet") -- Evita problemas

	if typeof(typeOfVision) == "table" and (typeOfVision[2] == "NVG" or typeOfVision[3] == "NVG") then
		if not (conexionTeclaNVG or conexionBotonNVG) then
			listaHabilidades.NVG.Visible = true
			conexionTeclaNVG = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
				if input.KeyCode == Enum.KeyCode.N and not (gameProcessedEvent or (procesando or procesandoTecla) or moduloDatos.Module_obtenerValor("cargandoJugador") or moduloDatos.Module_obtenerValor("menuAbierto")) then
					procesandoTecla = true
					if VTActiva then
						VTActivarDesactivar()
					elseif VSActiva then
						VSActivarDesactivar()
					end
					NVGActivarDesactivar()
					procesandoTecla = false
				end
			end)
			conexionBotonNVG = listaHabilidades.NVG.MouseButton1Click:Connect(function()
				if not ((procesando or procesandoTecla) or moduloDatos.Module_obtenerValor("cargandoJugador") or moduloDatos.Module_obtenerValor("menuAbierto")) then
					procesandoTecla = true
					if VTActiva then
						VTActivarDesactivar()
					elseif VSActiva then
						VSActivarDesactivar()
					end
					NVGActivarDesactivar()
					procesandoTecla = false
				end
			end)
		end
	elseif conexionTeclaNVG or conexionBotonNVG then
		listaHabilidades.NVG.Visible = false
		conexionTeclaNVG:Disconnect()
		conexionBotonNVG:Disconnect()
		conexionTeclaNVG = nil
		conexionBotonNVG = nil
	end

	if typeof(typeOfVision) == "table" and (typeOfVision[2] == "VT" or typeOfVision[3] == "VT") then
		if not (conexionTeclaVT or conexionBotonVT) then
			listaHabilidades.VT.Visible = true
			conexionTeclaVT = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
				if input.KeyCode == Enum.KeyCode.B and not (gameProcessedEvent or (procesando or procesandoTecla) or moduloDatos.Module_obtenerValor("cargandoJugador") or moduloDatos.Module_obtenerValor("menuAbierto")) then
					procesandoTecla = true
					if NVGActiva then
						NVGActivarDesactivar()
					end
					VTActivarDesactivar()
					procesandoTecla = false
				end
			end)
			conexionBotonVT = listaHabilidades.VT.MouseButton1Click:Connect(function()
				if not ((procesando or procesandoTecla) or moduloDatos.Module_obtenerValor("cargandoJugador") or moduloDatos.Module_obtenerValor("menuAbierto")) then
					procesandoTecla = true
					if NVGActiva then
						NVGActivarDesactivar()
					end
					VTActivarDesactivar()
					procesandoTecla = false
				end
			end)
		end
	elseif conexionTeclaVT or conexionBotonVT then
		listaHabilidades.VT.Visible = false
		conexionTeclaVT:Disconnect()
		conexionBotonVT:Disconnect()
		conexionTeclaVT = nil
		conexionBotonVT = nil
	end

	if typeof(typeOfVision) == "table" and (typeOfVision[2] == "VS" or typeOfVision[3] == "VS") then
		if not (conexionTeclaVS or conexionBotonVS) then
			listaHabilidades.VS.Visible = true
			conexionTeclaVS = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
				if input.KeyCode == Enum.KeyCode.B and not (gameProcessedEvent or (procesando or procesandoTecla) or moduloDatos.Module_obtenerValor("cargandoJugador") or moduloDatos.Module_obtenerValor("menuAbierto")) then
					procesandoTecla = true
					if NVGActiva then
						NVGActivarDesactivar()
					end
					VSActivarDesactivar()
					procesandoTecla = false
				end
			end)
			conexionBotonVS = listaHabilidades.VS.MouseButton1Click:Connect(function()
				if not ((procesando or procesandoTecla) or moduloDatos.Module_obtenerValor("cargandoJugador") or moduloDatos.Module_obtenerValor("menuAbierto")) then
					procesandoTecla = true
					if NVGActiva then
						NVGActivarDesactivar()
					end
					VSActivarDesactivar()
					procesandoTecla = false
				end
			end)
		end
	elseif conexionTeclaVS or conexionBotonVS then
		listaHabilidades.VS.Visible = false
		conexionTeclaVS:Disconnect()
		conexionBotonVS:Disconnect()
		conexionTeclaVS = nil
		conexionBotonVS = nil
	end

	if typeOfVision and modeloHelmet then
		if typeOfVision[1] == true then -- Si la NVG es visible
			visionInvisible = false
			configuracionNVG = modeloHelmet.Up:WaitForChild("NVG_Settings")
			animacionBajarNVG = localPlayer.Character.Humanoid:LoadAnimation(script.Down)
			animacionSubirNVG = localPlayer.Character.Humanoid:LoadAnimation(script.Up)
		else -- Si es invisible
			visionInvisible = true
			configuracionNVG = modeloHelmet:WaitForChild("NVG_Settings")
		end

		Overlay.Image = "rbxassetid://"..configuracionNVG.OverlayImage.Value -- Carga el efecto visual de la NVG en la interfaz

		animacionVisualNVG_On = {
			TweenService:Create(Lighting,info,{ExposureCompensation = 3}),
			TweenService:Create(Lighting,info,{EnvironmentDiffuseScale = 1}),
			TweenService:Create(visionColorCorrectionEffect,info,{Brightness = 0.7,Contrast = 1,Saturation = -1,TintColor = configuracionNVG.VisionColor.Value}),
			TweenService:Create(Overlay,info,{ImageTransparency = 0}),
			TweenService:Create(Noise,info,{ImageTransparency = 0}),
		}

		animacionVisualNVG_Off = {
			TweenService:Create(Lighting,info,{ExposureCompensation = exposureOriginal}),
			TweenService:Create(Lighting,info,{EnvironmentDiffuseScale = 0}),
			TweenService:Create(visionColorCorrectionEffect,info,{Brightness = 0,Contrast = 0,Saturation = 0,TintColor = Color3.fromRGB(255, 255, 255)}),
			TweenService:Create(Overlay,info,{ImageTransparency = 1}),
			TweenService:Create(Noise,info,{ImageTransparency = 1})
		}

		animacionVisualVS_On = {
			TweenService:Create(Lighting,info,{ExposureCompensation = 0}),
			TweenService:Create(Lighting,info,{EnvironmentDiffuseScale = 1}),
			TweenService:Create(visionColorCorrectionEffect,info,{Brightness = 0,Contrast = -0.2,Saturation = -1,TintColor = Color3.fromRGB(255, 255, 255)}),
			TweenService:Create(Overlay,info,{ImageTransparency = 0}),
			TweenService:Create(Noise,info,{ImageTransparency = 0}),
		}

		animacionVisualVS_Off = {
			TweenService:Create(Lighting,info,{ExposureCompensation = exposureOriginal}),
			TweenService:Create(Lighting,info,{EnvironmentDiffuseScale = 0}),
			TweenService:Create(visionColorCorrectionEffect,info,{Brightness = 0,Contrast = 0,Saturation = 0,TintColor = Color3.fromRGB(255, 255, 255)}),
			TweenService:Create(Overlay,info,{ImageTransparency = 1}),
			TweenService:Create(Noise,info,{ImageTransparency = 1})
		}
	end
end

local function playtween(tweentbl)
	spawn(function()
		for _,step in pairs(tweentbl) do
			if typeof(step) == "number" then
				task.wait(step)
			else
				step:Play()
			end
		end
	end)
end

--------------------------------------
-------- SCRIPT VISION TERMICA -------
--------------------------------------
local function ponerMarcaTermica(otherCharacter) -- Funcion propia de la vision termica
	local highlightClone = script.VTVision:Clone()
	repeat task.wait() until otherCharacter -- Espera a que el caracter del jugador aparezca
	highlightClone.Parent = otherCharacter
end

local function conectarJugador(otherPlayer)
	
	conexionTemporal = otherPlayer.CharacterAdded:Connect(function(character)
		ponerMarcaTermica(character)
	end)
	table.insert(conexionesJugadoresVT, {player = otherPlayer.Name, conexion = conexionTemporal})

	if otherPlayer.Character then
		ponerMarcaTermica(otherPlayer.Character)
	end
end

function VTActivarDesactivar(obligatorio, esPeticion) -- Control VT

	if not obligatorio then
		listaHabilidades.VT.BackgroundColor3 = colorAmarillo
	end

	VTActiva = not VTActiva

	if VTActiva then -- Si la termica se tiene que activar

		playtween(animacionVTOn)

		conexionVTNuevoJugador = Players.PlayerAdded:Connect(conectarJugador)
		conexionVTSalidaJugador = Players.PlayerRemoving:Connect(function(player) -- Elimina las conexiones del jugador que se a ido del juego
			for i, data in ipairs(conexionesJugadoresVT) do
				if data.player == player.Name then
					data.conexion:Disconnect()
					table.remove(conexionesJugadoresVT, i)
					break
				end
			end
		end)
		
		for _, otherPlayers in pairs(Players:GetPlayers()) do
			if localPlayer ~= otherPlayers then
				conectarJugador(otherPlayers)
			end
		end
	else -- Si no se tiene que activar
		conexionVTNuevoJugador:Disconnect() -- Elimina la conexion de nuevos jugadores
		conexionVTNuevoJugador = nil -- Lo deja vacio
		
		conexionVTSalidaJugador:Disconnect() -- Elimina la conexion de nuevos jugadores
		conexionVTSalidaJugador = nil -- Lo deja vacio

		-- Desconectar todas las conexiones en la tabla
		for i, data in ipairs(conexionesJugadoresVT) do
			data.conexion:Disconnect()
		end
		conexionesJugadoresVT = {}


		playtween(animacionVTOff) -- Animacion visual de la VT

		for _, otherPlayers in pairs(Players:GetPlayers()) do -- Busca entre todos los jugadores el Highlight
			if otherPlayers ~= localPlayer and otherPlayers.Character and otherPlayers.Character:FindFirstChild("VTVision") then
				otherPlayers.Character.VTVision:Destroy()
			end
		end
	end

	if not obligatorio then task.wait(0.5) end -- Espera final

	listaHabilidades.VT.BackgroundColor3 = VTActiva and colorVerde or colorNegro -- Boton interfaz
end

--------------------------------------
------- SCRIPT VISION NOCTURNA -------
--------------------------------------
local function NVGCycle(grain)
	local label = Noise
	local source = grain.src
	local newframe
	repeat newframe = source[math.random(1, #source)]; 
	until newframe ~= grain.last 
	label.Image = 'rbxassetid://'..newframe
	local rand = math.random(230,255)
	label.Position = UDim2.new(math.random(.4,.6),0,math.random(.4,.6),0)
	label.ImageColor3 = Color3.fromRGB(rand,rand,rand)
	grain.last = newframe
end

function NVGActivarDesactivar(obligatorio)  -- Control NVG
	NVGActiva = not NVGActiva

	if not obligatorio then -- Pasa de poner el boton en amarillo si es obligatorio
		listaHabilidades.NVG.BackgroundColor3 = colorAmarillo
	end

	if NVGActiva then -- Activa la vision termica si es true
		if not visionInvisible then -- Si la NVG es visible
			remoteEventNVGAnimationEquip:FireServer(true) -- Equipar vision nocturna
			animacionSubirNVG:Play()
			if not visionInvisible then task.wait(0.7) end -- Espera X tiempo si no es invisible
			script.SonidoActivar:Play()
		end
		ACSNVG:Fire(NVGActiva)
		playtween(animacionVisualNVG_On)
		spawn(function() -- Animacion visual en bucle
			while NVGActiva do 
				NVGCycle(NVG_GUI_Effect.dark)
				NVGCycle(NVG_GUI_Effect.light)
				task.wait(0.05)
			end
		end)
		if not visionInvisible then task.wait(0.7) end -- Espera X tiempo si no es invisible
	else -- Desactiva la vision nocturna si es false
		if not visionInvisible and not obligatorio then -- Si la NVG no es invisible
			remoteEventNVGAnimationEquip:FireServer(false) -- Desequipar vision nocturna
			animacionBajarNVG:Play()
			if not visionInvisible then task.wait(0.7) end -- spera X tiempo si no es invisible o si no es obligatorio
		end
		ACSNVG:Fire(NVGActiva)
		playtween(animacionVisualNVG_Off)
		if not visionInvisible and not obligatorio then task.wait(0.7) end -- Espera X tiempo si no es invisible o si no es obligatorio
	end

	if not obligatorio then task.wait(0.5) end -- Espera final
	listaHabilidades.NVG.BackgroundColor3 = NVGActiva and colorVerde or colorNegro -- Boton interfaz
end

--------------------------------------
-------- SCRIPT VISION SCREAM  -------
--------------------------------------
function VSActivarDesactivar(obligatorio)  -- Control NVG
	VSActiva = not VSActiva

	if not obligatorio then -- Pasa de poner el boton en amarillo si es obligatorio
		listaHabilidades.VS.BackgroundColor3 = colorAmarillo
	end

	if VSActiva then -- Activa la vision termica si es true
		if not visionInvisible then -- Si la NVG es visible
			remoteEventNVGAnimationEquip:FireServer(true) -- Equipar vision nocturna
			animacionSubirNVG:Play()
			if not visionInvisible then task.wait(0.7) end -- Espera X tiempo si no es invisible
			script.SonidoActivar:Play()
		end
		ACSNVG:Fire(VSActiva)
		playtween(animacionVisualVS_On)
		SCP_096_Scramble.Enabled = true
		spawn(function() -- Animacion visual en bucle
			while VSActiva do 
				NVGCycle(NVG_GUI_Effect.dark)
				NVGCycle(NVG_GUI_Effect.light)
				task.wait(0.05)
			end
		end)
		if not visionInvisible then task.wait(0.7) end -- Espera X tiempo si no es invisible
	else -- Desactiva la vision nocturna si es false
		if not visionInvisible and not obligatorio then -- Si la NVG no es invisible
			remoteEventNVGAnimationEquip:FireServer(false) -- Desequipar vision nocturna
			animacionBajarNVG:Play()
			if not visionInvisible then task.wait(0.7) end -- spera X tiempo si no es invisible o si no es obligatorio
		end
		SCP_096_Scramble.Enabled = false
		ACSNVG:Fire(VSActiva)
		playtween(animacionVisualVS_Off)
		if not visionInvisible and not obligatorio then task.wait(0.7) end -- Espera X tiempo si no es invisible o si no es obligatorio
	end

	if not obligatorio then task.wait(0.5) end -- Espera final
	listaHabilidades.VS.BackgroundColor3 = VSActiva and colorVerde or colorNegro -- Boton interfaz
end

--------------------------------------
---------- ACCIONES VISIONES ---------
--------------------------------------
function modulo.accionVisionEspecial(accion)

	if accion == "Apagar" then -- Apagar la vision especial
		apagar = true
	elseif accion == "Configurar" then -- Configurar la vision especial
		configurar = true
	end

	if not procesando then
		procesando = true
		
		while procesandoTecla do
			task.wait()
			print("Esperando")
		end
		
		while true do
			task.wait()

			if apagar then -- Apagar la vision especial
				if NVGActiva then -- Desactiva la vision nocturna si esta activa
					NVGActivarDesactivar(true) -- Desactivacion obligatoria
				elseif VTActiva then -- Desactiva la vision termica si esta activa
					VTActivarDesactivar(true) -- Desactivacion obligatoria
				elseif VSActiva then -- Desactiva la vision termica si esta activa
					VSActivarDesactivar(true) -- Desactivacion obligatoria
				end
				apagar = false
			end

			if configurar then -- Configurar la vision especial
				if NVGActiva then
					NVGActivarDesactivar(true)
				elseif VTActiva then
					VTActivarDesactivar(true)
				elseif VSActiva then
					VSActivarDesactivar(true)
				end
				cargarVision()
				configurar = false
			end

			if not apagar and not configurar then
				procesando, configurar, apagar = false, false, false
				break
			end

		end
	end
end

return modulo