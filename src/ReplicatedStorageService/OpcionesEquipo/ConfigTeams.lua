-- Colores
local Aliados = Color3.fromRGB(170, 170, 170)		-- Gris
local SCP = Color3.fromRGB(170, 170, 0) 			-- Amarillo
local Reclusos = Color3.fromRGB(170, 100, 0)		-- Naranja
local Hostiles = Color3.fromRGB(170, 0, 0) 			-- Rojo
local Neutrales = Color3.fromRGB(0, 77, 170) 		-- Azul
local IDsGruposGamepass = game:GetService("ReplicatedStorage").OpcionesEquipo

local Equipos = {}

Equipos["CD || Clase D"] = {
	Salario = nil,
	Grupo = nil,
	RequisitoRango = nil,
	Gamepass = nil,
	Informacion = "Los sujetos de prueba denominados como Clase-D son un actor fundamental en la misión de la Fundación SCP para entender, contener y proteger a la humanidad de lo inexplicable. A pesar de los desafíos, tu contribución es esencial para el bienestar de todos.", -- Descripción
	HabilidadesEspeciales = {"Sin habilidades.", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=6443974032",
	Color = Reclusos,
	Tipo = "RECLUSO",
	Tag = { 
		Prefijo = "CD-",
		Color = Color3.fromRGB(220, 154, 0),
		Rango = "Numero",
		SinRango = nil
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"RECLUSO"}
		}
	}
}

Equipos["IC || Insurgencia del Caos"] = {
	Salario = 47,
	Grupo = IDsGruposGamepass.ID_GrupoIC.Value,
	RequisitoRango = nil,
	Gamepass = IDsGruposGamepass.GP_IC.Value,
	Informacion = "La Insurgencia del Caos es un grupo rebelde que se opone a la Fundación SCP y busca aprovechar los objetos anómalos para sus propios fines.",
	HabilidadesEspeciales = {"- Sabotaje.", "- Daño extra del 10% contra jugadores"},
	IconoPrincipal = "http://www.roblox.com/asset/?id=12048832754",
	Color = Hostiles,
	Tipo = "HOSTIL",
	Tag = { 
		Prefijo = nil,
		Color = Color3.fromRGB(0, 0, 0),
		Rango = "Grupo", 
		SinRango = "INSURGENTE DEL CAOS"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"RECLUTA", "OPERATIVO", "MEDICO", "HAZMAT", "OFICIAL", "CAPITAN"}
		},
		{
			Name = "GAMEPASS",
			Units = {"JUGGERNAUT"}
		},
		{
			Name = "LIDER",
			RangoLider = 254,
			Units = {"AGENTE 47"}
		}
	}
}

Equipos["AI || Agencia de Inteligencia"] = {
	Salario = 38,
	Grupo = IDsGruposGamepass.ID_GrupoAI.Value,
	RequisitoRango = nil,
	Gamepass = nil,
	Informacion = "La Agencia de Inteligencia es la mente maestra que guía a la Fundación SCP, asegurando que cada movimiento esté respaldado por un conocimiento profundo y una comprensión precisa de los eventos anómalos.",
	HabilidadesEspeciales = {"- Localización de SCPs.", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=18219207176",
	Color = Aliados,
	Tipo = "SEMI COMBATIVO",
	Tag = { 
		Prefijo = "AI-", 
		Color = Color3.fromRGB(105, 0, 140),
		Rango = "Numero", 
		SinRango = "AGENTE NO OFICIAL"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"RECLUTA", "AGENTE", "HAZMAT", "ONIX", "LEXUZ", "VIX", "DIRECTOR EJECUTIVO", "ASISTENTE DIRECTOR", "DIRECTOR"}
		},
		{
			Name = "GAMEPASS",
			Units = {"JUGGERNAUT"}
		},
		{
			Name = "LIDER",
			RangoLider = 253,
			Units = {"O5-7"}
		}
	}
}

