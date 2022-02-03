-- old thing, idk why i made tables for this, i guess for config? Gonna redo it in the future.
singularity.xpSystem = singularity.xpSystem or {}
singularity.xpSystem.Time = 600
singularity.xpSystem.GainAmountUser = 5
singularity.xpSystem.GainAmountDonator = 10

local PLAYER = FindMetaTable("Player")

function PLAYER:GetXP()
	-- Player's XP might not have loaded so we check PData too
	return self:GetNWInt("ixXP") or ( SERVER and self:GetPData("ixXP", 0) or 0 )
end

singularity.RegisterChatCommand("/setxp",{
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_ADMIN,
	HelpDescription = "Set a user's XP.",
	onRun  = function(self,ply,args)
		if not ply:IsSuperAdmin() then return end
		local findUser = args[1]
		local user = findUser
		local group = (tonumber(args[2]))
		if IsValid(user) then
			user:SetXP(group)
			ply:Notify("Successfully set " .. user:Nick() .. " XP to " .. group)
		else
			ply:Notify("Couldn't find the user to edit!")
		end
	end
})

singularity.RegisterChatCommand("/getxp",{
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_SUPERADMIN,
	HelpDescription = "Set a user's XP.",
	onRun  = function(self,ply,args)
		if not ply:IsSuperAdmin() then return end
		local findUser = args[1]
		local user = singularity.FindPlayer(args[1])
		if IsValid(user) then
			ply:ChatPrint(""..user:Nick() .. " XP Count is " .. user:GetXP())
		else
			ply:ChatPrint("Couldn't find the user to edit!")
		end

	end
})
