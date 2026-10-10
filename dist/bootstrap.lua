-- Serenity key-window UI test. Authentication is intentionally not connected.
-- This file contains the entire window; it does not load the dashboard or games.
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
local colors = {
    navy = Color3.fromRGB(13, 28, 49),
    glass = Color3.fromRGB(26, 47, 76),
    text = Color3.fromRGB(238, 244, 252),
    muted = Color3.fromRGB(167, 188, 219),
    cyan = Color3.fromRGB(48, 202, 244),
    lavender = Color3.fromRGB(159, 137, 223),
    ivory = Color3.fromRGB(249, 233, 198),
    error = Color3.fromRGB(255, 149, 157),
}
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
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
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
    Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(552, 468),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1,
    GroupColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0, GroupTransparency = 1, ClipsDescendants = true,
}, viewport)
round(panel, 18)
local edge = stroke(panel, Color3.fromRGB(255, 255, 255), 0.08, 1.5)
make("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(134, 188, 245)),
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
round(background, 18)
make("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(27, 50, 83)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(17, 34, 59)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(21, 35, 65)),
    }), Rotation = 35,
}, background)
local scaling = make("UIScale", {Scale = 1}, panel)
local header = make("Frame", {
    Name = "Header", BackgroundColor3 = colors.glass,
    BackgroundTransparency = 0.68, BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 64),
}, panel)
make("Frame", {
    BackgroundColor3 = colors.muted, BackgroundTransparency = 0.85,
    BorderSizePixel = 0, Position = UDim2.new(0, 0, 1, -1),
    Size = UDim2.new(1, 0, 0, 1),
}, header)
-- The compass uses native GUI shapes; no external image asset is required.
local emblem = make("Frame", {
    BackgroundTransparency = 1, Position = UDim2.fromOffset(24, 16),
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
text(header, "SERENITY", 20, UDim2.fromOffset(69, 0), UDim2.fromOffset(220, 64), colors.text, true)
local close = make("TextButton", {
    Name = "Close", BackgroundTransparency = 1, Text = "×",
    TextColor3 = colors.muted, TextSize = 30, Font = Enum.Font.Gotham,
    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 10),
    Size = UDim2.fromOffset(44, 44), AutoButtonColor = false,
}, header)

local body = make("ScrollingFrame", {
    Name = "Body", BackgroundTransparency = 1, BorderSizePixel = 0,
    Position = UDim2.fromOffset(0, 64), Size = UDim2.new(1, 0, 1, -114),
    CanvasSize = UDim2.fromOffset(0, 354), ScrollBarThickness = 3,
    ScrollBarImageColor3 = colors.cyan, ScrollingDirection = Enum.ScrollingDirection.Y,
    ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
}, panel)
local title = text(body, "Welcome to Serenity", 28, UDim2.fromOffset(24, 18), UDim2.new(1, -48, 0, 36), colors.text, true)
title.TextXAlignment = Enum.TextXAlignment.Center
local subtitle = text(body, "Enter your key to continue.", 16, UDim2.fromOffset(24, 57), UDim2.new(1, -48, 0, 24), colors.muted)
subtitle.TextXAlignment = Enum.TextXAlignment.Center
text(body, "License key", 16, UDim2.fromOffset(28, 100), UDim2.new(1, -56, 0, 22), colors.text, true)
local inputShell = make("Frame", {
    BackgroundColor3 = colors.glass, BackgroundTransparency = 0.28,
    Position = UDim2.fromOffset(28, 130), Size = UDim2.new(1, -56, 0, 48),
    BorderSizePixel = 0,
}, body)
round(inputShell, 9)
local inputEdge = stroke(inputShell, colors.muted, 0.52)
local input = make("TextBox", {
    Name = "LicenseKey", BackgroundTransparency = 1,
    Position = UDim2.fromOffset(15, 0), Size = UDim2.new(1, -64, 1, 0),
    Text = "", PlaceholderText = "Paste your key here",
    TextColor3 = colors.text, PlaceholderColor3 = colors.muted,
    Font = Enum.Font.Gotham, TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false, MultiLine = false,
}, inputShell)
local paste = make("TextButton", {
    Name = "Paste", BackgroundTransparency = 1, Text = "",
    Position = UDim2.new(1, -47, 0, 2), Size = UDim2.fromOffset(44, 44),
    AutoButtonColor = false,
}, inputShell)
for _, offset in ipairs({{17, 11}, {13, 15}}) do
    local sheet = make("Frame", {
        BackgroundColor3 = colors.glass, BorderSizePixel = 0,
        Position = UDim2.fromOffset(offset[1], offset[2]), Size = UDim2.fromOffset(13, 17),
        Active = false,
    }, paste)
    round(sheet, 2)
    stroke(sheet, colors.muted, 0.1, 1.2)
end
local function button(name, caption, y, primary)
    local object = make("TextButton", {
        Name = name, BackgroundColor3 = primary and Color3.fromRGB(255, 255, 255) or colors.navy,
        BackgroundTransparency = primary and 0 or 0.3, BorderSizePixel = 0,
        Position = UDim2.fromOffset(28, y), Size = UDim2.new(1, -56, 0, 48),
        Text = caption, TextColor3 = primary and colors.navy or colors.text,
        Font = Enum.Font.GothamBold, TextSize = 18, AutoButtonColor = false,
    }, body)
    round(object, 9)
    stroke(object, primary and colors.cyan or colors.lavender, primary and 0.15 or 0.3)
    if primary then
        make("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(62, 216, 243), colors.cyan), Rotation = 90}, object)
    end
    bind(object.MouseEnter, function() animate(object, 0.12, {BackgroundTransparency = primary and 0.08 or 0.08}) end)
    bind(object.MouseLeave, function() animate(object, 0.12, {BackgroundTransparency = primary and 0 or 0.3}) end)
    return object
end
local verify = button("Verify", "Verify key  →", 194, true)
local getKey = button("GetKey", "Get a key", 252, false)
local rememberButton = make("TextButton", {
    Name = "RememberKey", BackgroundTransparency = 1, Text = "",
    Position = UDim2.fromOffset(25, 311), Size = UDim2.fromOffset(234, 40),
    AutoButtonColor = false,
}, body)
local check = make("TextLabel", {
    BackgroundColor3 = colors.glass, BackgroundTransparency = 0.1,
    Position = UDim2.fromOffset(3, 8), Size = UDim2.fromOffset(24, 24),
    Text = "", TextColor3 = colors.navy, Font = Enum.Font.GothamBold,
    TextSize = 18, BorderSizePixel = 0,
}, rememberButton)
round(check, 5)
local checkEdge = stroke(check, colors.muted, 0.55)
text(rememberButton, "Remember my key", 14, UDim2.fromOffset(39, 0), UDim2.new(1, -39, 1, 0))
local remembered = false
local statusDot = make("Frame", {
    BackgroundColor3 = colors.muted, BorderSizePixel = 0,
    Position = UDim2.fromOffset(288, 326), Size = UDim2.fromOffset(7, 7),
}, body)
round(statusDot, 7)
local statusLabel = text(body, "Ready to verify", 13, UDim2.fromOffset(304, 314), UDim2.new(1, -332, 0, 32), colors.muted)
statusLabel.TextWrapped = true

local footer = make("Frame", {
    Name = "Footer", BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 1, -50), Size = UDim2.new(1, 0, 0, 50),
}, panel)
make("Frame", {
    BackgroundColor3 = colors.muted, BackgroundTransparency = 0.85,
    Position = UDim2.fromOffset(24, 0), Size = UDim2.new(1, -48, 0, 1), BorderSizePixel = 0,
}, footer)
text(footer, "Need help?", 13, UDim2.fromOffset(28, 1), UDim2.fromOffset(80, 48), colors.muted)
local discord = make("TextButton", {
    Name = "Discord", BackgroundTransparency = 1, Text = "Join Discord",
    TextColor3 = colors.cyan, TextSize = 13, Font = Enum.Font.Gotham,
    Position = UDim2.fromOffset(106, 1), Size = UDim2.fromOffset(100, 48),
    TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false,
}, footer)

function controller:SetStatus(message, kind)
    if destroyed then return end
    local color = kind == "error" and colors.error or colors.muted
    statusLabel.Text = message
    statusLabel.TextColor3 = color
    statusDot.BackgroundColor3 = color
    -- Longer feedback gets a full-width row beneath the checkbox.
    local expanded = #message > 24
    statusLabel.Position = UDim2.fromOffset(expanded and 44 or 304, expanded and 356 or 314)
    statusLabel.Size = UDim2.new(1, expanded and -72 or -332, 0, expanded and 40 or 32)
    statusDot.Position = UDim2.fromOffset(expanded and 28 or 288, expanded and 371 or 326)
    body.CanvasSize = UDim2.fromOffset(0, expanded and 406 or 354)
    panel.Size = UDim2.fromOffset(552, expanded and 520 or 468)
    controller:Resize()
end
function controller:Resize()
    if destroyed then return end
    local dimensions = viewport.AbsoluteSize
    if dimensions.X <= 0 or dimensions.Y <= 0 then return end
    local mobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local naturalHeight = #statusLabel.Text > 24 and 520 or 468
    -- Always fit the complete layout: never shorten the body and hide controls.
    panel.Size = UDim2.fromOffset(552, naturalHeight)
    local availableWidth = math.max(1, dimensions.X - 32)
    local availableHeight = math.max(1, dimensions.Y - 32)
    if mobile then
        availableWidth = math.min(availableWidth, dimensions.X * 0.78)
        availableHeight = math.min(availableHeight, dimensions.Y * 0.80)
    end
    local inheritedScale = scaleProbe.AbsoluteSize.X / 100
    if inheritedScale <= 0 then inheritedScale = 1 end
    local fittedScale = math.min(460 / 552, availableWidth / 552, availableHeight / naturalHeight)
    scaling.Scale = fittedScale / inheritedScale
end
function controller:Destroy()
    if destroyed then return end
    destroyed = true
    for _, connection in ipairs(connections) do connection:Disconnect() end
    for _, tween in pairs(tweens) do tween:Cancel() end
    gui:Destroy()
    if environment.__SerenityKeyWindowTest == self then environment.__SerenityKeyWindowTest = nil end
end
local function submit()
    if destroyed or closing then return end
    local key = input.Text:match("^%s*(.-)%s*$") or ""
    if key == "" then
        controller:SetStatus("Enter a key first.", "error")
        input:CaptureFocus()
        return
    end
    -- No key is logged, saved, sent, or accepted by this visual-only build.
    controller:SetStatus("UI test only. Authentication is not connected yet.", "info")
    body.CanvasPosition = Vector2.new(0, 1000)
end
bind(verify.Activated, submit)
bind(input.FocusLost, function(enterPressed) if enterPressed then submit() end end)
bind(input.Focused, function() animate(inputEdge, 0.12, {Color = colors.cyan, Transparency = 0.12}) end)
bind(input.FocusLost, function() animate(inputEdge, 0.12, {Color = colors.muted, Transparency = 0.52}) end)
bind(rememberButton.Activated, function()
    if destroyed or closing then return end
    remembered = not remembered
    check.Text = remembered and "✓" or ""
    check.BackgroundColor3 = remembered and colors.cyan or colors.glass
    checkEdge.Color = remembered and colors.cyan or colors.muted
    controller:SetStatus(remembered and "Key saving will be enabled with authentication." or "Ready to verify", "info")
end)
bind(paste.Activated, function()
    local readClipboard = environment.getclipboard or getclipboard
    if type(readClipboard) ~= "function" then
        controller:SetStatus("Paste into the key field using your device keyboard.", "info")
        input:CaptureFocus()
        return
    end
    local ok, value = pcall(readClipboard)
    if ok and type(value) == "string" then
        input.Text = value:gsub("[\r\n]", ""):sub(1, 512)
        controller:SetStatus("Ready to verify", "info")
    else
        controller:SetStatus("Clipboard unavailable. Paste into the key field.", "error")
    end
end)
bind(getKey.Activated, function()
    controller:SetStatus("The get-key link has not been configured yet.", "info")
    body.CanvasPosition = Vector2.new(0, 1000)
end)
bind(discord.Activated, function()
    local copy = environment.setclipboard or setclipboard or toclipboard
    if type(copy) == "function" then
        local ok = pcall(copy, "https://discord.gg/pWPs7428wE")
        if ok then controller:SetStatus("Discord invite copied.", "info"); return end
    end
    controller:SetStatus("Discord: discord.gg/pWPs7428wE", "info")
    body.CanvasPosition = Vector2.new(0, 1000)
end)
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
controller.IsPreview = true
controller.FlowAuthLoader = "https://flowauth.net/v1/loaders/1648c904082188891affedeaf4cf550d.lua"
environment.__SerenityKeyWindowTest = controller
controller:Resize()
animate(panel, 0.22, {GroupTransparency = 0})
return controller