Equipos["CE || Comite de Etica"] = {
	Salario = 44,
	Grupo = IDsGruposGamepass.ID_GrupoCEyDTI.Value,
	RequisitoRango = nil,
	Gamepass = nil,
	Informacion = "El Comité de Ética es la voz moral que guía las acciones de la Fundación SCP. Tu compromiso con la ética y la responsabilidad contribuirá a mantener el equilibrio entre la búsqueda del conocimiento y el respeto por la humanidad y los derechos individuales.",
	HabilidadesEspeciales = {"Sin habilidades.", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=17458584039",
	Color = Aliados,
	Tipo = "NO COMBATIVO",
	Tag = { 
		Prefijo = nil,
		Color = Color3.fromRGB(41, 140, 61),
		Rango = "Grupo", 
		SinRango = "AGENTE NO OFICIAL"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"INTERNO", "AGENTE", "SECRETARIA", "ABOGADO", "INSPECTOR", "JUEZ"}
		},
		{
			Name = "LIDER",
			RangoLider = 254,
			Units = {"O5-2"}
		}
	}
}

Equipos["COG || Coalicion Oculta Global"] = {
	Salario = 34,
	Grupo = IDsGruposGamepass.ID_GrupoCOG.Value,
	RequisitoRango = nil,
	Gamepass = IDsGruposGamepass.GP_COG.Value,
	Informacion = "La Coalicion Oculta Global es la responsable de formar una red global de agentes dedicados a proteger a la humanidad de lo inexplicable. En las sombras, la COG opera como un escudo contra las amenazas que acechan en la oscuridad, manteniendo la balanza entre lo normal y lo anómalo.",
	HabilidadesEspeciales = {"- Daño del 25% contra SCPs", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=11675084985",
	Color = Neutrales,
	Tipo = "NEUTRAL",
	Tag = { 
		Prefijo = nil,
		Color = Color3.fromRGB(0, 9, 140),
		Rango = "Grupo", 
		SinRango = "OPERATIVO NO OFICIAL"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"BASICO", "HT OPERATIVO", "MEDICO", "PESADO", "FRANCOTIRADOR", "AGENTE", "CAPITAN", "TENIENTE", "COMANDANTE"}
		},
		{
			Name = "GAMEPASS",
			Units = {"JUGGERNAUT"}
		},
		{
			Name = "LIDER",
			RangoLider = 10,
			Units = {"LIDER 108"}
		}
	}
}

Equipos["DA || Departamento Administrativo"] = {
	Salario = 70,
	Grupo = IDsGruposGamepass.ID_GrupoPrincipal.Value,
	RequisitoRango = 100,
	Gamepass = nil,
	Informacion = "El Departamento Administrativo es la columna vertebral de la Fundación SCP, garantizando que cada engranaje funcione en armonía para proteger a la humanidad de lo inexplicable.",
	HabilidadesEspeciales = {"- Aparece y desaparece a su antojo.", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=120511702058601",
	Color = Aliados,
	Tipo = "NO COMBATIVO",
	Tag = { 
		Prefijo = nil,
		Color = Color3.fromRGB(140, 109, 59),
		Rango = "Grupo", 
		SinRango = "ADMINISTRATIVO NO OFICIAL"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"ADMINSITRADOR"}
		},
		{
			Name = "LIDER",
			RangoLider = nil,
			Units = {"LIDER 05"}
		}
	}
}

Equipos["DM || Departamento Medico"] = {
	Salario = 43,
	Grupo = IDsGruposGamepass.ID_GrupoDM.Value,
	RequisitoRango = nil,
	Gamepass = nil,
	Informacion = "El Departamento Médico de la Fundación SCP es el guardián de la salud y el bienestar dentro de la organización, asegurando que cada miembro, desde los investigadores hasta el personal de contención, reciba la atención necesaria para enfrentar los desafíos de lo anómalo. Con un equipo de profesionales altamente capacitados, el Departamento Médico maneja todo, desde emergencias críticas causadas por entidades peligrosas hasta el cuidado preventivo, proporcionando un refugio seguro para aquellos que arriesgan sus vidas en nombre de la ciencia y la seguridad global.",
	HabilidadesEspeciales = {"- Capacidad de curacion al 100%", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=8629059077",
	Color = Aliados,
	Tipo = "NO COMBATIVO",
	Tag = { 
		Prefijo = nil,
		Color = Color3.fromRGB(0, 140, 131),
		Rango = "Grupo", 
		SinRango = "MEDICO NO OFICIAL"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"ESTUDIANTE", "MEDICO", "HAZMAT", "MEDICO TACTICO", "DOCTOR", "ASISTENTE DIRECTOR", "DIRECTOR"}
		},
		{
			Name = "LIDER",
			RangoLider = 253,
			Units = {"O5-6"}
		}
	}
}

