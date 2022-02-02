--[[---------------------------------------------------------------------------
	Player Meta Functions
---------------------------------------------------------------------------]]--

local PLAYER = FindMetaTable("Player")

function PLAYER:IsOwner()
  	return ( self:SteamID64() == "76561199172557482" )
end

function PLAYER:IsDeveloper()
	return (self:SteamID64() == "76561199172557482" or self:SteamID64() == "76561198373309941")
end


function PLAYER:IsAnAdmin()
	return (self:GetUserGroup() == "admin")
end

function PLAYER:IsAnSuperAdmin()
	return (self:GetUserGroup() == "superadmin")
end

function PLAYER:IsDonator()
	return (self:GetUserGroup() == "donator")
end

if ( SERVER ) then
	util.AddNetworkString("singularityNotify")
	local PLAYER = FindMetaTable("Player")

	function PLAYER:NearEntity(entity, radius)
		for k, v in ipairs(ents.FindInSphere(self:GetPos(), radius or 96)) do
			if (v:GetClass() == entity) then
				return true
			end
		end
		return false
	end

	function PLAYER:Notify(message,duration)
		if not message then return end
		duration = duration or 5
		net.Start("singularityNotify")
			net.WriteString(message)
			net.WriteInt(duration,32)
		net.Send(self)
	end

	--[[
		-- Used the same as the above but you input a pure entity e.g. --
		local ply = Entity(1)
		local our_ent = Entity(123)
		if ( ply:NearEntityPure(our_ent) ) then
			DoStuff()
		end
	]]

	function PLAYER:NearEntityPure(entity, radius)
		for k, v in ipairs(ents.FindInSphere(self:GetPos(), radius or 96)) do
			if ( v == entity ) then
				return true
			end
		end
		return false
	end

	function PLAYER:NearPlayer(radius)
		for k, v in ipairs(ents.FindInSphere(self:GetPos(), radius or 96)) do
			if v:IsPlayer() and v:Alive() and v:IsValid() then
				return true
			end
		end
		return false
	end
else
	local PLAYER = FindMetaTable("Player")
	function PLAYER:Notify(message,duration)
		local panel = vgui.Create("singularityNotifyPanel")
		panel:SetDuration(duration or 5)
		panel:SetMessage(message)
	end
end