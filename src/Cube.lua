--[[
    Cube
    HawDevelopment
    12/01/2021
--]]

local Tables = require(script.Parent:WaitForChild("Tables"))

local Cube = {}
Cube.__index = Cube

function Cube.new(pos: Vector3, tab: { [number]: number }?, size: number?)
	local self = setmetatable({}, Cube)

	self.Size = size or 1
	self.Position = pos * self.Size
	self.Table = tab
		or {
			math.random(-10, 10),
			math.random(-10, 10),
			math.random(-10, 10),
			math.random(-10, 10),
			math.random(-10, 10),
			math.random(-10, 10),
			math.random(-10, 10),
			math.random(-10, 10),
		}
	self.LastConfig = -1

	return self
end

local wedge = Instance.new("WedgePart")
wedge.Anchored = true
wedge.CanCollide = false
wedge.CanQuery = false
wedge.CanTouch = false
wedge.TopSurface = Enum.SurfaceType.Smooth
wedge.BottomSurface = Enum.SurfaceType.Smooth

-- Taken from egomoose
local function Draw3dTriangle(a, b, c, parent, color)
	local ab, ac, bc = b - a, c - a, c - b
	local abd, acd, bcd = ab:Dot(ab), ac:Dot(ac), bc:Dot(bc)

	if abd > acd and abd > bcd then
		c, a = a, c
	elseif acd > bcd and acd > abd then
		a, b = b, a
	end

	ab, ac, bc = b - a, c - a, c - b

	local right = ac:Cross(ab).unit
	local up = bc:Cross(right).unit
	local back = bc.unit

	local height = math.abs(ab:Dot(up))

	local w1 = wedge:Clone()
	w1.Size = Vector3.new(0, height, math.abs(ab:Dot(back)))
	w1.CFrame = CFrame.fromMatrix((a + b) / 2, right, up, back)
	w1.Parent = parent

	local w2 = wedge:Clone()
	w2.Size = Vector3.new(0, height, math.abs(ac:Dot(back)))
	w2.CFrame = CFrame.fromMatrix((a + c) / 2, -right, up, -back)
	w2.Parent = parent

	w1.Color = color
	w2.Color = color

	return w1, w2
end

function Cube:Edge(a, b)
	local pos1 = Tables.Positions[a] * self.Size
	local pos2 = Tables.Positions[b] * self.Size

	local l = -self.Table[a] / (self.Table[b] - self.Table[a])
	return pos1 + Vector3.new(l, l, l) * (pos2 - pos1) -- Vector3.new(pos1.X + l * (pos2.X - pos1.X), pos1.Y + l * (pos2.Y - pos1.Y), pos1.Z + l * (pos2.Z - pos1.Z))
end

-- function Cube:Edge(a, b)
-- 	local pos1 = Tables.Positions[a]
-- 	local pos2 = Tables.Positions[a]

-- 	local l = (0 - a) / (b - a)
-- 	return Vector3.new(pos1.X + l * (pos2.X - pos1.X), pos1.Y + l * (pos2.Y - pos1.Y), pos1.Z + l * (pos2.Z - pos1.Z))
-- end

function Cube:Build(parent, color)
	local config = 0
	for i = 1, 8 do
		config = config + (self.Table[i] >= 0 and 2 ^ (i - 1) or 0)
	end

	-- Since lua tables start at 1
	config += 1

	if config == self.LastConfig then
		return
	end
	config = Tables.Triangulation[config]
	for i = 1, 15, 3 do
		local a = config[i] + 1
		if not a or a == 0 then
			break
		end
		local b = config[i + 1] + 1
		local c = config[i + 2] + 1
		Draw3dTriangle(
			self.Position + self:Edge(Tables.Points[a].X, Tables.Points[a].Y),
			self.Position + self:Edge(Tables.Points[b].X, Tables.Points[b].Y),
			self.Position + self:Edge(Tables.Points[c].X, Tables.Points[c].Y),
			parent,
			color
		)
	end
end

return Cube
