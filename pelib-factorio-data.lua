if not pe then pe = {} end
if not pe.data then pe.data = {} end
if not pe.data.data_control_xfr then pe.data.data_control_xfr = {} end

require("pelib-lua")
require("pelib-factorio")

function pe.data.data_control_xfr.put(name, data)
	res = 	{
        type = "item",
        name = pe.XFR_PREFIX .. name,
        icon = "__core__/graphics/empty.png",
        icon_size = 1,
        stack_size = 1,
        flags = {"hidden", "hide-from-bonus-gui", "hide-from-fuel-tooltip"},
        localised_name = pe.XFR_PREFIX .. name,
        localised_description = pe.encode(serpent.serialize(data, {})),
        order = "z"
    }
	
    return res
end