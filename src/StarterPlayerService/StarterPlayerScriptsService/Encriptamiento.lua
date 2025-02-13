local moduloDatos = require(script.Parent.Datos_Comportidos)

--------------------------------------
------- CODIGO DESENCRIPTACION -------
--------------------------------------
local shift = 5
local specialChars = { "*", "#", "@", "&", "%" }

--------------------------------------
---------------- VALORES -------------
--------------------------------------
local teamActual = nil
local localPlayer = moduloDatos.Module_obtenerValor("localPlayer")
local Players = moduloDatos.Module_obtenerValor("Players")
local procesando = false
local repetirProceso = false
local conexionNuevoCharacter = nil
local conexionSalidaJugador = nil
local conexionTemporal = nil
local conexionTemporal2 = nil

--------------------------------------
---------------- ARRAYS --------------
--------------------------------------
local conexionesCharacterAdded = {}  -- Para almacenar las conexiones de PlayerAdded
local teamsDesencriptadores = {
	["DSI || Departamento de Seguridad Interna"] = true,
	["AI || Agencia de Inteligencia"] = true,
	["DA || Departamento Administrativo"] = true,
	["ERR || Equipo de Respuesta Rapida"] = true
}
local teamsEncriptados = {
	["DSI || Departamento de Seguridad Interna"] = true,
	["AI || Agencia de Inteligencia"] = true
}

--------------------------------------
-------------- FUNCIONES -------------
--------------------------------------
function reverseString(str) -- Función para invertir la cadena
	local reversed = ""
	for i = #str, 1, -1 do
		reversed = reversed .. str:sub(i, i)
	end
	return reversed
end

function shiftWord(word, shiftDirection) -- Función para mover toda la palabra un lugar hacia adelante o hacia atrás
	local shiftedWord = ""
	if shiftDirection == 1 then
		-- Mover toda la palabra una posición hacia adelante
		shiftedWord = word:sub(2) .. word:sub(1, 1)
	elseif shiftDirection == -1 then
		-- Mover toda la palabra una posición hacia atrás
		shiftedWord = word:sub(-1) .. word:sub(1, -2)
	end
	return shiftedWord
end

function codigoEncripatcion(username) -- Funcion para encriptar un nombre
	-- Mover la palabra una posición según la longitud del texto
	local shiftDirection = #username % 2 == 0 and 1 or -1  -- Si la longitud es par, mover hacia adelante (1), si es impar, mover hacia atrás (-1)
	username = shiftWord(username, shiftDirection)

	-- Invertir el texto antes de encriptar
	username = reverseString(username)

	local encrypted = ""
	for i = 1, #username do
		local char = username:sub(i, i)
		if char:match("%a") then  -- Si el carácter es una letra
			local base = char:match("%u") and 65 or 97  -- Determina si es mayúscula o minúscula
			local encryptedChar = string.char(((string.byte(char) - base + shift) % 26) + base)
			encrypted = encrypted .. encryptedChar
		elseif char:match("%d") then  -- Si el carácter es un número
			encrypted = encrypted .. string.char(((string.byte(char) - 48 + shift) % 10) + 48)
		else
			-- Reemplazar el "_" con un carácter especial según la longitud del texto
			local specialChar = specialChars[(#username % #specialChars) + 1]
			encrypted = encrypted .. specialChar
		end
	end
	return encrypted
end

local function encriptarNombres(player) -- Funcion para encriptar nombres
	if teamsEncriptados[player.Team.Name] then
		local NuevoNombre = codigoEncripatcion(player.Name)
		player.Character.Head.RangoYNombre.Nombre.Text = NuevoNombre
		player.Character:SetAttribute("Encriptado", true)
	end
end

local function conectarJugador(player)
	conexionTemporal = player.CharacterAdded:Connect(function(character)
		local character = player.Character or player.CharacterAdded:Wait()
		local Cancelado = false

		while not character:GetAttribute("Cargado") do
			task.wait()
			if character.Parent == nil then
				Cancelado = true
				break
			end
		end

		if not Cancelado then
			local player = Players:GetPlayerFromCharacter(character)  -- Obtener el jugador a partir del personaje
			encriptarNombres(player)
		end
	end)

	table.insert(conexionesCharacterAdded, {player = player.Name, conexion = conexionTemporal})

	if player.Character then
		encriptarNombres(player)
	end
end

--------------------------------------
---------- CONEXION EXTERIOR ---------
--------------------------------------

local modulo = {}

function modulo.encriptamiento()
	if not procesando then -- Si no hay nada en proceso
		procesando = true

		while true do
			local teamActual = moduloDatos.Module_obtenerValor("actualTema") -- Pilla el team actual del jugador

			if teamsDesencriptadores[teamActual] then -- Si el team del jugador esta en la lista
				if conexionSalidaJugador or conexionNuevoCharacter then
					conexionSalidaJugador:Disconnect()
					conexionNuevoCharacter:Disconnect()
					conexionSalidaJugador = nil
					conexionNuevoCharacter = nil
				end

				for _, data in pairs(conexionesCharacterAdded) do
					data.conexion:Disconnect()  -- Desconectamos la conexión del evento
				end
				conexionesCharacterAdded = {}  -- Vaciar la tabla de conexiones

				for _, player in pairs(Players:GetPlayers()) do -- Desencripta los nombres de los jugadores que estan en la lista
					if player.Character and teamsEncriptados[player.Team.Name] and localPlayer ~= player then
						player.Character.Head.RangoYNombre.Nombre.Text = player.Name
						player.Character:SetAttribute("Encriptado", nil)
					end
				end
			else -- Si no esta en la lista
				conexionNuevoCharacter = Players.PlayerAdded:Connect(conectarJugador)
				conexionSalidaJugador = Players.PlayerRemoving:Connect(function(player) -- Elimina las conexiones del jugador que se a ido del juego
					for i, data in ipairs(conexionesCharacterAdded) do
						if data.player == player.Name then
							data.conexion:Disconnect()
							table.remove(conexionesCharacterAdded, i)
							break
						end
					end
				end)

				for _, player in pairs(Players:GetPlayers()) do
					if localPlayer ~= player then
						conectarJugador(player)
					end
				end

			end

			if not repetirProceso then -- Si al finalizar el proceso no hay ningun otro pendiente lo termina
				break
			else
				repetirProceso = false
			end
			task.wait()
		end
		procesando = false
	else
		repetirProceso = true
	end
end

return modulo
