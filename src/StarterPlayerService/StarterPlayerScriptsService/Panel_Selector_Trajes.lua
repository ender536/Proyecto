local moduloDatos = require(script.Parent.Datos_Comportidos)

-- SERVICIOS --
local OpcionesEquipo = moduloDatos.Module_obtenerValor("OpcionesEquipo")
local interfazCompleta = moduloDatos.Module_obtenerValor("interfazCompleta")
local TweenService = moduloDatos.Module_obtenerValor("TweenService")
local UserInputService = moduloDatos.Module_obtenerValor("UserInputService")

-- MODULOS --
local moduloTeams = require(OpcionesEquipo.ConfigTeams)

-- EVENTOS REMOTOS --
local remoteFunctionResetPlayer = moduloDatos.Module_obtenerValor("remoteFunctionResetPlayer") -- Funcion para reiniciar al jugador

-- OTROS --
local panelTrajes = interfazCompleta.Interfaz_Panel_Trajes
local listaDivisiones = panelTrajes.DivisionesYUnidades.Divisiones
local listaUnidades = panelTrajes.DivisionesYUnidades.Unidades
local carpetaSonidos = script.Sonidos
local botonesRapidos = moduloDatos.Module_obtenerValor("botonesRapidos")
local localPlayer = moduloDatos.Module_obtenerValor("localPlayer")

local colorAmarillo = moduloDatos.Module_obtenerValor("colorAmarillo")
local colorNegro = moduloDatos.Module_obtenerValor("colorNegro")
local colorGris = moduloDatos.Module_obtenerValor("colorGris")
local colorVerde = moduloDatos.Module_obtenerValor("colorVerde")
local colorRojo = moduloDatos.Module_obtenerValor("colorRojo")

local procesando = false
local panelAbierto = false
local cerrarPanel = false
local EsAdmin = moduloDatos.Module_obtenerValor("esAdmin")
local divisionActual = moduloDatos.Module_obtenerValor("actualDivision")
local divisionEnVista = nil
local unidadActual = moduloDatos.Module_obtenerValor("actualUnit")
local EstaEnGrupo = false
local teamEquipado = nil
local conexionTecaPanelTrajes = nil
local conexionBotonPanelTrajes = nil

local configurar = false
local procesandoTecla = false

-- ARRAYS --
local conexionesBotonesDivisiones = {} -- Botones del panel de trajes
local conexionesBotonesUnidades = {} -- Botones del panel de trajes

-- PRE CONFIGURACION --
panelTrajes.Position = UDim2.new(panelTrajes.Position.X.Scale, panelTrajes.Position.X.Offset, -1, panelTrajes.Position.Y.Offset)
botonesRapidos.PanelTrajes.Visible = false -- Esconde el boton del panel de trajes

local modulo = {}

local function preCargarUnidadDivision()
	teamEquipado = moduloDatos.Module_obtenerValor("actualTema")

	local informacionTeam = moduloTeams[teamEquipado] -- Busca el nombre del team actual del jugador dentro del modulo

	-- Busca entre las divisiones que hay en el modulo
	for i, division in ipairs(informacionTeam.Divisions) do


		if i == 1 then -- Si el primer frame que se crea sera desbloqueado automaticamente
			divisionActual = division.Name
			divisionEnVista = divisionActual
			moduloDatos.Module_establecerValor("actualDivision", divisionActual)

			-- Busca entre las unidades que hay en el modulo
			if i == 1 then
				for a, unit in ipairs(division.Units) do
					if a == 1 then -- Si es la primera unidad de la lista
						unidadActual = unit
						moduloDatos.Module_establecerValor("actualUnit", unidadActual)
					end
				end
			end
		end
	end
end

