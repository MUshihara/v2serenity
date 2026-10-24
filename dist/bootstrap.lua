-- Serenity Grimoire key-window design revision. VampAuth test. Protected payload must call CompleteAuthentication.
-- Test repository only; no production games are loaded.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
assert(player, "Serenity key window requires a local player")
local environment = _G
if type(getgenv) == "function" then
    local ok, value = pcall(getgenv)
    if ok and type(value) == "table" then environment = value end
end
local previous = environment.__SerenityKeyWindowTest
if type(previous) == "table" and type(previous.Destroy) == "function" then
    pcall(function() previous:Destroy() end)
end

local connections, tweens = {}, {}
local destroyed, closing = false, false
local controller = {}
local verifying, authenticated, attempt = false, false, 0
local authLoader = "https://vampauth.com/v1/loaders/59abff27e57ded3ff8ff7ff854b9834f.lua"
local testUI = "https://raw.githubusercontent.com/MUshihara/v2serenity/1d9600bb2a6910b749f9f819bf9b992f0517aa10/dist/ui/serenity.lua"
local pendingKey
local cacheFile = "Serenity_Test_VampAuth_Key.txt"
local readKeyFile = environment.readfile or readfile
local writeKeyFile = environment.writefile or writefile
local deleteKeyFile = environment.delfile or delfile
local function readSavedKey()
    if type(readKeyFile) ~= "function" then return nil end
    local ok, value = pcall(readKeyFile, cacheFile)
    if not ok or type(value) ~= "string" or #value > 512 then return nil end
    value = value:match("^%s*(.-)%s*$")
    if value == "" or value:find("[\r\n]") then return nil end
    return value
end
local function saveVerifiedKey(key)
    if type(writeKeyFile) ~= "function" or type(key) ~= "string" or key == "" then return false end
    return pcall(writeKeyFile, cacheFile, key)
end
function controller:ForgetSavedKey()
    if type(deleteKeyFile) == "function" then
        local ok = pcall(deleteKeyFile, cacheFile)
        if ok then return true end
    end
    if type(writeKeyFile) == "function" then return pcall(writeKeyFile, cacheFile, "") end
    return false
end

local colors = {
    navy = Color3.fromRGB(17, 24, 36),
    glass = Color3.fromRGB(32, 44, 62),
    text = Color3.fromRGB(242, 238, 225),
    muted = Color3.fromRGB(180, 193, 211),
    cyan = Color3.fromRGB(192, 170, 120),
    lavender = Color3.fromRGB(111, 140, 178),
    ivory = Color3.fromRGB(224, 211, 175),
    error = Color3.fromRGB(231, 147, 137),
}
local buttonAccents = {}
local function bind(signal, callback)
    local connection = signal:Connect(callback)
    connections[#connections + 1] = connection
    return connection
end
local function make(class, properties, parent)
    local object = Instance.new(class)
    for key, value in pairs(properties or {}) do object[key] = value end
    object.Parent = parent
    return object
end
local function round(object, radius)
    return make("UICorner", {CornerRadius = UDim.new(0, radius)}, object)
end
local function stroke(object, color, transparency, thickness)
    return make("UIStroke", {
        Color = color, Transparency = transparency or 0,
        Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, object)
end
local function animate(object, duration, properties)
    if destroyed then return end
    local active = tweens[object]
    if active then active:Cancel() end
    local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties)
    tweens[object] = tween
    tween:Play()
end
local function text(parent, content, size, position, dimensions, color, bold)
    return make("TextLabel", {
        BackgroundTransparency = 1, Text = content,
        TextColor3 = color or colors.text, TextSize = size,
        Font = bold and Enum.Font.GothamMedium or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Position = position, Size = dimensions,
    }, parent)
end

local gui = make("ScreenGui", {
    Name = "Serenity_KeyWindow_Test", ResetOnSpawn = false,
    IgnoreGuiInset = false, DisplayOrder = 150,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
local parented = false
if type(gethui) == "function" then
    local ok, parent = pcall(gethui)
    if ok and parent then parented = pcall(function() gui.Parent = parent end) end
end
if not parented then
    parented = pcall(function() gui.Parent = game:GetService("CoreGui") end)
end
if not parented then gui.Parent = player:WaitForChild("PlayerGui") end

local viewport = make("Frame", {
    Name = "SafeViewport", BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1), Active = false,
}, gui)
-- Measure inherited GUI scaling separately from the window's own UIScale.
local scaleProbe = make("Frame", {
    Name = "ScaleProbe", BackgroundTransparency = 1,
    Size = UDim2.fromOffset(100, 100), Active = false,
}, viewport)
local panel = make("CanvasGroup", {
    Name = "KeyWindow", AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(552, 380),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1,
    GroupColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0, GroupTransparency = 1, ClipsDescendants = true,
}, viewport)
round(panel, 8)
local edge = stroke(panel, Color3.fromRGB(255, 255, 255), 0.38, 1)
make("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 131, 106)),
        ColorSequenceKeypoint.new(1, colors.lavender),
    }), Rotation = 32,
}, edge)
-- A gradient on CanvasGroup tints its entire rendered subtree. Keep the
-- group neutral and shade only this background frame. White is intentional:
-- UIGradient multiplies the underlying color rather than replacing it.
local background = make("Frame", {
    Name = "GlassBackground", Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.025, BorderSizePixel = 0,
    ZIndex = 0, Active = false,
}, panel)
round(background, 8)
make("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 40, 57)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(19, 28, 41)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(23, 32, 46)),
    }), Rotation = 35,
}, background)
local scaling = make("UIScale", {Scale = 1}, panel)
local header = make("Frame", {
    Name = "Header", BackgroundColor3 = colors.glass,
    BackgroundTransparency = 0.68, BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 56),
}, panel)
make("Frame", {
    BackgroundColor3 = colors.muted, BackgroundTransparency = 0.85,
    BorderSizePixel = 0, Position = UDim2.new(0, 0, 1, -1),
    Size = UDim2.new(1, 0, 0, 1),
}, header)
-- The compass uses native GUI shapes; no external image asset is required.
local emblem = make("Frame", {
    BackgroundTransparency = 1, Position = UDim2.fromOffset(24, 12),
    Size = UDim2.fromOffset(32, 32),
}, header)
for i = 0, 11 do
    local distance = i / 11
    local thickness = math.max(1, math.floor(32 * 0.32 * (1 - distance) ^ 2))
    for _, axis in ipairs({0, 1}) do
        for _, sign in ipairs({-1, 1}) do
            make("Frame", {
                BorderSizePixel = 0, BackgroundColor3 = colors.ivory,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.fromOffset(axis == 0 and thickness or 1.4, axis == 0 and 1.4 or thickness),
                Position = UDim2.fromOffset(16 + (axis == 1 and sign * distance * 14.7 or 0), 16 + (axis == 0 and sign * distance * 14.7 or 0)),
            }, emblem)
        end
    end
