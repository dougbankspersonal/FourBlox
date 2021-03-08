local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BlockClass = require(game.ServerScriptService.BlockClass)

print("Adding incrementBlockColorRequest")

local incrementBlockColorRequest = Instance.new("RemoteFunction")
incrementBlockColorRequest.Parent = ReplicatedStorage
incrementBlockColorRequest.Name = "IncrementBlockColorRequest"
incrementBlockColorRequest.OnServerInvoke = function(player, blockIndex)
    local block = BlockClass.gBlocks[blockIndex]
    return block:_incrementColorIndex()
end

print("Added incrementBlockColorRequest")

local getBlockColorRequest = Instance.new("RemoteFunction")
getBlockColorRequest.Parent = ReplicatedStorage
getBlockColorRequest.Name = "GetBlockColorRequest"
getBlockColorRequest.OnServerInvoke = function(player, blockIndex)
    local block = BlockClass.gBlocks[blockIndex]
    return block.colorIndex
end

return module