Equipos["DC || Departamento Cientifico"] = {
	Salario = 55,
	Grupo = IDsGruposGamepass.ID_GrupoDC.Value,
	RequisitoRango = nil,
	Gamepass = nil,
	Informacion = "El Departamento Científico te permite sumergirte en el fascinante mundo de lo anómalo, donde tu curiosidad y habilidades científicas son fundamentales para desentrañar los misterios que yacen más allá de la comprensión convencional. La búsqueda del conocimiento es la fuerza impulsora que nos guía hacia la seguridad y la preservación de la humanidad.",
	HabilidadesEspeciales = {"Sin habilidades.", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=16395755105",
	Color = Aliados,
	Tipo = "NO COMBATIVO",
	Tag = { 
		Prefijo = nil,
		Color = Color3.fromRGB(91, 133, 140),
		Rango = "Grupo", 
		SinRango = "CIENTIFICO NO OFICIAL"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"APRENDIZ", "CIENTIFICO", "HAZMAT", "LIDER CIENTIFICO", "INVESTIGADOR", "ASISTENTE DIRECTOR", "DIRECTOR"}
		},
		{
			Name = "LIDER",
			RangoLider = 252,
			Units = {"O5-3"}
		}
	}
}

Equipos["DI || Departamento de Ingenieria"] = {
	Salario = 42,
	Grupo = IDsGruposGamepass.ID_GrupoDI.Value,
	RequisitoRango = nil,
	Gamepass = nil,
	Informacion = "El Departamento de Ingeniería es parte fundamental de la construcción del escudo protector que mantiene a la humanidad a salvo de lo inexplicable. Tu destreza y creatividad serán esenciales para diseñar y mantener las barreras que separan la normalidad de lo anómalo.",
	HabilidadesEspeciales = {"- Arreglan de todo", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=15777120928",
	Color = Aliados,
	Tipo = "NO COMBATIVO",
	Tag = { 
		Prefijo = nil, 
		Color = Color3.fromRGB(140, 135, 0),
		Rango = "Grupo", 
		SinRango = "INGENIERO NO OFICIAL"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"APRENDIZ", "INGENIERO", "HAZMAT", "SUPERVISOR"}
		},
		{
			Name = "LIDER",
			RangoLider = 253,
			Units = {"O5"}
		}
	}
}

Equipos["DdAE || Departamento de Asuntos Externos"] = {
	Salario = 46,
	Grupo = IDsGruposGamepass.ID_GrupoDAE.Value,
	RequisitoRango = nil,
	Gamepass = nil,
	Informacion = "El Departamento de Asuntos Exteriores es la embajada de la Fundación SCP. Tu habilidad para manejar relaciones externas y mantener la discreción será esencial para preservar la seguridad global y la estabilidad en el equilibrio entre lo conocido y lo anómalo.",
	HabilidadesEspeciales = {"Sin habilidades.", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=18219268456",
	Color = Aliados,
	Tipo = "NO COMBATIVO",
	Tag = { 
		Prefijo = nil, 
		Color = Color3.fromRGB(103, 140, 34),
		Rango = "Grupo", 
		SinRango = "AGENTE NO OFICIAL"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"RESIDENTE", "AGENTE", "DIPLOMATICO", "EMBAJADOR", "ASISTENTE DIRECTOR", "DIRECTOR"}
		},
		{
			Name = "LIDER",
			RangoLider = 253,
			Units = {"O5-4"}
		}
	}
}

