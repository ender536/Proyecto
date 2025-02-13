local moduloDatos = require(script.Datos_Comportidos)
local moduloSCP = require(script.Habilidades_SCP) -- Desactivado por ahora
local moduloTrajes = require(script.Panel_Selector_Trajes)
local moduloVisiones = require(script.Visiones_Especiales)
local moduloEncriptamiento = require(script.Encriptamiento)
local moduloDinero = require(script.Dinero)
local moduloSalud = require(script.Salud)
local moduloKillNotification = require(script.Kill_Notification)

--------------------------------------
-------------- SERVICIOS -------------
--------------------------------------
local ReplicatedStorage = moduloDatos.Module_obtenerValor("ReplicatedStorage") -- Servicio que almacena elementos de los jugadores
local UserInputService = moduloDatos.Module_obtenerValor("UserInputService") -- Servicio para detectar las teclas que presiona el jugador

--------------------------------------
----------------- GUI ----------------
--------------------------------------
local interfazCompleta = moduloDatos.Module_obtenerValor("interfazCompleta") -- GUI que ocupa toda la pantalla, incluso los limites
local botonesRapidos = moduloDatos.Module_obtenerValor("botonesRapidos") --Botones para el panel de trajes y para volver al menu

--------------------------------------
------------- UBICACIONES ------------
--------------------------------------
local carpetaEventosLocales = moduloDatos.Module_obtenerValor("carpetaEventosLocales") -- Carpeta de eventos remotos locales del jugador
local localPlayer = moduloDatos.Module_obtenerValor("localPlayer") -- Entidad jugador local

--------------------------------------
--------------- EVENTOS --------------
--------------------------------------
local remoteFunctionResetPlayer = moduloDatos.Module_obtenerValor("remoteFunctionResetPlayer") -- Funcion remota para reiniciar al jugador
local remoteFunctionEquipGear = ReplicatedStorage:WaitForChild("EquiparGear") -- Funcion remota para equipar al jugador con todo (traje, armas, visiones especiales)
local remoteFunctionEquipTag = ReplicatedStorage:WaitForChild("EquiparTag") -- Funcion remota para equipar al jugador con todo (traje, armas, visiones especiales)
local bindableEventAbrirMenu = carpetaEventosLocales:WaitForChild("AbrirMenu") -- Evento local que le indica al menu que debe abrirse
local bindableEventMenuCerrado = carpetaEventosLocales:WaitForChild("MenuCerrado") -- Evento local que indica a este script que el menu a sido cerrado
local remoteEventPlayerLoaded = ReplicatedStorage:WaitForChild("Player_Loading_Completed") -- Funcion remota para equipar al jugador con todo (traje, armas, visiones especiales)

--------------------------------------
--------------- COLORES --------------
--------------------------------------
local colorAmarillo = moduloDatos.Module_obtenerValor("colorAmarillo")
local colorNegro = moduloDatos.Module_obtenerValor("colorNegro")
local colorGris = moduloDatos.Module_obtenerValor("colorGris")
local colorVerde = moduloDatos.Module_obtenerValor("colorVerde")
local colorRojo = moduloDatos.Module_obtenerValor("colorRojo")

--------------------------------------
-------------- LIGHTING --------------
--------------------------------------
local NVGColorCorrectionEffect = moduloDatos.Module_obtenerValor("NVG_TVColorCorrectionEffect") -- Efecto vision especial

--------------------------------------
------------- CONEXIONES -------------
--------------------------------------
local conexionMuerteJugador = nil

--------------------------------------
------------- VALORES NIL ------------
--------------------------------------
local newTeam = nil -- Guarda el nuevo team del jugador
local actualTema = nil -- Guarda el team actual del jugador
local typeOfVision = nil -- Guarda la inforamcion de la vision especial

--------------------------------------
---------- VALORES NIL MENU ----------
--------------------------------------
local primeraPulsacion = nil -- Cuando a sido pulsado la primera pulsacion
local tiempoPrimeraPulsacion = nil -- Tiempo transcurido desde la ultima pulsacion
local tiempoMaximo = 1.5 -- Tiempo maximo antes de reiniciar las pulsaciones

