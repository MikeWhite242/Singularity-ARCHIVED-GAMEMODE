net.Receive("singularityNotify", function()
	local message = net.ReadString()
	local duration = net.ReadInt(32)
  LocalPlayer():Notify(message,duration)
end)

net.Receive("singularityPickupItem",function()
    local ply = net.ReadEntity()
    local itm = net.ReadString()

    local t = table.Copy(singularity.items.data[itm])
    
    LocalPlayer().Inventory = table.ForceInsert(ply.Inventory,t)
end)

singularity.VendorPanel = nil

net.Receive("singularityVendorOpen", function()
	local ent = net.ReadEntity()
	local class = net.ReadString()
	local ven = net.ReadTable()

	if not ent or not class then return end

	if ven.Panel then
		singularity.VendorPanel = singularity.VendorPanel or vgui.Create( ven.Panel ) 
	end

end)

net.Receive("singularityAddChatText", function()
	local t = net.ReadTable()
	if t then
		chat.AddText(unpack(t))
	end
end)