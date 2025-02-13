------------- SCRIPT GENERAL DE CONTROL DE DINERO -----------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote_Event = ReplicatedStorage:WaitForChild("DarDinero")

-- Función para recortar el nombre del equipo
local function recortarNombreEquipo(nombreEquipo)
	-- Buscar doble barra ||
	local index = string.find(nombreEquipo, "||")

	if index then
		-- Si se encuentra, recortar hasta ese punto
		return string.sub(nombreEquipo, 1, index - 1)
	else
		-- Si no se encuentra, mantener el nombre completo
		return nombreEquipo
	end
end

-- Función que dispara el RemoteEvent
local function triggerRemoteEvent(player, dinero, Equipo_Jugador, premium)
	if player and player:FindFirstChild("leaderstats") then
		local dineroJugador = player.leaderstats

		if dineroJugador:FindFirstChild("Dinero") then
			dineroJugador.Dinero.Value = dineroJugador.Dinero.Value + dinero

			-- Recortar el nombre del equipo
			local nombreRecortado = recortarNombreEquipo(Equipo_Jugador)
		end
	end
end

Remote_Event.OnServerEvent:Connect(triggerRemoteEvent)