end
local headerTitle = text(header, "SERENITY HUB", 22, UDim2.fromOffset(69, 0), UDim2.new(1, -137, 0, 56), colors.text, true)
headerTitle.Font = Enum.Font.GothamBold
local close = make("TextButton", {
    Name = "Close", BackgroundColor3 = colors.glass, BackgroundTransparency = 0.6, Text = "×",
    TextColor3 = colors.muted, TextSize = 30, Font = Enum.Font.Gotham,
    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 6),
    Size = UDim2.fromOffset(44, 44), AutoButtonColor = false,
}, header)

round(close, 8)
stroke(close, colors.muted, 0.75)
local body = make("CanvasGroup", {
    Name = "Body", BackgroundTransparency = 1, BorderSizePixel = 0,
    GroupTransparency = 0, GroupColor3 = Color3.fromRGB(255, 255, 255),
    Position = UDim2.fromOffset(0, 56), Size = UDim2.new(1, 0, 1, -120),
    ClipsDescendants = false,
}, panel)
local title = text(body, "Welcome to Serenity", 23, UDim2.fromOffset(24, 12), UDim2.new(1, -48, 0, 32), colors.text, true)
title.TextXAlignment = Enum.TextXAlignment.Left
local subtitle = text(body, "No key yet? Choose Get a key to get started.", 15, UDim2.fromOffset(24, 47), UDim2.new(1, -48, 0, 24), colors.muted)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
text(body, "Access key", 14, UDim2.fromOffset(28, 81), UDim2.new(1, -56, 0, 22), colors.text, true)
local inputShell = make("Frame", {
    BackgroundColor3 = colors.glass, BackgroundTransparency = 0.28,
    Position = UDim2.fromOffset(28, 108), Size = UDim2.new(1, -56, 0, 48),
    BorderSizePixel = 0,
}, body)
round(inputShell, 5)
local inputEdge = stroke(inputShell, colors.muted, 0.52)
local input = make("TextBox", {
    Name = "LicenseKey", BackgroundTransparency = 1,
    Position = UDim2.fromOffset(15, 0), Size = UDim2.new(1, -72, 1, 0),
    Text = "", PlaceholderText = "Enter or paste your access key",
    TextColor3 = colors.text, PlaceholderColor3 = colors.muted,
    Font = Enum.Font.Gotham, TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false, MultiLine = false,
}, inputShell)
local paste = make("TextButton", {
    Name = "Paste", BackgroundColor3 = Color3.fromRGB(40, 58, 82), BackgroundTransparency = 1,
    Text = "", TextColor3 = colors.text, Font = Enum.Font.GothamMedium,
    TextSize = 13, BorderSizePixel = 0,
    Position = UDim2.new(1, -48, 0, 4), Size = UDim2.fromOffset(44, 40),
    AutoButtonColor = false,
}, inputShell)
round(paste, 3)
local pasteGlyph = make("Frame", {
    Name = "PasteClipboard", BackgroundTransparency = 1, BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(14, 17), Active = false,
}, paste)
round(pasteGlyph, 2)
local pasteGlyphEdge = stroke(pasteGlyph, colors.muted, 0, 1.5)
local pasteClip = make("Frame", {
    BackgroundColor3 = colors.muted, BorderSizePixel = 0, Active = false,
    AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, -2),
    Size = UDim2.fromOffset(8, 4),
}, pasteGlyph)
round(pasteClip, 1)
local pasteGlyphScale = make("UIScale", {Scale = 1}, pasteGlyph)
bind(paste.MouseEnter, function()
    animate(pasteGlyphEdge, 0.12, {Color = colors.ivory})
    animate(pasteClip, 0.12, {BackgroundColor3 = colors.ivory})
end)
bind(paste.MouseLeave, function()
    animate(pasteGlyphEdge, 0.12, {Color = colors.muted})
    animate(pasteClip, 0.12, {BackgroundColor3 = colors.muted})
    animate(pasteGlyphScale, 0.12, {Scale = 1})
end)
bind(paste.InputBegan, function(event)
    if event.UserInputType == Enum.UserInputType.MouseButton1 or event.UserInputType == Enum.UserInputType.Touch then
        animate(pasteGlyphScale, 0.06, {Scale = 0.86})
    end
end)
bind(UserInputService.InputEnded, function(event)
    if event.UserInputType == Enum.UserInputType.MouseButton1 or event.UserInputType == Enum.UserInputType.Touch then
        animate(pasteGlyphScale, 0.12, {Scale = 1})
    end
end)
local function pixelSymbol(parent, name, rows, color, position)
    local icon = make("Frame", {
        Name = name, BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = position, AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromOffset(16, 16), Active = false,
    }, parent)
    for y, row in ipairs(rows) do
        for x = 1, #row do
            if row:sub(x,x) == "#" then
                make("Frame", {
                    BackgroundColor3 = color, BorderSizePixel = 0, Active = false,
                    Position = UDim2.fromOffset((x-1)*2, (y-1)*2),
                    Size = UDim2.fromOffset(2, 2),
                }, icon)
            end
        end
    end
    return icon
