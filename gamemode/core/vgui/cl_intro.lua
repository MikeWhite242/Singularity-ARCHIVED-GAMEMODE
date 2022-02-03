local PANEL = {}

local math = math
local floor = math.floor
local function getRandomSlideShow()
	local t = {}
	return t
end
function PANEL:Init()
    SCHEMA:SetHUDElement("Crosshair",false)
	SCHEMA:SetHUDElement("Health",false)
	SCHEMA:SetHUDElement("Armor",false)
	SCHEMA:SetHUDElement("Ammo",false)
    hook.Add("HUDShouldDraw", "removeall", function(name)
		if not( name == "CHudGMod" )then return false end
	end)
    self:SetSize(ScrW(),ScrH())
    self:Center()
    self:MakePopup()
    self:SetText("")
end
function PANEL:Paint(w,h)

    draw.RoundedBox(0,0,0,w,h,Color(0,0,0,100))

    singularity.blur(self,255,16,24)

    local c = singularity.Config.MainColor
    draw.SimpleText(SCHEMA.Name or "Half-Life 2 Roleplay", "SingularityFont35", w/2+5, h/2, Color(
		floor(c.r/2),
		floor(c.g/2),
		floor(c.b/2),
		floor(GlobalAlpha)
	), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,GlobalAlpha))

	draw.SimpleText(SCHEMA.Name or "Half-Life 2 Roleplay", "SingularityFont35", w/2, h/2, c, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,GlobalAlpha))
    draw.SimpleText("Click anywhere to begin.","",w/2,h/2+64,Color(245,245,245),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

end

function PANEL:DoClick()
    MainMenu = MainMenu or vgui.Create("singularityMainMenu")
    self:Remove()
end

singularity.Splash = singularity.Splash or nil

vgui.Register("singularitySplash", PANEL, "DLabel")

net.Receive("singularityStartMenu", function()
	singularity.Splash = singularity.Splash or vgui.Create("singularitySplash")
end)