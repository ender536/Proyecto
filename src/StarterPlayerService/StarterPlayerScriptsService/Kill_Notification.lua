local moduloDatos = require(script.Parent.Datos_Comportidos)

local TweenService = moduloDatos.Module_obtenerValor("TweenService")
local ReplicatedStorage = moduloDatos.Module_obtenerValor("ReplicatedStorage")
local GUI = moduloDatos.Module_obtenerValor("interfazLimitada")
local eventoRemotoJugadorMuerto = ReplicatedStorage:WaitForChild("KillBy") -- Evento remoto que indica que a muerto un jugador
local scrollingFrame = GUI.Interfaz_Notificacion_Kill -- Lista de jugadores muertos
local frameJugadorMuerto = script.FrameJugador -- Frame que muesta al jugador muerto
local sonidoKill = script.Hitmarker -- Carpeta de sonidos

local frames = {} -- Array que almacenará los frames en orden
local animatingFrames = {} -- Array para rastrear frames en animación
local frameLifetime = 5 -- Tiempo en segundos que cada frame permanecerá antes de ser eliminado

-- Animacion para eliminar el frame del jugador terminado
local function animateRemoval(frame)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local goal = {Position = UDim2.new(-1, 0, frame.NombreJugador.Position.Y.Scale, frame.NombreJugador.Position.Y.Offset)} -- Mover hacia la izquierda
	local tween = TweenService:Create(frame.NombreJugador, tweenInfo, goal)
	tween:Play()
	tween.Completed:Connect(function()
		frame:Destroy() -- Eliminar el frame después de la animación
		animatingFrames[frame] = nil -- Eliminar el frame del array de animación
		-- Eliminar el frame del array de frames
		for i, f in ipairs(frames) do
			if f == frame then
				table.remove(frames, i)
				break
			end
		end
	end)
	animatingFrames[frame] = true -- Añadir el frame al array de animación
end

-- Genera un frame del jugador terminado
eventoRemotoJugadorMuerto.OnClientEvent:Connect(function(playerName)
	-- Verificar si el nombre recibido es el mismo que el del jugador local
	if playerName == game.Players.LocalPlayer.Name then
		return -- Ignorar si es el mismo
	end

	-- Clonar y agregar el nuevo frame
	local newFrame = frameJugadorMuerto:Clone()
	newFrame.Parent = scrollingFrame
	newFrame.NombreJugador.Text = "Eliminado " .. playerName
	table.insert(frames, 1, newFrame) -- Insertar nuevo frame al inicio del array

	sonidoKill:Play() -- Sonido de muerte

	-- Configuración para la animación del nuevo frame
	newFrame.Size = UDim2.new(1, 0, 0, 0) -- Tamaño inicial (ancho completo y altura 0)
	local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local goal = {Size = UDim2.new(1, 0, 0.25, 0)} -- Tamaño final (ancho completo y altura 0.25)
	local tween = TweenService:Create(newFrame, tweenInfo, goal)
	tween:Play()

	-- Esperar a que la animación de expansión termine
	tween.Completed:Wait()

	-- Actualizar la transparencia y el LayoutOrder de cada frame
	for i, frame in ipairs(frames) do
		frame.LayoutOrder = i
		if i == 2 then
			frame.NombreJugador.TextTransparency = 0.3 -- El segundo, 30% de transparencia
		elseif i == 3 then
			frame.NombreJugador.TextTransparency = 0.6 -- El tercero, 60% de transparencia
		elseif i == 4 then
			frame.NombreJugador.TextTransparency = 0.9 -- El cuarto, 90% de transparencia
		end
	end

	-- Animar y eliminar el frame más antiguo si hay más de 4
	if #frames > 4 then
		local oldestFrame = frames[5] -- Remover el último (más antiguo)
		if not animatingFrames[oldestFrame] then
			table.remove(frames, 5) -- Eliminar el frame del array
			animateRemoval(oldestFrame) -- Animar y eliminar el frame
		end
	end

	-- Programar la eliminación del frame después de un tiempo específico
	for i = #frames, 1, -1 do
		local frame = frames[i]
		delay(frameLifetime, function()
			if frame and frame.Parent then -- Verificar si el frame aún está en el `ScrollingFrame`
				if not animatingFrames[frame] then
					animateRemoval(frame)
				end
			end
		end)
	end
end)

return true