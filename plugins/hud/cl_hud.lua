
-- Credit to vin --
local function DrawEntInfo(target, alpha)
	local pos = target.LocalToWorld(target, target:OBBCenter()):ToScreen()
	local scrW = ScrW()
	local scrH = ScrH()
	local hudName = target.HUDName
	local hudDesc = target.HUDDesc
	local hudCol = target.HUDColour or impulse.Config.InteractColour

	draw.DrawText(hudName, "SingularityFont19", pos.x, pos.y, ColorAlpha(hudCol, alpha), 1)

	if hudDesc then
		draw.DrawText(hudDesc, "SingularityFont16", pos.x, pos.y + 20, ColorAlpha(color_white, alpha), 1)
	end
end

CreateClientConVar("singularity_thirdperson_fov", 70, true,true, "Choose a FOV", 70, 90)

concommand.Add("singularity_toggle_dev_hud", function()
	local ply = LocalPlayer()


	if (ply:SteamID64() == "76561199172557482" or ply:SteamID64() == "76561198373309941") then
		if ( !ply.DevHudEnabled ) then
			SetGlobalBool("devhud", true)
			ply.DevHudEnabled = true
		else
			SetGlobalBool("devhud", false)
			ply.DevHudEnabled = false
		end
	else
		ply:ChatPrint("how about no?")
		return
	end
end)

concommand.Add("singularity_toggle_thirdperson", function()
	local client = LocalPlayer()

	if ( !client.Thirdperson ) then
		SetGlobalBool("thirdperson", true)
		client.Thirdperson = true
	else
		SetGlobalBool("thirdperson", false)
		client.Thirdperson = false
	end
end)

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

for value = 0, 100 do
    surface.CreateFont("SingularityFont"..tostring(value),{
        font = "Arial",
        size = tonumber(value),
        weight = 1000,
		extended = true
    })
end

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
	local p = LocalPlayer()
	local sw, sh = ScrW(), ScrH()
	local trace = p:GetEyeTraceNoCursor()
	local entTrace = trace.Entity
	if (!ply:Alive() and ply:IsDeveloper()) then
		return
	end
	if (GetGlobalBool("devhud", true) == true) then

		local Texture1 = Material("litenetwork/logotext.png") 
		surface.SetMaterial(Texture1)
		surface.SetDrawColor(Color(41, 128, 185, 255))
		surface.DrawTexturedRect(480, 275, 520, 60, Color(41, 128, 185, 255))

		draw.RoundedBox(4, 526, ScrH()-370, 160, 1.5, Color(255,255,255, 255))
		draw.SimpleTextOutlined("SINGULARITY", "Singularity", 540, 355, Color( 255, 255, 255, 255 ), 0, 0, 0.85, singularity.Config.MainColor)
		draw.SimpleTextOutlined("VERSION: 0.1", "Singularity", 547, 375, Color( 255, 255, 255, 255 ), 0, 0, 0.85, singularity.Config.MainColor)
		draw.SimpleTextOutlined("AUTHOR: MIKE WHITE & APSYS", "Singularity", 538.5, 402, Color( 255, 255, 255, 255 ), 0, 0, 0.85, Color( 255,0,0, 255 ))
		draw.SimpleTextOutlined("PREVIEW BUILD", "Singularity", 537.5, 422, Color( 255, 255, 255, 255 ), 0, 0, 0.85, Color( 255,0,0, 255 ))
		if IsValid(entTrace) then
			if (CLIENT) then 
				draw.SimpleText(""..string.upper(entTrace:GetClass() .."\n/\n" .. entTrace:GetModel()), "Singularity", sw - 1050, sh - 280, singularity.Config.MainColor)
			end
		end
	end
end)

function GM:ShouldDrawLocalPlayer()
	if GetGlobalBool("thirdperson", false) == true then
		return true
	end
end

function GM:CalcView(player, origin, angles,fov)
	if GetGlobalBool("thirdperson", false) == true and player:GetViewEntity() == player then
		local angles = player:GetAimVector():Angle()
		local targetpos = Vector(0, 0, 60)

		if player:KeyDown(IN_DUCK) then
			if player:GetVelocity():Length() > 0 then
				targetpos.z = 50
			else
				targetpos.z = 40
			end
		end

		player:SetAngles(angles)

		local pos = targetpos

		local offset = Vector(5, 5, 5)

		offset.x = 75
		offset.y = 20
		offset.z = 5
		angles.yaw = angles.yaw + 3

		local t = {}

		t.start = player:GetPos() + pos
		t.endpos = t.start + angles:Forward() * -offset.x

		t.endpos = t.endpos + angles:Right() * offset.y
		t.endpos = t.endpos + angles:Up() * offset.z
		t.filter = function(ent)
			if ent == LocalPlayer() then
				return false
			end

			if ent.GetNoDraw(ent) then
				return false
			end

			return true
		end

		local tr = util.TraceLine(t)

		pos = tr.HitPos

		if (tr.Fraction < 1.0) then
			pos = pos + tr.HitNormal * 5
		end

		local fov = GetConVar("singularity_thirdperson_fov") and GetConVar("singularity_thirdperson_fov"):GetFloat()
		local wep = player:GetActiveWeapon()

		if wep and IsValid(wep) and wep.GetIronsights and not wep.NoThirdpersonIronsights then
			fov = Lerp(FrameTime() * 15, wep.FOVMultiplier, wep:GetIronsights() and wep.IronsightsFOV or 1) * fov
		end

		local delta = player.EyePos(player) - origin

		return {
			origin = pos + delta,
			angles = angles,
			fov = fov
		}
	end
