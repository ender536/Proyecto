local moduloDatos = require(script.Parent.Datos_Comportidos)

---------------------------------
----------- SERVICIOS -----------
---------------------------------
local ReplicatedStorage = moduloDatos.Module_obtenerValor("ReplicatedStorage")
local UserInputService = moduloDatos.Module_obtenerValor("UserInputService") 

-----------------------------------
----------- UBICACIONES -----------
-----------------------------------
local folderModuleSCPs = ReplicatedStorage:WaitForChild("SCP_Local_Jugador")
local localPlayer = moduloDatos.Module_obtenerValor("localPlayer") 

-------------------------------
----------- EVENTOS -----------
-------------------------------
local funcionRemotaAtaque = folderModuleSCPs:WaitForChild("Ataque") 
local funcionRemotaConfPasiva = folderModuleSCPs:WaitForChild("ConfPasiva") 

-----------------------------------
------------- MODULOS -------------
-----------------------------------
local ModuloConfSCP = require(folderModuleSCPs:WaitForChild("SCP_Configuracion")) 


----------------------------------
------------ INTERFAZ ------------
----------------------------------
local interfazSCP = moduloDatos.Module_obtenerValor("interfazLimitada").Interfaz_SCP
local interfazBackground = moduloDatos.Module_obtenerValor("interfazBackground") 
local botonHabilidadE = interfazSCP.Habilidad_E
local botonHabilidadQ = interfazSCP.Habilidad_Q

--------------------------------
------------ ARRAYS ------------
--------------------------------
local HabilidadBasica = {}
local HabilidadQ = {}
local HabilidadE = {}
local animacionesCombos = {}

--------------------------------------
------------ VALROES BOLT ------------
--------------------------------------
local tag = false
local SCPActivo = false
local cooldownAtaque = false
local cooldownHabilidadE = false
local cooldownHabilidadQ = false
local SCPActual = nil

------------------------------------
------------ CONEXIONES ------------
------------------------------------
local conexionBotonAtaqueQ = nil
local conexionBotonAtaqueE = nil
local conexionTeclasAtaque = nil
local animacionHabilidadE = nil
local animacionHabilidadQ = nil

local modulo = {}

local function AtaqueBasico()
	funcionRemotaDevuelta = false
	BuclesActivosSCP = BuclesActivosSCP + 1

	if HabilidadBasica.combosMaximos then -- En caso de que tenga combos
		local currentTime = tick()

		if combosEnSerieActuales < HabilidadBasica.combosMaximos and currentTime - tiempoUltimoAtaque <= 2 then
			combosEnSerieActuales = combosEnSerieActuales + 1
		else
			combosEnSerieActuales = 1
		end
		tiempoUltimoAtaque = currentTime
	end

	if HabilidadBasica.preAtaque then -- En caso de que tenga preAtaque
		eventoRemotaPreAtaque:FireServer("Click", nombreSCP, combosEnSerieActuales)
	end

	animTrack = localPlayer.Character.Humanoid:LoadAnimation(CarpetaAnimaciones.Combos[combosEnSerieActuales])
	animTrack:Play() -- Ejecuta la animacion

	animTrack:GetMarkerReachedSignal("GenerarHitBox"):Connect(function() -- Espera X punto de la animacion
		funcionRemotaAtaque:InvokeServer("Click", nombreSCP, combosEnSerieActuales)
		funcionRemotaDevuelta = true
	end)

	while not cancelarBuclesSCP and (animTrack.IsPlaying or not funcionRemotaDevuelta) do -- Espera a que la animacion y la funcion remota terminen
		task.wait(0.1)
	end	
	BuclesActivosSCP = BuclesActivosSCP - 1
end

local function Habilidad(Nombre)
	funcionRemotaDevuelta = false
	BuclesActivosSCP = BuclesActivosSCP + 1

	if Nombre == "E" and HabilidadE.preAtaque then
		eventoRemotaPreAtaque:FireServer(Nombre, nombreSCP)
	elseif Nombre == "Q" and HabilidadQ.preAtaque then
		eventoRemotaPreAtaque:FireServer(Nombre, nombreSCP)
	end

	animTrack = localPlayer.Character.Humanoid:LoadAnimation(CarpetaAnimaciones["Especial" .. Nombre])
	animTrack:Play()

	animTrack:GetMarkerReachedSignal("GenerarHitBox"):Connect(function()
		-- Enviar el evento al servidor cuando el keyframe sea alcanzado
		funcionRemotaAtaque:InvokeServer(Nombre, nombreSCP)
		funcionRemotaDevuelta = true
	end)

	while not cancelarBuclesSCP and (animTrack.IsPlaying or not funcionRemotaDevuelta) do
		task.wait(0.1) -- Comprueba cada 0.1 segundos si la animación sigue reproduciéndose y si `Espera` es `true`
	end	
	BuclesActivosSCP = BuclesActivosSCP - 1
end

local function activarCooldownHabilidadE()
	spawn(function()
		BuclesActivosSCP = BuclesActivosSCP + 1

		botonHabilidadE.Cooldown.Text = HabilidadE.cooldown .. "s" -- Muestra el tiempo restante
		botonHabilidadE.Cooldown.Visible = true
		for i = HabilidadE.cooldown, 0, -1 do
			botonHabilidadE.Cooldown.Text = i .. "s" -- Muestra el tiempo restante
			task.wait(1) -- Espera un segundo
			if cancelarBuclesSCP then -- Si el jugador es un SCP, se detiene el bucle
				break
			end
		end
		BuclesActivosSCP = BuclesActivosSCP - 1

		botonHabilidadE.Cooldown.Visible = false
		botonHabilidadE.Bloqueado.Enabled = false
		botonHabilidadE.Desbloqueado.Enabled = true
		cooldownHabilidadE = false
	end)
