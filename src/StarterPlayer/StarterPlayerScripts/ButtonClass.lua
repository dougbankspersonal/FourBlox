local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockColors = require(ReplicatedStorage.BlockColors)
local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local incrementBlockColorRequest = ReplicatedStorage:WaitForChild("IncrementBlockColorRequest")

local RoactButtonClass = Roact.PureComponent:extend("RoactButtonClass")

function RoactButtonClass:init()
    self._onClick = function(rbx)
        print("Clicked me " .. tostring(self.props.index))
        print("rbx is " .. tostring(rbx))
        print("self is " .. tostring(self))
        incrementBlockColorRequest:InvokeServer(self.props.index)
    end    
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
        [Roact.Event.Activated] = self._onClick
    })
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
