local TeamsModule = {}

TeamsModule.RangosTarjeta = {
	[10] = 1,
	[15] = 2,
	[20] = 3,
	[25] = 4,
	[30] = 5,
}

-- Definición de equipos (o departamentos)
TeamsModule.Teams = {
	["AI || Agencia de Inteligencia"] = 5,
	["CE || Comite de Etica"] = 4,
	["DA || Departamento Administrativo"] = 5,
	["DC || Departamento Cientifico"] = 2,
	["DI || Departamento de Ingenieria"] = 3,
	["DM || Departamento Medico"] = 1,
	["DSI || Departamento de Seguridad Interna"] = 5,
	["DdAE || Departamento de Asuntos Externos"] = 4,
	["DdS || Departamento de Seguridad"] = 2,
	["ERR || Equipo de Respuesta Rapida"] = 5,
	["FTM || Fuerzas de Tareas Moviles"] = 4,
	["PF || Personal de la Fundacion"] = 1,
}

return TeamsModule