end
local function button(name, caption, y, primary)
    local object = make("TextButton", {
        Name = name, BackgroundColor3 = primary and Color3.fromRGB(255, 255, 255) or colors.navy,
        BackgroundTransparency = primary and 0 or 0.3, BorderSizePixel = 0,
        Position = UDim2.fromOffset(28, y), Size = UDim2.new(1, -56, 0, 48),
        Text = caption, TextColor3 = primary and colors.navy or colors.text,
        Font = Enum.Font.GothamBold, TextSize = 15, AutoButtonColor = false,
    }, body)
    round(object, 5)
    if primary then stroke(object, colors.cyan, 0.15) end
    if primary then
        make("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(213, 195, 149), colors.cyan), Rotation = 90}, object)
    end
    local hovered = false
    bind(object.MouseEnter, function()
        hovered = true
        animate(object, 0.12, {BackgroundTransparency = primary and 0.08 or 0})
    end)
    bind(object.MouseLeave, function()
        hovered = false
        animate(object, 0.12, {BackgroundTransparency = primary and 0 or 0.08})
    end)
    if not primary then
        bind(object.InputBegan, function(event)
            if event.UserInputType == Enum.UserInputType.MouseButton1 or event.UserInputType == Enum.UserInputType.Touch then
                animate(object, 0.06, {BackgroundTransparency = 0.16})
            end
        end)
        bind(UserInputService.InputEnded, function(event)
            if event.UserInputType == Enum.UserInputType.MouseButton1 or event.UserInputType == Enum.UserInputType.Touch then
                animate(object, 0.12, {BackgroundTransparency = hovered and 0 or 0.08})
            end
        end)
    end
    return object
end
-- One action row keeps the complete key gate visible in phone landscape.
local verify = button("Verify", "Verify key  →", 170, true)
verify.Size = UDim2.new(0.64, -36, 0, 48)
local getKey = button("GetKey", "Get a key", 170, false)
getKey.Position = UDim2.new(0.64, 4, 0, 170)
getKey.Size = UDim2.new(0.36, -32, 0, 48)
-- Restrained action colors stay readable against the charcoal window.
verify.TextXAlignment = Enum.TextXAlignment.Center
make("UIPadding", {PaddingLeft = UDim.new(0, 18)}, verify)
pixelSymbol(verify, "VerifyShield", {
    " ###### ", "########", "### ####", "## ## ##",
    "##   ###", " ###### ", "  ####  ", "   ##   ",
}, colors.navy, UDim2.new(0.5, -68, 0.5, 0))
getKey.BackgroundColor3 = Color3.fromRGB(44, 83, 143)
getKey.BackgroundTransparency = 0.08
getKey.TextColor3 = Color3.fromRGB(241, 247, 255)
stroke(getKey, Color3.fromRGB(122, 174, 244), 0.18, 1)
make("UIPadding", {PaddingLeft = UDim.new(0, 18)}, getKey)
pixelSymbol(getKey, "GetKeyIcon", {
    " ###    ", "#   #   ", "# # #   ", "#   #   ",
    " ###### ", "     ## ", "      ##", "      ##",
}, Color3.fromRGB(234, 243, 255), UDim2.new(0.5, -55, 0.5, 0))
buttonAccents[getKey] = Color3.fromRGB(119, 163, 222)
local statusDot = make("Frame", {
    BackgroundColor3 = colors.muted, BorderSizePixel = 0,
    Position = UDim2.fromOffset(28, 240), Size = UDim2.fromOffset(5, 5),
}, body)
round(statusDot, 7)
local statusLabel = text(body, "Enter your key to continue.", 12, UDim2.fromOffset(42, 228), UDim2.new(1, -70, 0, 30), colors.muted)
statusLabel.TextWrapped = true

local footer = make("Frame", {
    Name = "Footer", BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 1, -64), Size = UDim2.new(1, 0, 0, 64),
}, panel)
make("Frame", {
    BackgroundColor3 = colors.muted, BackgroundTransparency = 0.85,
    Position = UDim2.fromOffset(24, 0), Size = UDim2.new(1, -48, 0, 1), BorderSizePixel = 0,
}, footer)
text(footer, "Need a hand?", 13, UDim2.fromOffset(28, 8), UDim2.new(1, -190, 0, 22), colors.text, true)
text(footer, "Keys, updates and premium support.", 13, UDim2.fromOffset(28, 31), UDim2.new(1, -190, 0, 22), colors.muted)
local discordBlue = Color3.fromRGB(104, 139, 255)
local discord = make("TextButton", {
    Name = "Discord", BackgroundColor3 = Color3.fromRGB(33, 53, 105),
    BackgroundTransparency = 0.08, Text = "", BorderSizePixel = 0,
    TextColor3 = Color3.fromRGB(233, 241, 255), TextSize = 14, Font = Enum.Font.GothamMedium,
    Position = UDim2.new(1, -152, 0, 10), Size = UDim2.fromOffset(124, 44),
    AutoButtonColor = false, ClipsDescendants = true,
}, footer)
round(discord, 7)
local discordOutline = stroke(discord, discordBlue, 0.22)
make("UIGradient", {
    Color = ColorSequence.new(Color3.fromRGB(155, 188, 255), Color3.fromRGB(91, 116, 213)),
    Rotation = 90,
}, discord)
-- Compact pixel Discord mark: native shapes keep the icon sharp without an asset download.
local discordMark = make("Frame", {
    Name = "DiscordIcon", BackgroundTransparency = 1, BorderSizePixel = 0,
    Position = UDim2.fromOffset(12, 14), Size = UDim2.fromOffset(22, 16), ZIndex = 3,
    Active = false,
}, discord)
local discordPixels = {
    "   ###        ###   ",
    "  ################  ",
    " ################## ",
    " ################## ",
    "####################",
    "####################",
    "#####  ######  #####",
    "####    ####    ####",
    "####    ####    ####",
    "#####  ######  #####",
    "####################",
    " ################## ",
    "  #####      #####  ",
    "   ###        ###   ",
}
for y, row in ipairs(discordPixels) do
    local x = 1
    while x <= #row do
        if row:sub(x,x) == "#" then
            local first = x
            repeat x = x + 1 until x > #row or row:sub(x,x) ~= "#"
            make("Frame", {
                BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(234, 242, 255),
                Position = UDim2.fromOffset(first, y), Size = UDim2.fromOffset(x-first, 1),
                Active = false, ZIndex = 3,
            }, discordMark)
        else x = x + 1 end
    end