local function conectarBotonesUnidades() -- Conecta los botones de las unidades
	for _, boton in ipairs(listaUnidades:GetChildren()) do
		if boton:IsA("TextButton") then

			local conexionBoton = boton.MouseButton1Click:Connect(function()
				if boton:GetAttribute("Bloqueado") == false and not ((procesando or procesandoTecla) or moduloDatos.Module_obtenerValor("cargandoJugador") or moduloDatos.Module_obtenerValor("menuAbierto")) then -- Si el boton esta desbloqueado
					procesandoTecla = true
					boton:SetAttribute("Bloqueado", true) -- Bloquea el boton
					boton.BackgroundColor3 = colorAmarillo

					if divisionActual == divisionEnVista then -- Si la unidad es de la misma division que esta viendo el jugador
						listaUnidades[unidadActual].BackgroundColor3 = colorGris -- Cambia el color del boton de la unidad anterior
						listaUnidades[unidadActual]:SetAttribute("Bloqueado", false) -- Desbloquea el boton de la unidad anterior
					end

					divisionActual = divisionEnVista -- Indica la division actual
					unidadActual = boton.Name -- Indica la unidad actual
					moduloDatos.Module_establecerValor("actualDivision", divisionActual)
					moduloDatos.Module_establecerValor("actualUnit", unidadActual)

					remoteFunctionResetPlayer:InvokeServer()
					task.wait(0.3)
					boton.BackgroundColor3 = colorVerde
					procesandoTecla = false
				else
					carpetaSonidos.Incorrecto:Play()
				end

			end)
			table.insert(conexionesBotonesUnidades, conexionBoton) -- Guardar la conexión en la tabla
		end
	end
end

local function conectarBotonesDivisiones()  -- Conecta los botones de la divisiones
	for _, boton in ipairs(listaDivisiones:GetChildren()) do
		if boton:IsA("TextButton") then

			-- Crea la conexion con el boton
			local conexionBoton = boton.MouseButton1Click:Connect(function()

				if boton:GetAttribute("Bloqueado") == false and not ((procesando or procesandoTecla) or moduloDatos.Module_obtenerValor("cargandoJugador") or moduloDatos.Module_obtenerValor("menuAbierto")) then -- Si el boton esta desbloqueado
					procesandoTecla = true
					boton:SetAttribute("Bloqueado", true) -- Bloquea el boton

					boton.BackgroundColor3 = colorAmarillo
					listaDivisiones[divisionEnVista].BackgroundColor3 = colorGris -- Cambia el color del boton anteriormente selecionado
					listaDivisiones[divisionEnVista]:SetAttribute("Bloqueado", false) -- Desbloquea el boton anteriormente selecionado
					divisionEnVista = boton.Name -- Pone a la division seleccionada en vista
					cambiarPaginaUnidades() -- Cambiar la lista de unidades a la vista

					task.wait(0.1)
					boton.BackgroundColor3 = colorVerde
					procesandoTecla = false
				else
					carpetaSonidos.Incorrecto:Play()
				end

			end)
			table.insert(conexionesBotonesDivisiones, conexionBoton) -- Guarda la conexion en la tabla
		end
	end
end

local function desconectarBotonesDivisiones() -- Desconectar los botones de las divisiones
	for _, conexion in ipairs(conexionesBotonesDivisiones) do
		conexion:Disconnect()
	end
	conexionesBotonesDivisiones = {}
end

local function desconectarBotonesUnidades() -- Desconectar los botones de las unidades
	for _, conexion in ipairs(conexionesBotonesUnidades) do
		conexion:Disconnect()
	end
	conexionesBotonesUnidades = {}
end

