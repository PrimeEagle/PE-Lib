if not pe then pe = {} end
if not pe.data then pe.data = {} end
if not pe.data.data_control_xfr then pe.data.data_control_xfr = {} end

require("pelib-lua")
require("pelib-factorio")


function pe.data.data_control_xfr.get(name, prototypeList)
	prototypeList = prototypeList or game.item_prototypes
	
	log("get name = "..pe.XFR_PREFIX .. name)
	log("get prototypeList = "..serpent.dump(prototypeList))
	
	local idxName = pe.XFR_PREFIX .. name
	local prototype = prototypeList[idxName]
	
	
	local res

	if(prototype) then
		res = loadstring("return "..pe.decode(prototype.localised_description))()
	end
	
	return res
end