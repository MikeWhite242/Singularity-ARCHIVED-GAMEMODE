singularity.Teams = singularity.Teams or {}
singularity.Teams.Data = singularity.Teams.Data or {}
singularity.TeamIndex = singularity.TeamIndex or 1

-- provide table for team data
-- 

-- Must be hooked into CreateTeams or bugs out
function singularity.Teams.Define(self)

	for _,Team in ipairs(singularity.Teams.Data) do
		if Team.UniqueID == self.UniqueID then
			return _
		end
	end
	
	
	singularity.ConsoleMessage("Registering team \n"..self.UniqueID)
	team.SetUp(singularity.TeamIndex, self.DisplayName, self.TeamColor, true)
	local teamIndex = singularity.TeamIndex + 0
	singularity.Teams.Data[teamIndex] = self
	singularity.TeamIndex = teamIndex + 1

	return teamIndex
end

if SERVER then

	hook.Add("PlayerLoadout", "singularityTeamLoadout", function(ply)
		local loadout = ply:GetLoadout() or nil
		if loadout then
			for v,k in pairs(loadout.weapons) do
				print(v)
				ply:Give(v)
			end
			for v,k in pairs(loadout.ammo) do
				print(v)
				ply:GiveAmmo(k,v,true)
			end
		end
	end)
end

if CLIENT then
	hook.Add("PreDrawHalos", "singularityTeamOutline", function()
		local ply = LocalPlayer()
		local playerTeam = ply:Team()
		local teamData = singularity.Teams.Data[playerTeam] 
		if teamData then
			if teamData["OutlineTeamMates"] then
				outline.Add(team.GetPlayers(playerTeam),team.GetColor(playerTeam),teamData.OutlineMode)
			end
		end
	end)
end