function cambiarPaginaUnidades() -- Funcion para cambiar las unidades del panel de trajes

	desconectarBotonesUnidades() -- Desconecta los botones dentro de la division

	-- Elimina todos los botones dentro de la division
	for _, child in ipairs(listaUnidades:GetChildren()) do
		if not (child:IsA("UIListLayout")) then
			child:Destroy()
		end
	end

	local infoTeam = moduloTeams[teamEquipado] -- Pilla el team actual del jugador dentro del modulo

	for i, division in ipairs(infoTeam.Divisions) do -- Inicia a revisar divisiones en el modulo

		if division.Name == divisionEnVista then -- Si una de las divisiones del modulo es igual a la vista del modulo actual
			for a, unit in ipairs(division.Units) do -- Busca entre todas las unidades
				local Desbloqueado = false
				local clonedObject = script.Nombre_Unidad:Clone()
				clonedObject.Name = unit
				clonedObject.Nombre.Text = unit

				if divisionActual == divisionEnVista and unidadActual == unit then -- Si la unidad es la que tiene el jugador equipada actualmente
					unidadActual = unit
					clonedObject.BackgroundColor3 = colorVerde
					clonedObject:SetAttribute("Bloqueado", true) -- Bloquea la unidad actual
					Desbloqueado = true
				elseif EstaEnGrupo or a == 1 then -- Si esta en el grupo o es la primera unidad de la division
					clonedObject.BackgroundColor3 = colorGris
					clonedObject:SetAttribute("Bloqueado", false) -- Desbloquea el boton
					Desbloqueado = true
				else -- Si nada de lo anterior se cumple bloquea la unidad
					clonedObject.BackgroundColor3 = colorRojo
					clonedObject:SetAttribute("Bloqueado", true) -- Bloquea la unidad
				end

				if Desbloqueado then -- Si la unidad esta desbloqueada cambia el icono
					if division.IconoIndividual then -- Si la division tiene icono individual se lo pone a la unidad
						clonedObject.Imagen.Icono.Image = division.IconoIndividual
					else -- Si no tiene icono individual pone el icono principal del team
						clonedObject.Imagen.Icono.Image = infoTeam.IconoPrincipal
					end
				end
				clonedObject.Parent = listaUnidades
			end
		end
	end
	conectarBotonesUnidades()
end

