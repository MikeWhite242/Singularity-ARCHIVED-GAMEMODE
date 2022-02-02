
RunConsoleCommand("mp_falldamage","1")
AddCSLuaFile("shared.lua")
include("shared.lua")

function GM:PlayerSpawn(pl)
    pl:StripWeapons()
    pl:Give("singularity_hands")
    pl:Give("gmod_tool")
    pl:Give("weapon_physgun")
    pl:SetRunSpeed(200)
	pl:SetWalkSpeed(118)
	pl:SetSlowWalkSpeed(70)
	pl:SetDuckSpeed(0.2)
end