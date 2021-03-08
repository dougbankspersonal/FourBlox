local ButtonClass = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockColors = require(ReplicatedStorage.BlockColors)
local incrementBlockColorRequest = ReplicatedStorage:WaitForChild("IncrementBlockColorRequest")
local getBlockColorRequest = ReplicatedStorage:WaitForChild("GetBlockColorRequest")

ButtonClass.__index = ButtonClass

ButtonClass.gButtons = {}

function ButtonClass.new(index, screenGui)
    local self = {}
    setmetatable(self, ButtonClass)

    self.buttonIndex = index

    -- make text button.
    self.textButton = Instance.new("TextButton")
    self.textButton.Parent = screenGui

    ButtonClass.gButtons[index] = self

    local colorIndex = getBlockColorRequest:InvokeServer(self.buttonIndex)

    self:_setColor(colorIndex)
    self.textButton.Position = UDim2.new(0.5, -50, 0, 10 + 40 * (self.buttonIndex-1))
    self.textButton.Size = UDim2.new(0, 100, 0, 30)
    self.textButton.Text = "Click " .. tostring(self.buttonIndex)
    self.textButton.Activated:Connect(function() 
        self:_onClick()
    end)

    local remoteEvent = ReplicatedStorage:WaitForChild("BlockColorChangeBroadcast")
    remoteEvent.OnClientEvent:Connect(function(blockIndex, colorIndex) 
        if (self.buttonIndex == blockIndex) then 
            self:_setColor(colorIndex)
        end
    end)

    return self
end

function ButtonClass:_setColor(colorIndex)
    self.textButton.BackgroundColor3 = BlockColors.gBlockColors[colorIndex].Color
end

function ButtonClass:_onClick()
    print("Clicked me " .. tostring(self.buttonIndex))
    incrementBlockColorRequest:InvokeServer(self.buttonIndex)
end

return ButtonClass
