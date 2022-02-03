----// singularity.chatbox //----
-- Author: Exho (obviously), Tomelyr, LuaTenshi
-- Version: 4/12/15

singularity.chatbox = {}
singularity.chatbox.isOpen = false
messages = {}
singularity.chatbox.config = {
	timeStamps = false,
	position = 1,	
	fadeTime = 12
}
singularity.chatbox.CommandColors = {}
singularity.chatbox.CommandColors[PERMISSION_LEVEL_USER] = Color(10,132,255,255)
singularity.chatbox.CommandColors[PERMISSION_LEVEL_ADMIN] = Color(52,199,89,255)
singularity.chatbox.CommandColors[PERMISSION_LEVEL_LEAD_ADMIN] = Color(88,86,214)
singularity.chatbox.CommandColors[PERMISSION_LEVEL_SUPERADMIN] = Color(255,69,58)

surface.CreateFont( "singularity.chatbox_18", {
	font = "Segoe UI",
	size = 18,
	weight = 3500,
	antialias = true,
	shadow = false,
	extended = true,
	outline = false
} )

surface.CreateFont( "singularity.chatbox_16", {
	font = "Segoe UI Light",
	size = 16,
	weight = 3500,
	antialias = true,
	shadow = false,
	extended = true,
	outline = false
} )


