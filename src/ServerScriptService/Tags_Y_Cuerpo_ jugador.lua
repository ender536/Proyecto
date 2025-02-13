local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Configuracion = require(ReplicatedStorage.OpcionesEquipo:WaitForChild("ConfigTeams"))

local GrupoPrincipal = ReplicatedStorage.OpcionesEquipo.ID_GrupoPrincipal.Value
local TagRangoYNombre = script.RangoYNombre
local TagEstado = script.Estado
local TagObjetivo = script.Objetivo
local FuncionEquiparTag = ReplicatedStorage:WaitForChild("EquiparTag")



FuncionEquiparTag.OnServerInvoke = function(player, character)
	local success, errorMessage = pcall(function() -- En caso de que algo falle
		local EsAdmin = false
		local Numero = nil

		while true do
			local success, rank = pcall(function()
				return player:GetRankInGroup(GrupoPrincipal)
			end)

			if success then
				if rank >= 110 then
					EsAdmin = true
				end
				break -- Sale del bucle si no hay error
			else
				warn("Error al obtener el rango del grupo. Reintentando...")
				wait(1) -- Espera antes de reintentar
			end
		end

		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		local descriptionClone = humanoid:GetAppliedDescription()
		local Rango_Nombre = TagRangoYNombre:Clone()
		local Estado = TagEstado:Clone()
		local Objetivo = TagObjetivo:Clone()
		local ConfigTeam = Configuracion[player.Team.Name]

		local ownsGamePass = false -- Si tiene el gamepass del equipo
		local inGroup = false -- Si pertenece al grupo del equipo
		local RangoGrupo = nil
		local grupoIds = {} -- Tabla para almacenar las IDs de los equipos
		local gamepassIds = {}  -- Tabla para almacenar los gamepass IDs

		-- Pone el cuerpo del jugador en modo default
		descriptionClone.Head = 0
		descriptionClone.LeftArm = 0
		descriptionClone.RightArm = 0
		descriptionClone.LeftLeg = 0
		descriptionClone.RightLeg = 0
		descriptionClone.Torso = 0
		humanoid:ApplyDescription(descriptionClone)

		-- Revisa si pertenece a algun grupo
		if ConfigTeam.Grupo and not EsAdmin then
			local grupoIds = {} -- Tabla para almacenar los ID de los grupos

			-- Extraer los ID de los grupos
			for grupoId in string.gmatch(ConfigTeam.Grupo, "%d+") do
				table.insert(grupoIds, tonumber(grupoId)) -- Convertir a número y agregar a la tabla
			end

			-- Verificar si el jugador pertenece a uno de los grupos
			for _, grupoId in pairs(grupoIds) do
				local success, isInGroup = pcall(function()
					return player:IsInGroup(grupoId)
				end)

				if success and isInGroup then
					local successRank, rank = pcall(function()
						return player:GetRankInGroup(grupoId)
					end)

					if successRank and (not ConfigTeam.RequisitoRango or rank >= ConfigTeam.RequisitoRango) then
						local successRole, role = pcall(function()
							return player:GetRoleInGroup(grupoId)
						end)

						if successRole then
							inGroup = true
							RangoGrupo = role -- Pilla el rol del jugador
						else
							warn("Error al obtener el rol del jugador en el grupo " .. grupoId)
						end
						break
					elseif not successRank then
						warn("Error al obtener el rango del jugador en el grupo " .. grupoId)
					end
				elseif not success then
					warn("Error al comprobar si el jugador está en el grupo " .. grupoId)
				end
			end
		end


		-- Si no pertenece a un grupo revisa si tiene gamepass
		if not inGroup and not EsAdmin and ConfigTeam.Gamepass then
			local success, ownsGamepass = pcall(function()
				return MarketplaceService:UserOwnsGamePassAsync(player.UserId, ConfigTeam.Gamepass)
			end)

			if success and ownsGamepass then
				ownsGamePass = true
			elseif not success then
				warn("Error al verificar el Gamepass para el jugador. Reintentando...")
				task.wait(1) -- Espera antes de reintentar
			end
		end

		-- Si es admin y no es un CD, AI O DSI pone un rango especial
		if EsAdmin and player.Team.Name ~= "CD || Clase D" and player.Team.Name ~= "AI || Agencia de Inteligencia" and player.Team.Name ~= "DSI || Departamento de Seguridad Interna" then -- Si es adminsitrodr
			if ConfigTeam.Tag.Rango == "SCP" then -- Si el rango es SCP
				Rango_Nombre.Grupo.Text = "SCP"
			else
				Rango_Nombre.Grupo.Text = "ALTO CARGO"
			end
			Rango_Nombre.Grupo.TextColor3 = ConfigTeam.Tag.Color	

		elseif ConfigTeam.Tag.Rango == "Numero" then -- Si el rango es numerico
			Numero = math.random(1000, 9999)
			Rango_Nombre.Grupo.Text = ConfigTeam.Tag.Prefijo..Numero
			Rango_Nombre.Grupo.TextColor3 = ConfigTeam.Tag.Color

		elseif inGroup and ConfigTeam.Tag.Rango == "Grupo" then -- Si el team tiene grupo y el jugador pertenece al mismo
			for grupoId in string.gmatch(ConfigTeam.Grupo, "%d+") do
				table.insert(grupoIds, tonumber(grupoId))  -- Convertir a número y agregar a la tabla
			end
			Rango_Nombre.Grupo.Text = RangoGrupo:upper() -- Pone le rol en mayusculas
			Rango_Nombre.Grupo.TextColor3 = ConfigTeam.Tag.Color -- Cambia el color de las letras

		elseif ownsGamePass then -- Si no pertenece a un grupo pero tiene gamepass
			Rango_Nombre.Grupo.Text = "??GAMEPASS??"
			Rango_Nombre.Grupo.TextColor3 = Color3.new(1, 0.968627, 0)

		else -- Si no pertenece a un grupo y no tiene gamepass
			Rango_Nombre.Grupo.Text = ConfigTeam.Tag.SinRango
			Rango_Nombre.Grupo.TextColor3 = ConfigTeam.Tag.Color
		end

		Rango_Nombre.Nombre.Text = player.Name -- Pone el nombre del jugador
		Rango_Nombre.Parent = player.Character.Head -- Inserta el nombre y rango en el jugador
		Estado.Parent = player.Character.Head -- Inserta el estado del jugador
		Objetivo.Parent = player.Character.UpperTorso -- Inserta el estado del jugador en el cuerpo

		-- Oculta el nombre y grupo al jugador
		-- Rango_Nombre.PlayerToHideFrom = player
		-- Estado.PlayerToHideFrom = player
		return true
	end)
	
	if not success then
		return false -- Devuelve false si pcall falla
	end
end