local function configurarDivisionesYUnidades() -- Funcion para preparar el panel de trajes la primera vez
	local grupoIds = {} -- Tabla para almacenar las IDs de los equipos
	EstaEnGrupo = false

	desconectarBotonesDivisiones()
	desconectarBotonesUnidades()

	-- Elimina todos los frames de divisiones que haya dentro del contenedor
	for _, child in ipairs(listaDivisiones:GetChildren()) do
		if not (child:IsA("UIListLayout")) then
			child:Destroy()
		end
	end

	-- Elimina todos los frames de unidades que haya dentro del contenedor
	for _, child in ipairs(listaUnidades:GetChildren()) do
		if not (child:IsA("UIListLayout")) then
			child:Destroy()
		end
	end

	if teamEquipado ~= "CD || Clase D" then -- Si no es clase-D conecta todos los botones de division y unidad
		teamEquipado = moduloDatos.Module_obtenerValor("actualTema")
		local informacionTeam = moduloTeams[teamEquipado] -- Busca el nombre del team actual del jugador dentro del módulo
		local separatorIndex = string.find(teamEquipado, "||")
		local teamName = string.sub(teamEquipado, separatorIndex + 3) -- +3 para omitir "|| "
		panelTrajes.NombreTeam.Nombre.Text = string.upper(teamName) -- Pone el nombre del team en el título del panel

		if informacionTeam.Grupo and not EsAdmin then
			local grupoIds = {} -- Tabla para almacenar los ID de los grupos

			for grupoId in string.gmatch(informacionTeam.Grupo, "%d+") do
				table.insert(grupoIds, tonumber(grupoId)) -- Convertir a número y agregar a la tabla
			end

			-- Verificar si el jugador pertenece a uno de los grupos
			for _, grupoId in pairs(grupoIds) do
				local success, isInGroup = pcall(function()
					return localPlayer:IsInGroup(grupoId)
				end)

				if success and isInGroup then
					local successRank, rank = pcall(function()
						return localPlayer:GetRankInGroup(grupoId)
					end)

					if successRank and (not informacionTeam.RequisitoRango or rank >= informacionTeam.RequisitoRango) then
						EstaEnGrupo = true
						break
					elseif not successRank then
						warn("Error al obtener el rango del jugador para el grupo " .. grupoId)
					end
				elseif not success then
					warn("Error al comprobar si el jugador está en el grupo " .. grupoId)
				end
			end
		elseif EsAdmin then
			EstaEnGrupo = true
		end

		-- Busca entre las divisiones que hay en el modulo
		for i, division in ipairs(informacionTeam.Divisions) do

			local clonedObject = script.Nombre_Division:Clone() -- Clona el boton
			clonedObject.Name = division.Name -- Pone el nombre de la division en el nombre del boton
			clonedObject.Text = division.Name -- Pone el nombre de la division en el texto del boton

			if i == 1 then -- Si el primer frame que se crea sera desbloqueado automaticamente
				divisionActual = division.Name
				divisionEnVista = division.Name
				clonedObject.BackgroundColor3 = colorVerde
				clonedObject:SetAttribute("Bloqueado", true) -- Bloqueado para evitar que le de de nuevo

			elseif division.Name == "LIDER" then -- Si el team tiene la division lider
				if division.Rango and localPlayer:GetRankInGroup(informacionTeam.Grupo) == division.Rango or EsAdmin then -- Si es el lider o es admin
					clonedObject.BackgroundColor3 = colorGris
					clonedObject:SetAttribute("Bloqueado", false) -- Desbloqueado
				else
					clonedObject.BackgroundColor3 = colorRojo
					clonedObject:SetAttribute("Bloqueado", true) -- Bloqueado
				end

			elseif division.Name == "GAMEPASS" then	-- Si el team tiene al division gamepass
				if moduloDatos.Module_obtenerValor("tieneGamepassJuggernaut")
					or EsAdmin then -- Si es lider o tiene el gamepass
					clonedObject.BackgroundColor3 = colorGris
					clonedObject:SetAttribute("Bloqueado", false) -- Desbloqueado
				else
					clonedObject.BackgroundColor3 = colorRojo
					clonedObject:SetAttribute("Bloqueado", true) -- Bloqueado
				end

			elseif EstaEnGrupo then -- Si la final de todo no es nada especial y el jugador esta en el grupo se deslboquea
				clonedObject.BackgroundColor3 = colorGris
				clonedObject:SetAttribute("Bloqueado", false) -- Desbloqueado
			else -- Si no esta en el grupo, no es admin y nada de lo anterior se aplico
				clonedObject.BackgroundColor3 = colorRojo
				clonedObject:SetAttribute("Bloqueado", true) -- Bloqueado
			end
			clonedObject.Parent = listaDivisiones

			-- Busca entre las unidades que hay en el modulo
			if i == 1 then
				for a, unit in ipairs(division.Units) do
					local Desbloqueado = false
					local clonedObject = script.Nombre_Unidad:Clone() -- Clona el contenedor
					clonedObject.Name = unit
					clonedObject.Nombre.Text = unit

					if a == 1 then -- Si es la primera unidad de la lista
						unidadActual = unit
						clonedObject.BackgroundColor3 = colorVerde
						clonedObject:SetAttribute("Bloqueado", true) -- Bloqueado para evitar volver a seleccionar
						Desbloqueado = true
					elseif EstaEnGrupo then -- Si pertenece al grupo
						clonedObject.BackgroundColor3 = colorGris
						clonedObject:SetAttribute("Bloqueado", false) -- Desbloqueado
						Desbloqueado = true
					else -- Si nada de lo anterior se cumple bloquea el boton
						clonedObject.BackgroundColor3 = colorRojo
						clonedObject:SetAttribute("Bloqueado", true) -- Bloqueado
					end
					if Desbloqueado then -- Si el jugador esta en el grupo se pone el icono de la division o grupo
						if division.IconoIndividual then -- Si esta unidad tiene un icono individual por su division
							clonedObject.Imagen.Icono.Image = division.IconoIndividual
						else -- Si no hay icono individual
							clonedObject.Imagen.Icono.Image = informacionTeam.IconoPrincipal
						end
					end
					clonedObject.Parent = listaUnidades -- Pone el boton en la lista de unidades
				end
			end
		end

		conectarBotonesDivisiones()
		conectarBotonesUnidades()

		if not conexionTecaPanelTrajes then
			botonesRapidos.PanelTrajes.Visible = true -- Esconde el boton del panel de trajes
			conexionTecaPanelTrajes = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
				if input.KeyCode == Enum.KeyCode.L and not (gameProcessedEvent or (procesando or procesandoTecla) or moduloDatos.Module_obtenerValor("cargandoJugador") or moduloDatos.Module_obtenerValor("menuAbierto")) then
					procesandoTecla = true
					abrirCerrarPanel()
					procesandoTecla = false
				end
			end)

			conexionBotonPanelTrajes = botonesRapidos.PanelTrajes.MouseButton1Click:Connect(function()
				if not (moduloDatos.Module_obtenerValor("cargandoJugador") or (procesando or procesandoTecla) or moduloDatos.Module_obtenerValor("menuAbierto")) then
					procesandoTecla = true
					abrirCerrarPanel()
					procesandoTecla = false
				end
			end)
		end
	elseif conexionTecaPanelTrajes or conexionBotonPanelTrajes then
		botonesRapidos.PanelTrajes.Visible = false
		conexionTecaPanelTrajes:Disconnect()
		conexionBotonPanelTrajes:Disconnect()
		conexionTecaPanelTrajes = nil
		conexionBotonPanelTrajes = nil
	end
