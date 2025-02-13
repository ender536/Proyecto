local moduloDatos = require(script.Parent.Datos_Comportidos)

--------------------------------------
---------------- OTROS ---------------
--------------------------------------
local localplayer = moduloDatos.Module_obtenerValor("localPlayer")
local Gui = moduloDatos.Module_obtenerValor("interfazLimitada").Interfaz_Nombre_Salud
local barra = Gui.Barra -- Barra que contiene elementos
local textoNombreJugador = Gui.NombreJugador -- TextLabel que contiene el nombre del jugadpr
local barraRoja = barra.Rojo -- Color verde de fondo de la barra
local barraBlanco = barra.Blanco -- Color verde al fondo de todo de la barra
local barraBlanco2 = barra.Blanco2 -- Color verde al fondo de todo de la barra
local barraAzul = barra.Azul -- Color verde al fondo de todo de la barra
local textoSalud = barra.Salud -- TextLabel que indica la salud actual y maxima del jguador

--------------------------------------
------------- VALORES NIL ------------
--------------------------------------
local humanoid = nil -- Guarda el humanoid del jugador
local teamActual = nil -- Guarda el team actual del jugador
local character = nil
local conexionHumanoid = nil -- Conexion para detectar cuando el humanoid reaparece
local health = nil
local maxHealth = nil

--------------------------------------
--------------- MODULOS --------------
--------------------------------------
local function ActualizarInterfaz(TeamCambiado)
	local health = humanoid.Health
	local maxHealth = humanoid.MaxHealth

	if TeamCambiado then -- Si el tema ha sido cambiado aplica un efecto de desaparición en el TextLabel del nombre del jugador
		spawn(function()
			local firstThreeChars = ""

			for i = 1, #teamActual do
				local char = string.sub(teamActual, i, i)

				if char == "|" or char == " " then
					break
				else
					firstThreeChars = firstThreeChars .. char
				end
			end
			--// Asignar el nombre combinado al objeto en Roblox \\--
			textoNombreJugador.Text = "(" .. firstThreeChars .. ") " .. localplayer.Name
			for i = 1, 3 do
				textoNombreJugador.Visible = true
				task.wait(0.2)
				textoNombreJugador.Visible = false
				task.wait(0.2)
			end
			textoNombreJugador.Visible = true -- Asegurarse de que el texto esté visible al final
		end)
	end

	if health < 0 then -- Si la vida llega a ser negativa
		textoSalud.Text = 0 .. " / " .. maxHealth -- Muestra 0 de vida y la vida máxima
	elseif humanoid.Health >= 100000 then -- Si la vida llega a ser superior a 100k de vida
		textoSalud.Text = "ERROR 404"
	else -- Si nada de lo anterior se aplica
		textoSalud.Text = math.floor(health) .. " / " .. maxHealth -- Muestra la vida actual y máxima del jugador
	end

	spawn(function() -- Animacion asincrona que aumenta y reduce la barra de salud
		if health > maxHealth then
			-- Si la vida actual supera la vida máxima, manejar la barra azul (armadura)
			barraRoja:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 1, true) -- Mantiene la barra roja llena

			local armorHealth = health - maxHealth
			local armorMax = maxHealth * 2
			barraAzul:TweenSize(UDim2.new((armorHealth / armorMax), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 1, true)
			task.wait(0.25)
			barraBlanco2:TweenSize(UDim2.new((armorHealth / armorMax), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 2, true)
		else
			-- Si la vida está dentro del rango normal, ajustar solo la barra roja
			barraBlanco2:TweenSize(UDim2.new(0, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 1, true) -- La barra azul se oculta
			barraAzul:TweenSize(UDim2.new(0, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 1, true) -- La barra azul se oculta

			barraRoja:TweenSize(UDim2.new((health / maxHealth), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 1, true)
			task.wait(0.25)
			barraBlanco:TweenSize(UDim2.new((health / maxHealth), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 2, true)
		end
	end)
end

--------------------------------------
--------------- ENTRADA --------------
--------------------------------------
local modulo = {}

function modulo.actualizarSalud(accion)
	character = localplayer.Character
	humanoid = character:WaitForChild("Humanoid") -- Pilla le humanoid del jugador
	teamActual = moduloDatos.Module_obtenerValor("actualTema")

	if conexionHumanoid then -- Desconecta la conexion en caso de que exista
		conexionHumanoid:Disconnect()
	end
	
	ActualizarInterfaz(true)

	if teamActual ~= localplayer.Team.Name then -- Si a cambiado de team
		ActualizarInterfaz(true)
	else -- Si no ha cambiado de team
		ActualizarInterfaz()
	end

	conexionHumanoid = humanoid.HealthChanged:Connect(function() -- Genera la conexion para detectar cuando el humanoid gana o pierde vida
		ActualizarInterfaz()
	end)
end

return modulo