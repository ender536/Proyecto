--------------------------------------
-------------- SERVICIOS -------------
-------------------------------------- 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

--------------------------------------
----------- EVENTOS REMOTOS ----------
--------------------------------------
local remoteFunctionResetPlayer = ReplicatedStorage:WaitForChild("ResetPlayer") -- Reiniciar al jugador

--------------------------------------
---------------- OTROS ---------------
--------------------------------------
local localPlayer = Players.LocalPlayer
local playerGUI = localPlayer.PlayerGui
local interfazCompleta = playerGUI:WaitForChild("Interfaz_Completa")
local interfazCompletaVisionEspecial = playerGUI:WaitForChild("Interfaz_Completa_NVG")
local interfazLimitada = playerGUI:WaitForChild("Interfaz_Limitada")
local interfazBackground = playerGUI:WaitForChild("Inventario")
local OpcionesEquipo = ReplicatedStorage:WaitForChild("OpcionesEquipo")
local botonesRapidos = interfazCompleta.Interfaz_Botones_Rapidos
local carpetaEventosLocales = ReplicatedStorage:WaitForChild("GeneralLocalEvents")

--------------------------------------
--------------- COLORES --------------
--------------------------------------
local colorAmarillo = Color3.fromRGB(157, 157, 0) -- Color amarillo
local colorNegro = Color3.fromRGB(0, 0, 0) -- Color negro
local colorGris = Color3.fromRGB(157, 157, 157) -- Color gris
local colorVerde = Color3.fromRGB(3, 157, 0) -- Colro verde
local colorRojo = Color3.fromRGB(157, 0, 3) -- Color rojo

--------------------------------------
----------- VALORES BOOLEAN ----------
--------------------------------------
local esAdmin = false -- Si el jugador es administrador o no
local tieneGamepassJuggernaut = false -- Si tiene el gamepass de jugarnaut o no
local cargandoJugador = false -- Si el jugador se esta cargando o no
local menuAbierto = true -- Si el menu esta abierto o no

--------------------------------------
------------- VALORES NIL ------------
--------------------------------------
local actualTema = nil -- Guarda el team actual del jguador
local actualDivision = nil -- Guarda la division en la que se encuentrar el jugador actualemtne
local actualUnit = nil -- Guarda la unidad actual del jugador

-- NVG --
local procesandoVision = false -- Si hay una vision en proceso de ejecucion o no
local typeOfVision = nil -- Tipo de vision que tiene el jugador

--------------------------------------
----------- COMPROBACIONES -----------
--------------------------------------
esAdmin = true

--[[ 
while true do -- Revisa si el jugador es un adminsitrador para desbloquear todos los teams
	local success, rank = pcall(function() -- Evita que el codigo pete
		return localPlayer:GetRankInGroup(OpcionesEquipo.ID_GrupoPrincipal.Value)
	end)

	if success then -- Si no a habido ningun error de HTTP
		if rank >= 110 then
			esAdmin = true
		end
		break -- Salir del bucle si no hubo error (independientemente de si cumple la condición o no)
	else
		warn("Error al obtener el rango. Reintentando...")
		task.wait(1) -- Espera antes de reintentar
	end
end

while true do -- Revisa si el jugador tiene el gamepass de Juggernaut
	local success, ownsGamepass = pcall(function() -- Evita que el codigo pete
		-- Revisa si tiene el gamepass de Juggernaut
		return MarketplaceService:UserOwnsGamePassAsync(localPlayer.UserId, OpcionesEquipo.GP_Juggernaut.Value)
	end)

	if success then -- Si no a habido ningun error de HTTP
		if ownsGamepass then
			tieneGamepassJuggernaut = true
		end
		break -- Salir del bucle si no hubo error (independientemente de si cumple la condición o no)
	else
		warn("Error al verificar el Gamepass Juggernaut para el jugador. Reintentando...")
		task.wait(1) -- Espera antes de reintentar
	end
end
]]--

--------------------------------------
---------- DATOS COMPARTIDOS ---------
--------------------------------------
local datosCompartidos = {
	ReplicatedStorage = ReplicatedStorage,
	UserInputService = UserInputService,
	MarketplaceService = MarketplaceService,
	TweenService = TweenService,
	Lighting = Lighting,
	Players = Players,
	localPlayer = localPlayer,
	interfazCompleta = interfazCompleta,
	interfazLimitada = interfazLimitada,
	interfazCompletaVisionEspecial = interfazCompletaVisionEspecial,
	interfazBackground = interfazBackground,
	colorAmarillo = colorAmarillo,
	colorNegro = colorNegro,
	colorGris = colorGris,
	colorVerde = colorVerde,
	colorRojo = colorRojo,
	remoteFunctionResetPlayer = remoteFunctionResetPlayer,
	carpetaEventosLocales = carpetaEventosLocales,
	esAdmin = esAdmin,
	tieneGamepassJuggernaut = tieneGamepassJuggernaut,
	cargandoJugador = cargandoJugador,
	menuAbierto = menuAbierto,
	actualTema = actualTema,
	actualDivision = actualDivision,
	actualUnit = actualUnit,
	botonesRapidos = botonesRapidos,
	typeOfVision = typeOfVision,
	OpcionesEquipo = OpcionesEquipo,
}

--------------------------------------
---------- ENTRADA Y SALIDA ----------
--------------------------------------
local modulo = {}

-- Función para obtener un valor de los datos compartidos
function modulo.Module_obtenerValor(clave)
	return datosCompartidos[clave]
end

-- Función para establecer un valor en los datos compartidos
function modulo.Module_establecerValor(clave, valor)
	datosCompartidos[clave] = valor
end

return modulo