Equipos["DdS || Departamento de Seguridad"] = {
	Salario = 25,
	Grupo = IDsGruposGamepass.ID_GrupoDdS.Value,
	RequisitoRango = nil,
	Gamepass = nil,
	Informacion = "Departamento de Seguridad es el protector directo de la Fundación SCP. Tu dedicación y habilidades en seguridad serán esenciales para mantener la integridad de la organización mientras enfrentamos desafíos y amenazas inesperadas.",
	HabilidadesEspeciales = {"Sin habilidades.", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=107822717700673",
	Color = Aliados,
	Tipo = "COMBATIVO",
	Tag = { 
		Prefijo = nil, 
		Color = Color3.fromRGB(140, 140, 140),
		Rango = "Grupo", 
		SinRango = "GUARDIA NO OFICIAL"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"RECLUTA", "GUARDIA", "CORPORAL", "MEDICO", "HAZMAT", "FRANCOTIRADOR", "AGENTE", "SARGENTO", "TENIENTE", "CAPITAN", "ASISTENTE DIRECTOR", "JEFE DE SEGURIDAD", "COMANDANTE", "DIRECTOR"}
		},
		{
			Name = "GAMEPASS",
			Units = {"JUGGERNAUT"}
		},
		{
			Name = "LIDER",
			RangoLider = 253,
			Units = {"O5-12"}
		}
	}
}

Equipos["ERR || Equipo de Respuesta Rapida"] = {
	Salario = 34,
	Grupo = IDsGruposGamepass.ID_GrupoERR.Value,
	RequisitoRango = nil,
	Gamepass = nil,
	Informacion = "El Equipo de Respuesta Rápida es el último grupo que actúa como bastión de defensa contra lo desconocido. Tu dedicación y valentía serán fundamentales para proteger a la humanidad de las amenazas que acechan en el mundo anómalo.",
	HabilidadesEspeciales = {"- Daño extra del 15% contra jugadores", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=18219224285",
	Color = Aliados,
	Tipo = "COMBATIVO",
	Tag = { 
		Prefijo = "ERR-", 
		Color = Color3.fromRGB(),
		Rango = "Numero", 
		SinRango = "OPERATIVO NO OFICIAL"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"RECLUTA", "OPERATIVO", "MEDICO", "SARGENTO", "CAPITAN", "MAYOR", "OFICIAL EJECUTIVO", "ASISTENTE", "COMANDANTE", "DIRECTOR"}
		},
		{
			Name = "GAMEPASS",
			Units = {"JUGGERNAUT"}
		},
		{
			Name = "LIDER",
			RangoLider = 253,
			Units = {"O5-8"}
		}
	}
}

Equipos["FTM || Fuerzas de Tareas Moviles"] = {
	Salario = 30,
	Grupo = IDsGruposGamepass.ID_GrupoFTM.Value,
	RequisitoRango = nil,
	Gamepass = nil,
	Informacion = "Las Fuerzas de Tareas Móviles son equipos altamente capacitados que se enfrentan a lo desconocido con velocidad y eficacia. Tu habilidad para adaptarte a situaciones cambiantes y abordar amenazas en cualquier lugar del mundo será esencial para la misión de la Fundación SCP.",
	HabilidadesEspeciales = {"- Vision Nocturna Especial", "- Capacidad para contener"},
	IconoPrincipal = "http://www.roblox.com/asset/?id=14170240874",
	Color = Aliados,
	Tipo = "COMBATIVO",
	Tag = { 
		Prefijo = nil, 
		Color = Color3.fromRGB(140, 89, 8),
		Rango = "Grupo", 
		SinRango = "OPERATIVO NO OFICIAL"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"RECLUTA", "HT RECLUTA"}
		},
		{
			Name = "ALPHA-1",
			IconoIndividual = "http://www.roblox.com/asset/?id=13378201592",
			Units = {"OPERATIVO", "ESPECIALISTA", "CAPITAN"}
		},
		{
			Name = "BETA-7",
			IconoIndividual = "http://www.roblox.com/asset/?id=7448475673",
			Units = {"OPERATIVO", "ESPECIALISTA", "CAPITAN"}
		},
		{
			Name = "EPSILON-11",
			IconoIndividual = "http://www.roblox.com/asset/?id=1433788937",
			Units = {"OPERATIVO", "ESPECIALISTA", "CAPITAN"}
		},
		{
			Name = "EPSILON-9",
			IconoIndividual = "http://www.roblox.com/asset/?id=15005064545",
			Units = {"OPERATIVO", "ESPECIALISTA", "CAPITAN"}
		},
		{
			Name = "NU-7",
			IconoIndividual = "http://www.roblox.com/asset/?id=10743733971",
			Units = {"OPERATIVO", "ESPECIALISTA", "CAPITAN"}
		},
		{
			Name = "OMEGA-1",
			IconoIndividual = "http://www.roblox.com/asset/?id=11947672481",
			Units = {"OPERATIVO", "ESPECIALISTA", "CAPITAN"}
		},
		{
			Name = "TAU-5",
			IconoIndividual = "http://www.roblox.com/asset/?id=11829158712",
			Units = {"OPERATIVO", "ESPECIALISTA", "CAPITAN"}
		},
		{
			Name = "GAMEPASS",
			Units = {"JUGGERNAUT"}
		},
		{
			Name = "LIDER",
			RangoLider = 253,
			Units = {"O5-5"}
		}
	}
}

