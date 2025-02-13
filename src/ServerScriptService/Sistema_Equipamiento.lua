local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local FuncionEquiparTraje = ReplicatedStorage:WaitForChild("EquiparGear") -- Funcion remota que recive el servidor para equipar el equipamiento al jugador
local Uniformes = ServerStorage.Uniformes_Equipos -- Carpeta donde se guardan los uniformes uniformes
local TarjetasParaDar = ServerStorage.TarjetasAutorizadas
local ModuloTarjetas = require(script.NivelesTarjeta)
local grupoPrincipal = ReplicatedStorage.OpcionesEquipo.ID_GrupoPrincipal.Value
local gamePass = ReplicatedStorage.OpcionesEquipo.GP_TN5.Value
local attachpts = {
	Vest = "UpperTorso",
	Face = "Head",
	Helmet = "Head",
	Belt = "LowerTorso",
}

--------------------------------------
-------------- FUNCIONES -------------
--------------------------------------
local function recursive(parent,root)
	for k,v in pairs(parent:GetChildren()) do
		if v:IsA("BasePart") then
			local w = Instance.new("Weld")
			w.Part0 = root
			w.Part1 = v
			w.C1 = v.CFrame:toObjectSpace(root.CFrame)
			w.Parent = root
			v.Anchored = false
			v.CanCollide = false
		elseif v:IsA("Model") and v.Name ~= "Up" then
			recursive(v,root)
		end
	end
end

function Equipar_Traje(modelo, jugador)
	local g = modelo:clone()
	g.Parent = jugador.Traje
	local C = g:GetChildren()
	for i=1, #C do
		if C[i].className == "Part" or C[i].className == "UnionOperation" or C[i].className == "WedgePart" or C[i].className == "MeshPart" then
			local W = Instance.new("Weld")
			W.Part0 = g.Middle
			W.Part1 = C[i]
			local CJ = CFrame.new(g.Middle.Position)
			local C0 = g.Middle.CFrame:inverse()*CJ
			local C1 = C[i].CFrame:inverse()*CJ
			W.C0 = C0
			W.C1 = C1
			W.Parent = g.Middle
		end
		local Y = Instance.new("Weld")
		Y.Part0 = jugador[modelo.Name]
		Y.Part1 = g.Middle
		Y.C0 = CFrame.new(0, 0, 0)
		Y.Parent = Y.Part0
	end
end

