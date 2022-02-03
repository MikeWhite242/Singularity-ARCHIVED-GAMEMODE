if SERVER then
	util.AddNetworkString("singularityEventCommand")
end

if CLIENT then
	net.Receive("singularityEventCommand", function()
		local message = net.ReadString()
		chat.AddText(Color(255,69,58),"[Event] ",message)
	end)
end

-- EVENT
singularity.RegisterChatCommand("/event",{
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_LEAD_ADMIN,
	HelpDescription = "Broadcast a message for the entire server.",
	onRun  = function(self,ply,args)
		if ply:IsLeadAdmin() then
			net.Start("singularityEventCommand")
				net.WriteString(table.concat(args," "))
			net.Broadcast()
		end
	end
})

-- ICONTOOL
if CLIENT then
	concommand.Add("icontool", function()
		if LocalPlayer():IsSuperAdmin() then
			vgui.Create( "singularityIcontool" )
		else
			MsgC(Color(255,0,0),"Invalid Permissions.\n",color_white)
		end
	end)
end
singularity.RegisterChatCommand("/icontool",{
	RequireAlive    = false,
	RequireArgs     = false,
	PermissionLevel = PERMISSION_LEVEL_SUPERADMIN,
	HelpDescription = "Open the Icon Tool.",
	onRun  = function(self,ply,args)
		if ply:IsSuperAdmin() then
			ply:ConCommand("icontool") -- add local concommand
			--singularity.
		end
	end
})

-- GOTO
singularity.RegisterChatCommand("/goto",{
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_ADMIN,
	HelpDescription = "Teleport to a player",
	onRun  = function(self,ply,args)
		if ply:IsAdmin() then
			local user = singularity.FindPlayer(args[1])
			if IsValid(user) then
				if user:IsValid() then
					ply:SetPos(user:GetPos()+Vector(100,0,0))
				end
			end
		end
	end
})

-- BRING
singularity.RegisterChatCommand("/bring",{
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_ADMIN,
	HelpDescription = "Bring a player to you",
	onRun  = function(self,ply,args)
		if ply:IsAdmin() then
			local user = singularity.FindPlayer(args[1])
			if IsValid(user) then
				if user:IsValid() then
					user:SetPos(ply:GetPos()+Vector(100,0,0))
				end
			end
		end
	end
})

-- DROPMONEY
singularity.RegisterChatCommand("/dropmoney",{
	RequireAlive    = true,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_USER,
	HelpDescription = "Drop a specified amount of money",
	onRun  = function(self,ply,args)
		ply:DropMoney(tonumber(args[1]))
	end
})

-- ME
singularity.RegisterChatCommand("/me",{
	RequireAlive    = true,
	RequireArgs     = false,
	PermissionLevel = PERMISSION_LEVEL_USER,
	HelpDescription = "Make yourself perform an action",
	onRun  = function(self,ply,args)
		for v,k in ipairs(player.GetHumans()) do
			if hook.Run("PlayerCanSeePlayersChat", "ME_MESSAGE", false, k, ply) then
				k:AddChatText(Color(255,200,40),ply:GetRPName()," ",table.concat(args," "))
			end
		end
	end
})

-- LUARUNNER
singularity.RegisterChatCommand("/luarunner",{
	RequireAlive    = false,
	RequireArgs     = false,
	PermissionLevel = PERMISSION_LEVEL_SUPERADMIN,
	HelpDescription = "Open the Lua Runner.",
	onRun  = function(self,ply,args)
		if ply:IsSuperAdmin() then
			ply:ConCommand("luarunner")
		end
	end
})

-- singularity.chat.commands
singularity.RegisterChatCommand("/ban",{
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_ADMIN,
	HelpDescription = "Ban a user from the server",
	onRun  = function(self,ply,args)
		if not ply:IsAdmin() then return end
		local findUser = args[1]
		local user = singularity.FindPlayer(findUser)
		local p = table.Copy(args)
		table.remove(p, 1)
		table.remove(p, 1) // shifts
		local duration = args[2] or 0
		local reason = table.concat( p, " " ) or "Violation of Community Guidelines."
		if IsValid(user) and not (user == ply) then

			for v,k in ipairs(player.GetHumans()) do
				if k:IsLeadAdmin() then
					k:AddChatText(Color(10,130,255),"[Admin] ",Color(240,240,0),ply:Nick(),color_white," banned ",Color(240,240,0),user:Nick(),color_white," for ",Color(240,240,0),tostring(duration))
				end
			end

			sql.Query("INSERT INTO singularity_bans VALUES(" .. sql.SQLStr( user:SteamID64() ) .. ", " .. sql.SQLStr( ply:SteamID64() ) .. ", " .. sql.SQLStr( reason ) .. ", " .. tostring(os.time()) .. ", " .. tostring(os.time() + (duration*60)) .. ")")
			ply:Notify("Successfully banned " .. user:Nick())
			user:Kick("You have been banned.")
			
		else
			ply:Notify("Couldn't find the user to ban!")
		end

	end
})