--// Builds the chatbox but doesn't display it
function singularity.chatbox.buildBox()
	singularity.chatbox.frame = vgui.Create("DFrame")
	singularity.chatbox.frame:SetSize( ScrW()*0.375, ScrH()*0.25 )
	singularity.chatbox.frame:SetTitle("Chat")
	singularity.chatbox.frame:ShowCloseButton( false )
	//singularity.chatbox.frame:SetDraggable( true )
	//singularity.chatbox.frame:SetSizable( true )
	singularity.chatbox.frame:SetPos( ScrW()*0.0116, (ScrH() - singularity.chatbox.frame:GetTall()) - ScrH()*0.177)
	singularity.chatbox.frame:SetMinWidth( 300 )
	singularity.chatbox.frame:SetMinHeight( 100 )
	singularity.chatbox.oldPaint = singularity.chatbox.frame.Paint
	singularity.chatbox.frame.Think = function()
		if input.IsKeyDown( KEY_ESCAPE ) then
			singularity.chatbox.hideBox()
		end
	end
	
	local serverName = vgui.Create("DLabel", singularity.chatbox.frame)
	serverName:SetText( "" )
	singularity.chatbox.entry = vgui.Create("DTextEntry", singularity.chatbox.frame) 
	singularity.chatbox.entry:SetSize( singularity.chatbox.frame:GetWide() - 50, 20 )
	singularity.chatbox.entry:SetTextColor( color_white )
	singularity.chatbox.entry:SetFont("singularity.chatbox_18")
	singularity.chatbox.entry:SetDrawBorder( false )
	singularity.chatbox.entry:SetDrawBackground( false )
	singularity.chatbox.entry:SetCursorColor( color_white )
	singularity.chatbox.entry:SetHighlightColor( Color(52, 152, 219) )
	singularity.chatbox.entry:SetPos( 45, singularity.chatbox.frame:GetTall() - singularity.chatbox.entry:GetTall() - 5 )
	singularity.chatbox.entry.Paint = function( self, w, h )
		draw.RoundedBox( singularity.Config.CornerRadius, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
		derma.SkinHook( "Paint", "TextEntry", self, w, h )
	end

	singularity.chatbox.entry.OnTextChanged = function( self )
		if self and self.GetText then 
			gamemode.Call( "ChatTextChanged", self:GetText() or "" )
		end
	end

	singularity.chatbox.entry.OnKeyCodeTyped = function( self, code )
		local types = {"", "teamchat", "console"}

		if code == KEY_ESCAPE then

			singularity.chatbox.hideBox()
			gui.HideGameUI()

		elseif code == KEY_TAB then
			
			singularity.chatbox.TypeSelector = (singularity.chatbox.TypeSelector and singularity.chatbox.TypeSelector + 1) or 1
			
			if singularity.chatbox.TypeSelector > 3 then singularity.chatbox.TypeSelector = 1 end
			if singularity.chatbox.TypeSelector < 1 then singularity.chatbox.TypeSelector = 3 end
			
			singularity.chatbox.ChatType = types[singularity.chatbox.TypeSelector]

			timer.Simple(0.001, function() singularity.chatbox.entry:RequestFocus() end)

		elseif code == KEY_ENTER then
			-- Replicate the client pressing enter
			
			if string.Trim( self:GetText() ) != "" then
				if singularity.chatbox.ChatType == types[2] then
					LocalPlayer():ConCommand("say_team \"" .. (self:GetText() or "") .. "\"")
				elseif singularity.chatbox.ChatType == types[3] then
					LocalPlayer():ConCommand(self:GetText() or "")
				else
					LocalPlayer():ConCommand("say \"" .. self:GetText() .. "\"")
				end
			end

			singularity.chatbox.TypeSelector = 1
			singularity.chatbox.hideBox()
		end
	end

	singularity.chatbox.chatLog = vgui.Create("singularityScroll", singularity.chatbox.frame) 
	singularity.chatbox.chatLog:SetSize( singularity.chatbox.frame:GetWide() - 10, singularity.chatbox.frame:GetTall() - 60 )
	singularity.chatbox.chatLog:SetPos( 5, 30 )
	singularity.chatbox.chatLog.Paint = function( self, w, h )
		draw.RoundedBox( singularity.Config.CornerRadius, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
	end
	singularity.chatbox.chatLog.Think = function( self )
		if singularity.chatbox.lastMessage then
			if CurTime() - singularity.chatbox.lastMessage > singularity.chatbox.config.fadeTime then
				self:SetVisible( false )
			else
				self:SetVisible( true )
			end
		end
		self:SetSize( singularity.chatbox.frame:GetWide() - 10, singularity.chatbox.frame:GetTall() - singularity.chatbox.entry:GetTall() - serverName:GetTall() - 20 )
		//settings:SetPos( singularity.chatbox.frame:GetWide() - settings:GetWide(), 0 )
	end
	singularity.chatbox.chatLog.PerformLayout = function( self )
		self:SetFontInternal("singularity.chatbox_18")
		self:SetFGColor( color_white )
	end
	singularity.chatbox.chatLog.PaintOver = function( self, w, h )
        if not singularity.chat then return end
        if not singularity.chat.commands then return end
        if singularity.chatbox.entry:IsEditing() then
            local typed = singularity.chatbox.entry:GetValue()
            if not typed then return end
            typed = string.Split(typed, " ")[1]
            local len   = string.len(typed)
            if string.Left(typed, 1) == "/" then
                singularity.blur(self,200,15,10)
                surface.SetDrawColor(30, 30, 30, 200)
                surface.DrawRect(0, 0, w, h)
                local i = 1
                local pLevel = LocalPlayer():GetPermissionLevel()
                for name,data in pairs( singularity.chat.commands ) do
                    if string.Left(typed, len) == string.Left(name, len) then
                        if pLevel < data.PermissionLevel then 
                            continue 
                        end 
                        draw.SimpleText(name .. " - " .. data.HelpDescription, "singularity.chatbox_18", 5, 5 + ((i-1)*18), singularity.chatbox.CommandColors[data.PermissionLevel])
                        i = i + 1
                    end
                end
            end
        end
    end
	singularity.chatbox.oldPaint2 = singularity.chatbox.chatLog.Paint
	
	local text = "Say :"

	local say = vgui.Create("DLabel", singularity.chatbox.frame)
	say:SetText("")
	surface.SetFont( "singularity.chatbox_18")
	local w, h = surface.GetTextSize( text )
	say:SetSize( w + 5, 20 )
	say:SetPos( 5, singularity.chatbox.frame:GetTall() - singularity.chatbox.entry:GetTall() - 5 )
	
	say.Paint = function( self, w, h )
		draw.RoundedBox( singularity.Config.CornerRadius, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
		draw.DrawText( text, "singularity.chatbox_18", 2, 1, color_white )
	end

	say.Think = function( self )
		local types = {"", "teamchat", "console"}
		local s = {}

		if singularity.chatbox.ChatType == types[2] then 
			text = "Say (TEAM) :"	
		elseif singularity.chatbox.ChatType == types[3] then
			text = "Console :"
		else
			text = "Say :"
			s.pw = 45
			s.sw = singularity.chatbox.frame:GetWide() - 50
		end

		if s then
			if not s.pw then s.pw = self:GetWide() + 10 end
			if not s.sw then s.sw = singularity.chatbox.frame:GetWide() - self:GetWide() - 15 end
		end

		local w, h = surface.GetTextSize( text )
		self:SetSize( w + 5, 20 )
		self:SetPos( 5, singularity.chatbox.frame:GetTall() - singularity.chatbox.entry:GetTall() - 5 )

		singularity.chatbox.entry:SetSize( s.sw, 20 )
		singularity.chatbox.entry:SetPos( s.pw, singularity.chatbox.frame:GetTall() - singularity.chatbox.entry:GetTall() - 5 )
	end	
	
	singularity.chatbox.hideBox()
end

-- Hides the chat box but not the messages
function singularity.chatbox.hideBox()
	singularity.chatbox.isOpen = false

	singularity.chatbox.frame.Paint = function() end
	singularity.chatbox.chatLog.Paint = function() end
	
	singularity.chatbox.chatLog:SetScrollbarVisible(false)
	singularity.chatbox.chatLog:GotoTextEnd()
	
	singularity.chatbox.lastMessage = singularity.chatbox.lastMessage or CurTime() - singularity.chatbox.config.fadeTime
	
	-- Hide the chatbox except the log
	local children = singularity.chatbox.frame:GetChildren()
	for _, pnl in pairs( children ) do
		if pnl == singularity.chatbox.frame.btnMaxim or pnl == singularity.chatbox.frame.btnClose or pnl == singularity.chatbox.frame.btnMinim then continue end
		
		if pnl != singularity.chatbox.chatLog then
			pnl:SetVisible( false )
		end
	end
	
	-- Give the player control again
	singularity.chatbox.frame:SetMouseInputEnabled( false )
	singularity.chatbox.frame:SetKeyboardInputEnabled( false )
	gui.EnableScreenClicker( false )
	
	-- We are done chatting
	gamemode.Call("FinishChat")
	--hook.Run("singularityFinishChat")
	
	-- Clear the text entry
	singularity.chatbox.entry:SetText( "" )
	gamemode.Call( "ChatTextChanged", "" )
	singularity.chatbox.chatLog:SetVisible(true)
	singularity.chatbox.chatLog:GetVBar():SetVisible(false)
end

--// Shows the chat box
function singularity.chatbox.showBox()
	singularity.chatbox.isOpen = true
	-- Draw the chat box again
	singularity.chatbox.frame.Paint = singularity.chatbox.oldPaint
	singularity.chatbox.chatLog.Paint = singularity.chatbox.oldPaint2
	
	singularity.chatbox.chatLog:GetVBar():Show()
	singularity.chatbox.lastMessage = nil
	
	-- Show any hidden children
	local children = singularity.chatbox.frame:GetChildren()
	for _, pnl in pairs( children ) do
		if pnl == singularity.chatbox.frame.btnMaxim or pnl == singularity.chatbox.frame.btnClose or pnl == singularity.chatbox.frame.btnMinim then continue end
		
		pnl:SetVisible( true )
	end
	singularity.chatbox.chatLog:SetVisible(true)
	-- MakePopup calls the input functions so we don't need to call those
	singularity.chatbox.frame:MakePopup()
	singularity.chatbox.entry:RequestFocus()

	singularity.chatbox.chatLog:GetVBar():SetVisible(true)
	
	-- Make sure other addons know we are chatting
	gamemode.Call("StartChat") -- this runs too much so we are circumventing this with a custom hook
	--hook.Run("singularityStartChat")
end

-- Opens the settings panel
function singularity.chatbox.openSettings()
	singularity.chatbox.hideBox()
	
	singularity.chatbox.frameS = vgui.Create("DFrame")
	singularity.chatbox.frameS:SetSize( 400, 300 )
	singularity.chatbox.frameS:SetTitle("")
	singularity.chatbox.frameS:MakePopup()
	singularity.chatbox.frameS:SetPos( ScrW()/2 - singularity.chatbox.frameS:GetWide()/2, ScrH()/2 - singularity.chatbox.frameS:GetTall()/2 )
	singularity.chatbox.frameS:ShowCloseButton( true )
	singularity.chatbox.frameS.Paint = function( self, w, h )
		singularity.blur( self, 10, 20, 255 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
		
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 80, 80, 80, 100 ) )
		
		draw.RoundedBox( 0, 0, 25, w, 25, Color( 50, 50, 50, 50 ) )
	end
	
	local serverName = vgui.Create("DLabel", singularity.chatbox.frameS)
	serverName:SetText( "singularity.chatbox - Settings" )
	serverName:SetFont( "singularity.chatbox_18")
	serverName:SizeToContents()
	serverName:SetPos( 5, 4 )
	
	local label1 = vgui.Create("DLabel", singularity.chatbox.frameS)
	label1:SetText( "Time stamps: " )
	label1:SetFont( "singularity.chatbox_18")
	label1:SizeToContents()
	label1:SetPos( 10, 40 )
	
	local checkbox1 = vgui.Create("DCheckBox", singularity.chatbox.frameS ) 
	checkbox1:SetPos(label1:GetWide() + 15, 42)
	checkbox1:SetValue( singularity.chatbox.config.timeStamps )
	
	local label2 = vgui.Create("DLabel", singularity.chatbox.frameS)
	label2:SetText( "Fade time: " )
	label2:SetFont( "singularity.chatbox_18")
	label2:SizeToContents()
	label2:SetPos( 10, 70 )
	
	local textEntry = vgui.Create("DTextEntry", singularity.chatbox.frameS) 
	textEntry:SetSize( 50, 20 )
	textEntry:SetPos( label2:GetWide() + 15, 70 )
	textEntry:SetText( singularity.chatbox.config.fadeTime ) 
	textEntry:SetTextColor( color_white )
	textEntry:SetFont("singularity.chatbox_18")
	textEntry:SetDrawBorder( false )
	textEntry:SetDrawBackground( false )
	textEntry:SetCursorColor( color_white )
	textEntry:SetHighlightColor( Color(52, 152, 219) )
	textEntry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
		derma.SkinHook( "Paint", "TextEntry", self, w, h )
	end
	
	--[[local checkbox2 = vgui.Create("DCheckBox", singularity.chatbox.frameS ) 
	checkbox2:SetPos(label2:GetWide() + 15, 72)
	checkbox2:SetValue( singularity.chatbox.config.sesingularity.chatboxTags )
	
	local label3 = vgui.Create("DLabel", singularity.chatbox.frameS)
	label3:SetText( "Use chat tags: " )
	label3:SetFont( "singularity.chatbox_18")
	label3:SizeToContents()
	label3:SetPos( 10, 100 )
	
	local checkbox3 = vgui.Create("DCheckBox", singularity.chatbox.frameS ) 
	checkbox3:SetPos(label3:GetWide() + 15, 102)
	checkbox3:SetValue( singularity.chatbox.config.ussingularity.chatboxTag )]]
	
	local save = vgui.Create("DButton", singularity.chatbox.frameS)
	save:SetText("Save")
	save:SetFont( "singularity.chatbox_18")
	save:SetTextColor( Color( 230, 230, 230, 150 ) )
	save:SetSize( 70, 25 )
	save:SetPos( singularity.chatbox.frameS:GetWide()/2 - save:GetWide()/2, singularity.chatbox.frameS:GetTall() - save:GetTall() - 10)
	save.Paint = function( self, w, h )
		if self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 80, 80, 80, 200 ) )
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 200 ) )
		end
	end
	save.DoClick = function( self )
		singularity.chatbox.frameS:Close()
		
		singularity.chatbox.config.timeStamps = checkbox1:GetChecked() 
		singularity.chatbox.config.fadeTime = tonumber(textEntry:GetText()) or singularity.chatbox.config.fadeTime
	end
