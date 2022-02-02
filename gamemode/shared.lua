
DeriveGamemode("sandbox")

GM.Name 	= "Singularity"
GM.Author 	= "Mike White & Apsys"
GM.Email 	= "None"
GM.Website 	= "None"

singularity = singularity or {}
singularity.lib = singularity.lib or {}

singularity.__VERSION = "2.0"
singularity.__DISPLAY = "Singularity Framework"
singularity.__XTNOTES = "PREVIEW BUILD"

singularity.Config =  {}
singularity.Config.MainColor        = Color( 73, 123, 240)
singularity.Config.DefaultTextColor = Color( 245, 245, 245 )
singularity.Config.BGColorDark      = Color( 44,  44,  46  )
singularity.Config.BGColorLight     = Color( 229, 229, 234  )
singularity.Config.InteractColour	= Color( 214,188,39)
singularity.Config.ConsolePrefix    = "[Singularity]"
singularity.Config.VoiceRange       = 600

function singularity.ConsoleMessage(...)
	local mColor = singularity.Config.MainColor
	local prefix = singularity.Config.ConsolePrefix
	local textCo = singularity.Config.DefaultTextColor
	if CLIENT then
		return MsgC(mColor,prefix," ",textCo,...,"\n") -- \n to prevent same line console messages
	end
	return MsgC(mColor,prefix," ",textCo,...,"\n")
end

function GM:PlayerCanSeePlayersChat( _, __, listener, talker )
	if not talker:Alive() then return false end
	if listener:GetPos():DistToSqr( talker:GetPos() ) < ((singularity.Config.VoiceRange*singularity.Config.VoiceRange) or 600*600) then
		return true,true
	end
end

function GM:PlayerCanHearPlayersVoice( listener, talker )
	if not talker:Alive() then return false end
	if listener:GetPos():DistToSqr( talker:GetPos() ) < ((singularity.Config.VoiceRange*singularity.Config.VoiceRange) or 600*600) then
		return true,true
	end
end

function singularity.Warn(...)
	local singularity = landis.Config.MainColor
	local singularity = landis.Config.ConsolePrefix
	local singularity = landis.Config.DefaultTextColor
	if CLIENT then
		return MsgC(mColor,prefix,Color(255,149,0),"[Warn] ",textCo,...,"\n") -- \n to prevent same line console messages
	end
	return MsgC(mColor,prefix,Color(255,149,0),"[Warn] ",textCo,...,"\n")
end

function singularity.Error(...)
	local mColor = singularity.Config.MainColor
	local prefix = singularity.Config.ConsolePrefix
	local textCo = singularity.Config.DefaultTextColor
	if CLIENT then
		return MsgC(mColor,prefix,Color(255,149,0),"[Error] ",textCo,...,"\n") -- \n to prevent same line console messages
	end
	MsgC(mColor,prefix,Color(255,59,48),"[Error] ",textCo,...,"\n")
	print("======[STACK TRACEBACK]=====")
	debug.Trace()
	print("======[ENDOF TRACEBACK]=====")
end

function singularity.includeDir( scanDirectory, core )
	-- Null-coalescing for optional argument
	core = core or false
	
	local queue = { scanDirectory }
	
	-- Loop until queue is cleared
	while #queue > 0 do
		-- For each directory in the queue...
		for _, directory in pairs( queue ) do
			--print(directory)
			-- print( "Scanning directory: ", directory )
			
			local files, directories = file.Find( directory .. "/*", "LUA" )
			
			-- Include files within this directory
			for _, fileName in pairs( files ) do
				
				if fileName != "shared.lua" and fileName != "init.lua" and fileName != "cl_init.lua" then
					-- print( "Found: ", fileName )
					
					-- Create a relative path for inclusion functions
					-- Also handle pathing case for including gamemode folders
					local relativePath = directory .. "/" .. fileName
	
					if core then
						relativePath = string.gsub( directory .. "/" .. fileName, "landis/gamemode/", "" )
					end

					-- Include server files
					if string.match( fileName, "^rq" ) then
						if (SERVER) then
							AddCSLuaFile(relativePath)
						end
						_G[string.sub(fileName, 3, string.len(fileName) - 4)] = include(relativePath)
					end
					
					-- Include server files
					if string.match( fileName, "^sv" ) then
						if SERVER then
							include( relativePath )
						end
					end
					
					-- Include shared files
					if string.match( fileName, "^sh" ) then
						AddCSLuaFile( relativePath )
						include( relativePath )
					end
					
					-- Include client files
					if string.match( fileName, "^cl" ) then
						AddCSLuaFile( relativePath )
						
						if CLIENT then
							include( relativePath )
						end
					end
				end
			end
			
			-- Append directories within this directory to the queue
			for _, subdirectory in pairs( directories ) do
				-- print( "Found directory: ", subdirectory )
				table.insert( queue, directory .. "/" .. subdirectory )
			end
			
			-- Remove this directory from the queue
			table.RemoveByValue( queue, directory )
		end
	end
end

if SERVER then
	MsgC(Color(10,132,255),"[SINGULARITY] loading gamemode...\n")
	singularity.includeDir("singularity")
	MsgC(Color(10,132,255),"[SINGULARITY] loading plugins...\n")
	singularity.includeDir("singularity/plugins")
	MsgC(Color(10,132,255),"[SINGULARITY] loading metas...\n")
	singularity.includeDir("singularity/meta")
	MsgC(Color(10,132,255),"[SINGULARITY] loading VGUI's...\n")
	singularity.includeDir("singularity/vgui")
end

if CLIENT then 
	MsgC(Color(10,132,255),"[SINGULARITY] loading gamemode...\n")
	singularity.includeDir("singularity")
	MsgC(Color(10,132,255),"[SINGULARITY] loading plugins...\n")
	singularity.includeDir("singularity/plugins")
	MsgC(Color(10,132,255),"[SINGULARITY] loading metas...\n")
	singularity.includeDir("singularity/meta")
	MsgC(Color(10,132,255),"[SINGULARITY] loading VGUI's...\n")
	singularity.includeDir("singularity/vgui")

end