end
local discordCaption = text(discord, "Discord", 14, UDim2.fromOffset(42, 0), UDim2.new(1, -48, 1, 0), Color3.fromRGB(235, 243, 255), true)
discordCaption.ZIndex = 3
local discordShine = make("Frame", {
    Name = "GlassShine", Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0,
    BackgroundTransparency = 0.62, ZIndex = 2, Active = false,
}, discord)
round(discordShine, 7)
local shineGradient = make("UIGradient", {
    Rotation = 20, Offset = Vector2.new(-1.4, 0),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.38, 1),
        NumberSequenceKeypoint.new(0.5, 0.25),
        NumberSequenceKeypoint.new(0.62, 1),
        NumberSequenceKeypoint.new(1, 1),
    }),
}, discordShine)
-- One repeating native tween, cancelled by the existing window cleanup.
local shineTween = TweenService:Create(shineGradient,
    TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, false, 2.6),
    {Offset = Vector2.new(1.4, 0)})
tweens[shineGradient] = shineTween
shineTween:Play()
bind(discord.MouseEnter, function()
    animate(discord, 0.14, {BackgroundTransparency = 0})
    animate(discordOutline, 0.14, {Transparency = 0})
end)
bind(discord.MouseLeave, function()
    animate(discord, 0.14, {BackgroundTransparency = 0.08})
    animate(discordOutline, 0.14, {Transparency = 0.22})
end)

function controller:SetStatus(message, kind)
    if destroyed then return end
    local color = kind == "error" and colors.error or colors.muted
    statusLabel.Text = message
    statusLabel.TextColor3 = color
    statusDot.BackgroundColor3 = color

    animate(inputEdge,0.14,{Color=kind=="error" and colors.error or colors.muted,Transparency=kind=="error" and 0.25 or 0.52})
    -- Feedback always occupies the same row; text never resizes the window.

end
function controller:Resize()
    if destroyed then return end
    local dimensions = viewport.AbsoluteSize
    if dimensions.X <= 0 or dimensions.Y <= 0 then return end
    -- Mobile devices can report keyboard support even without a physical one.
    local mobile = UserInputService.TouchEnabled
    local naturalHeight = 380
    local availableWidth = math.max(1, dimensions.X - 32)
    local availableHeight = math.max(1, dimensions.Y - 32)
    local targetWidth = 500
    if mobile then
        targetWidth = dimensions.X < dimensions.Y and 480 or 500
        availableWidth = math.min(availableWidth, dimensions.X * (dimensions.X < dimensions.Y and 0.94 or 0.82))
        availableHeight = math.min(availableHeight, dimensions.Y * 0.84)
    end
    local inheritedScale = scaleProbe.AbsoluteSize.X / 100
    if inheritedScale <= 0 then inheritedScale = 1 end
    -- Fit the entire form on both axes. No shortened body and no scrolling.
    local fittedScale = math.min(targetWidth / 552, availableWidth / 552, availableHeight / naturalHeight)
    panel.Size = UDim2.fromOffset(552, naturalHeight)
    scaling.Scale = fittedScale / inheritedScale
    self:ClampPosition()
end
-- The header moves the complete window with mouse or a single touch.
-- Normalized positions account for inherited scaling and keep the close button reachable.
function controller:ClampPosition()
    if destroyed then return end
    local dimensions = viewport.AbsoluteSize
    if dimensions.X <= 0 or dimensions.Y <= 0 then return end
    local inheritedScale = math.max(0.001, scaleProbe.AbsoluteSize.X / 100)
    local width = panel.Size.X.Offset * scaling.Scale * inheritedScale
    local height = panel.Size.Y.Offset * scaling.Scale * inheritedScale
    local x = panel.Position.X.Scale * dimensions.X + panel.Position.X.Offset * inheritedScale
    local y = panel.Position.Y.Scale * dimensions.Y + panel.Position.Y.Offset * inheritedScale
    local lowX, highX = width / 2 + 12, dimensions.X - width / 2 - 12
    local lowY, highY = height / 2 + 12, dimensions.Y - height / 2 - 12
    x = lowX <= highX and math.max(lowX, math.min(highX, x)) or dimensions.X / 2
    y = lowY <= highY and math.max(lowY, math.min(highY, y)) or dimensions.Y / 2
    panel.Position = UDim2.fromScale(x / dimensions.X, y / dimensions.Y)
end
local dragHandle = make("TextButton", {
    Name = "DragHandle", BackgroundTransparency = 1, Text = "",
    Size = UDim2.new(1, -64, 1, 0), Active = true,
    AutoButtonColor = false, ZIndex = 3,
}, header)
close.ZIndex = 4
local drag = nil
bind(dragHandle.InputBegan, function(event)
    if closing or destroyed then return end
    local kind = event.UserInputType
    if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
    drag = {
        Input = event, Kind = kind, X = event.Position.X, Y = event.Position.Y,
        Position = panel.Position,
    }
end)
bind(UserInputService.InputChanged, function(event)
    if not drag or closing or destroyed then return end
    local movement = drag.Kind == Enum.UserInputType.Touch and event == drag.Input
        or drag.Kind == Enum.UserInputType.MouseButton1 and event.UserInputType == Enum.UserInputType.MouseMovement
    if not movement then return end
    local dimensions = viewport.AbsoluteSize
    if dimensions.X <= 0 or dimensions.Y <= 0 then return end
    panel.Position = UDim2.fromScale(
        drag.Position.X.Scale + (event.Position.X - drag.X) / dimensions.X,
        drag.Position.Y.Scale + (event.Position.Y - drag.Y) / dimensions.Y
    )
    controller:ClampPosition()
end)
bind(UserInputService.InputEnded, function(event)
    if drag and (event == drag.Input or event.UserInputType == drag.Kind) then drag = nil end
end)
function controller:Destroy()
    if destroyed then return end
    destroyed = true
    for _, connection in ipairs(connections) do connection:Disconnect() end
    for _, tween in pairs(tweens) do tween:Cancel() end
    gui:Destroy()
    if environment.__SerenityKeyWindowTest == self then environment.__SerenityKeyWindowTest = nil end
end
local function setVerifying(value)
    verifying = value
    verify.Text = value and "Checking key…" or "Verify key  →"
    verify.Active = not value
    input.TextEditable = not value
