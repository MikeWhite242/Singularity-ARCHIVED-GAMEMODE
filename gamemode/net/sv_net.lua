util.AddNetworkString("singularityRPNameChange")

net.Receive("singularityRPNameChange", function(len,ply)
	if (ply.rpNameChangeWait or 0) > CurTime() then 
		return
	end
	ply.rpNameChangeWait = CurTime() + 2


	local name = net.ReadString()
	if name == nil then -- nick, remember, players could just be sending nothing at all
		return
	end


	name = singularity.SafeString(name)
	local len  = name:len()

	if len >= 24 then
		ply:Notify("Name too long! (max 24)")
		return
	end

	if len <= 6 then
		ply:Notify("Name too short! (min 6)")
		return
	end

	ply:EditRPName(name,false)

end)