singularity.RegisterChatCommand("/givexp",{
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_SUPERADMIN,
	HelpDescription = "Add XP for a user. (NOT FUNCTIONAL)",
	onRun  = function(self,ply,args)
		if not ply:IsSuperAdmin() then return end
		local findUser = args[1]
		local user = singularity.FindPlayer(findUser)
		local amount = args[2] or 0
		if IsValid(user) then
			ply:Notify("Successfully added XP for " .. user:Nick())
		else
			ply:Notify("Couldn't find the user to give XP!")
		end

	end
})

singularity.RegisterChatCommand("/setusergroup",{
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_SUPERADMIN,
	HelpDescription = "Set a user's usergroup. (STEAM ID ONLY!)",
	onRun  = function(self,ply,args)
		if not ply:IsSuperAdmin() then return end
		local findUser = args[1]
		local user = player.GetBySteamID(findUser)
		local group = args[2] or "user"
		if IsValid(user) then
			if user:IsSuperAdmin() then
				ply:Notify("Can't change another superadmin's usergroup! You have to edit their account data!")
				return
			end
			user:SetUserGroup(group)
			ply:Notify("Successfully set " .. user:Nick() .. " to " .. group)
		else
			ply:Notify("Couldn't find the user to edit!")
		end

	end
})

singularity.RegisterChatCommand("/sethp",{
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_ADMIN,
	HelpDescription = "Set someone's HP",
	onRun  = function(self,ply,args)
		local findUser = args[1]
		local user = singularity.FindPlayer(findUser)
		local group = ply:IsSuperAdmin() and (tonumber(args[2]) or 100) or math.Clamp(tonumber(args[2]),0,100)
		if IsValid(user) then
			for v,k in ipairs(player.GetHumans()) do
				if k:IsLeadAdmin() then
					local msg = "[Admin] " .. ply:Nick() .. " set " .. user:Nick() .. "'s HP to " .. tostring(group)
					k:AddChatText(Color(10,130,255),"[Admin] ",Color(240,240,0),ply:Nick(),color_white," set ",Color(240,240,0),user:Nick(),color_white,"'s HP to ",Color(240,240,0),tostring(group))
				end
			end
			user:SetHealth(group)
			ply:Notify("Successfully set " .. user:Nick() .. "'s HP' to " .. group)
		else
			ply:Notify("Couldn't find the user to edit!")
		end

	end
})

singularity.RegisterChatCommand("/setteam",{
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_ADMIN,
	HelpDescription = "Set someone's team",
	onRun  = function(self,ply,args)
		local findUser = args[1]
		local user = singularity.FindPlayer(findUser)
		local group = tonumber(args[2])
		if IsValid(user) then
			for v,k in ipairs(player.GetHumans()) do
				if k:IsLeadAdmin() then
					k:AddChatText(Color(10,130,255),"[Admin] ",Color(240,240,0),ply:Nick(),color_white," set ",Color(240,240,0),user:Nick(),color_white,"'s team to ",Color(240,240,0),tostring(group))
				end
			end
			user:SetTeam(group)
			ply:Notify("Successfully set " .. user:Nick() .. "'s team to " .. group)
		else
			ply:Notify("Couldn't find the user to edit!")
		end

	end
})

if SERVER then
	util.AddNetworkString("singularityOOCMessage")
end

if CLIENT then
	singularity.DefineSetting("oocEnabled",{type="tickbox",name="OOC Chat Enabled",default=true,category="Chatbox"})
	net.Receive("singularityOOCMessage",function()
		local ply = net.ReadEntity()
		local txt = net.ReadString()
		if singularity.GetSetting("oocEnabled") then
			chat.AddText(Color(255,0,0),"[OOC] ",singularity.chatbox.CommandColors[ply:GetPermissionLevel()], ply:Nick(), Color(245,245,245,255),": ", txt)
		end
	end)
end

local oocCommand = {
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_USER,
	HelpDescription = "Send an out of character message",
	onRun  = function(self,ply,args)
		local text = table.concat(args, " ")
		if text then
			net.Start("singularityOOCMessage")
				net.WriteEntity(ply)
				net.WriteString(text)
			net.Broadcast()
		end
	end
}

-- OOC
singularity.RegisterChatCommand("/ooc",oocCommand)
singularity.RegisterChatCommand("//",oocCommand)