end
function controller:CompleteAuthentication()
    -- Called by the VampAuth-protected payload, never inferred from a loader return value.
    if destroyed or closing or not verifying or authenticated then return false end
    authenticated = true
    saveVerifiedKey(pendingKey)
    pendingKey = nil
    self:SetStatus("Key verified. Opening Serenity...", "info")
    task.spawn(function()
        local ok = pcall(function()
            local source = game:HttpGet(testUI)
            if destroyed then return end
            local run, compileError = loadstring(source, "Serenity authenticated UI test")
            if not run then error(compileError or "UI unavailable", 0) end
            run()
        end)
        if destroyed then return end
        if not ok then
            authenticated = false
            setVerifying(false)
            self:SetStatus("Key verified, but the UI could not load. Try again.", "error")
            return
        end
        closing = true
        input.Text = ""
        input:ReleaseFocus()
        animate(panel, 0.16, {GroupTransparency = 1})
        task.delay(0.18, function() self:Destroy() end)
    end)
    return true
end
-- Called only by the protected custom verifier while a submission is pending.
function controller:GetPendingKey()
    if destroyed or closing or not verifying or authenticated then return nil end
    return pendingKey
end
function controller:RejectAuthentication(reason)
    if destroyed or closing or not verifying or authenticated then return false end
    local code=tostring(reason or ""):upper()
    local message="Verification failed. Please try again."
    if code=="KEY_NOT_FOUND" or code=="UNAUTHORIZED" or code=="INVALID_KEY" then
        message="Invalid key. Check it and try again."
        self:ForgetSavedKey()
    elseif code=="KEY_EXPIRED" or code=="EXPIRED" then
        message="This key has expired. Get a new key."
        self:ForgetSavedKey()
    elseif code=="KEY_BANNED" then
        message="This key has been revoked. Contact support."
        self:ForgetSavedKey()
    elseif code=="FINGERPRINT_MISMATCH" then
        message="This key is linked to another device. Contact support."
        self:ForgetSavedKey()
    elseif code=="RATE_LIMITED" then
        message="Too many attempts. Wait a minute and try again."
    elseif code=="REQUEST FAILED" or code=="NETWORK_ERROR" then
        message="Could not connect. Please try again."
    elseif code=="BAD_SIGNATURE" or code=="CONFIG_ERROR" then
        message="Key service configuration needs attention. Contact support."
    end
    pendingKey=nil
    setVerifying(false)
    self:SetStatus(message,"error")
    return true
end
local function submit()
    if destroyed or closing or verifying or authenticated then return end
    local key = input.Text:match("^%s*(.-)%s*$") or ""
    if key == "" then
        controller:SetStatus("Enter a key first.", "error")
        input:CaptureFocus()
        return
    end
    attempt = attempt + 1
    local currentAttempt = attempt
    pendingKey = key
    setVerifying(true)
    controller:SetStatus("Checking your key...", "info")
    task.spawn(function()
        local previousKey = environment.script_key
        environment.script_key = key
        local ok, failure = pcall(function()
            local source = game:HttpGet(authLoader)
            local run, compileError = loadstring(source, "Serenity VampAuth test")
            if not run then error(compileError or "Loader unavailable", 0) end
            run()
        end)
        -- Restore the caller's key; only the success callback saves verified keys.
        environment.script_key = previousKey
        key = nil
        if destroyed or authenticated or not verifying or currentAttempt ~= attempt then return end
        pendingKey = nil
        setVerifying(false)
        local message = "Verification did not finish. Check your key and try again."
        if not ok then
            local detail = tostring(failure):lower()
            if detail:find("invalid_key", 1, true) or detail:find("expired", 1, true)
                or detail:find("key_required", 1, true) or detail:find("hwid", 1, true) then
                controller:ForgetSavedKey()
                input.Text = ""
            end
            if detail:find("invalid_key", 1, true) or detail:find("key_required", 1, true) then
                message = "Invalid key. Use a key from this Serenity VampAuth project."
            elseif detail:find("expired", 1, true) then
                message = "Your key has expired. Get a new key."
            elseif detail:find("hwid", 1, true) then
                message = "Key device mismatch. Contact support."
            elseif detail:find("http", 1, true) or detail:find("connect", 1, true) then
                message = "Connection failed. Please try again."
            end
        end
        controller:SetStatus(message, "error")
    end)
end
bind(verify.Activated, submit)
bind(input.FocusLost, function(enterPressed) if enterPressed then submit() end end)
bind(input.Focused, function() animate(inputEdge, 0.12, {Color = colors.cyan, Transparency = 0.12}) end)
bind(input.FocusLost, function() animate(inputEdge, 0.12, {Color = colors.muted, Transparency = 0.52}) end)
local function focusForManualPaste(message)
    controller:SetStatus(message, "info")
    input:CaptureFocus()
    input.CursorPosition = #input.Text + 1
end
bind(paste.Activated, function()
    if destroyed or closing or verifying then return end
    local candidates = {
        environment.getclipboard, getclipboard,
        environment.readclipboard, readclipboard,
        environment.get_clipboard, get_clipboard,
    }
    -- pairs also visits candidates after nil entries.
    for _, readClipboard in pairs(candidates) do
        if type(readClipboard) == "function" then
            local ok, value = pcall(readClipboard)
            if ok and type(value) == "string" then
                value = value:gsub("[\r\n]", ""):match("^%s*(.-)%s*$"):sub(1, 512)
                if value ~= "" then
                    input.Text = value
                    controller:SetStatus("Key pasted.", "info")
                    input:CaptureFocus()
                    input.CursorPosition = #input.Text + 1
                    return
                end
            end
        end
    end
    local hint = UserInputService.TouchEnabled and "Hold the key field and choose Paste." or "Press Ctrl+V in the key field to paste."
    focusForManualPaste(hint)
end)
local providers = make("CanvasGroup", {
    Name = "Providers", BackgroundTransparency = 1, BorderSizePixel = 0,
    GroupTransparency = 1, GroupColor3 = Color3.fromRGB(255, 255, 255),
    Position = UDim2.fromOffset(0, 56), Size = UDim2.new(1, 0, 1, -120),
    Visible = false, ClipsDescendants = false,
}, panel)
local back = make("TextButton", {
    Name = "Back", BackgroundColor3 = colors.glass, BackgroundTransparency = 0.35,
    Position = UDim2.fromOffset(28, 10), Size = UDim2.fromOffset(38, 38),
    Text = "←", TextSize = 24, Font = Enum.Font.Gotham,
    TextColor3 = colors.text, AutoButtonColor = false, BorderSizePixel = 0,
}, providers)
round(back, 8)
stroke(back, colors.muted, 0.7)
text(providers, "Get your key", 24, UDim2.fromOffset(80, 10), UDim2.new(1, -108, 0, 32), colors.text, true)
text(providers, "Choose a service to continue.", 15, UDim2.fromOffset(80, 43), UDim2.new(1, -108, 0, 24), colors.muted)
local providerFeedback = text(providers, "", 12, UDim2.fromOffset(28, 240), UDim2.new(1, -56, 0, 18), colors.muted)
local providerLinks = {}
function controller:SetProviderLinks(links)
    if type(links) ~= "table" then return end
    for _, name in ipairs({"Linkvertise", "LootLabs", "Work.ink"}) do
        local url = links[name]
        providerLinks[name] = type(url) == "string" and url:match("^https://") and url or nil
    end