end

function abrirCerrarPanel(obligatorio)
	panelAbierto = not panelAbierto

	local TargetY = nil
	local TweenInf = nil

	if not obligatorio then
		botonesRapidos.PanelTrajes.BackgroundColor3 = colorAmarillo
	end

	if panelAbierto then -- Muestra el panel de trajes si esta cerrado
		carpetaSonidos.Abrir:Play()
		TargetY = 0 -- Posicion abierta
	else -- Guarda el menu si esta mostrado
		if not obligatorio then
			carpetaSonidos.Cerrar:Play()
		end
		TargetY = -1 -- Posicion cerrada
	end

	local tiempoAnimacion = obligatorio and 0.5 or 1 -- Si es true, 0.5, si es false, 1

	TweenInf = TweenInfo.new(tiempoAnimacion, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local Tween = TweenService:Create(panelTrajes, TweenInf, {
		Position = UDim2.new(
			panelTrajes.Position.X.Scale,
			panelTrajes.Position.X.Offset,
			TargetY,
			panelTrajes.Position.Y.Offset
		)
	})

	panelTrajes.Visible = true
	Tween:Play() -- Ejecuta la animacion

	-- Espera hasta que la animacion termina
	while Tween.PlaybackState ~= Enum.PlaybackState.Completed and Tween.PlaybackState ~= Enum.PlaybackState.Cancelled do -- Por si la aniamcion se calcela sin sentido
		task.wait()
	end

	botonesRapidos.PanelTrajes.BackgroundColor3 = panelAbierto and colorVerde or colorNegro -- Boton interfaz
	panelTrajes.Visible = panelAbierto
end

function modulo.accionPanelTrajes(accion)

	if accion == "PreCargar" then
		preCargarUnidadDivision()
	elseif accion == "Configurar" then
		configurar = true
	elseif accion == "Cerrar" then
		cerrarPanel = true
	end

	if not procesando then
		procesando = true

		while procesandoTecla do -- Espera hasta que la accion de la tecla o boton termine
			task.wait()
		end

		while true do
			task.wait()

			if cerrarPanel then -- Si pide cerrar el panel
				if panelAbierto then -- Si el panel esta abierto
					abrirCerrarPanel(true)
				end
				cerrarPanel = false
			end

			if configurar then -- Si pide configurar el panel
				if panelAbierto then -- CIera el panel si esta abierto
					abrirCerrarPanel(true)
				end
				configurarDivisionesYUnidades()
				configurar = false
			end

			if not configurar and not cerrarPanel then -- Si no hace falta configura el panel o cerrarlo termina el bucle
				print("FIN BUCLE")
				procesando, configurar, cerrarPanel = false, false, false
				break
			end
		end
	end
end

return modulo
