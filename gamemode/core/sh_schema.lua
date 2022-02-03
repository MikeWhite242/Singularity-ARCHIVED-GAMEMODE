singularity.Schema = {}
singularity.Schema.Name = singularity.Schema.Name or "#NONE"

SCHEMA = {}
SCHEMA.Config = {}
SCHEMA.HUD = {}
SCHEMA.HUD.Elements = {
	["Crosshair"] = true,
	["Health"] = true,
	["Armor"] = true,
	["Ammo"] = true
}

function singularity.Schema.Boot( schemaName )
	singularity.ConsoleMessage("booting schema \"" .. schemaName .. "\"")
	singularity.Schema.Name = schemaName
	singularity.includeDir(GM.FolderName .. "/schema")
end

-- Default Hooks

function SCHEMA:ShowRankInChat(ply,rank)
	return true
end

function SCHEMA:SetHUDElement( element, bVal )
	self.HUD.Elements[element] = bVal
end

function SCHEMA:ShouldDrawElement( element )
	return self.HUD.Elements[element]
end