Equipos["GRU || Division P"] = {
	Salario = 5,
	Grupo = IDsGruposGamepass.ID_GrupoGRU.Value,
	RequisitoRango = nil,
	Gamepass = IDsGruposGamepass.GP_GRU.Value,
	Informacion = "La División P es la fuerza del orden de la querida madre patria. Su poder es incomparable, y su principal objetivo es la recuperación total de todas las anomalías de la Fundación SCP. Destruye a la fundación y captura a las anomalías para nuestro beneficio.",
	HabilidadesEspeciales = {"- Bonificacion de salud", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=745714842",
	Color = Hostiles,
	Tipo = "HOSTIL",
	Tag = { 
		Prefijo = nil, 
		Color = Color3.fromRGB(0, 220, 7),
		Rango = "Grupo", 
		SinRango = "SOLDADO NO OFICIAL"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"BASICO", "SOLDADO", "MEDICO", "FRANCOTIRADOR", "SARGENTO", "TENIENTE", "HT PESADO"}
		},
		{
			Name = "GAMEPASS",
			Units = {"JUGGERNAUT"}
		},
		{
			Name = "LIDER",
			RangoLider = 254,
			Units = {"COMISARIO"}
		}
	}
}

Equipos["CS || Culto Sarkico"] = {
	Salario = nil,
	Grupo = nil,
	RequisitoRango = nil,
	Gamepass = IDsGruposGamepass.GP_CS.Value,
	Informacion = "[Contenido redactado por el consejo O5]",
	HabilidadesEspeciales = {"- Transformacion en anomalia", "- Inmune a los SCPs"},
	IconoPrincipal = "http://www.roblox.com/asset/?id=12655875106",
	Color = SCP,
	Tipo = "SITUACIONAL",
	Tag = { 
		Prefijo = nil, 
		Color = Color3.fromRGB(220, 0, 0),
		Rango = "Grupo", 
		SinRango = "CREYENTE"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"SEGUIDOR", "ADEPTO", "DEVOTO", "SACERDOTE", "ALTO SACERDOTE", "GUARDIAN OCULTO", "GUARDIAN SAGRADO"}
		},
		{
			Name = "GAMEPASS",
			Units = {"JUGGERNAUT"}
		},
		{
			Name = "LIDER",
			RangoLider = nil,
			Units = {"LIDER SUPREMO"}
		}
	}
}

Equipos["DSI || Departamento de Seguridad Interna"] = {
	Salario = 38,
	Grupo = IDsGruposGamepass.ID_GrupoDSI.Value,
	RequisitoRango = nil,
	Gamepass = nil,
	Informacion = "El [REDACTADO] es el escudo que resguarda la Fundación SCP. Tu dedicación a la seguridad y tu capacidad para anticipar y neutralizar amenazas serán esenciales para mantener la integridad de la organización y preservar la seguridad de la humanidad ante lo anómalo.",
	HabilidadesEspeciales = {"- Detecta hostiles en un radio", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=18219218843",
	Color = Aliados,
	Tipo = "COMBATIVO",
	Tag = { 
		Prefijo = "DSI-", 
		Color = Color3.fromRGB(140, 0, 0),
		Rango = "Numero", 
		SinRango = "AGENTE NO OFICIAL"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"RECLUTA", "INTERNO", "HAZMAT", "COMBATIVO", "ASISTENTE DIRECTOR", "DIRECTOR"}
		},
		{
			Name = "GAMEPASS",
			Units = {"JUGGERNAUT"}
		},
		{
			Name = "LIDER",
			RangoLider = 254,
			Units = {"O5-1"}
		}
	}
}

