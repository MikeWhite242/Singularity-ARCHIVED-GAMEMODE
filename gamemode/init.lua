
RunConsoleCommand("mp_falldamage","1")
AddCSLuaFile("shared.lua")
include("shared.lua")

function GM:PlayerSpawn(pl)
  pl:SetupHands(pl)
  pl:StripWeapons()
  pl:Give("singularity_hands")
  pl:Give("gmod_tool")
  pl:Give("weapon_physgun")
  pl:SetRunSpeed(200)
	pl:SetWalkSpeed(118)
	pl:SetSlowWalkSpeed(70)
	pl:SetDuckSpeed(0.2)
end

function GM:OnReloaded()
  MsgC(Color(10,132,255),"[SINGULARITY] loading gamemode...\n")
	singularity.includeDir("singularity/core")
	MsgC(Color(10,132,255),"[SINGULARITY] loading plugins...\n")
	singularity.includeDir("singularity/plugins")
	MsgC(Color(10,132,255),"[SINGULARITY] loading metas...\n")
	singularity.includeDir("singularity/meta")
	MsgC(Color(10,132,255),"[SINGULARITY] loading VGUI's...\n")
	singularity.includeDir("singularity/vgui")
	MsgC(Color(10,132,255),"[SINGULARITY] loading libraries...\n")
	singularity.includeDir("singularity/lib")
end

util.AddNetworkString("F4Menu")

function GM:ShowSpare2(ply)
    net.Start("F4Menu")
    net.Send(ply)
end