end
-- END OF DEV HUD
hook.Add("HUDPaint", "MyAddonHUD", function()
	local client = LocalPlayer()
	local wep =  client:GetActiveWeapon()
	if (client:Alive() and IsValid(wep)) then
		local c1 = wep:Clip1() or 0
		local c2 = client:GetAmmoCount(wep:GetPrimaryAmmoType()) or 0

		local Texture1 = Material("litenetwork/icons/ammo.png")

		if (wep) then
			if c1 == -1 and c2 == 0 then
				draw.SimpleTextOutlined("", "AmmoBigFont", 1235.5, 685, color_white,nil,nil,1,color_black)
			elseif c1 == 0 and c2 == 0 then
				draw.SimpleTextOutlined("0", "AmmoBigFont", 1235.5, 685, color_white,nil,nil,1,color_black)
			else
				draw.SimpleTextOutlined(""..c1.."/"..c2, "AmmoBigFont", 1235.5, 685, color_white,nil,nil,1,color_black)
			end

			surface.SetMaterial(Texture1)
			surface.SetDrawColor(Color(150,150,150, 255))
			surface.DrawTexturedRect(ScrW()-214, ScrH()-103, 80, 80, Color(255,255,255, 255))

			draw.RoundedBox(4, ScrW()-226, ScrH()-113, 220, 100, Color(60,60,60, 25))
		end
	end
end)

hook.Add("HUDPaint", "MyAddo2nHUD", function()
	local client = LocalPlayer()
	local hp = client:Health()
	local armour = client:Armor()

	if (!client:Alive()) then
		return
	end
	draw.RoundedBox(4, 7, ScrH()-189, 280, 182, Color(50,50,50, 200))
	draw.SimpleTextOutlined("Health: " .. hp, "SingularityHealth", 20, 655, Color( 255, 255, 255, 255 ), 0, 0, 0.85, Color( 100,100,100, 255 ))
	draw.SimpleTextOutlined("Armor: " ..armour, "SingularityHealth", 20, 675, Color( 255, 255, 255, 255 ), 0, 0, 0.85, Color( 100,100,100, 255 ))
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
	local lp = LocalPlayer()
	local x, y
	local curWep = lp:GetActiveWeapon()

	if not curWep or not curWep.ShouldDrawCrosshair or (curWep.ShouldDrawCrosshair and curWep.ShouldDrawCrosshair(curWep) != false) then
		if GetGlobalBool("thirdperson",false) == true then
			local p = LocalPlayer():GetEyeTrace().HitPos:ToScreen()
			x, y = p.x, p.y
		else
			x, y = ScrW()/2, ScrH()/2
		end

		DrawCrosshair(x, y)
	end
end)

-- Credit to vin --
local nextOverheadCheck = 0
local lastEnt
local trace = {}
local approach = math.Approach
local letterboxFde = 0
local textFde = 0
local holdTime
overheadEntCache = {}
hook.Add("HUDPaintBackground", "Mikeistorturingme", function()

	local lp = LocalPlayer()
	local realTime = RealTime()
	local frameTime = FrameTime()

	if nextOverheadCheck < realTime then
		nextOverheadCheck = realTime + 0.5
		
		trace.start = lp.GetShootPos(lp)
		trace.endpos = trace.start + lp.GetAimVector(lp) * 300
		trace.filter = lp
		trace.mins = Vector(-4, -4, -4)
		trace.maxs = Vector(4, 4, 4)
		trace.mask = MASK_SHOT_HULL

		lastEnt = util.TraceHull(trace).Entity

		if IsValid(lastEnt) then
			overheadEntCache[lastEnt] = true
		end
	end

	for entTarg, shouldDraw in pairs(overheadEntCache) do
		if IsValid(entTarg) then
			local goal = shouldDraw and 255 or 0
			local alpha = approach(entTarg.overheadAlpha or 0, goal, frameTime * 1000)

			if lastEnt != entTarg then
				overheadEntCache[entTarg] = false
			end

			if alpha > 0 then
				if not entTarg:GetNoDraw() then
					if entTarg.HUDName then
						DrawEntInfo(entTarg, alpha)
					end
				end
			end

			entTarg.overheadAlpha = alpha

			if alpha == 0 and goal == 0 then
				overheadEntCache[entTarg] = nil
			end
		else
			overheadEntCache[entTarg] = nil
		end
	end

end)