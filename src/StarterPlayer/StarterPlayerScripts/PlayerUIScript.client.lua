print("Hello world")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Rodux = require(ReplicatedStorage.Rodux)
local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)
local RoactButtonClass = require(StarterPlayer.StarterPlayerScripts.ButtonClass)

local getBlockColorRequest = ReplicatedStorage:WaitForChild("GetBlockColorRequest")
local blockColorChangeBroadcast = ReplicatedStorage:WaitForChild("BlockColorChangeBroadcast")

-- Action creator for the ReceivedBlockColor action
local function ReceivedBlockColor(blockIndex, colorIndex)
    local retVal = {
		type = "ReceivedBlockColor",
        blockColors = {},
    }
    retVal.blockColors[blockIndex] = colorIndex
	return retVal
end

-- Reducer for the BlockIndex-to-color map in state.
local receivedBlockColorReducer = Rodux.createReducer({}, {
    ReceivedBlockColor = function(state, action)
        local newState = {}

        -- Since state is read-only, we copy it into newState
        for blockIndex, colorIndex in pairs(state) do
            newState[blockIndex] = colorIndex
        end

        for blockIndex, colorIndex in pairs(action.blockColors) do
            newState[blockIndex] = colorIndex
        end

        return newState
    end,
})

local reducer = Rodux.combineReducers({
    buttonColorByIndex = receivedBlockColorReducer,
})

-- Make rodux store...
local store = Rodux.Store.new(reducer, 
    nil, 
    {
        Rodux.loggerMiddleware,
    })

-- little helper function for updating button color in store.
function setButtonColorInRoduxStore(buttonIndex, colorIndex)
    store:dispatch(ReceivedBlockColor(buttonIndex, colorIndex))
end

-- Listen for server to tell you about updated block colors.
blockColorChangeBroadcast.OnClientEvent:Connect(function(blockIndex, newColorIndex) 
    setButtonColorInRoduxStore(blockIndex, newColorIndex)
end)

-- Get the current colors of blocks, dump that into store.
for i = 1, 4 do 
    local currentColorIndex = getBlockColorRequest:InvokeServer(i)
    setButtonColorInRoduxStore(i, currentColorIndex)
end

-- make table of roact buttons.
local roactButtonElements = {}
for i = 1, 4 do 
    local buttonElement = Roact.createElement(RoactButtonClass, 
    {
        index = i
    })
    roactButtonElements["RoactButtonElement" .. tostring(i)] = buttonElement
end


-- make roact screen gui
local app = Roact.createElement(RoactRodux.StoreProvider, {
    store = store, 
}, {
    FourBloxScreenGui = Roact.createElement("ScreenGui", {
    }, roactButtonElements)   
})

Roact.mount(app, Players.LocalPlayer.PlayerGui)