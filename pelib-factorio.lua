require("pelib-factorio-constants")
require("pelib-factorio-defines")

function pe.flying_text(surface, position, text) 
	surface.create_entity{ name = "flying-text", position = position, text = text, speed = 3.0 }
end


