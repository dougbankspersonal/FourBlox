local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockColors = require(ReplicatedStorage.BlockColors)
local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local incrementBlockColorRequest = ReplicatedStorage:WaitForChild("IncrementBlockColorRequest")

local RoactButtonClass = Roact.Component:extend("RoactButtonClass")

function RoactButtonClass:init()
end

function dumpTable(t)
    for i, v in ipairs(t) do 
        print(i .. ": " .. v)
    end
end

function RoactButtonClass:render()
    local buttonIndex = self.props.index
    local colorIndex = self.props.buttonColorByIndex[buttonIndex]
    if not colorIndex then 
        colorIndex = buttonIndex
    end

    return Roact.createElement("TextButton", {
        Size = UDim2.new(0, 100, 0, 30),
        Position = UDim2.new(0.5, -50, 0, 10 + 40 * (buttonIndex-1)),
        Text = "Click " .. tostring(buttonIndex), 
        BackgroundColor3 = BlockColors.gBlockColors[colorIndex].Color,
        [Roact.Event.Activated] = function(rbx) 
            self:_onClick()
        end
    })
end

function RoactButtonClass:_onClick()
    print("Clicked me " .. tostring(self.props.index))
    incrementBlockColorRequest:InvokeServer(self.props.index)
end

-- wrap the RoactButtonClass in Roact/Rodux fu.
RoactButtonClass = RoactRodux.connect(
    function(state, props) 
        return {
            buttonColorByIndex = state.buttonColorByIndex
        }
    end
)(RoactButtonClass)

return RoactButtonClass
