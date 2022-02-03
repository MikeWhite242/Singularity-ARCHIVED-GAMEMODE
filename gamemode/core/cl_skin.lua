local SKIN = {}

--PrintTable(derma.GetDefaultSkin())

SKIN.Colours = table.Copy(derma.SkinList.Default.Colours)
SKIN.Colours.Window.TitleActive = Color(255, 255, 255)
SKIN.Colours.Window.TitleInactive = Color(255, 255, 255)
SKIN.fontFrame = "SingularityFont19"
SKIN.Colours.Button.Normal = Color(255, 255, 255)
SKIN.Colours.Button.Hover = Color(255, 255, 255)
SKIN.Colours.Button.Down = Color(180, 180, 180)
SKIN.Colours.Button.Disabled = Color(0, 0, 0, 100)

SKIN.Colours.Label.Dark      = Color(20,20,20,255)
SKIN.Colours.Label.Highlight = Color(90, 200, 250, 255)

SKIN.Colours.Tree.Normal      = Color(255,255,255,255)

SKIN.Colours.Properties.Label_Normal = Color(255,255,255,255)
SKIN.Colours.Properties.Column_Disabled = Color(40,40,40,255)

SKIN.Colours.Category.Line.Text = Color(255,255,255,255)
SKIN.Colours.Category.Line.Button_Selected = Color(40,40,40,255)
SKIN.Colours.Category.LineAlt.Text = Color(255,255,255,255)

singularity.Config.CornerRadius = 0
singularity.Config.PillButtons = false

singularity.Config.ButtonColorOff      = Color(72,72,74,255)
singularity.Config.ButtonColorHovered  = Color(99,99,102,255)
singularity.Config.ButtonColorOn       = Color(142,142,147,255)
singularity.Config.CloseButtonColor    = Color(255,69,58,255)

singularity.Config.ButtonColorOffV      = Vector(72,72,74,255)
singularity.Config.ButtonColorHoveredV  = Vector(99,99,102,255)
singularity.Config.ButtonColorOnV       = Vector(142,142,147,255)
singularity.Config.CloseButtonColorV    = Vector(255,69,58,255)

singularity.Config.ClickSound = "singularity/ui/notification.mp3"
singularity.Config.HoverSound = "singularity/ui/scroll.mp3"

singularity.DefineSetting("buttonClicks",{type="tickbox",default=false,category="UI",name="Button Clicks"})

surface.CreateFont("singularity_base-default-14", {
	font = "Segoe UI Light",
	weight = 2500,
	size = 24
})

surface.CreateFont("singularity_base-default-20", {
	font = "Segoe UI Light",
	weight = 500,
	size = 24
})

local blur = Material("pp/blurscreen")
function singularity.blur(panel,alpha,layers,density)
    local x, y = panel:LocalToScreen(0, 0)
    surface.SetDrawColor(255, 255, 255, alpha)
    surface.SetMaterial(blur)
    for i = 1, 3 do
        blur:SetFloat("$blur", (i / layers) * density)
        blur:Recompute()

        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
    end
end


function SKIN:PaintVScrollBar(panel, w, h)
	local col = singularity.Config.ButtonColorOff
    surface.SetDrawColor(col.r,col.g,col.b,200)
    surface.DrawRect(0, 0, w, h)
end

function SKIN:PaintScrollBarGrip(panel, w, h)
	--local rad = singularity.Config.CornerRadius > 0 and (w-2)/2 or 0
	if panel:IsSelected() or panel.Depressed then
		return draw.RoundedBox(0, 0, 0, w, h, singularity.Config.ButtonColorOn)
	end

	if panel:IsHovered() then
		return draw.RoundedBox(0, 0, 0, w, h, singularity.Config.ButtonColorHovered)
	end
    draw.RoundedBox(0, 0, 0, w, h, singularity.Config.ButtonColorOff)
end

function SKIN:PaintButtonDown(panel, w, h)
	if !panel.m_bBackground then return end

	if panel.Depressed or panel:IsSelected() then
		return self.tex.Scroller.DownButton_Down( 0, 0, w, h, singularity.Config.ButtonColorOn )
	end

	if panel.Hovered then
		return self.tex.Scroller.DownButton_Hover(0, 0, w, h, singularity.Config.ButtonColorHovered)
	end

	self.tex.Scroller.DownButton_Normal(0, 0, w, h, singularity.Config.ButtonColorOff)
end

function SKIN:PaintButtonUp( panel, w, h )

	if ( !panel.m_bBackground ) then return end

	if ( panel.Depressed or panel:IsSelected() ) then
		return self.tex.Scroller.UpButton_Down( 0, 0, w, h, singularity.Config.ButtonColorOn )
	end

	if ( panel.Hovered ) then
		return self.tex.Scroller.UpButton_Hover( 0, 0, w, h, singularity.Config.ButtonColorHovered)
	end

	self.tex.Scroller.UpButton_Normal(0, 0, w, h, singularity.Config.ButtonColorOff) -- 

end

