-- [[Settings.v2]] --
-- HEAVILY BASED ON IMPULSE'S SETTING SYSTEM
-- LARGE MAJORITY OF CREDIT GOES TO VIN BECAUSE FUCK I COULD NOT FIGURE THIS OUT
singularity.Settings = singularity.Settings or {}

function singularity.LoadSettings()
    for v,k in pairs(singularity.Settings) do
        -- check types
        if k.type == "tickbox" or k.type == "slider" or k.type == "int" then
            -- number values
            local default = k.default
            if k.type == "tickbox" then
                default = tonumber(k.default)
            end

            k.value = cookie.GetNumber("singularity_setting-"..v, default)
        elseif k.type == "dropdown" or k.type == "textbox" then
            -- string values
            k.value = cookie.GetString("singularity_setting-"..v, k.default)
        end
    end
end

function singularity.SetSetting(name,val)
    local data = singularity.Settings[name]
    if data then
        if type(val) == "boolean" then
            val = val and 1 or 0
        end
        cookie.Set("singularity_setting-"..name, val)
        data.value = val
        return
    end
    singularity.Error("Could not SetSetting! Improper name!")
end

function singularity.GetSetting(name)
	local data = singularity.Settings[name]

	if data.type == "tickbox" then
		if data.value == nil then
			return data.default
		end

		return tobool(data.value)
	end

	return data.value or data.default
end


function singularity.DefineSetting(name,data)
    singularity.Settings[name] = data
    singularity.LoadSettings()
end