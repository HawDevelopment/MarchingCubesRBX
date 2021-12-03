--[[
    Map
    HawDevelopment
    12/01/2021
--]]

local SCALE = 0.1

return function(sizex, sizey, sizez)
	local map = {}
	for x = 1, sizex do
		map[x] = {}
		for y = 1, sizey do
			map[x][y] = {}
			for z = 1, sizez do
				if math.noise(x * SCALE, y * SCALE, z * SCALE) > 0.1 then
					map[x][y][z] = 10
				else
					map[x][y][z] = -10
				end
			end
		end
	end
	return map
end