end
-- All reward providers use the same project flow.
local rewardFlow = "https://vampauth.com/4976E1392B744E1B/flow"
controller:SetProviderLinks({
    Linkvertise = rewardFlow,
    LootLabs = rewardFlow,
    ["Work.ink"] = rewardFlow,
})
-- Small uploaded PNGs are embedded: no Roblox asset IDs or image downloads.
local providerPng = {
    ["Linkvertise"] = "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",
    ["LootLabs"] = "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",
    ["Work.ink"] = "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",
}
local function decodePng(encoded)
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local lookup, chunks = {}, {}
    for i = 1, #alphabet do lookup[alphabet:sub(i, i)] = i - 1 end
    for i = 1, #encoded, 4 do
        local a, b, c, d = encoded:sub(i, i), encoded:sub(i + 1, i + 1), encoded:sub(i + 2, i + 2), encoded:sub(i + 3, i + 3)
        local value = lookup[a] * 262144 + lookup[b] * 4096 + (lookup[c] or 0) * 64 + (lookup[d] or 0)
        chunks[#chunks + 1] = string.char(math.floor(value / 65536) % 256)
        if c ~= "=" then chunks[#chunks + 1] = string.char(math.floor(value / 256) % 256) end
        if d ~= "=" then chunks[#chunks + 1] = string.char(value % 256) end
    end
    return table.concat(chunks)
end
controller.IconStatus = {}
local function localProviderIcon(name)
    local custom = environment.getcustomasset or getcustomasset or environment.getsynasset or getsynasset
    local write = environment.writefile or writefile
    local exists = environment.isfile or isfile
    if type(custom) ~= "function" or type(write) ~= "function" then
        controller.IconStatus[name] = "Local image support unavailable"
        return nil
    end
    local filename = "Serenity_KeyIcon_v1_" .. name:gsub("[^%w]", "") .. ".png"
    local ok, uri = pcall(function()
        if type(exists) ~= "function" or not exists(filename) then write(filename, decodePng(providerPng[name])) end
        return custom(filename)
    end)
    if ok and type(uri) == "string" and uri ~= "" then
        controller.IconStatus[name] = "Loading"
        return uri
    end
    controller.IconStatus[name] = "Local image registration failed"
    return nil
end

for index, name in ipairs({"Linkvertise", "LootLabs", "Work.ink"}) do
    local option = make("TextButton", {
        Name = name, BackgroundColor3 = colors.glass, BackgroundTransparency = 0.2,
        Position = UDim2.fromOffset(28, 82 + (index - 1) * 54),
        Size = UDim2.new(1, -56, 0, 48), BorderSizePixel = 0,
        Text = "", AutoButtonColor = false,
    }, providers)
    round(option, 9)
    stroke(option, index == 1 and colors.cyan or colors.muted, index == 1 and 0.25 or 0.6)
    if index == 1 then
        local accent = make("Frame", {
            BackgroundColor3 = colors.cyan, BorderSizePixel = 0,
            Position = UDim2.fromOffset(0, 12), Size = UDim2.fromOffset(3, 24),
        }, option)
        round(accent, 2)
        local recommendation = make("TextLabel", {
            Name = "RecommendedBadge", Text = "★  Recommended", TextSize = 11,
            Font = Enum.Font.GothamBold, TextColor3 = colors.cyan,
            BackgroundColor3 = colors.cyan, BackgroundTransparency = 0.88,
            BorderSizePixel = 0, Position = UDim2.new(1, -172, 0, 12),
            Size = UDim2.fromOffset(124, 24),
        }, option)
        round(recommendation, 6)
        stroke(recommendation, colors.cyan, 0.7)
    end
    local mark = make("TextLabel", {
        BackgroundColor3 = colors.cyan, BackgroundTransparency = 0.84,
        Position = UDim2.fromOffset(12, 10), Size = UDim2.fromOffset(28, 28),
        Text = name:sub(1, 1), Font = Enum.Font.GothamBold, TextSize = 14,
        TextColor3 = colors.cyan, BorderSizePixel = 0,
    }, option)
    round(mark, 7)
    local iconUri = localProviderIcon(name)
    if iconUri then
        local logo = make("ImageLabel", {
            Name = "ProviderLogo", BackgroundTransparency = 1,
            Image = iconUri, ImageColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromOffset(12, 8), Size = UDim2.fromOffset(32, 32),
            ScaleType = Enum.ScaleType.Fit, Visible = true, ZIndex = mark.ZIndex + 1,
        }, option)
        local function updateLogo()
            if destroyed then return end
            -- Keep the image renderable while loading; the badge stays underneath.
            mark.Visible = not logo.IsLoaded
            if logo.IsLoaded then
                controller.IconStatus[name] = "Loaded"
                if providerFeedback.Text == "Icons unavailable on this device; using letter badges." then
                    local failed = false
                    for _, state in pairs(controller.IconStatus) do
                        if state == "Local image support unavailable" or state == "Local image registration failed" then failed = true end
                    end
                    if not failed then providerFeedback.Text = "" end
                end
            end
        end
        bind(logo:GetPropertyChangedSignal("IsLoaded"), updateLogo)
        updateLogo()
        task.spawn(function()
            pcall(function() game:GetService("ContentProvider"):PreloadAsync({logo}) end)
            if destroyed then return end
            updateLogo()
            if not logo.IsLoaded then controller.IconStatus[name] = "Image could not load" end
        end)
    end
    text(option, name, 17, UDim2.fromOffset(54, 0), UDim2.new(1, -102, 1, 0), colors.text, true)
    text(option, "→", 22, UDim2.new(1, -40, 0, 0), UDim2.fromOffset(28, 48), colors.muted)
    bind(option.MouseEnter, function() animate(option, 0.12, {BackgroundTransparency = 0}) end)
    bind(option.MouseLeave, function() animate(option, 0.12, {BackgroundTransparency = 0.2}) end)
    bind(option.Activated, function()
        if destroyed or closing then return end
        local url = providerLinks[name]
        if not url then
            providerFeedback.Text = name .. " link is not configured yet."
            return
        end
        local copy = environment.setclipboard or setclipboard or toclipboard
        local ok = type(copy) == "function" and pcall(copy, url)
        providerFeedback.Text = ok and ("Link copied. Open it in your browser.") or "Clipboard unavailable on this device."
    end)
end
local showingProviders, switching = false, false
local function switchView(show)
    if destroyed or closing or switching or showingProviders == show then return end
    switching = true
    showingProviders = show
    input:ReleaseFocus()
    local incoming = show and providers or body
    local outgoing = show and body or providers
    local direction = show and 1 or -1
    incoming.Position = UDim2.fromOffset(22 * direction, 56)
    incoming.GroupTransparency = 1
    incoming.Visible = true
    animate(outgoing, 0.16, {GroupTransparency = 1, Position = UDim2.fromOffset(-22 * direction, 56)})
    animate(incoming, 0.20, {GroupTransparency = 0, Position = UDim2.fromOffset(0, 56)})
    task.delay(0.21, function()
        if destroyed then return end
        outgoing.Visible = false
        switching = false
    end)
end
bind(getKey.Activated, function()
    providerFeedback.Text = ""
    for _, state in pairs(controller.IconStatus) do
        if state == "Local image support unavailable" or state == "Local image registration failed" then
            providerFeedback.Text = "Icons unavailable on this device; using letter badges."
            break
        end
    end
    switchView(true)
end)
bind(back.Activated, function() switchView(false) end)
-- Modal stays inside the fitted window, so every action remains visible on mobile.
local discordInvite = "https://discord.gg/pWPs7428wE"
local discordModal = make("CanvasGroup", {
    Name = "DiscordPopup", BackgroundTransparency = 1, GroupColor3 = Color3.fromRGB(255, 255, 255),
    GroupTransparency = 1, Visible = false, Size = UDim2.fromScale(1, 1), ZIndex = 20,
}, panel)
local dismiss = make("TextButton", {
    Name = "DiscordBackdrop", Text = "", AutoButtonColor = false,
    BackgroundColor3 = colors.navy, BackgroundTransparency = 0.35,
    Size = UDim2.fromScale(1, 1), ZIndex = 1,
}, discordModal)
local card = make("Frame", {
    Name = "DiscordCard", AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(452, 264),
    BackgroundColor3 = Color3.fromRGB(23, 33, 54), BorderSizePixel = 0, ZIndex = 2,
}, discordModal)
round(card, 7)
local discordCardEdge = stroke(card, discordBlue, 0.22)
local discordTile = make("Frame", {
    Name = "DiscordBadge", Position = UDim2.fromOffset(24, 21),
    Size = UDim2.fromOffset(40, 40), BackgroundColor3 = Color3.fromRGB(51, 79, 150),
    BorderSizePixel = 0, Active = false,
}, card)
round(discordTile, 8)
stroke(discordTile, discordBlue, 0.3)
local popupMark = discordMark:Clone()
popupMark.Position = UDim2.fromOffset(9, 12)
popupMark.Parent = discordTile
local popupShine = make("Frame", {
    Name = "DiscordHeaderShine", BackgroundColor3 = Color3.fromRGB(145, 180, 255),
    BackgroundTransparency = 0.86, Size = UDim2.new(1, 0, 0, 106),
    BorderSizePixel = 0, Active = false, ZIndex = 0,
}, card)
round(popupShine, 7)
local popupShineGradient = make("UIGradient", {
    Offset = Vector2.new(-1.4, 0), Rotation = 15,
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.35, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.65, 1),
        NumberSequenceKeypoint.new(1, 1),
    }),
}, popupShine)
local community = text(card, "SERENITY HUB DISCORD", 13, UDim2.fromOffset(76, 19), UDim2.fromOffset(320, 22), Color3.fromRGB(164, 191, 255), true)
text(card, "Community & support", 21, UDim2.fromOffset(76, 41), UDim2.fromOffset(350, 32), Color3.fromRGB(237, 243, 255), true)
text(card, "Help with keys, updates and premium.", 14, UDim2.fromOffset(24, 80), UDim2.fromOffset(400, 24), colors.muted)
local popupClose = make("TextButton", {
    Name = "DiscordClose", Text = "×", TextSize = 24, TextColor3 = colors.muted,
    Font = Enum.Font.Gotham, BackgroundTransparency = 1, AutoButtonColor = false,
    Position = UDim2.new(1, -48, 0, 8), Size = UDim2.fromOffset(40, 40),
}, card)
local inviteField = make("TextBox", {
    Name = "DiscordInvite", Text = discordInvite, TextEditable = false, ClearTextOnFocus = false,
    TextColor3 = colors.text, TextSize = 16, Font = Enum.Font.Gotham,
    BackgroundColor3 = Color3.fromRGB(17, 26, 43), BackgroundTransparency = 0,
    Position = UDim2.fromOffset(24, 116), Size = UDim2.fromOffset(404, 44),
}, card)
round(inviteField, 8)
stroke(inviteField, discordBlue, 0.55)
local copyInvite = make("TextButton", {
    Name = "CopyDiscordInvite", Text = "Copy link", TextSize = 15,
    Font = Enum.Font.GothamMedium, TextColor3 = colors.text,
    BackgroundColor3 = Color3.fromRGB(48, 76, 145), BorderSizePixel = 0, AutoButtonColor = false,
    Position = UDim2.fromOffset(24, 174), Size = UDim2.fromOffset(404, 44),
}, card)
round(copyInvite, 5)
local copyInviteEdge = stroke(copyInvite, discordBlue, 0.2)
local inviteFeedback = text(card, "Copy the link and open Discord in your browser.", 14,
    UDim2.fromOffset(24, 228), UDim2.fromOffset(404, 22), colors.muted)
