include( "shared.lua" )
AddCSLuaFile("vgui/cl_notify.lua")
AddCSLuaFile("vgui/cl_spawnicon.lua")

net.Receive("F4Menu",function()
  if ( !f4 ) then
    local f4 = vgui.Create( "DFrame" )
    f4:SetTitle("Roleplay Options")
    f4:SetPos( ScrW() / 2 - 150, ScrH() / 2 - 150 )
    f4:SetSize( 650,600 )
    f4:SetSizable( false )
    f4:Center()
    f4:SetVisible( true )
    f4:MakePopup()
    f4:SetDeleteOnClose( true )
    f4.Paint = function(self, w ,h)
      surface.SetDrawColor(30,30,30,240)
      surface.DrawRect(0,0,w,h)
    end
    addButtons(f4)
  end
end)

function addButtons(f4)
  local pb = vgui.Create("DButton")
  pb:SetParent(f4)
  pb:SetPos(10,20)
  pb:SetSize(110,70)
  pb:SetText("")
  pb.DoClick = function(pb)
    local jp = f4:Add("PageJobs")
  end
  pb.Paint = function(self, w, h)
    draw.RoundedBox(5,0,0,w,h,Color(54,53,53))

    draw.SimpleText("Jobs", "SingularityFont25", 50,35,color_white,1,1)
  end
end

PANEL = {}

function PANEL:Init()
    self:SetSize(550, 500)
    self:SetPos(120,75)
end

function PANEL:Paint(w,h)
    local teamPanel = vgui.Create("DScrollPanel", self.TeamTab)
	teamPanel:Dock(FILL)
	--self.TeamPanels.teamPanel.Paint = function() end

	for v,k in ipairs(singularity.Teams.Data) do
		local a = vgui.Create("landisTeam", self.TeamTab)
		a:SetTeam( v )
		teamPanel:AddItem(a)
		a:Dock(TOP)
	end 
    draw.RoundedBox(0,0,0,w,h, Color(19,19,19,190))
end

vgui.Register("PageJobs", PANEL, "Panel")