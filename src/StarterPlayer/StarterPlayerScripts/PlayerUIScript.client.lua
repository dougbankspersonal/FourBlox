print("Hello world")
local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local ButtonClass = require(StarterPlayer.StarterPlayerScripts.ButtonClass)

-- make screen gui.
local myScreenGui = Instance.new("ScreenGui")
myScreenGui.Parent = Players.LocalPlayer.PlayerGui

-- make buttons
for i = 1, 4 do 
    local button = ButtonClass.new(i, myScreenGui)
end
  