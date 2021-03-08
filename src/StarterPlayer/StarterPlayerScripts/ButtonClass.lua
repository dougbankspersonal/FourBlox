local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockColors = require(ReplicatedStorage.BlockColors)
local Roact = require(ReplicatedStorage.Roact)

local incrementBlockColorRequest = ReplicatedStorage:WaitForChild("IncrementBlockColorRequest")
local getBlockColorRequest = ReplicatedStorage:WaitForChild("GetBlockColorRequest")

local RoactButtonClass = Roact.Component:extend("RoactButtonClass")

RoactButtonClass.gButtons = {}

function RoactButtonClass:init()
    local index = self.props.index

    -- keep a reference to the button.
    RoactButtonClass.gButtons[index] = self

    -- get the current color of the corresponding block.
    local colorIndex = getBlockColorRequest:InvokeServer(index)

    -- Listen for remote event indicating block changed color.
    local remoteEvent = ReplicatedStorage:WaitForChild("BlockColorChangeBroadcast")
    remoteEvent.OnClientEvent:Connect(function(blockIndex, colorIndex) 
        if (index == blockIndex) then 
            self:setState({
                colorIndex = colorIndex
            })
        end
    end)

    self:setState({
        colorIndex = index
    })
end

function RoactButtonClass:render()
    local colorIndex = self.state.colorIndex
    local buttonIndex = self.props.index

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

return RoactButtonClass