--------------------------------------
------------ VALORES BOOLT -----------
--------------------------------------
local cancelarCarga = false -- Cancela la carga del jugador y la reinicia
local reiniciarJugador = false -- Reinicia al jugador una vez se reinicia la carga
local cargandoJugador = moduloDatos.Module_obtenerValor("cargandoJugador") -- Indica si se esta cargando el jugador actualmente
local cooldownCambioTeam = false -- Cooldown que evita que el jugador se reinicie de nuevo al reaparecer por cambiarse de team
local menuAbierto = moduloDatos.Module_obtenerValor("menuAbierto") -- Indica si el menu esta abierto o no

--------------------------------------
-------------- FUNCIONES -------------
--------------------------------------
local function canelarCarga() -- Funcion que revisa si hace falta cancelar la carga del jugador y repetirla
	if (cancelarCarga or menuAbierto) then -- En caso de que la carga se haya cancelado o el menu este abierto
		cancelarCarga = false
		return true
	end
	return false
end

local function equiparJugador() -- Funcion que equipa al jugador cuando se genera
	while true do
		if not menuAbierto then -- Si la funcion se vuelve a repetir revisara si el menu esta abierto
			if not reiniciarJugador then -- Si se vuelve a repetir revisara si hace falta reinciiar al jugador
				interfazCompleta.Parent.Inventario.Enabled = false
				repeat task.wait() until localPlayer.Character -- Espera a que el caracter del jugador aparezca en el mapa

				if conexionMuerteJugador then -- Desconecta la conexion de muerte si esta conectada
					conexionMuerteJugador:Disconnect()
				end

				if cooldownCambioTeam then -- Indica que el cambio de team a terminado si existe el cooldown
					cooldownCambioTeam = false
				end
				
				remoteFunctionEquipTag:InvokeServer(localPlayer.Character)

				-- Carga el equipamiento del personaje (tools y trajes) y activa o desactiva el panel de trajes
				if not canelarCarga() then -- Revisa si se tiene que interumpir la carga del jugador
					newTeam = localPlayer.Team.Name -- Pilll el nuevo o actual team del jugador
					if newTeam ~= actualTema  then -- Si el team nuevo y viejo son diferentes significa que ha cambiado de team
						actualTema = newTeam -- Almacena el nuevo team
						moduloDatos.Module_establecerValor("actualTema", newTeam)

						moduloTrajes.accionPanelTrajes("PreCargar") -- Pre carga la configuracion del traje del jugador
						task.spawn(function() -- Asíncrono
							moduloTrajes.accionPanelTrajes("Configurar") -- Carga la configuracion de los trajes en el panel visual
							moduloEncriptamiento.encriptamiento()
						end)
					end

					typeOfVision = remoteFunctionEquipGear:InvokeServer(localPlayer.Character, moduloDatos.Module_obtenerValor("actualDivision"),moduloDatos.Module_obtenerValor("actualUnit"), actualTema)
					moduloDatos.Module_establecerValor("typeOfVision", typeOfVision)

				else -- Reinicia el while
					continue
				end

				task.spawn(function() -- Actualiza la interfaz de salud del jugador
				moduloSalud.actualizarSalud()
				end)

				-- Cargar modulo de vision especial del jguador (NVG, VT, VS)
				if not canelarCarga() then -- Revisa si se tiene que interumpir la carga del jugador
					task.spawn(function() -- Asíncrono
						moduloVisiones.accionVisionEspecial("Configurar") -- Configura la vision especial
					end)
				else
					continue
				end

				-- Habilidades de SCP
				if not canelarCarga() then -- Revisa si se tiene que interumpir la carga del jugador
					moduloSCP.accionSCP()
				else
					continue
				end

				-- Conexion que detecta cuando el jugador muere
				if not canelarCarga() then -- Revisa si se tiene que interumpir la carga del jugador
					conexionMuerteJugador = localPlayer.Character.Humanoid.Died:Connect(function() -- Conexion de muerte
						conexionMuerteJugador:Disconnect()

						task.spawn(function() -- Asíncrono
							moduloVisiones.accionVisionEspecial("Apagar") -- Apaga la vision especial especial
						end)
					end)
				else
					continue
				end

				if not canelarCarga() then -- Revisa si se tiene que interumpir la carga del jugador
					
				else
					continue
				end

				if not canelarCarga() then -- Ultima revision antes de terminar el proceso
					remoteEventPlayerLoaded:FireServer(localPlayer.Character)
					interfazCompleta.Parent.Inventario.Enabled = true
					cargandoJugador, cancelarCarga = false, false
					moduloDatos.Module_establecerValor("cargandoJugador", cargandoJugador) -- Guarda en el modulo si esta actualmetne en carga el personaje
					print("[FIN DE LA CARGA DEL JUGADOR]")
					break
				else
					continue
				end
			else
				remoteFunctionResetPlayer:InvokeServer() -- Reinicia al jugador
				reiniciarJugador, cancelarCarga, cooldownCambioTeam = false, false, true
				continue
			end
		else -- Si el menu esta abierto
			cargandoJugador, reiniciarJugador, cancelarCarga = false, false, false
			moduloDatos.Module_establecerValor("cargandoJugador", cargandoJugador)
			break
		end
	end