--------------------------------------
---------- SCRIPT PRINCIPAL ----------
--------------------------------------
FuncionEquiparTraje.OnServerInvoke = function(player, Character, Division, Unidad, Team)
	print("Equipo: ", Team, " Division: ", Division, " Unidad: ", Unidad)
	local UbicacionTraje = Uniformes[Team][Division][Unidad] 
	local FolderConfiguracion = UbicacionTraje.Config -- Folder de configuracion
	local FolderTraje = UbicacionTraje:FindFirstChild("Traje")
	local teamInfo = ModuloTarjetas.Teams[Team]
	local humanoid = Character.Humanoid

	-- VALORES INSERT --
	if FolderConfiguracion:FindFirstChild("Valores") then
		-- MODIFICAR CARA --
		if FolderConfiguracion.Valores:FindFirstChild("Cara") then
			if Character.Head:FindFirstChild("face") then -- Si tiene cara el jugador
				Character.Head.face.Texture = FolderConfiguracion.Valores.Cara.Value
			else -- Si no tiene cara el jugador
				local faceDecal = Instance.new("Decal")
				faceDecal.Name = "face"
				faceDecal.Texture = "rbxassetid://" .. FolderConfiguracion.Valores.Cara.Value
				faceDecal.Face = Enum.NormalId.Front
				faceDecal.Parent = Character.Head 
			end
		end

		-- ELIMINAR ACCESORIOS DEL JUGADOR --
		if FolderConfiguracion.Valores:FindFirstChild("Eliminar_Accesorio") then
			for _, accesorio in pairs(Character:GetChildren()) do
				if accesorio:IsA("Accessory") then
					accesorio:Destroy()
				end
			end
		end

		-- MODIFICAR VIDA --
		if FolderConfiguracion.Valores:FindFirstChild("Salud") then
			humanoid.MaxHealth = FolderConfiguracion.Valores.Salud.Value
			humanoid.Health = FolderConfiguracion.Valores.Salud.Value
		end

		-- VALORES ESPECIALES --
		if FolderConfiguracion.Valores:FindFirstChild("Estado") then
			Character:SetAttribute("Estado", FolderConfiguracion.Valores.Estado.Value)
		end

		if FolderConfiguracion.Valores:FindFirstChild("Team") then
			Character:SetAttribute("Team", FolderConfiguracion.Valores.Team.Value)
		end

		if FolderConfiguracion.Valores:FindFirstChild("Etiqueta") then
			Character:SetAttribute("Etiqueta", FolderConfiguracion.Valores.Etiqueta.Value)
		end

		-- MODIFICAR ALTURA DEL JUGADOR --
		if FolderConfiguracion.Valores:FindFirstChild("Altura") then
			local Value = FolderConfiguracion.Valores.Altura.Value
			local Head = Character.Head
			-- for _, obj in pairs(FolderTraje:GetChildren()) do
				-- if not obj:IsA("Accessory") then
					-- obj:ScaleTo(Value)
				-- end
			-- end

			humanoid.BodyDepthScale.Value = (Value - 0.1)
			humanoid.BodyHeightScale.Value = Value
			humanoid.BodyWidthScale.Value = (Value - 0.1)
			humanoid.HeadScale.Value = (Value - 0.1)

			Head.RangoYNombre.StudsOffset = Head.RangoYNombre.StudsOffset + Vector3.new(0, Value - 1, 0)
			Head.Estado.StudsOffset = Head.Estado.StudsOffset + Vector3.new(0, Value - 1, 0)
		end

		if FolderConfiguracion.Valores:FindFirstChild("VelocidadBase") then
			Character:SetAttribute("VelocidadBase", FolderConfiguracion.Valores.VelocidadBase.Value)
		end
	end

	-- ROPA DEL PERSONAJE Y COLOR --
	-- Destruye todo lo inecesario
	for _, objeto in pairs(Character:GetChildren()) do
		if objeto:IsA("Clothing") or objeto:IsA("ShirtGraphic") or (objeto:IsA("BodyColors") and FolderConfiguracion.Insertar:FindFirstChild("Body Colors")) then
			objeto:Destroy()
		end
	end

	-- Cambia el color del jugador si existe x cosa
	if FolderConfiguracion.Insertar:FindFirstChild("Body Colors") then
		local Color = FolderConfiguracion.Insertar["Body Colors"]:Clone()
		Color.Parent = Character
	end

	-- Equipa los uniformes
	FolderConfiguracion.Insertar.Pants:Clone().Parent = Character
	FolderConfiguracion.Insertar.Shirt:Clone().Parent = Character

	-- EQUIPA ACCEOSRIOS Y MODELOS --
	if FolderTraje then
		for _, child in pairs(FolderTraje:GetChildren()) do
			if child:IsA("Model") then -- Si detecta modelos
				Equipar_Traje(child, Character)
			elseif child:IsA("Accessory") then -- SI detecta accesorios
				local accesorioClonado = child:Clone()
				accesorioClonado.Parent = Character
			end
		end
	end

	-- AÑADIR HERRAMIENTAS AL JUGADOR --
	for _, tool in pairs(FolderConfiguracion.Tools:GetChildren()) do
		if tool:IsA("Tool") then
			local toolClone = tool:Clone()
			toolClone.Parent = player.Backpack
		end
	end

	if teamInfo then -- Si el team esta dentro del modulo de teams con tarjetas personalizadas
		local nombreTeam = Team:match("^(.-)%s*||")
		local RangoGrupo

		while true do
			local success, rank = pcall(function()
				return player:GetRankInGroup(grupoPrincipal)
			end)

			if success then
				RangoGrupo = rank
				break -- Salir del bucle si se obtiene el rango correctamente
			else
				warn("Error al obtener el rango del grupo. Reintentando...")
				task.wait(1) -- Espera antes de reintentar
			end
		end

		local nivelJugador = ModuloTarjetas.RangosTarjeta[RangoGrupo] or RangoGrupo
		local tieneGamepass = false

		-- Verificar si el jugador posee alguno de los gamepasses
		local success, ownsGamepass = pcall(function()
			return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePass)
		end)

		if success and ownsGamepass then
			tieneGamepass = true
		elseif not success then
			warn("Error al verificar el Gamepass para el jugador. Reintentando...")
			task.wait(1) -- Espera antes de reintentar
		end


		if nivelJugador and nivelJugador >= 5 or tieneGamepass then
			local toolClone = nil
			if tieneGamepass or not (nivelJugador > 5) then
				toolClone = TarjetasParaDar["Tarjeta N5"]:Clone()
			else
				toolClone = TarjetasParaDar["Tarjeta Omni"]:Clone()
			end
			toolClone.PartTexto.SurfaceGui.Team.Text = nombreTeam
			toolClone.Parent = player.Backpack

		elseif nivelJugador and teamInfo <= nivelJugador then
			local toolClone = TarjetasParaDar["Tarjeta N" .. nivelJugador]:Clone()
			toolClone.PartTexto.SurfaceGui.Team.Text = nombreTeam
			toolClone.Parent = player.Backpack
		else
			local toolClone = TarjetasParaDar["Tarjeta N" .. teamInfo]:Clone()
			toolClone.PartTexto.SurfaceGui.Team.Text = nombreTeam
			toolClone.Parent = player.Backpack
		end
	end

	-- EQUIPA LA VISION NOCTURNA --
	if FolderConfiguracion:FindFirstChild("Helmet") then
		local EsVisible = false
		local tipos = FolderConfiguracion.Helmet:GetAttribute("Tipo")
		local elementosSeparados = {}
		local g = FolderConfiguracion.Helmet:Clone()

		if FolderConfiguracion.Helmet:IsA("Model") then -- Inserta el modelo si lo es
			EsVisible = true
			recursive(g,g.Middle)
			local Y = Instance.new("Weld")
			Y.Part0 = Character[attachpts[FolderConfiguracion.Helmet.Name]]
			Y.Part1 = g.Middle
			Y.Parent = Y.Part0
		end
		g.Parent = Character

		-- Comprobar si el atributo no es nulo y dividirlo
		if tipos then
			for tipo in string.gmatch(tipos, "[^,]+") do
				table.insert(elementosSeparados, tipo:match("^%s*(.-)%s*$")) -- Eliminar espacios
			end
		end

		return {EsVisible, unpack(elementosSeparados)} -- Configuracion de la visio / Es visible o no es visible
	else
		return false -- Devuelve nada y deja seguir el proceso
	end
end
