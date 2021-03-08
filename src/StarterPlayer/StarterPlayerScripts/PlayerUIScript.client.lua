print("Hello world")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Roact = require(ReplicatedStorage.Roact)
local RoactButtonClass = require(StarterPlayer.StarterPlayerScripts.ButtonClass)

-- make table of roact buttons.
local roactButtonElements = {}
for i = 1, 4 do 
    roactButtonElements["RoactButtonElement" .. tostring(i)] = Roact.createElement(RoactButtonClass, 
    {
        index = i
    })
end


-- make roact screen gui
local app = Roact.createElement("ScreenGui", 
    {
        Name = "FourBloxScreenGui"
    }, 
    roactButtonElements   
)

Roact.mount(app, Players.LocalPlayer.PlayerGui)