end

local function abrirMenu(saltarComprobacion) -- Funcion para abrir el menu
	local tiempoActual = tick()

	if not saltarComprobacion and not primeraPulsacion then -- Si no hay que saltar la comprobacion y es la primera vez que se presiona la M
		primeraPulsacion = true
		tiempoPrimeraPulsacion = tiempoActual
		script.MenuBeep:Play()
		task.wait(tiempoMaximo)
		primeraPulsacion = false
	elseif saltarComprobacion or tiempoActual - tiempoPrimeraPulsacion <= tiempoMaximo then -- Si hay que saltar la comprobacion o es la seguna pulsacion en el tiempo correcto
		menuAbierto = true
		moduloDatos.Module_establecerValor("menuAbierto", menuAbierto) -- Guarda en el modulo si esta actualmetne en carga el personaje

		while cargandoJugador do -- En caso de que el jugador se este cargando espera hasta que finalice
			task.wait()
		end
		
		moduloVisiones.accionVisionEspecial("Apagar")
		moduloTrajes.accionPanelTrajes("Cerrar") -- Carga la configuracion de los trajes en el panel visual
		
		bindableEventAbrirMenu:Fire()
	else -- Reinicia el ciclo si la segunda pulsacion se hace fuera de tiempo
		primeraPulsacion = false
	end
end

--------------------------------------
--------- SCRIPTS PRINCIPALES --------
--------------------------------------
localPlayer.CharacterAdded:Connect(function() -- Detectar cuando el jugador aparece en el mapa
	print("[JUGADOR GENERADO]")
	if not menuAbierto then  -- Si el menu no esta abierto
		if not cargandoJugador then -- Si el jugador no se esta cargando
			cargandoJugador = true
			moduloDatos.Module_establecerValor("cargandoJugador", cargandoJugador) -- Guarda en el modulo si esta actualmetne en carga el personaje
			equiparJugador()
		elseif not cooldownCambioTeam then -- Si el team no esta en cooldown cancela la carga, evita que se ejecute si el
			cancelarCarga = true
		end
	end
end)

localPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Detectar cuando el jugador cambia de team
	print("[TEAM CAMBIADO]")
	if not menuAbierto then -- Si el menu no esta abierto
		if not cooldownCambioTeam and not cargandoJugador then -- Si el cambio de team no esta en cooldown y el jugador no se esta cargando
			cooldownCambioTeam, cargandoJugador = true, true
			moduloDatos.Module_establecerValor("cargandoJugador", cargandoJugador) -- Guarda en el modulo si esta actualmetne en carga el personaje
			remoteFunctionResetPlayer:InvokeServer() -- Reinicia al jugador
			equiparJugador() -- Funcion para equipar al jugador
		else -- Si el cambio de team esta en cooldown y el jugador cargandose cancela todo el proceso
			reiniciarJugador, cancelarCarga = true, true
		end
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent) -- Tecla M para abrir el menu
	if input.KeyCode == Enum.KeyCode.M and not (gameProcessedEvent or menuAbierto) then -- Si el menu no esta abierto y no esta escribiendo
		abrirMenu(false) -- Funcion para abrir el menu
	end
end)

interfazCompleta.Interfaz_Botones_Rapidos.Menu.MouseButton1Click:Connect(function() -- Boton para abrir el menu
	if not menuAbierto then -- Si el menu no esta abierto
		abrirMenu(true) -- Una pulsacion para abrir el menu
	end
end)

bindableEventMenuCerrado.Event:Connect(function(menuActivo) -- Evento remoto que se activa cuando el menu es cerrado
	menuAbierto = menuActivo
	moduloDatos.Module_establecerValor("menuAbierto", menuAbierto) -- Guarda en el modulo si esta actualmetne en carga el personaje
end)