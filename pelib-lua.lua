if not pe then pe = {} end
if not pe.lua then pe.lua = {} end

function pe.has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end




function pe.vector_length(v) 
	return math.sqrt(math.abs(v.x)^2 + math.abs(v.y)^2) 
end



function pe.snap_angle(position, ang)
	local vx = pe.vector_length(position) 
	local rad = math.rad(math.deg(math.atan2(position.x, position.y)) + ang) 
	
	return { x = vx * (math.sin(rad)), y = vx*(math.cos(rad)) } 
end




function pe.snap_orientation(position, angle)
	return pe.snap_angle(position, angle * 360) 
end




local b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function pe.base64_encode(data)
    return ((data:gsub('.', function(x) 
        local r, b64 = '', x:byte()
        for i=8, 1, -1 do
			r = r..(b64 % 2^i - b64 % 2^(i-1) > 0 and '1' or '0') 
		end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then 
			return '' 
		end
        local c = 0
        for i=1, 6 do 
			c = c + (x:sub(i,i) == '1' and 2^(6 - i) or 0) 
		end
        return b64:sub(c + 1, c + 1)
    end)..({ '', '==', '=' })[#data % 3 + 1])
end




function pe.base64_decode(data)
    data = string.gsub(data, '[^'..b64..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then 
			return '' 
		end
        local r, f = '', (b64:find(x) - 1)
        for i=6, 1, -1 do 
			r = r..(f % 2^i - f % 2^(i-1) > 0 and '1' or '0') 
		end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then 
			return '' 
		end
        local c = 0
        for i=1, 8 do
			c = c + (x:sub(i,i) == '1' and 2^(8-i) or 0) 
		end
        return string.char(c)
    end))
end




function pe.insert_node(nodes, node, value)
    table.insert(node, value)
    if 21 == #node then
        node = { "" }
        table.insert(nodes, node)
    end
    return node
end




function pe.encode(data)
    local node = { "" }
    local root = { node }
    local n = string.len(data)
	
    for i = 1, n, 200 do
        local value = string.sub(data, i, i + 199)
        node = pe.insert_node(root, node, value)
    end
	
    while #root > 20 do
        local nodes,node = {},{""}
        for _, value in ipairs(root) do
            node = pe.insert_node(nodes, node, value)
        end
        root = nodes
    end
	
    if #root == 1 then root = root[1] else
        table.insert(root, 1, "")
    end
	
    return #root < 3 and (root[2] or "") or root
end




function pe.decode(data)
    if type(data) == "string" then 
		return data 
	end
    
	local str = {}
    
	for i = 2, #data do
        str[i-1] = pe.decode(data[i])
    end
    
	return table.concat(str, "")
end