end

-- Panel based blur function by Chessnut from NutScript
local blur = Material( "pp/blurscreen" )
function singularity.chatbox.blur( panel, layers, density, alpha )
	-- Its a scientifically proven fact that blur improves a script
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end

local oldAddText = chat.AddText

--// Overwrite chat.AddText to detour it into my chatbox
function chat.AddText(...)
	if not singularity.chatbox.chatLog then
		singularity.chatbox.buildBox()
	end
	
	local msg = vgui.Create( "chatmessage", singularity.chatbox.chatLog )
	

	msg:SetMessage( ... )
	msg:Dock( TOP )
	singularity.chatbox.chatLog:AddItem(msg)
	-- Iterate through the strings and colors
	--[[for _, obj in pairs( {...} ) do
		if type(obj) == "table" then
			singularity.chatbox.chatLog:InsertColorChange( obj.r, obj.g, obj.b, obj.a )
			table.insert( msg, Color(obj.r, obj.g, obj.b, obj.a) )
		elseif type(obj) == "string"  then
			singularity.chatbox.chatLog:AppendText( obj )
			table.insert( msg, obj )
		elseif obj:IsPlayer() then
			local ply = obj
			
			if singularity.chatbox.config.timeStamps then
				singularity.chatbox.chatLog:InsertColorChange( 130, 130, 130, 255 )
				singularity.chatbox.chatLog:AppendText( "["..os.date("%X").."] ")
			end
			
			if singularity.chatbox.config.sesingularity.chatboxTags and ply:GetNWBool("singularity.chatbox_tagEnabled", false) then
				local col = ply:GetNWString("singularity.chatbox_tagCol", "255 255 255")
				local tbl = string.Explode(" ", col )
				singularity.chatbox.chatLog:InsertColorChange( tbl[1], tbl[2], tbl[3], 255 )
				singularity.chatbox.chatLog:AppendText( "["..ply:GetNWString("singularity.chatbox_tag", "N/A").."] ")
			end
			
			local col = GAMEMODE:GetTeamColor( obj )
			singularity.chatbox.chatLog:InsertColorChange( col.r, col.g, col.b, 255 )
			singularity.chatbox.chatLog:AppendText( obj:Nick() )
			table.insert( msg, obj:Nick() )
		end
	end]]
	singularity.chatbox.lastMessage = CurTime()
	singularity.chatbox.chatLog:SetVisible( true )

	chat.PlaySound()
	timer.Simple(0.05,function()
		singularity.chatbox.chatLog:ScrollToChild(msg)
	end)
