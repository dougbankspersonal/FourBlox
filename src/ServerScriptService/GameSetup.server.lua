print("Blocks")

local RemoteFunctions = require(game.ServerScriptService.RemoteFunctionSetup)
local BlockClass = require(game.ServerScriptService.BlockClass)

for i = 1, 4 do 
    local blockPart = BlockClass.new(i)
end