inviteFeedback.Name = "DiscordFeedback"
inviteFeedback.TextColor3 = Color3.fromRGB(183, 200, 232)
local popupOpen, popupGeneration = false, 0
local function setDiscordPopup(open)
    if destroyed or closing or popupOpen == open then return end
    popupOpen = open
    popupGeneration = popupGeneration + 1
    local generation = popupGeneration
    input:ReleaseFocus()
    inviteField:ReleaseFocus()
    if open then
        copyInvite.Text = "Copy link"
        copyInviteEdge.Transparency = 0.2
        popupShineGradient.Offset = Vector2.new(-1.4, 0)
        animate(popupShineGradient, 0.7, {Offset = Vector2.new(1.4, 0)})
        inviteFeedback.Text = "Copy the link and open Discord in your browser."
        discordModal.Visible = true
        discordModal.GroupTransparency = 1
        card.Position = UDim2.new(0.5, 0, 0.5, 18)
        animate(discordModal, 0.20, {GroupTransparency = 0})
        animate(card, 0.24, {Position = UDim2.fromScale(0.5, 0.5)})
    else
        animate(discordModal, 0.16, {GroupTransparency = 1})
        animate(card, 0.16, {Position = UDim2.new(0.5, 0, 0.5, 12)})
        task.delay(0.17, function()
            if not destroyed and popupGeneration == generation and not popupOpen then discordModal.Visible = false end
        end)
    end