function SKIN:PaintFrame( self,w,h )
	local lblTitle = self.lblTitle
	if lblTitle then
		if IsValid(lblTitle) then
			self.lblTitle:SetFont("SingularityFont18")
		end
	end
	singularity.blur(self,200,10,20)
	local mainColor = singularity.Config.MainColor
	local bgColor   = singularity.Config.BGColorDark
	local cornerRadius = singularity.Config.CornerRadius
	draw.RoundedBox(cornerRadius, 0, 0, w, h, Color(bgColor.r, bgColor.g, bgColor.b, 220))
	draw.RoundedBoxEx(cornerRadius, 0, 0, w, 23, Color(mainColor.r, mainColor.g, mainColor.b, 255),true, true)
	
	--
	--surface.DrawRect( 0, 0, w, 23 )
	--[[if cornerRadius == 0 then
		surface.SetDrawColor( mainColor.r, mainColor.g, mainColor.b )
		surface.DrawOutlinedRect( 0, 23, w, h-23, 2 )
	end]]
	--
	if self:GetSizable() then
		surface.SetDrawColor(0, 0, 0)
		draw.NoTexture()
		surface.SetDrawColor( mainColor.r, mainColor.g, mainColor.b )
		surface.DrawPoly({
			{x=w-15,y=h-5},
			{x=w-5,y=h-15},
			{x=w-5,y=h-5}
		})
	end
end

function SKIN:PaintMenuBar(self,w,h)
	local bgColor   = singularity.Config.ButtonColorOff
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	surface.DrawRect( 0, 0, w, h )
end

function SKIN:PaintWindowMaximizeButton() end
function SKIN:PaintWindowMinimizeButton() end

function SKIN:PaintWindowCloseButton(self,w,h)
	if not self.ButtonHoldAlpha then
		self.ButtonHoldAlpha = 0
	end
	local mainColor = singularity.Config.CloseButtonColor
	local bgColor   = singularity.Config.ButtonColorOff
	local cornerRadius = singularity.Config.CornerRadius
	if 	self:IsHovered() then
		self.ButtonHoldAlpha = math.Clamp(self.ButtonHoldAlpha+(((1/60)*FrameTime()))*50000,0,255)
	else
		self.ButtonHoldAlpha = math.Clamp(self.ButtonHoldAlpha-(((1/60)*FrameTime()))*50000,0,255)
	end
	surface.SetDrawColor(255,255,255,255)
	draw.NoTexture()

	surface.DrawTexturedRectRotated(w/2, h/2, h/2, 2, 45)
	surface.DrawTexturedRectRotated(w/2, h/2, h/2, 2, -45)

	surface.SetDrawColor( mainColor.r, mainColor.g, mainColor.b, self.ButtonHoldAlpha )
	draw.NoTexture()

	surface.DrawTexturedRectRotated(w/2, h/2, h/2, 2, 45)
	surface.DrawTexturedRectRotated(w/2, h/2, h/2, 2, -45)
end

function SKIN:PaintPropertySheet(self,w,h)
	singularity.blur(self,200,10,20)
	local mainColor = singularity.Config.MainColor
	local bgColor   = singularity.Config.BGColorDark
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 220 )
	surface.DrawRect(  0, 20, w, h-20 )
	surface.SetDrawColor( mainColor.r, mainColor.g, mainColor.b )
	surface.DrawOutlinedRect( 0, 20, w, h-20, 2 )
end

function SKIN:PaintTab(self,w,h)
	self:SetFont("SingularityFont16")
	if not self.hSND then
		self.hSND = false
	end
	if not self.pSND then
		self.pSND = false
	end
	if self:GetName() == "DNumberScratch" then return end
	local bgColor   = singularity.Config.ButtonColorOff
	if self:IsHovered() then
		if not self.hSND then
			if singularity.GetSetting("buttonClicks") then surface.PlaySound(singularity.Config.HoverSound) end
			self.hSND = true
		end
		bgColor = singularity.Config.ButtonColorHovered
	else self.hSND = false end
	if self:IsDown() then
		if not self.pSND then
			if singularity.GetSetting("buttonClicks") then surface.PlaySound(singularity.Config.ClickSound) end
			self.pSND = true
		end
		bgColor = singularity.Config.ButtonColorOn
	else self.pSND = false end
	if self:IsActive() then
		bgColor = singularity.Config.MainColor
	end
	draw.RoundedBoxEx(singularity.Config.CornerRadius, 0, 0, w, 20, Color( bgColor.r, bgColor.g, bgColor.b, 255 ), true, true)
	--surface.DrawRect(0, 0, w, 20)
end

function SKIN:PaintCategoryHeader(self,w,h)
	self:SetFont("singularity-24-B")
end

function SKIN:PaintCategoryList(self,w,h)
	local cornerRadius = singularity.Config.CornerRadius
	local mainColor    = singularity.Config.MainColor 
	draw.RoundedBox(cornerRadius, 0, 0, w, h, mainColor)
	draw.RoundedBox(cornerRadius, 2,2,w-4,h-4, Color(40,40,40,255))
end

