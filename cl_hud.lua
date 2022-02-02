local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudSuitPower"] = true,
	["CHudAmmo"] = true,
	["CHudSquadStatus"] = true,
	["CHudCrosshair"] = true,
	["CHudHistoryResource"] = true,
	["CHudDeathNotice"] = true,
	["CHudDamageIndicator"] = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then
		return false
	end

end )

Singularity = {

	["Description"] = [[ Singularity Framework is founded and developed by Mike White,
			 this contains alot of new features, this framework is made
			 for Half Life 2 Semi Serious Roleplay.
	]],
	["Name"] = "Singularity Framework",
	["Author"] = "Mike White",
	["Version"] = "0.1",
}

PrintTable(Singularity)

surface.CreateFont("SingularityElementsSmall", { 
	font = "Arial",
	size = 16 ,
	extended = true,
} )

surface.CreateFont("SingularityHealth", { 
	font = "Arial",
	size = 25,
	weight = 750,
	extended = true,
} )

surface.CreateFont("SingularityElementsBig", { 
	font = "Arial",
	size = 19 ,
	extended = true,
} )

surface.CreateFont("Singularity", { 
	font = "Arial",
	size = 23 ,
	weight = 1000,
	extended = true,
} )

surface.CreateFont("SingularitySmall", { 
	font = "Arial",
	size = 16 ,
	weight = 1000,
	extended = true,
} )

surface.CreateFont("SingularityBig", { 
	font = "Arial",
	size = 19 ,
	weight = 1000,
	extended = true,
} )

surface.CreateFont("AmmoBigFont", {
	font = font,
	size = 45,
	extended = true,
	weight = 750
})

-- DEV HUD
hook.Add("HUDPaint", "Test2", function()
	local ply = LocalPlayer()
	if (!ply:Alive()) then
		return
	end
	draw.RoundedBox(4, 526, ScrH()-370, 160, 1.5, Color(255,255,255, 255))
	draw.SimpleTextOutlined("SINGULARITY", "Singularity", 540, 355, Color( 255, 255, 255, 255 ), 0, 0, 0.85, Color( 0,0,255, 255 ))
	draw.SimpleTextOutlined("VERSION: 0.1", "Singularity", 547, 375, Color( 255, 255, 255, 255 ), 0, 0, 0.85, Color( 0,0,255, 255 ))
	draw.SimpleTextOutlined("AUTHOR: MIKE WHITE & APSYS", "Singularity", 538.5, 402, Color( 255, 255, 255, 255 ), 0, 0, 0.85, Color( 255,0,0, 255 ))
	draw.SimpleTextOutlined("PREVIEW BUILD", "Singularity", 537.5, 422, Color( 255, 255, 255, 255 ), 0, 0, 0.85, Color( 255,0,0, 255 ))
end)
-- END OF DEV HUD
hook.Add("HUDPaint", "MyAddonHUD", function()
	local client = LocalPlayer()
	local wep =  client:GetActiveWeapon()
	local c1 = wep:Clip1() or 0
	local c2 = p:GetAmmoCount(wep:GetPrimaryAmmoType()) or 0

	if (!client:Alive()) then
		return
	end

	local Texture1 = Material("litenetwork/icons/ammo.png") 

	if (wep) then
            if c1 == -1 and c2 == 0 then
                draw.SimpleTextOutlined("", "AmmoBigFont", 1235.5, 685, color_white,nil,nil,1,color_black)
            elseif c1 == 0 and c2 == 0 then
                draw.SimpleTextOutlined("0", "AmmoBigFont", 1235.5, 685, color_white,nil,nil,1,color_black)
            else
                draw.SimpleTextOutlined(""..c1.."/"..c2, "AmmoBigFont", 1235.5, 685, color_white,nil,nil,1,color_black)
            end
        end

		surface.SetMaterial(Texture1)
	    surface.SetDrawColor(Color(150,150,150, 255))
	    surface.DrawTexturedRect(ScrW()-214, ScrH()-103, 80, 80, Color(255,255,255, 255))

		draw.RoundedBox(4, ScrW()-226, ScrH()-113, 220, 100, Color(60,60,60, 25))
	end
end)

hook.Add("HUDPaint", "MyAddo2nHUD", function()
	local client = LocalPlayer()
	local hp = client:Health()

	if (!client:Alive()) then
		return
	end
	draw.RoundedBox(4, 7, ScrH()-189, 280, 182, Color(50,50,50, 200))
	draw.SimpleTextOutlined("Health: " .. hp, "SingularityHealth", 20, 655, Color( 255, 255, 255, 255 ), 0, 0, 0.85, Color( 100,100,100, 255 ))
	draw.SimpleTextOutlined("Armor: " .. LocalPlayer():Armor(), "SingularityHealth", 20, 675, Color( 255, 255, 255, 255 ), 0, 0, 0.85, Color( 100,100,100, 255 ))
	draw.SimpleTextOutlined("" .. LocalPlayer():Name(), "SingularityHealth", 20, 595, Color( 255, 255, 255, 255 ), 0, 0, 0.85, Color( 100,100,100, 255 ))
end)

local crosshairGap = 5
local crosshairLength = crosshairGap + 5

local function DrawCrosshair(x, y)
    surface.SetDrawColor(color_white)

    surface.DrawLine(x - crosshairLength, y, x - crosshairGap, y)
    surface.DrawLine(x + crosshairLength, y, x + crosshairGap, y)
    surface.DrawLine(x, y - crosshairLength, x, y - crosshairGap)
    surface.DrawLine(x, y + crosshairLength, x, y + crosshairGap)
end

hook.Add("HUDPaint", "DrawCross1", function()
	DrawCrosshair(ScrW() / 2, ScrH() / 2)
end)

