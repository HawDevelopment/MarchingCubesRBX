--[[
    Marching Cubes
    HawDevelopment
    12/01/2021
--]]

local SIZE = 80

local Cube = require(script.Parent:WaitForChild("Cube"))
local Map = require(script.Parent:WaitForChild("Map"))

print("Creating Map")
local mymap = Map(SIZE, SIZE, SIZE)
print("Building Map")

local final = Instance.new("Folder")
final.Name = "Marching Cubes"
local folder = Instance.new("Folder")
folder.Name = "Map"
local parent = Instance.new("Folder")
folder.Name = "Parent"

for x = 1, SIZE - 1 do
	for y = 1, SIZE - 1 do
		for z = 1, SIZE - 1 do
			local mycube = Cube.new(Vector3.new(x, y, z), {
				mymap[x][y][z],
				mymap[x][y][z + 1],
				mymap[x + 1][y][z + 1],
				mymap[x + 1][y][z],
				mymap[x][y + 1][z],
				mymap[x][y + 1][z + 1],
				mymap[x + 1][y + 1][z + 1],
				mymap[x + 1][y + 1][z],
			}, 10)
			mycube:Build(
				parent,
				Color3.fromHSV(Vector3.new(x / (SIZE * 4), y / (SIZE * 4), z / (SIZE * 4)).Magnitude, 1, 1)
			)
		end
		if y % 20 == 0 then
			parent.Parent = folder
			parent = Instance.new("Folder")
			parent.Name = "Parent"
			task.wait()
		elseif y == SIZE - 1 then
			parent.Parent = folder
		end
	end
	if x % 10 == 0 then
		task.defer(pcall, function()
			folder.Parent = final
		end)
		folder = Instance.new("Folder")
		folder.Name = "Map"
		task.wait(1)
	elseif x == SIZE - 1 then
		folder.Parent = final
	end
end
pcall(function()
	final.Parent = game.Workspace
end)
task.wait(1)
print("Done")