function SKIN:PaintTree(self,w,h)
	local cornerRadius = singularity.Config.CornerRadius
	local mainColor    = singularity.Config.MainColor 
	draw.RoundedBox(cornerRadius, 0, 0, w, h, mainColor)
	draw.RoundedBox(cornerRadius, 2,2,w-4,h-4, Color(40,40,40,255))
end

function SKIN:PaintTree_Node(self,w,h)
	self:SetFont("singularity-12-S")
	self:SetTextColor(color_white)
end

function SKIN:PaintCollapsibleCategory(self,w,h)
	self.Header:SetFont("singularity-16-B")
	local cornerRadius = singularity.Config.CornerRadius
	local mainColor    = singularity.Config.MainColor 
	draw.RoundedBox(cornerRadius, 0, 0, w, 20, mainColor)
	draw.RoundedBox(cornerRadius, w-18,2,16,16, Color(40,40,40,255))
	if ( self:GetExpanded() ) then
		draw.SimpleText(
			"-",
			"singularity-20-B",
			w-11,
			9,
			color_white,
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	else
		draw.SimpleText(
			"+",
			"singularity-20-B",
			w-11,
			9,
			color_white,
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end
end

function SKIN:PaintButton(self,w,h)
	if self.SetFont then
		self:SetFont("SingularityFont19")
	end
	if !self.m_bBackground then return end
	
	if not self.hSND then
		self.hSND = false
	end
	if not self.pSND then
		self.pSND = false
	end
	if not self.no then
		self.no = false
	end
	if not self.LerpPos then 
		self.LerpPos = 1
	end
	
	if self:GetName() == "DNumberScratch" then return end
	self.LerpPos = math.Clamp( self.LerpPos	+ FrameTime()*4, 0, 1)
	local bgColor   = singularity.Config.ButtonColorOff
	if self:IsHovered() then
		if not self.hSND then
			if singularity.GetSetting("buttonClicks") then surface.PlaySound(singularity.Config.HoverSound) end
			self.hSND = true
			self.LerpPos = 0
		end
		local c = LerpVector( self.LerpPos, singularity.Config.ButtonColorOffV, singularity.Config.ButtonColorHoveredV )
		bgColor = Color(c[1],c[2],c[3])
	else self.hSND = false end
	if self:IsDown() then
		if not self.pSND then
			if singularity.GetSetting("buttonClicks") then surface.PlaySound(singularity.Config.ClickSound) end
			self.pSND = true
			self.LerpPos = 0
		end
		local c = LerpVector( self.LerpPos, singularity.Config.ButtonColorHoveredV, singularity.Config.ButtonColorOnV )
		bgColor = Color(c[1],c[2],c[3])
	else self.pSND = false end
	if not self.hSND and not self.pSND then
		if not self.no then
			self.no = true
			self.LerpPos = 0
		end
		local c = LerpVector( self.LerpPos, singularity.Config.ButtonColorHoveredV, singularity.Config.ButtonColorOffV )
		bgColor = Color(c[1],c[2],c[3])
	else
		self.no = false
	end
	local cornerRadius = singularity.Config.CornerRadius
	--local isPill = singularity.Config.PillButtons
	--if false then
		--draw.RoundedBox(h/2.2, 0, 0, w, h, Color( bgColor.r, bgColor.g, bgColor.b, 255 ))
	--else
	draw.RoundedBox(cornerRadius, 0, 0, w, h, Color( bgColor.r, bgColor.g, bgColor.b, 255 ))
	--end
end

function SKIN:PaintTooltip(self,w,h)
	local bgColor = singularity.Config.BGColorLight
	local cornerRadius = singularity.Config.CornerRadius
	draw.RoundedBox(cornerRadius, 0, 0, w, h, Color( bgColor.r, bgColor.g, bgColor.b, 255 ))
end

local oldPaintMenuOption = derma.SkinList.Default.PaintMenuOption

function SKIN:PaintMenuOption(panel,w,h)
	panel:SetTextColor(color_black)
	if ( panel.m_bBackground && !panel:IsEnabled() ) then
		surface.SetDrawColor( Color( 0, 0, 0, 50 ) )
		surface.DrawRect( 0, 0, w, h )
		
	end

	if ( panel.m_bBackground && ( panel.Hovered || panel.Highlight) ) then
		self.tex.MenuBG_Hover( 0, 0, w, h )
		panel:SetTextColor(Color(80,80,80,255))
	end

	if ( panel:GetChecked() ) then
		self.tex.Menu_Check( 5, h / 2 - 7, 15, 15 )

	end
end

function SKIN:PaintComboBox(self,w,h)
	local bgColor   = singularity.Config.ButtonColorOff
	if self:IsHovered() then
		bgColor = singularity.Config.ButtonColorHovered
	end
	if self:IsDown() then
		bgColor = singularity.Config.ButtonColorOn
	end
	local cornerRadius = singularity.Config.CornerRadius
	draw.RoundedBox(cornerRadius, 0, 0, w, h, Color( bgColor.r, bgColor.g, bgColor.b, 255 ))
end



derma.DefineSkin("singularity", "The default skin for singularity.", SKIN)

-- lol look at tthe identifier
hook.Add("ForceDermaSkin", "foreskin", function()
	return "singularity"
end)
derma.RefreshSkins()