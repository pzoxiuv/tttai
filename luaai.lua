require "my_opencv"

function spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    if order then
        table.sort(keys, function(a, b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    local i=0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

coords = detectAndDisplay("full_shot5.png", "single_square.xml")

for i, t in spairs(coords, function(t, a, b)
        if (t[b][2] > t[a][2]) then
            return true
        elseif (t[b][2] < t[a][2]) then
            return false
        else
            return t[b][1] > t[a][1]
        end
    end) do
--    print ("x: " .. t[1] .. " y: " .. t[2])
end

table.sort(coords,
	function(a, b)
		local ay = math.floor(a[2]/100)
		local by = math.floor(b[2]/100)
		return ay < by or ay == by and a[1] < b[1]
	end
)

for i, t in ipairs(coords) do
    print ("X: " .. t[1] .. " Y: " .. t[2])
end