end

local function activarCooldownHabilidadQ()
	spawn(function()
		BuclesActivosSCP = BuclesActivosSCP + 1

		botonHabilidadQ.Cooldown.Text = HabilidadQ.cooldown .. "s" -- Muestra el tiempo restante
		botonHabilidadQ.Cooldown.Visible = true
		for i = HabilidadQ.cooldown, 0, -1 do
			botonHabilidadQ.Cooldown.Text = i .. "s" -- Muestra el tiempo restante
			task.wait(1) -- Espera un segundo
			if cancelarBuclesSCP then -- Si el jugador es un SCP, se detiene el bucle
				break
			end
		end
		BuclesActivosSCP = BuclesActivosSCP - 1

		botonHabilidadQ.Cooldown.Visible = false
		botonHabilidadQ.Bloqueado.Enabled = false
		botonHabilidadQ.Desbloqueado.Enabled = true
		cooldownHabilidadQ = false
	end)
end

local function aplicarHabilidad(tecla)
	if not cooldownAtaque then
		cooldownAtaque = true
		if cooldownAtaque == "Q" then
			cooldownHabilidadQ = true

			botonHabilidadQ.Desbloqueado.Enabled = false
			botonHabilidadQ.Cargando.Enabled = true
			Habilidad("Q")
			botonHabilidadQ.Cargando.Enabled = false
			botonHabilidadQ.Bloqueado.Enabled = true

		elseif cooldownAtaque == "E" then
			cooldownHabilidadE = true

			botonHabilidadE.Desbloqueado.Enabled = false
			botonHabilidadE.Cargando.Enabled = true
			Habilidad("E")
			botonHabilidadE.Cargando.Enabled = false
			botonHabilidadE.Bloqueado.Enabled = true

		else
			AtaqueBasico()
		end
		cooldownAtaque = false
	end
end

function modulo.accionSCP(accion)
	tag = localPlayer.Character:GetAttribute("Etiqueta") -- Busca la etiqueta
	SCPActual = ModuloConfSCP[tag]-- Revisa si es una etiqueta especial

	-- Si el jugador es un SCP
	if SCPActual then
		SCPActual = tag
		local configuracion = ModuloConfSCP[SCPActual] -- Carga la configuracion del SCP
		local animator = localPlayer.Character.Humanoid:FindFirstChild("Animator")
		animacionesCombos = {} -- Vacia el array

		interfazBackground.Enabled = false -- Desactiva el inventario
		CarpetaAnimaciones = folderModuleSCPs.SCP_Configuracion[SCPActual]

		for _, child in pairs(CarpetaAnimaciones.Animaciones_Movimiento:GetChildren()) do
			local clone = child:Clone()
			clone.Parent = localPlayer.Character.Animate
		end

		for _, animation in ipairs(CarpetaAnimaciones.Animaciones_Combos:GetChildren()) do
			local animTrack = animator:LoadAnimation(animation)
			table.insert(animacionesCombos, animTrack)
		end

		animacionHabilidadE = animator:LoadAnimation(CarpetaAnimaciones.Animaciones_Habilidades.EspecialE)
		animacionHabilidadQ = animator:LoadAnimation(CarpetaAnimaciones.Animaciones_Habilidades.EspecialQ)

		-- Carga la configuracion del jugador
		HabilidadBasica = configuracion.AtaqueBasico
		HabilidadQ = configuracion.HabilidadQ
		HabilidadE = configuracion.HabilidadE

		-- Carga la interfaz
		botonHabilidadE.Nombre.Text = "[E] " .. HabilidadE.nombre
		botonHabilidadE.Imagen.Logo.Image = "http://www.roblox.com/asset/?id=" .. HabilidadE.imagen
		botonHabilidadQ.Nombre.Text = "[Q] " .. HabilidadQ.nombre
		botonHabilidadQ.Imagen.Logo.Image = "http://www.roblox.com/asset/?id=" .. HabilidadQ.imagen
		interfazSCP.Enabled = true

		funcionRemotaConfPasiva:InvokeServer(SCPActual) -- Carga la pasiva del SCP

		if not SCPActivo then -- En caso de que ya existan las conexiones no volvera a ejecutarlas
			SCPActivo = true
			conexionBotonAtaqueQ = interfazSCP.Habilidad_Q.MouseButton1Click:Connect(function()
				aplicarHabilidad("Q")
			end)

			conexionBotonAtaqueE = interfazSCP.Habilidad_E.MouseButton1Click:Connect(function()
				aplicarHabilidad("E")
			end)

			conexionTeclasAtaque = UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if not gameProcessed then -- Revisa si no esta aciendo otra cosa

					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not cooldownAtaque then -- Basico
						aplicarHabilidad("Click")

					elseif input.KeyCode == Enum.KeyCode.Q and not (cooldownAtaque or cooldownHabilidadQ) then -- Habilidad Q
						aplicarHabilidad("Q")

					elseif input.KeyCode == Enum.KeyCode.E and not (cooldownAtaque or cooldownHabilidadE) then -- Habilidad E
						aplicarHabilidad("E")
					end
				end
			end)
		end

	elseif SCPActivo then -- Si no es un SCP y anteriormente lo fue
		SCPActivo = false
		conexionBotonAtaqueE:Disconnect()
		conexionBotonAtaqueQ:Disconnect()
		conexionTeclasAtaque:Disconnect()
		conexionBotonAtaqueE = nil
		conexionBotonAtaqueQ = nil
		conexionTeclasAtaque = nil

		interfazSCP.Enabled = false
		interfazBackground.Enabled = true -- Activa el inventari
	end

	localPlayer.Character.Animate.Enabled = true -- Activa la animacion del jugador
end

return modulo
