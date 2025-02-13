local moduloDatos = require(script.Parent.Datos_Comportidos)

--------------------------------------
-------------- SERVICIOS -------------
--------------------------------------
local Players = moduloDatos.Module_obtenerValor("Players")
local ReplicatedStorage = moduloDatos.Module_obtenerValor("ReplicatedStorage")

--------------------------------------
----------- EVENTOS REMOTOS ----------
--------------------------------------
local eventoRemotoDarDinero = ReplicatedStorage:WaitForChild("DarDinero") -- Evento remoto para dar dinero al jugador

--------------------------------------
---------------- OTROS ---------------
--------------------------------------
local localPlayer = moduloDatos.Module_obtenerValor("localPlayer")
local moduloTeams = require(moduloDatos.Module_obtenerValor("OpcionesEquipo").ConfigTeams) -- Modulo de configuracion de los teams
local interfazDinero = moduloDatos.Module_obtenerValor("interfazLimitada").Interfaz_Dinero_Habilidades.Dinero.Puntos
local leaderstats = localPlayer.leaderstats
local money = leaderstats.Dinero

--------------------------------------
------------ CONFIGURACION -----------
--------------------------------------
local tiempoEntreCadaPago = 60 * 15 -- Minutos que pasaran entre cada pago
local dineroGanadoBasico = 20 -- Dinero basico que gana el jugador
local bonusPremium = 0.15 -- Bonus del 15% para los jugadores premium

--------------------------------------
---------------- VALORES -------------
--------------------------------------
local esPremium = false -- Si el jugador es premium
local dinero = 0 -- Dinero que ganara

--------------------------------------
--------------- INICIO ---------------
--------------------------------------
if localPlayer.MembershipType == Enum.MembershipType.Premium then -- Revisa si el jugador es premium
	esPremium = true
end

money.Changed:Connect(function(newValue) -- Detecta cuando el valor dinero es cambiado
	interfazDinero.Text = newValue
end)

interfazDinero.Text = money.Value -- Añade el dinero actual del jugador dentro del texto

--------------------------------------
---------- CODIGO PRINCIPAL ----------
--------------------------------------
task.spawn(function()
	while true do -- Bucle infinito que añade dinero al jugador cada X tiempo
		task.wait(tiempoEntreCadaPago) -- Cooldown en minutos

		local jugadoresActuales = #Players:GetPlayers() -- Pilla la cantidad actual de jugadores en el juego

		if jugadoresActuales >= 0 then -- Si son menos de X cantidad de jugador no da el dinero
			local playerTeam = localPlayer.Team.Name -- Pilla el team actual del jugador
			local team = moduloTeams[playerTeam] -- Busca el nombre del team del jugador en el modulo
			local tieneSalario = team.Salario -- Si el team tiene un salario definido

			if tieneSalario then -- Si el team tiene salario definido
				if esPremium then -- Si es premium le aplica un bonus
					dinero = tieneSalario * (1 + bonusPremium)
					eventoRemotoDarDinero:FireServer(dinero, playerTeam, esPremium)
				else -- Si no es premium
					eventoRemotoDarDinero:FireServer(tieneSalario, playerTeam, esPremium)
				end
			else -- Si no teiene salario definido
				if esPremium then -- Si es premium le aplica un bonus
					dinero = dineroGanadoBasico * (1 + bonusPremium)
					eventoRemotoDarDinero:FireServer(dinero, playerTeam, esPremium)
				else -- Si no es premium
					eventoRemotoDarDinero:FireServer(dineroGanadoBasico, playerTeam, esPremium)
				end
			end
		end
	end
end)

return true