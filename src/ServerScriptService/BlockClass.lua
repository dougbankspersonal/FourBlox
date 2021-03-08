local BlockClass = {}

BlockClass.__index = BlockClass

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockColors = require(game.ReplicatedStorage.BlockColors)

local blockColorChangeBroadcast = Instance.new("RemoteEvent")
blockColorChangeBroadcast.Parent = ReplicatedStorage
blockColorChangeBroadcast.Name = "BlockColorChangeBroadcast"

local function indexToOffset(index, bit)
    local offset = (bit32.band(index, bit) > 0)
    offset = offset and 1 or 0
    offset = -4 + offset * 8
    return offset
end

BlockClass.gBlocks = {}

function BlockClass.new(index)
    local self = {}
    setmetatable(self, BlockClass)

    -- make the part.
	self.blockPart = game.ServerStorage.BlockPart:Clone()
    self.blockIndex = index

    -- store it in global dict.
    BlockClass.gBlocks[index] = self

    -- keep the labels in an array.
    self.labels = {
        self.blockPart.SurfaceGui01.TextLabel,
        self.blockPart.SurfaceGui02.TextLabel,
        self.blockPart.SurfaceGui03.TextLabel,
        self.blockPart.SurfaceGui04.TextLabel,
    }

    -- set labels to show index.
    for i, v in ipairs(self.labels) do 
        self.labels[i].Text = tostring("Hi " .. tostring(index))
    end

    -- init color based on index.
    self:_setColorByIndex(index)

    print("index = " .. tostring(index))
    -- figure out position in the world based on index.
    local x = indexToOffset(index, 1)
    local z = indexToOffset(index, 2)
    self.blockPart.Position = Vector3.new(x, 2, z)

    -- put it in the workspace.
    self.blockPart.Parent = game.Workspace

    return self
end

function BlockClass:_incrementColorIndex()
    return self:_setColorByIndex(self.colorIndex % 4 + 1)
end

function BlockClass:_setColorByIndex(index)
    -- change server state.
	self.colorIndex = index
    -- change color.
    self.blockPart.Color = BlockColors.gBlockColors[self.colorIndex].Color
    -- broadcast to clients.
    blockColorChangeBroadcast:FireAllClients(self.blockIndex, self.colorIndex)
    return self.colorIndex
end

return BlockClass