Equipos["UII || Unidad de Incidentes Inusuales"] = {
	Salario = 36,
	Grupo = IDsGruposGamepass.ID_GrupoUII.Value,
	RequisitoRango = nil,
	Gamepass = IDsGruposGamepass.GP_UII.Value,
	Informacion = "[Contenido redactado por el consejo O5]",
	HabilidadesEspeciales = {"Sin habilidades.", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=15521837049",
	Color = Neutrales,
	Tipo = "NEUTRAL",
	Tag = { 
		Prefijo = nil, 
		Color = Color3.fromRGB(53, 95, 140),
		Rango = "Grupo", 
		SinRango = "FBI NO OFICIAL"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"BASICO", "AGENTE", "HAZMAT", "OPERATIVO", "MEDICO", "FRANCOTIRADOR", "FUERZAS ESPECIALES"}
		},
		{
			Name = "GAMEPASS",
			Units = {"JUGGERNAUT"}
		},
		{
			Name = "LIDER",
			RangoLider = 254,
			Units = {"BOSS"}
		}
	}
}

Equipos["SCP || Anomalias"] = {
	Salario = nil,
	Grupo = nil,
	RequisitoRango = nil,
	Gamepass = IDsGruposGamepass.GP_SCP.Value,
	Informacion = "[Contenido redactado por el consejo O5]",
	HabilidadesEspeciales = {"Inmune a los SCPs", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=107450123133678",
	Color = SCP,
	Tipo = "SITUACIONAL",
	Tag = { 
		Prefijo = nil, 
		Color = Color3.fromRGB(220, 0, 0),
		Rango = "SCP",
		SinRango = "SIN GAMEPASS"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"SCP-049", "SCP-073", "SCP-076", "SCP-096", "SCP-106", "SCP-457", "SCP-662"}
		},
		{
			Name = "GAMEPASS",
			Units = {"SCP-001"}
		}
	},
}

Equipos["PF || Personal de la Fundacion"] = {
	Salario = 22,
	Grupo = IDsGruposGamepass.ID_GrupoPrincipal.Value,
	RequisitoRango = nil,
	Gamepass = nil,
	Informacion = "El personal de la Fundación es la piedra angular de la organización; sin ellos, ningún departamento tendría miembros, ya que todos los integrantes de cualquier departamento han sido, en algún momento, parte del personal de la Fundación.",
	HabilidadesEspeciales = {"Sin habilidades.", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=2240081681",
	Color = Aliados,
	Tipo = "NO COMBATIVO",
	Tag = { 
		Prefijo = nil, 
		Color = Color3.fromRGB(140, 128, 119),
		Rango = "Grupo", 
		SinRango = "PERSONAL NO OFICIAL"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"PERSONAL", "CONSERJE"}
		}
	},
}

Equipos["FB || Fuerza Blindada"] = {
	Salario = 15,
	Grupo = nil,
	RequisitoRango = nil,
	Gamepass = nil,
	Informacion = "---",
	HabilidadesEspeciales = {"Sin habilidades.", ""},
	IconoPrincipal = "http://www.roblox.com/asset/?id=8761604962",
	Color = Aliados,
	Tipo = "ESPECIAL",
	Tag = { 
		Prefijo = nil, 
		Color = Color3.fromRGB(140, 0, 0),
		Rango = "Grupo", 
		SinRango = "GDI"
	},
	Divisions = {
		{
			Name = "ESTANDAR",
			Units = {"GEO", "GRUT"}
		}
	},
}

-- Equipos["LMS || La Mano de la Serpeinte"] = {
--	Salario = 21,
--	Informacion = "[Contenido redactado por el consejo O5]",
--	HabilidadesEspeciales = {"- Adopta la apariencia de otro jugadores.", ""},
--	IconoPrincipal = "http://www.roblox.com/asset/?id=5044896355",
--	Color = GrupoDeInteres,
--	Tag = "HOSTIL",
--	Divisions = {
--		{
--			Name = "ESTANDAR",
--			Units = {"Ni puta idea"}
--		},
--		{
--			Name = "GAMEPASS",
--			Units = {"JUGGERNAUT"}
--		},
--		{
--			Name = "LIDER",
--			Units = {"Ni puta idea"}
--		}
--	}
--}

return Equipos