--	oldAddText(unpack(msg))
end

--// Write any server notifications
hook.Remove( "ChatText", "singularity.chatbox_joinleave")
hook.Add( "ChatText", "singularity.chatbox_joinleave", function( index, name, text, type )
	if not singularity.chatbox.chatLog then
		singularity.chatbox.buildBox()
	end
	
	if type != "chat" then
		singularity.chatbox.chatLog:InsertColorChange( 0, 128, 255, 255 )
		singularity.chatbox.chatLog:AppendText( text.."\n" )
		singularity.chatbox.chatLog:SetVisible( true )
		singularity.chatbox.lastMessage = CurTime()
		return true
	end
end)

--// Stops the default chat box from being opened
hook.Remove("PlayerBindPress", "singularity.chatbox_hijackbind")
hook.Add("PlayerBindPress", "singularity.chatbox_hijackbind", function(ply, bind, pressed)
	if string.sub( bind, 1, 11 ) == "messagemode" then
		if pressed then
			net.Start("singularityStartChat")
			net.SendToServer()
		end
		if bind == "messagemode2" then 
			singularity.chatbox.ChatType = "teamchat"
		else
			singularity.chatbox.ChatType = ""
		end
		
		if IsValid( singularity.chatbox.frame ) then
			singularity.chatbox.showBox()
			singularity.chatbox.chatLog:SetScrollbarVisible(true)
		else
			singularity.chatbox.buildBox()
			singularity.chatbox.showBox()
		end
		return true
	end
end)

--// Hide the default chat too in case that pops up
hook.Remove("HUDShouldDraw", "singularity.chatbox_hidedefault")
hook.Add("HUDShouldDraw", "singularity.chatbox_hidedefault", function( name )
	if name == "CHudChat" then
		return false
	end
end)

 --// Modify the Chatbox for align.
local oldGetChatBoxPos = chat.GetChatBoxPos
function chat.GetChatBoxPos()
	return singularity.chatbox.frame:GetPos()
end

function chat.GetChatBoxSize()
	return singularity.chatbox.frame:GetSize()
end

chat.Open = singularity.chatbox.showBox
function chat.Close(...) 
	if IsValid( singularity.chatbox.frame ) then 
		singularity.chatbox.hideBox(...)
		singularity.chatbox.chatLog:SetScrollbarVisible(false)
	else
		singularity.chatbox.buildBox()
		singularity.chatbox.showBox()
	end
end