end
bind(discord.Activated, function() setDiscordPopup(true) end)
bind(popupClose.Activated, function() setDiscordPopup(false) end)
bind(dismiss.Activated, function() setDiscordPopup(false) end)
bind(copyInvite.MouseEnter, function() animate(copyInvite, 0.12, {BackgroundTransparency = 0.18}) end)
bind(copyInvite.MouseLeave, function() animate(copyInvite, 0.12, {BackgroundTransparency = 0}) end)
bind(copyInvite.Activated, function()
    if destroyed or closing or not popupOpen then return end
    local copy = environment.setclipboard or setclipboard or toclipboard
    local ok = type(copy) == "function" and pcall(copy, discordInvite)
    copyInvite.Text = ok and "Copied" or "Select link"
    inviteFeedback.Text = ok and "Link copied to clipboard." or "Select the link above to copy it manually."
    if not ok then inviteField:CaptureFocus() end
    animate(copyInvite, 0.12, {BackgroundTransparency = 0})
    if ok then
        copyInviteEdge.Transparency = 0
        animate(copyInviteEdge, 0.8, {Transparency = 0.2})
    end
    task.delay(1.8, function()
        if not destroyed and popupOpen then copyInvite.Text = "Copy link" end
    end)
end)
-- Shared pointer/touch feedback, using native tweens only while interacting.
local function addButtonFeedback(object)
    if not object:IsA("TextButton") then return end
    local baseColor = object.BackgroundColor3
    local baseText = object.TextColor3
    local pressColor = baseColor:Lerp(buttonAccents[object] or ((object == discord or object == copyInvite or object == popupClose) and discordBlue or colors.cyan), 0.22)
    local hovered, held = false, false
    local function release()
        if not held then return end
        held = false
        animate(object, 0.12, {BackgroundColor3 = hovered and baseColor:Lerp(colors.ivory, 0.07) or baseColor, TextColor3 = baseText})
    end
    bind(object.MouseEnter, function()
        hovered = true
        if not held then animate(object, 0.10, {BackgroundColor3 = baseColor:Lerp(colors.ivory, 0.07)}) end
    end)
    bind(object.MouseLeave, function()
        hovered = false
        release()
        animate(object, 0.12, {BackgroundColor3 = baseColor, TextColor3 = baseText})
    end)
    bind(object.InputBegan, function(event)
        if event.UserInputType ~= Enum.UserInputType.MouseButton1 and event.UserInputType ~= Enum.UserInputType.Touch then return end
        if destroyed or closing or not object.Active then return end
        held = true
        animate(object, 0.06, {BackgroundColor3 = pressColor, TextColor3 = baseText:Lerp(colors.ivory, 0.18)})
    end)
    bind(object.InputEnded, function(event)
        if event.UserInputType == Enum.UserInputType.MouseButton1 or event.UserInputType == Enum.UserInputType.Touch then release() end
    end)
    bind(UserInputService.InputEnded, function(event)
        if held and (event.UserInputType == Enum.UserInputType.MouseButton1 or event.UserInputType == Enum.UserInputType.Touch) then release() end
    end)
end
for _, object in ipairs(gui:GetDescendants()) do addButtonFeedback(object) end

bind(close.Activated, function()
    if closing then return end
    closing = true
    input:ReleaseFocus()
    animate(panel, 0.16, {GroupTransparency = 1})
    task.delay(0.18, function() controller:Destroy() end)
end)
bind(viewport:GetPropertyChangedSignal("AbsoluteSize"), function() controller:Resize() end)
bind(scaleProbe:GetPropertyChangedSignal("AbsoluteSize"), function() controller:Resize() end)
controller.Gui = gui
controller.Input = input
controller.IsPreview = false
controller.AuthenticationConnected = true
controller.AutoSaveAvailable = type(writeKeyFile) == "function"
controller.VampAuthLoader = "https://vampauth.com/v1/loaders/59abff27e57ded3ff8ff7ff854b9834f.lua"
environment.__SerenityKeyWindowTest = controller
controller:Resize()
animate(panel, 0.22, {GroupTransparency = 0})
local savedKey = readSavedKey()
if savedKey then
    input.Text = savedKey
    task.defer(submit)
end
return controller

