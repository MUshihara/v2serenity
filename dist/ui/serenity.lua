-- Serenity M4 Compact: generated from modular test source. One download; UI only.
-- Popup isolation also applies to hover events, which Roblox can deliver behind a shield.
local function serenityInputBlocked(object)
    while object do
        if object:GetAttribute("SerenityPopupBlocked") then return true end
        object=object.Parent
    end
    return false
end
local modules = {}
modules["src/core/Runtime.lua"] = (function()
local Runtime = {}
Runtime.__index = Runtime

function Runtime.new(key)
    local self = setmetatable({}, Runtime)
    self.Key = key
    self.Connections = {}
    self.Instances = {}
    self.Cleanup = {}
    self.Destroyed = false
    return self
end

function Runtime:TrackConnection(connection)
    table.insert(self.Connections, connection)
    return connection
end

function Runtime:TrackInstance(instance)
    table.insert(self.Instances, instance)
    return instance
end

function Runtime:TrackCleanup(callback)
    table.insert(self.Cleanup, callback)
end

function Runtime:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true

    for _, callback in ipairs(self.Cleanup) do
        pcall(callback)
    end

    for _, connection in ipairs(self.Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    for _, instance in ipairs(self.Instances) do
        pcall(function()
            instance:Destroy()
        end)
    end
end

return Runtime

end)()
modules["src/core/Tokens.lua"] = (function()
local Tokens = {}

-- Serenity M3: compact 1.4:1 desktop canvas inspired by professional utility panels.
Tokens.Size = {
    Window = Vector2.new(798, 546),
    Topbar = 56,
    Sidebar = 200,
    SidebarBrand = 66,
    SidebarUser = 64,
    SidebarCollapsed = 62,
    Footer = 0,

    NavGroup = 24,
    NavRow = 36,
    NavIcon = 22,
    GameContext = 64,
    MetricPill = 26,
    SegmentTabs = 34,
    InfoBanner = 62,

    SectionLabel = 36,
    SectionHeader = 50,
    Control = 40,
    ControlWithDescription = 56,
    Button = 46,
    Slider = 55,
    Select = 54,
    Status = 46,

    RadiusShell = 14,
    RadiusPanel = 10,
    RadiusSection = 10,
    RadiusControl = 7,
    RadiusPopup = 9,
    RadiusNav = 7,
    RadiusTile = 7,
}

Tokens.Type = {
    Brand = 15,
    BrandSub = 9,
    TopSelect = 13,
    Page = 17,
    PageSub = 9,
    NavGroup = 9,
    Nav = 13,
    Section = 10,
    Control = 14,
    Description = 9,
    Value = 12,
    Status = 9,
    User = 12,
    UserSub = 9,
    Metric = 9,
    BannerTitle = 11,
    BannerBody = 9,
}

Tokens.Space = {
    XXS = 3,
    XS = 5,
    S = 7,
    M = 10,
    L = 14,
    XL = 18,
}

Tokens.Color = {
    Shell = Color3.fromRGB(16, 18, 25),
    ShellDeep = Color3.fromRGB(12, 14, 20),
    ShellSoft = Color3.fromRGB(17, 19, 27),
    Sidebar = Color3.fromRGB(18, 21, 29),
    Topbar = Color3.fromRGB(16, 18, 25),

    Panel = Color3.fromRGB(23, 26, 35),
    PanelSoft = Color3.fromRGB(32, 37, 50),
    Surface = Color3.fromRGB(14, 16, 26),
    SurfaceSoft = Color3.fromRGB(17, 20, 31),
    Control = Color3.fromRGB(17, 20, 31),
    ControlHover = Color3.fromRGB(23, 27, 40),
    RowHover = Color3.fromRGB(23, 27, 40),
    Inset = Color3.fromRGB(31, 35, 47),
    InsetHover = Color3.fromRGB(24, 28, 42),
    Popup = Color3.fromRGB(13, 15, 25),

    NavActive = Color3.fromRGB(33, 38, 51),
    NavHover = Color3.fromRGB(20, 22, 33),

    Text = Color3.fromRGB(228, 231, 240),
    TextMuted = Color3.fromRGB(171, 177, 191),
    TextDim = Color3.fromRGB(161, 173, 192),

    Divider = Color3.fromRGB(38, 41, 54),
    Stroke = Color3.fromRGB(49, 55, 70),
    StrokeBright = Color3.fromRGB(112, 121, 146),

    Accent = Color3.fromRGB(72, 130, 255),
    AccentBright = Color3.fromRGB(97, 151, 255),
    Blue = Color3.fromRGB(72, 130, 255),
    Cyan = Color3.fromRGB(73, 216, 239),
    Mint = Color3.fromRGB(82, 224, 177),
    Lavender = Color3.fromRGB(173, 126, 255),
    Pink = Color3.fromRGB(241, 79, 170),
    Amber = Color3.fromRGB(242, 185, 77),
    Red = Color3.fromRGB(239, 91, 116),
    Disabled = Color3.fromRGB(66, 70, 82),
}

Tokens.Material = {
    ShellTransparency = 0.04,
    SidebarTransparency = 0.06,
    TopbarTransparency = 0.08,
    PanelTransparency = 0.06,
    SectionTransparency = 0.12,
    ControlTransparency = 1,
    PopupTransparency = 0.04,
    ShadowTransparency = 0.46,
    EdgeTransparency = 0.78,
    HighlightTransparency = 0.92,
}

Tokens.Motion = {
    Hover = 0.10,
    Toggle = 0.13,
    Popup = 0.16,
    Page = 0.12,
    Collapse = 0.14,
    Nav = 0.11,
}

return Tokens

end)()
modules["src/core/Typography.lua"] = (function()
local Typography = {}

Typography.Font = {
    Regular = Enum.Font.Gotham,
    Medium = Enum.Font.GothamMedium,
    Semibold = Enum.Font.GothamMedium,
    Bold = Enum.Font.GothamBold,
}

local function specFor(role, tokens)
    local sizes = tokens.Type
    local map = {
        Brand = {sizes.Brand, Typography.Font.Bold},
        BrandSub = {sizes.BrandSub, Typography.Font.Medium},
        TopSelect = {sizes.TopSelect, Typography.Font.Medium},
        Page = {sizes.Page, Typography.Font.Bold},
        PageSub = {sizes.PageSub, Typography.Font.Regular},
        NavGroup = {sizes.NavGroup, Typography.Font.Semibold},
        Nav = {sizes.Nav, Typography.Font.Medium},
        Section = {sizes.Section, Typography.Font.Semibold},
        Control = {sizes.Control, Typography.Font.Semibold},
        Description = {sizes.Description, Typography.Font.Regular},
        Value = {sizes.Value, Typography.Font.Medium},
        Status = {sizes.Status, Typography.Font.Bold},
        User = {sizes.User, Typography.Font.Semibold},
        UserSub = {sizes.UserSub, Typography.Font.Medium},
        Metric = {sizes.Metric, Typography.Font.Medium},
        BannerTitle = {sizes.BannerTitle, Typography.Font.Semibold},
        BannerBody = {sizes.BannerBody, Typography.Font.Regular},
    }
    return map[role] or map.Control
end

function Typography.Apply(label, role, tokens, color)
    local spec = specFor(role, tokens)
    label.TextSize = spec[1] or 12
    label.Font = spec[2] or Typography.Font.Medium
    label.TextColor3 = color or tokens.Color.Text
    label.BackgroundTransparency = 1
    return label
end

function Typography.Label(parent, role, tokens, text, position, size, color)
    local label = Instance.new("TextLabel")
    label.Text = text or ""
    label.Position = position or UDim2.new()
    label.Size = size or UDim2.fromScale(1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Parent = parent
    Typography.Apply(label, role, tokens, color)
    return label
end

return Typography

end)()
modules["src/core/Motion.lua"] = (function()
local TweenService = game:GetService("TweenService")

local Motion = {
    Reduced = false,
    Durations = {
        Hover = 0.11,
        Toggle = 0.14,
        Select = 0.16,
        Popup = 0.18,
        Collapse = 0.18,
        Modal = 0.20,
    }
}

function Motion:Tween(instance, durationKey, props, style, direction)
    local duration = self.Reduced and 0 or (self.Durations[durationKey] or durationKey or 0.15)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

return Motion

end)()
modules["src/core/Material.lua"] = (function()
local Material = {}

local SHADOW_IMAGE = "rbxassetid://1316045217"

local function corner(parent, radius, name)
    local c = Instance.new("UICorner")
    c.Name = name or "Corner"
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function stroke(parent, color, transparency, thickness, name)
    local s = Instance.new("UIStroke")
    s.Name = name or "Stroke"
    s.Color = color
    s.Transparency = transparency
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

function Material.Shadow(parent, targetSize, radius, tokens)
    -- No external shadow layer: avoids the oversized black backing on desktop.
    return nil
end

function Material.Shell(frame, tokens)
    frame:SetAttribute("GlassRole", "Shell")
    frame.BackgroundColor3 = tokens.Color.Shell
    frame.BackgroundTransparency = tokens.Material.ShellTransparency
    frame.BorderSizePixel = 0
    corner(frame, tokens.Size.RadiusShell, "ShellCorner")
    stroke(frame, tokens.Color.Stroke, tokens.Material.EdgeTransparency, 1, "ShellEdge")

    local gradient = Instance.new("UIGradient")
    gradient.Name = "ShellTone"
    gradient.Rotation = 118
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 240, 255)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 231, 250)),
    })
    gradient.Parent = frame

    local topLine = Instance.new("Frame")
    topLine.Name = "TopGlassLine"
    topLine.BackgroundColor3 = Color3.fromRGB(186, 204, 238)
    topLine.BackgroundTransparency = 0.93
    topLine.BorderSizePixel = 0
    topLine.Position = UDim2.fromOffset(14, 0)
    topLine.Size = UDim2.new(1, -28, 0, 1)
    topLine.ZIndex = frame.ZIndex + 1
    topLine.Parent = frame
    return frame
end

function Material.Sidebar(frame, tokens)
    frame:SetAttribute("GlassRole", "Sidebar")
    frame.BackgroundColor3 = tokens.Color.Sidebar
    frame.BackgroundTransparency = tokens.Material.SidebarTransparency
    frame.BorderSizePixel = 0

    local divider = Instance.new("Frame")
    divider.Name = "SidebarDivider"
    divider.AnchorPoint = Vector2.new(1, 0)
    divider.Position = UDim2.new(1, 0, 0, 14)
    divider.Size = UDim2.new(0, 1, 1, -28)
    divider.BackgroundColor3 = tokens.Color.Divider
    divider.BackgroundTransparency = 0.34
    divider.BorderSizePixel = 0
    divider.Parent = frame
    return frame
end

-- Shared pointer and keyboard feedback for popup choices and filtered lists.
function Material.OptionHover(button, tokens, selected, motion)
    local pointer, focused = false, false
    local baseTransparency = button.BackgroundTransparency
    local function render()
        local active = pointer or focused
        local properties={BackgroundColor3=active and tokens.Color.InsetHover or (selected and tokens.Color.NavActive or tokens.Color.PanelSoft),BackgroundTransparency=active and 0 or baseTransparency}
        if button.Text ~= "" then properties.TextColor3=active and tokens.Color.Text or (selected and tokens.Color.Text or tokens.Color.TextMuted) end
        if motion then motion:Tween(button,"Hover",properties) else for key,value in pairs(properties) do button[key]=value end end
    end
    button.MouseEnter:Connect(function() if serenityInputBlocked(button) then return end; pointer=true;render() end)
    button.MouseLeave:Connect(function() pointer=false;render() end)
    button.SelectionGained:Connect(function() if serenityInputBlocked(button) then return end; focused=true;render() end)
    button.SelectionLost:Connect(function() focused=false;render() end)
end

function Material.Topbar(frame, tokens)
    frame:SetAttribute("GlassRole", "Topbar")
    frame.BackgroundColor3 = tokens.Color.Topbar
    frame.BackgroundTransparency = tokens.Material.TopbarTransparency
    frame.BorderSizePixel = 0

    local divider = Instance.new("Frame")
    divider.AnchorPoint = Vector2.new(0, 1)
    divider.Position = UDim2.new(0, 12, 1, 0)
    divider.Size = UDim2.new(1, -24, 0, 1)
    divider.BackgroundColor3 = tokens.Color.Divider
    divider.BackgroundTransparency = 0.42
    divider.BorderSizePixel = 0
    divider.Parent = frame
    return frame
end

-- Lightweight pixel brackets for surfaces without list-managed children.
function Material.PixelCorners(parent,tokens,inset)
    local root=Instance.new("Frame");root.Name="PixelCorners"
    root.BackgroundTransparency=1;root.Size=UDim2.fromScale(1,1)
    root.ZIndex=parent.ZIndex+1;root.Parent=parent
    local parts={}
    for _,right in ipairs({false,true}) do
        for _,bottom in ipairs({false,true}) do
            for _,segment in ipairs({{0,4,2,7},{2,2,2,2},{4,0,7,2}}) do
                local x,y,w,h=table.unpack(segment)
                local f=Instance.new("Frame");f.BorderSizePixel=0
                f.Size=UDim2.fromOffset(w,h)
                f.Position=UDim2.new(right and 1 or 0,right and -(inset+x+w) or inset+x,bottom and 1 or 0,bottom and -(inset+y+h) or inset+y)
                f.BackgroundColor3=tokens.Color.Lavender;f.BackgroundTransparency=0.72
                f.ZIndex=root.ZIndex;f.Parent=root;table.insert(parts,f)
            end
        end
    end
    return root,parts
end

-- Five non-overlapping strips form a genuine stepped silhouette without corner masks.
-- Only use on fixed control surfaces, never on containers managed by UIListLayout.
function Material.PixelSurface(frame,step)
    step=step or 2
    local opacity=frame.BackgroundTransparency
    frame.BackgroundTransparency=1
    for _,child in ipairs(frame:GetChildren()) do
        if child:IsA("UICorner") then child:Destroy() end
        if child:IsA("UIStroke") then child.Enabled=false end
    end
    local strips={}
    local specs={
        {step*2,0,1,-step*4,0,step},
        {step,step,1,-step*2,0,step},
        {0,step*2,1,0,1,-step*4},
        {step,-step*2,1,-step*2,0,step},
        {step*2,-step,1,-step*4,0,step},
    }
    for index,spec in ipairs(specs) do
        local strip=Instance.new("Frame");strip.Name="PixelSurfaceStrip"
        strip.BorderSizePixel=0;strip.Active=false
        strip.Position=UDim2.new(0,spec[1],index>=4 and 1 or 0,spec[2])
        strip.Size=UDim2.new(spec[3],spec[4],spec[5],spec[6])
        strip.BackgroundColor3=frame.BackgroundColor3;strip.BackgroundTransparency=opacity
        strip.ZIndex=frame.ZIndex;strip.Parent=frame;table.insert(strips,strip)
    end
    -- Propagate hover, on/off and theme colors only when they change.
    frame:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        for _,strip in ipairs(strips) do strip.BackgroundColor3=frame.BackgroundColor3 end
    end)
    frame:GetPropertyChangedSignal("ZIndex"):Connect(function()
        for _,strip in ipairs(strips) do strip.ZIndex=frame.ZIndex end
    end)
    return frame
end

function Material.Section(frame, tokens)
    frame:SetAttribute("GlassRole", "Section")
    frame.BackgroundColor3 = tokens.Color.Panel
    frame.BackgroundTransparency = tokens.Material.PanelTransparency
    frame.BorderSizePixel = 0
    corner(frame, 3, "PanelCorner")
    stroke(frame, tokens.Color.Stroke, 0.56, 1, "PanelStroke")
    local sheen=Instance.new("UIGradient")
    sheen.Name="GlassSheen"
    sheen.Rotation=110
    sheen.Color=ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(191,212,235))
    sheen.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.04),
        NumberSequenceKeypoint.new(0.42,0),
        NumberSequenceKeypoint.new(1,0.03)
    })
    sheen.Parent=frame
    return frame
end

function Material.Control(frame, tokens)
    frame.BackgroundColor3 = tokens.Color.PanelSoft
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0

    local separator = frame:FindFirstChild("RowSeparator")
    if not separator then
        separator = Instance.new("Frame")
        separator.Name = "RowSeparator"
        separator.AnchorPoint = Vector2.new(0, 1)
        separator.Position = UDim2.new(0, 12, 1, 0)
        separator.Size = UDim2.new(1, -24, 0, 1)
        separator.BackgroundColor3 = tokens.Color.Divider
        separator.BackgroundTransparency = 0.62
        separator.BorderSizePixel = 0
        separator.Parent = frame
    end
    return frame
end

function Material.Popup(frame, tokens)
    frame.BackgroundColor3 = tokens.Color.Popup
    frame.BackgroundTransparency = 0
    frame.Active = true
    frame.BorderSizePixel = 0
    corner(frame, 3, "PopupCorner")
    stroke(frame, tokens.Color.Stroke, 0.52, 1, "PopupStroke")

    return frame
end

function Material.NavRow(frame, tokens, selected)
    frame.BackgroundColor3 = selected and tokens.Color.NavActive or tokens.Color.NavHover
    frame.BackgroundTransparency = selected and 0.04 or 1
    frame.BorderSizePixel = 0

    local c = frame:FindFirstChild("NavCorner")
    if not c then
        c = corner(frame, 4, "NavCorner")
    end
    return frame
end

function Material.NavTile(frame, tokens, color, selected)
    -- Kept for compatibility. M3 uses the icon itself as the strongest accent.
    frame.BackgroundColor3 = selected and tokens.Color.InsetHover or tokens.Color.Inset
    frame.BackgroundTransparency = selected and 0.10 or 0.38
    frame.BorderSizePixel = 0

    local c = frame:FindFirstChild("NavTileCorner")
    if not c then c = corner(frame, 6, "NavTileCorner") end
    local s = frame:FindFirstChild("NavTileStroke")
    if not s then s = stroke(frame, tokens.Color.Stroke, 0.90, 1, "NavTileStroke") end
    s.Color = selected and (color or tokens.Color.Accent) or tokens.Color.Stroke
    s.Transparency = selected and 0.78 or 0.93
    return frame
end

function Material.Inset(frame, tokens)
    frame.BackgroundColor3 = tokens.Color.Inset
    frame.BackgroundTransparency = 0.04
    frame.BorderSizePixel = 0
    corner(frame, 2, "InsetCorner")
    stroke(frame, tokens.Color.Stroke, 0.88, 1, "InsetStroke")
    return frame
end

function Material.Pill(frame, tokens, accent)
    frame.BackgroundColor3 = tokens.Color.Inset
    frame.BackgroundTransparency = 0.04
    frame.BorderSizePixel = 0
    corner(frame, 7, "PillCorner")
    stroke(frame, accent or tokens.Color.Stroke, accent and 0.76 or 0.90, 1, "PillStroke")
    return frame
end

function Material.Hover(frame, tokens, active)
    frame.BackgroundColor3 = active and tokens.Color.RowHover or tokens.Color.PanelSoft
    frame.BackgroundTransparency = active and 0.28 or 1
end

-- Four tapered rays drawn from Frames; independent of font glyph coverage.
-- Small vector emblems; no font glyphs or external image downloads.
function Material.Emblem(parent,position,size,color,kind)
    local root=Instance.new("Frame")
    root.Name="SerenityEmblem";root.BackgroundTransparency=1
    root.Position=position;root.Size=UDim2.fromOffset(size,size);root.Parent=parent
    local function line(x1,y1,x2,y2,width)
        local dx,dy=x2-x1,y2-y1
        local f=Instance.new("Frame");f.BorderSizePixel=0;f.BackgroundColor3=color
        f.AnchorPoint=Vector2.new(0.5,0.5);f.Position=UDim2.fromOffset((x1+x2)*size/2,(y1+y2)*size/2)
        f.Size=UDim2.fromOffset(math.sqrt(dx*dx+dy*dy)*size,width or 1.5)
        f.Rotation=math.deg(math.atan2(dy,dx));f.ZIndex=2;f.Parent=root
        local c=Instance.new("UICorner");c.CornerRadius=UDim.new(1,0);c.Parent=f
    end
    if kind=="compass" then
        -- Open orbital arc around an asymmetric navigation needle.
        for i=0,13 do
            local a=math.rad(35+i*21);local b=math.rad(35+(i+1)*21)
            line(0.5+0.43*math.cos(a),0.5+0.43*math.sin(a),0.5+0.43*math.cos(b),0.5+0.43*math.sin(b),1.2)
        end
        line(0.68,0.23,0.57,0.58,1.8);line(0.57,0.58,0.29,0.74,1.8)
        line(0.29,0.74,0.41,0.39,1.8);line(0.41,0.39,0.68,0.23,1.8)
        line(0.41,0.39,0.57,0.58,1.2)
    else
        -- Two interlocking open loops: connection and community.
        for _,offset in ipairs({0,0.3}) do
            for i=0,11 do
                local a=math.rad(-50+i*25);local b=math.rad(-50+(i+1)*25)
                line(0.34+offset+0.25*math.cos(a),0.39+offset*0.5+0.25*math.sin(a),0.34+offset+0.25*math.cos(b),0.39+offset*0.5+0.25*math.sin(b),1.6)
            end
        end
        line(0.38,0.62,0.65,0.34,1.8)
    end
    return root
end

-- Compact stepped ornament; individual opaque pixels avoid overlapping bright rays.
function Material.PixelStar(parent, position, z)
    local root=Instance.new("Frame")
    root.Name="GrimoireStar";root.BackgroundTransparency=1
    root.Position=position;root.Size=UDim2.fromOffset(30,30);root.ZIndex=z or 5;root.Parent=parent
    local pattern={".......s.......",".......g.......",".......g.......","......sgs......","......gig......",".....sgigs.....","...sggiIiggs...","sgggiIIIiggggs","...sggiIiggs...",".....sgigs.....","......gig......","......sgs......",".......g.......",".......g.......",".......s......."}
    local palette={s=Color3.fromRGB(100,91,70),g=Color3.fromRGB(166,145,103),i=Color3.fromRGB(197,181,143),I=Color3.fromRGB(216,204,174)}
    for y,row in ipairs(pattern) do
        for x=1,#row do
            local tone=row:sub(x,x)
            if palette[tone] then
                local pixel=Instance.new("Frame");pixel.Name=tone=="I" and "StarHighlight" or "StarPixel"
                pixel.BorderSizePixel=0;pixel.Size=UDim2.fromOffset(2,2)
                pixel.Position=UDim2.fromOffset((x-1)*2,(y-1)*2)
                pixel.BackgroundColor3=palette[tone];pixel:SetAttribute("FixedPresetColor",true)
                pixel.ZIndex=root.ZIndex;pixel.Parent=root
            end
        end
    end
    return root
end

function Material.Star(parent, position, size, color, z)
    local root=Instance.new("Frame")
    root.Name="SerenityStar"
    root.BackgroundTransparency=1
    root.Position=position
    root.Size=UDim2.fromOffset(size,size)
    root.ZIndex=z or 2
    root.Parent=parent
    for i=0,11 do
        local distance=i/11
        local thickness=math.max(1, math.floor(size*0.32*(1-distance)^2))
        for _,axis in ipairs({0,1}) do
            for _,sign in ipairs({-1,1}) do
                local ray=Instance.new("Frame")
                ray.BorderSizePixel=0
                ray.BackgroundColor3=color
                ray.AnchorPoint=Vector2.new(0.5,0.5)
                ray.Size=UDim2.fromOffset(axis==0 and thickness or math.max(1,size/24),axis==0 and math.max(1,size/24) or thickness)
                ray.Position=UDim2.fromOffset(size/2+(axis==1 and sign*distance*size*0.46 or 0),size/2+(axis==0 and sign*distance*size*0.46 or 0))
                ray.ZIndex=root.ZIndex
                ray.Parent=root
            end
        end
    end
    return root
end
return Material

end)()
modules["src/core/AcrylicEngine.lua"] = (function()
local Lighting = game:GetService("Lighting")

local AcrylicEngine = {}
AcrylicEngine.__index = AcrylicEngine

function AcrylicEngine.new(runtime, options)
    options = options or {}

    local self = setmetatable({}, AcrylicEngine)
    self.Quality = "Basic"
    self.Visible = true
    self.Amount = options.BasicBlur or 3

    self.Blur = runtime:TrackInstance(Instance.new("BlurEffect"))
    self.Blur.Name = "SerenityAcrylicBlur"
    self.Blur.Size = options.BasicBlur or 3
    self.Blur.Enabled = true
    self.Blur.Parent = Lighting

    self.Depth = runtime:TrackInstance(Instance.new("DepthOfFieldEffect"))
    self.Depth.Name = "SerenityAcrylicDepth"
    self.Depth.Enabled = false
    self.Depth.FocusDistance = 35
    self.Depth.InFocusRadius = 28
    self.Depth.NearIntensity = 0.04
    self.Depth.FarIntensity = 0.08
    self.Depth.Parent = Lighting

    return self
end

function AcrylicEngine:SetQuality(quality)
    quality = quality or "Basic"
    self.Quality = quality

    if not self.Visible or quality == "Off" then
        self.Blur.Enabled = false
        self.Depth.Enabled = false
    elseif quality == "Enhanced" then
        self.Blur.Enabled = true
        self.Blur.Size = self.Amount
        self.Depth.Enabled = true
    else
        self.Blur.Enabled = true
        self.Blur.Size = self.Amount
        self.Depth.Enabled = false
        self.Quality = "Basic"
    end
end

function AcrylicEngine:SetVisible(visible)
    self.Visible = visible
    self:SetQuality(self.Quality)
end

function AcrylicEngine:SetAmount(value)
    self.Amount = math.clamp(value, 0, 8)
    self.Blur.Size = self.Amount
end

function AcrylicEngine:SetEnabled(enabled)
    self:SetQuality(enabled and "Basic" or "Off")
end

return AcrylicEngine

end)()
modules["src/core/Icons.lua"] = (function()
local Icons = {}

Icons.Map = {
    home = "rbxassetid://98755624629571",
    dashboard = "rbxassetid://98755624629571",
    about = "rbxassetid://124560466474914",
    info = "rbxassetid://124560466474914",
    automation = "rbxassetid://80451686744860",
    progression = "rbxassetid://81819858538839",
    shops = "rbxassetid://90338129673705",
    shop = "rbxassetid://90338129673705",
    configs = "rbxassetid://126791525623846",
    misc = "rbxassetid://126791525623846",
    settings = "rbxassetid://80758916183665",
    search = "rbxassetid://121018724060431",
    activity = "rbxassetid://94212016861936",
    webhook = "rbxassetid://94212016861936",
    roll = "rbxassetid://81268120302865",
    target = "rbxassetid://87563802520297",
    inventory = "rbxassetid://140420225386018",
    pets = "rbxassetid://112218825427601",
    world = "rbxassetid://95107167260947",
    server = "rbxassetid://95107167260947",
    store = "rbxassetid://90338129673705",
    shield = "rbxassetid://87354736164608",
    lock = "rbxassetid://134724289526879",
    warning = "rbxassetid://125920361880643",
    check = "rbxassetid://93898873302694",
    chevron_right = "rbxassetid://92473583511724",
    chevron_down = "rbxassetid://134243273101015",
    plus = "rbxassetid://111774323017047",
    minus = "rbxassetid://118026365011536",
    close = "rbxassetid://110786993356448",
    save = "rbxassetid://126116963775616",
}

function Icons.Get(name)
    return Icons.Map[name] or Icons.Map.info
end

local discordBytes = "\137\080\078\071\013\010\026\010\000\000\000\013\073\072\068\082\000\000\000\096\000\000\000\096\008\006\000\000\000\226\152\119\056\000\000\000\006\098\075\071\068\000\255\000\255\000\255\160\189\167\147\000\000\007\135\073\068\065\084\120\156\237\157\107\172\093\069\025\134\159\217\080\045\160\080\048\020\106\075\079\041\002\210\082\169\128\182\133\054\165\085\049\018\021\047\137\049\214\107\172\070\052\193\018\073\212\038\218\024\196\250\195\160\008\018\019\012\074\240\022\139\134\168\137\183\018\091\032\177\252\192\210\096\065\173\008\216\026\133\010\148\182\156\222\207\227\143\057\109\119\247\125\239\181\102\239\150\051\079\114\126\156\189\215\204\251\173\111\246\204\172\053\235\155\111\065\038\147\201\100\050\153\076\038\147\201\100\050\153\076\223\008\131\020\087\039\000\151\000\179\129\103\066\008\119\245\073\247\099\192\105\192\122\224\161\016\194\011\253\208\029\056\234\084\245\163\234\247\213\191\170\035\030\102\088\157\210\007\027\166\169\187\171\116\071\212\071\213\239\169\031\086\039\167\182\161\111\168\199\171\139\213\155\212\199\108\207\119\251\096\211\237\029\216\177\081\253\134\186\080\061\046\181\077\165\162\030\167\094\169\222\161\062\219\193\201\086\179\071\157\154\208\182\169\163\026\221\176\213\216\104\139\213\074\217\054\149\054\007\168\231\003\031\007\062\004\156\089\160\170\155\067\008\203\026\212\127\042\113\220\158\000\188\012\056\169\230\144\157\192\094\224\121\224\217\016\194\246\006\117\220\004\092\087\192\182\127\003\119\002\119\132\016\030\047\080\207\033\010\053\192\104\247\188\026\248\012\176\168\104\125\163\236\000\110\006\206\001\134\070\255\038\002\227\186\172\103\047\240\052\240\047\224\041\224\113\224\179\192\201\037\216\040\176\026\184\021\248\117\008\097\164\215\138\122\118\152\122\021\112\011\048\189\215\058\094\034\252\003\184\038\132\176\186\151\194\061\053\128\058\009\216\008\156\218\075\249\151\032\207\000\051\067\008\255\235\182\096\175\147\202\173\100\231\087\051\017\248\118\047\005\187\238\001\234\213\192\061\189\136\141\001\174\010\033\252\166\155\002\093\053\128\122\034\240\040\113\098\204\212\243\004\113\040\218\213\105\129\110\135\160\047\146\157\223\138\179\137\062\234\152\142\123\128\058\013\120\012\024\223\157\077\099\142\221\192\140\016\194\019\157\028\220\077\015\088\073\118\126\039\140\007\190\222\233\193\029\245\000\245\141\192\186\078\143\207\032\048\047\132\240\096\187\003\059\237\001\095\035\059\191\027\002\113\196\104\075\219\006\080\175\000\222\084\208\160\177\200\034\181\173\223\218\254\170\213\053\192\194\050\044\026\131\060\016\066\088\208\234\128\150\061\064\093\064\118\126\017\230\171\045\253\215\110\008\250\124\137\198\140\085\090\250\176\233\016\164\190\150\120\215\155\039\223\098\008\204\010\033\108\108\244\101\171\030\176\140\236\252\050\008\192\181\173\190\172\195\024\173\176\133\250\167\078\153\222\024\006\038\135\016\182\213\126\209\172\007\044\033\059\191\076\078\036\062\170\173\163\089\015\088\079\140\213\201\148\199\134\016\066\157\079\235\122\128\058\155\236\252\020\092\164\190\190\246\195\070\067\208\007\251\096\204\088\101\073\237\007\071\012\065\106\000\158\004\146\197\230\140\113\054\003\067\033\004\015\126\080\219\003\230\144\157\159\146\179\128\185\213\031\212\054\192\187\251\103\203\152\229\093\213\255\212\054\192\219\251\104\200\088\229\008\031\031\106\000\117\008\152\209\007\003\030\001\062\069\012\232\170\132\016\002\048\153\056\065\221\215\007\253\063\001\031\001\166\134\081\128\105\192\082\224\207\125\208\159\049\250\120\247\072\212\165\093\006\173\118\203\030\245\218\118\001\174\234\123\212\231\018\232\111\087\091\094\225\169\193\232\135\023\019\232\087\243\137\070\226\063\074\040\184\071\189\178\211\159\136\058\067\125\186\068\253\023\212\075\187\208\191\076\221\081\162\126\045\063\110\036\186\057\161\224\039\059\061\249\042\123\022\168\251\075\208\030\081\187\158\219\212\247\150\160\221\140\045\181\098\211\018\138\173\237\246\228\171\236\186\173\004\253\159\020\208\191\167\004\253\102\012\193\225\073\120\110\011\059\138\242\213\002\101\087\002\251\007\168\127\067\065\237\086\204\129\195\013\112\073\034\145\255\000\247\246\090\056\132\176\025\232\185\007\001\235\155\061\008\233\080\255\033\098\048\090\010\046\133\195\013\080\183\072\084\018\247\021\217\188\112\176\142\002\101\215\020\212\046\170\223\138\217\112\184\001\046\076\036\242\183\018\234\216\116\012\235\183\226\066\128\138\250\042\224\140\068\034\117\251\180\122\096\231\128\245\119\148\080\071\035\038\169\019\042\192\185\137\004\160\156\088\210\034\117\148\161\127\066\009\117\052\227\220\010\113\051\092\042\166\149\080\199\217\199\176\126\059\206\169\144\054\222\255\178\001\215\081\134\254\188\018\234\104\198\080\133\184\016\150\138\025\234\204\094\011\171\039\003\111\046\160\191\080\157\088\064\127\136\209\203\197\068\076\169\000\147\018\010\000\092\095\160\236\053\020\139\206\024\071\220\027\220\043\215\209\251\070\198\078\056\019\245\254\132\183\219\170\007\212\249\221\090\166\014\025\023\209\138\178\203\024\229\215\173\254\044\187\079\107\208\045\107\042\164\223\110\090\001\126\106\023\057\032\212\087\002\119\083\206\174\246\241\192\047\140\151\219\157\234\159\014\172\034\166\068\072\201\105\021\098\238\133\212\076\006\238\087\047\110\119\160\122\022\113\249\162\204\177\247\002\096\173\218\246\146\219\152\243\098\045\112\126\137\250\205\056\165\066\255\034\224\166\002\235\212\111\169\117\233\013\212\137\234\114\224\047\192\027\018\232\207\004\030\086\111\080\095\221\064\127\138\122\035\049\137\211\005\009\244\027\241\138\160\238\006\094\222\039\193\106\254\078\188\205\063\064\188\094\159\009\244\043\055\207\008\113\145\237\159\196\208\156\233\068\167\247\059\024\121\056\168\035\003\016\206\068\246\087\200\206\031\036\149\148\215\184\153\014\168\016\199\224\204\096\216\087\033\102\150\202\012\134\189\021\098\110\131\204\096\024\174\144\238\129\067\166\061\059\043\064\221\190\165\076\223\216\086\001\158\075\040\240\036\176\039\097\253\169\217\069\204\186\152\138\231\043\192\214\068\149\223\069\188\187\029\002\086\016\115\110\030\043\060\005\044\039\198\243\207\002\126\158\072\103\043\234\007\060\050\151\114\025\236\181\038\022\212\152\198\248\029\234\221\198\037\226\163\141\093\234\207\212\183\089\147\174\088\125\167\071\230\185\046\075\239\125\007\005\102\027\243\037\151\205\239\108\016\020\171\158\162\046\081\087\169\219\018\232\118\202\054\163\211\151\024\159\190\213\218\057\079\253\099\002\221\013\234\172\090\177\241\198\132\213\101\004\196\086\051\162\254\074\189\188\081\031\052\246\140\249\234\151\213\223\155\182\065\182\171\171\213\021\198\224\223\134\217\120\213\069\234\111\019\232\239\083\087\170\135\022\063\235\214\129\212\185\192\237\164\009\214\122\016\248\014\176\042\132\208\240\254\195\184\081\240\053\192\069\196\021\202\243\136\171\165\083\136\241\075\237\194\068\118\019\019\169\110\038\094\004\108\034\174\124\110\000\054\053\139\212\083\079\002\222\015\124\026\104\251\220\162\007\030\006\150\142\134\059\182\070\029\167\126\065\221\153\224\087\160\250\195\094\207\066\061\193\248\236\096\122\205\223\025\198\180\154\189\214\251\203\068\231\186\093\253\156\122\124\047\070\077\049\110\220\040\115\002\026\177\139\205\018\253\194\248\174\128\050\057\160\254\192\152\230\185\176\113\115\212\053\037\025\086\191\059\228\040\193\242\122\193\031\212\242\035\206\213\183\170\235\010\024\246\162\241\153\239\081\137\122\158\197\034\033\030\080\023\247\195\208\183\168\247\246\096\224\242\228\198\021\068\189\177\203\115\026\049\094\049\045\026\132\177\023\171\119\218\217\141\220\035\106\234\048\143\194\024\039\249\077\029\156\207\176\241\213\038\175\027\180\205\168\167\171\215\219\252\069\061\251\060\010\039\222\102\024\039\228\003\045\126\072\203\140\175\084\057\250\080\231\170\183\168\255\173\050\250\043\131\182\171\091\212\111\086\217\191\197\248\038\168\020\247\007\105\048\190\077\233\010\245\075\246\114\013\060\096\140\043\003\043\212\203\077\240\246\164\076\038\147\201\100\050\153\076\038\147\201\100\050\153\001\240\127\198\110\234\048\180\057\119\096\000\000\000\000\073\069\078\068\174\066\096\130" -- Simple Icons, CC0; same compact mark as existing Serenity library.
local discordUri
local function loadDiscord(image)
    local environment=type(getgenv)=="function" and getgenv() or _G
    local custom=environment.getcustomasset or getcustomasset or environment.getsynasset or getsynasset
    local write=environment.writefile or writefile
    local exists=environment.isfile or isfile
    if type(custom)~="function" or type(write)~="function" then return end
    task.spawn(function()
        local ok,uri=pcall(function()
            if discordUri then return discordUri end
            local path="Serenity_Discord_Mark_v1.png"
            if type(exists)~="function" or not exists(path) then write(path,discordBytes) end
            return custom(path)
        end)
        if ok and type(uri)=="string" and image.Parent then
            discordUri=uri;image.Image=uri;image.ImageColor3=Color3.new(1,1,1)
        end
    end)
end

function Icons.Create(parent, name, size, color, position)
    local image = Instance.new("ImageLabel")
    image.Name = "Icon_" .. tostring(name)
    image.BackgroundTransparency = 1
    image.Image = name=="discord" and "" or Icons.Get(name)
    image.ImageColor3 = color or Color3.new(1, 1, 1)
    image.ScaleType = Enum.ScaleType.Fit
    image.Size = UDim2.fromOffset(size or 18, size or 18)
    if position then image.Position = position end
    image.Parent = parent
    if name=="discord" then loadDiscord(image) end
    return image
end

return Icons

end)()
modules["src/core/PopupManager.lua"] = (function()
local PopupManager = {}
PopupManager.__index = PopupManager

function PopupManager.new()
    return setmetatable({
        Active = nil,
    }, PopupManager)
end

function PopupManager:Close()
    if self.Active then
        pcall(function()
            self.Active:Destroy()
        end)
        self.Active = nil
    end
    if self.OnChange then self.OnChange(nil) end
end

function PopupManager:Set(frame)
    self:Close()
    self.Active = frame
    frame.Active=true
    if self.OnChange then self.OnChange(frame) end
    return frame
end

return PopupManager

end)()
modules["src/components/NavItem.lua"] = (function()
local NavItem = {}
NavItem.__index = NavItem

function NavItem.new(parent, deps, props)
    local tokens = deps.Tokens
    props = props or {}

    local row = Instance.new("TextButton")
    row.Name = props.Id or props.Title or "NavItem"
    row.Size = UDim2.new(1, 0, 0, tokens.Size.NavRow)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.Text = ""
    row.AutoButtonColor = false
    row.LayoutOrder = props.Order or 1
    row.Parent = parent
    deps.Material.NavRow(row, tokens, false)

    local tile=Instance.new("Frame")
    tile.Name="NavGlassTile";tile.Size=UDim2.fromOffset(28,28)
    tile.AnchorPoint=Vector2.new(0.5,0.5);tile.Position=UDim2.new(0,22,0.5,0)
    tile.BackgroundColor3=tokens.Color.PanelSoft;tile.BackgroundTransparency=1
    tile.BorderSizePixel=0;tile.Parent=row
    local rounding=Instance.new("UICorner");rounding.CornerRadius=UDim.new(0,8);rounding.Parent=tile
    local rim=Instance.new("UIStroke");rim.Name="NavGlassEdge";rim.Color=Color3.new(1,1,1)
    rim.Transparency=0.72;rim.Thickness=1;rim.Parent=tile;rim.Enabled=false
    local spectrum=Instance.new("UIGradient");spectrum.Rotation=35
    spectrum.Color=ColorSequence.new(Color3.fromRGB(135,217,255),Color3.fromRGB(222,175,243));spectrum.Parent=rim
    local shine=Instance.new("UIGradient");shine.Rotation=115
    shine.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(139,167,204));shine.Parent=tile
    local scale=Instance.new("UIScale");scale.Parent=tile
    local marker=Instance.new("Frame");marker.Name="SelectionMarker";marker.BorderSizePixel=0
    marker.Size=UDim2.fromOffset(2,10);marker.Position=UDim2.new(0,3,0.5,-5)
    marker.BackgroundColor3=tokens.Color.Accent;marker.BackgroundTransparency=1;marker.Parent=row;marker.Visible=true
    local markerTip=Instance.new("Frame");markerTip.Name="PixelTip"
    markerTip.Size=UDim2.fromOffset(2,4);markerTip.Position=UDim2.fromOffset(2,3)
    markerTip.BorderSizePixel=0;markerTip.BackgroundColor3=tokens.Color.Accent
    markerTip.BackgroundTransparency=1;markerTip.Parent=marker
    local icon = deps.Icons.Create(tile, props.Icon or "info", tokens.Size.NavIcon-2, tokens.Color.TextMuted)
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.Position = UDim2.fromScale(0.5,0.5)

    local label = deps.Typography.Label(
        row,
        "Nav",
        tokens,
        props.Title or "Page",
        UDim2.fromOffset(44, 0),
        UDim2.new(1, -52, 1, 0),
        tokens.Color.TextMuted
    )

    local self = setmetatable({
        Row = row,
        Icon = icon,
        Label = label,
        Tile=tile, Rim=rim, Marker=marker, MarkerTip=markerTip, Scale=scale,
        Accent = props.Accent or tokens.Color.Accent,
        Selected = false,
        Callback = props.Callback,
        Deps = deps,
    }, NavItem)

    row.MouseEnter:Connect(function() if serenityInputBlocked(row) then return end;
        deps.Motion:Tween(tile,"Hover",{BackgroundTransparency=1})
        deps.Motion:Tween(rim,"Hover",{Transparency=0.25})
        deps.Motion:Tween(label,"Hover",{Position=UDim2.fromOffset(deps.Motion.Reduced and 44 or 46,0)})
        if not self.Selected then
            row.BackgroundColor3 = tokens.Color.NavHover
            deps.Motion:Tween(row, "Hover", {BackgroundTransparency = 0.34})
            label.TextColor3 = tokens.Color.Text
            icon.ImageColor3 = tokens.Color.Text
        end
    end)

    row.MouseLeave:Connect(function()
        deps.Motion:Tween(tile,"Hover",{BackgroundTransparency=1})
        deps.Motion:Tween(rim,"Hover",{Transparency=self.Selected and 0.3 or 0.72})
        deps.Motion:Tween(label,"Hover",{Position=UDim2.fromOffset(44,0)})
        deps.Motion:Tween(scale,"Hover",{Scale=1})
        if not self.Selected then
            deps.Motion:Tween(row, "Hover", {BackgroundTransparency = 1})
            label.TextColor3 = tokens.Color.TextMuted
            icon.ImageColor3 = tokens.Color.TextMuted
        end
    end)

    row.MouseButton1Down:Connect(function()
        deps.Motion:Tween(scale,0.08,{Scale=deps.Motion.Reduced and 1 or 0.9})
    end)
    row.MouseButton1Up:Connect(function()
        deps.Motion:Tween(scale,"Select",{Scale=1})
    end)
    row.Activated:Connect(function() if serenityInputBlocked(row) then return end;
        if self.Callback then self.Callback() end
        if deps.PlayUISound then deps.PlayUISound() end
    end)

    return self
end

function NavItem:SetSelected(selected)
    self.Selected = not not selected
    local tokens = self.Deps.Tokens
    self.Row.BackgroundColor3=tokens.Color.NavActive
    self.Deps.Motion:Tween(self.Row,"Select",{BackgroundTransparency=self.Selected and 0.18 or 1})
    self.Tile.BackgroundColor3=tokens.Color.PanelSoft
    self.Marker.BackgroundColor3=tokens.Color.Accent
    self.MarkerTip.BackgroundColor3=tokens.Color.Accent
    self.Deps.Motion:Tween(self.Marker,"Select",{BackgroundTransparency=self.Selected and 0.15 or 1,Position=UDim2.new(0,self.Selected and 5 or 3,0.5,-5)})
    self.Deps.Motion:Tween(self.MarkerTip,"Select",{BackgroundTransparency=self.Selected and 0.15 or 1})
    self.Deps.Motion:Tween(self.Tile,"Select",{BackgroundTransparency=1})
    self.Deps.Motion:Tween(self.Rim,"Select",{Transparency=self.Selected and 0.3 or 0.72})
    self.Icon.ImageColor3 = self.Selected and tokens.Color.Accent or tokens.Color.TextMuted
    self.Label.TextColor3 = self.Selected and tokens.Color.Text or tokens.Color.TextMuted
end

function NavItem:SetCollapsed(collapsed)
    self.Label.Visible = not collapsed
end

return NavItem

end)()
modules["src/components/Section.lua"] = (function()
local Section = {}
Section.__index = Section

function Section.new(parent, deps, props)
    local tokens = deps.Tokens
    props = props or {}

    local frame = Instance.new("Frame")
    frame.Name = props.Id or "Section"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.Parent = parent

    local stack = Instance.new("UIListLayout")
    stack.Padding = UDim.new(0, deps.Mobile and 4 or 6)
    stack.SortOrder = Enum.SortOrder.LayoutOrder
    stack.Parent = frame

    local header = Instance.new("TextButton")
    header.BackgroundTransparency = 1
    header.BackgroundColor3 = tokens.Color.PanelSoft
    local headerCorner=Instance.new("UICorner");headerCorner.CornerRadius=UDim.new(0,2);headerCorner.Parent=header
    local headerEdge=Instance.new("UIStroke");headerEdge.Name="SectionHeaderEdge"
    headerEdge.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;headerEdge.Thickness=1
    headerEdge.Color=tokens.Color.Stroke;headerEdge.Transparency=1;headerEdge.Parent=header
    header.Text = ""
    header.AutoButtonColor = false
    header.Size = UDim2.new(1, 0, 0, 24)
    header.LayoutOrder = 1
    header.Parent = frame

    local title = deps.Typography.Label(
        header,
        "Section",
        tokens,
        string.upper(props.Title or "SECTION"),
        UDim2.fromOffset(12, 0),
        UDim2.new(1, props.Status and -122 or -52, 1, 0),
        tokens.Color.TextDim
    )
    title.TextTransparency = 0
    title.Text = props.Title or "Section"
    title.TextSize = 13
    title.Font = deps.Typography.Font.Semibold
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.Position = UDim2.fromOffset(20,0)
    title.TextColor3 = tokens.Color.Text
    local underline = Instance.new("Frame")
    underline.Name = "SectionAccent"
    underline.Size = UDim2.fromOffset(2, 10)
    underline.AnchorPoint=Vector2.new(0,0.5);underline.Position=UDim2.new(0,10,0.5,0)
    underline.BorderSizePixel=0;underline.BackgroundColor3=props.Accent or tokens.Color.Accent
    underline.BackgroundTransparency=0.32;underline.Parent=header
    local wings={}
    for _,x in ipairs({-2,2}) do
        local wing=Instance.new("Frame");wing.BorderSizePixel=0
        wing.Size=UDim2.fromOffset(2,4);wing.Position=UDim2.fromOffset(x,3)
        wing.BackgroundColor3=props.Accent or tokens.Color.Accent;wing.BackgroundTransparency=0.45;wing.Parent=underline
        table.insert(wings,wing)
    end
    local function runeFeedback(active)
        deps.Motion:Tween(underline,0.14,{BackgroundTransparency=active and 0 or 0.32})
        for _,wing in ipairs(wings) do deps.Motion:Tween(wing,0.14,{BackgroundTransparency=active and 0.1 or 0.45}) end
        deps.Motion:Tween(headerEdge,0.14,{Transparency=active and 0.88 or 1})
    end
    deps.Runtime:TrackConnection(header.MouseEnter:Connect(function() if serenityInputBlocked(header) then return end; runeFeedback(true) end))
    deps.Runtime:TrackConnection(header.MouseLeave:Connect(function() runeFeedback(false) end))

    -- Opt-in feature groups preserve legacy section sizing and presentation.
    local description
    if props.Description then
        title.Text = props.Title or "Section"
        title.TextColor3 = tokens.Color.Text
        title.TextTransparency = 0
        title.Position = UDim2.fromOffset(20, 0)
        title.Size = UDim2.new(1, -45, 1, 0)
        description = deps.Typography.Label(frame, "Description", tokens, props.Description,
            UDim2.fromOffset(10, 0), UDim2.new(1, -20, 0, 34), tokens.Color.TextMuted)
        description.TextSize = 12
        description.TextColor3 = tokens.Color.TextMuted
        description.TextWrapped = true
        description.TextYAlignment = Enum.TextYAlignment.Center
        description.LayoutOrder = 2
        description.Visible = props.Open ~= false
    end
    if props.Tooltip and deps.Help then
        local help = Instance.new("TextButton")
        help.Name = "SectionHelp"
        help.AnchorPoint = Vector2.new(1, 0.5)
        help.Position = UDim2.new(1, props.Collapsible and -20 or -2, 0.5, 0)
        help.Size = UDim2.fromOffset(24, 24)
        help.Text = "?"
        help.TextSize = 13
        help.Font = Enum.Font.GothamBold
        help.TextColor3 = tokens.Color.Accent
        help.BackgroundTransparency = 1
        help.Parent = header
        deps.Help(help, props.Tooltip)
    end

    local status
    if props.Status then
        status = deps.Typography.Label(
            header,
            "Status",
            tokens,
            string.upper(props.Status),
            UDim2.new(1, -104, 0, 0),
            UDim2.fromOffset(80, tokens.Size.SectionLabel),
            props.StatusColor or tokens.Color.TextDim
        )
        status.TextXAlignment = Enum.TextXAlignment.Right
    end

    local caret
    if props.Collapsible then
        caret = deps.Icons.Create(header, props.Open == false and "plus" or "minus", 12, tokens.Color.TextDim)
        caret.AnchorPoint = Vector2.new(1, 0.5)
        caret.Position = UDim2.new(1, -2, 0.5, 0)
    end

    local body = Instance.new("Frame")
    body.Name = "Panel"
    body.Size = UDim2.new(1, 0, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.Visible = props.Open ~= false
    body.LayoutOrder = props.Description and 3 or 2
    body.Parent = frame
    deps.Material.Section(body, tokens)
    body:SetAttribute("ReadingSurface", true)

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 0)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = body

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 2)
    pad.PaddingBottom = UDim.new(0, 2)
    pad.Parent = body

    local self = setmetatable({
        Frame = frame,
        Header = header,
        Body = body,
        Description = description,
        Open = props.Open ~= false,
        Status = status,
        Caret = caret,
        Collapsible = props.Collapsible == true,
        Deps = deps,
    }, Section)

    if self.Collapsible then
        header.MouseEnter:Connect(function() if serenityInputBlocked(header) then return end; deps.Motion:Tween(header,"Hover",{BackgroundColor3=tokens.Color.InsetHover,BackgroundTransparency=0.88}) end)
        header.MouseLeave:Connect(function() deps.Motion:Tween(header,"Hover",{BackgroundColor3=tokens.Color.PanelSoft,BackgroundTransparency=1}) end)
    end
    deps.Runtime:TrackConnection(header.MouseButton1Click:Connect(function() if serenityInputBlocked(header) then return end;
        if self.Collapsible then
            self:SetOpen(not self.Open)
        end
    end))

    return self
end

function Section:SetOpen(value)
    self.Open = not not value
    self.Body.Visible = self.Open
    if self.Description then self.Description.Visible=self.Open end
    if self.Caret then
        self.Caret.Image = self.Deps.Icons.Get(self.Open and "minus" or "plus")
    end
end

function Section:SetStatus(text, color)
    if not self.Status then return end
    self.Status.Text = string.upper(tostring(text))
    if color then self.Status.TextColor3 = color end
end

return Section

end)()
modules["src/components/Toggle.lua"] = (function()
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(parent, deps, props)
    local tokens = deps.Tokens
    props = props or {}
    local hasDescription = props.Description and props.Description ~= ""
    local height = hasDescription and tokens.Size.ControlWithDescription or tokens.Size.Control

    local row = Instance.new("CanvasGroup")
    row.Name = props.Id or "Toggle"
    row:SetAttribute("FeatureTitle", props.Title or "Toggle")
    row:SetAttribute("FeatureDescription", props.Description or "")
    row.Size = UDim2.new(1, 0, 0, height)
    row.Parent = parent
    deps.Material.Control(row, tokens)

    local titleY = hasDescription and 6 or 0
    local titleH = hasDescription and 19 or height
    local controlTitle=deps.Typography.Label(
        row,
        "Control",
        tokens,
        props.Title or "Toggle",
        UDim2.fromOffset(13, titleY),
        UDim2.new(1, props.Settings and props.OnSettings and -108 or -68, 0, titleH),
        tokens.Color.Text
    )

    if deps.Mobile then controlTitle.TextSize=13 end
    controlTitle.TextTruncate=Enum.TextTruncate.AtEnd
    if hasDescription then
        deps.Typography.Label(
            row,
            "Description",
            tokens,
            props.Description,
            UDim2.fromOffset(13, 27),
            UDim2.new(1, -108, 0, 15),
            tokens.Color.TextDim
        )
    end

    if props.Settings and props.OnSettings then
        local dots = deps.Typography.Label(row, "Value", tokens, "•••", UDim2.new(1, -96, 0, 0), UDim2.fromOffset(34, height), tokens.Color.TextDim)
        dots.TextXAlignment = Enum.TextXAlignment.Center
    end

    local switch = Instance.new("Frame")
    switch.AnchorPoint = Vector2.new(1, 0.5)
    switch.Position = UDim2.new(1, -13, 0.5, 0)
    switch.Size = UDim2.fromOffset(38, 21)
    switch.BorderSizePixel = 0
    switch.Parent = row
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch
    deps.Material.PixelSurface(switch,2)

    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Size = UDim2.fromOffset(15, 15)
    knob.BackgroundColor3 = Color3.fromRGB(249, 250, 255)
    knob.BorderSizePixel = 0
    knob.Parent = switch
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    deps.Material.PixelSurface(knob,1)

    local hit = Instance.new("TextButton")
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.Size = UDim2.fromScale(1, 1)
    hit.Parent = row

    local self = setmetatable({
        Frame = row,
        Value = not not props.Default,
        Enabled = props.Enabled ~= false,
        Switch = switch,
        Knob = knob,
        Callback = props.Callback,
        Motion = deps.Motion,
        Tokens = tokens,
    }, Toggle)

    function self:_render(animate)
        self.Switch.BackgroundColor3 = self.Value and self.Tokens.Color.Accent or self.Tokens.Color.Disabled
        local pos = self.Value and UDim2.new(1, -10.5, 0.5, 0) or UDim2.fromOffset(10.5, 10.5)
        if animate then
            self.Motion:Tween(self.Knob, "Toggle", {Position = pos})
        else
            self.Knob.Position = pos
        end
        self.Frame.GroupTransparency = self.Enabled and 0 or 0.45
    end

    self:_render(false)

    hit.MouseEnter:Connect(function() if serenityInputBlocked(hit) then return end;
        if self.Enabled then deps.Material.Hover(row, tokens, true) end
    end)
    hit.MouseLeave:Connect(function()
        deps.Material.Hover(row, tokens, false)
    end)
    hit.MouseButton1Click:Connect(function() if serenityInputBlocked(hit) then return end;
        if not self.Enabled then return end
        self:Set(not self.Value)
    end)

    return self
end

function Toggle:Set(value, silent)
    self.Value = not not value
    self:_render(true)
    if self.Callback and not silent then self.Callback(self.Value) end
end

function Toggle:SetEnabled(value)
    self.Enabled = not not value
    self:_render(false)
end

function Toggle:Get()
    return self.Value
end

function Toggle:SetVisible(value)
    self.Frame.Visible = not not value
end

function Toggle:IsVisible()
    return self.Frame.Visible
end

return Toggle

end)()
modules["src/components/Slider.lua"] = (function()
local Slider = {}
Slider.__index = Slider

function Slider.new(parent, deps, props)
    local tokens = deps.Tokens
    props = props or {}

    local min = props.Min or 0
    local max = props.Max or 100
    local step = math.max(0.000001, props.Step or 1)
    max = math.max(min, max)
    local value = math.clamp(props.Default or min, min, max)
    local suffix = props.Suffix or ""

    local row = Instance.new("CanvasGroup")
    row.Name = props.Id or "Slider"
    row:SetAttribute("FeatureTitle", props.Title or "Slider")
    row:SetAttribute("FeatureDescription", props.Description or "")
    row.Size = UDim2.new(1, 0, 0, tokens.Size.Slider)
    row.Parent = parent
    deps.Material.Control(row, tokens)

    deps.Typography.Label(
        row,
        "Control",
        tokens,
        props.Title or "Slider",
        UDim2.fromOffset(13, 0),
        UDim2.new(1, -86, 0, 29),
        tokens.Color.Text
    )

    if props.Settings and props.OnSettings then
        local dots = deps.Typography.Label(row, "Value", tokens, "•••", UDim2.new(0.39, 0, 0, 0), UDim2.fromOffset(30, tokens.Size.Slider), tokens.Color.TextDim)
        dots.TextXAlignment = Enum.TextXAlignment.Center
    end

    local valueBox = Instance.new("Frame")
    valueBox.AnchorPoint = Vector2.new(1, 0.5)
    valueBox.Position = UDim2.new(1, -12, 0, 15)
    valueBox.Size = UDim2.fromOffset(48, 26)
    valueBox.Parent = row
    deps.Material.Inset(valueBox, tokens)
    deps.Material.PixelSurface(valueBox,2)

    local valueLabel = Instance.new("TextBox")
    valueLabel.Size=UDim2.fromScale(1,1)
    valueLabel.ClearTextOnFocus=false
    valueLabel.Text=tostring(value)
    valueLabel.Parent=valueBox
    deps.Typography.Apply(valueLabel,"Value",tokens,tokens.Color.TextMuted)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Center

    local bar = Instance.new("Frame")
    bar.AnchorPoint = Vector2.new(1, 0.5)
    bar.Position = UDim2.new(1, -16, 0, 42)
    bar.Size = UDim2.new(1, -32, 0, 4)
    bar.BackgroundColor3 = tokens.Color.Disabled
    bar.BackgroundTransparency = 0.34
    bar.BorderSizePixel = 0
    bar.Parent = row
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 0)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = tokens.Color.Accent
    fill.BorderSizePixel = 0
    fill.Parent = bar
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 0)
    fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Size = UDim2.fromOffset(12, 12)
    knob.BackgroundColor3 = Color3.fromRGB(247, 249, 255)
    knob.BorderSizePixel = 0
    knob.Parent = bar
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    deps.Material.PixelSurface(knob,1)

    local hit = Instance.new("TextButton")
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.AnchorPoint = Vector2.new(1, 0.5)
    hit.Position = UDim2.new(1, -8, 0, 42)
    hit.Size = UDim2.new(1, -16, 0, 28)
    hit.Parent = row

    local self = setmetatable({
        Frame = row,
        Value = value,
        Enabled = props.Enabled ~= false,
        Min = min,
        Max = max,
        Step = step,
        Suffix = suffix,
        Fill = fill,
        Knob = knob,
        Label = valueLabel,
        Callback = props.Callback,
        Tokens = tokens,
    }, Slider)

    local function roundToStep(v)
        local snapped = math.floor(((v - min) / step) + 0.5) * step + min
        return math.clamp(snapped, min, max)
    end

    function self:_render()
        local alpha = (self.Value - self.Min) / math.max(0.0001, self.Max - self.Min)
        self.Fill.Size = UDim2.new(alpha, 0, 1, 0)
        self.Knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        self.Label.Text = string.format("%.3f", self.Value):gsub("0+$", ""):gsub("%.$", "") .. self.Suffix
        self.Frame.GroupTransparency = self.Enabled and 0 or 0.45
    end

    function self:_setFromX(x)
        if not self.Enabled then return end
        local alpha = math.clamp((x - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X), 0, 1)
        local raw = self.Min + (self.Max - self.Min) * alpha
        self:Set(roundToStep(raw))
    end

    local dragging = false
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            self:_setFromX(input.Position.X)
        end
    end)

    deps.Runtime:TrackConnection(deps.UserInputService.InputChanged:Connect(function(input)
        if dragging and deps.WindowFrame.Visible and deps.WindowFrame.Parent.Visible and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            self:_setFromX(input.Position.X)
        end
    end))

    deps.Runtime:TrackConnection(deps.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))

    valueLabel.Focused:Connect(function()
        if not self.Enabled then valueLabel:ReleaseFocus() return end
        valueLabel.Text=tostring(self.Value)
    end)
    valueLabel.FocusLost:Connect(function()
        local number=tonumber(valueLabel.Text)
        if self.Enabled and number and number==number and math.abs(number)<math.huge then self:Set(number) end
        self:_render()
    end)
    valueBox.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseWheel and self.Enabled then
            self:Set(self.Value+input.Position.Z*self.Step)
        end
    end)
    self:_render()
    return self
end

function Slider:Set(value, silent)
    if type(value)~="number" or value~=value or math.abs(value)==math.huge then return end
    local nextValue = math.clamp(self.Min + math.floor((value - self.Min) / self.Step + 0.5) * self.Step, self.Min, self.Max)
    if nextValue == self.Value then return end
    self.Value = nextValue
    self:_render()
    if self.Callback and not silent then self.Callback(self.Value) end
end

function Slider:SetEnabled(value)
    self.Enabled = not not value
    self:_render()
end

function Slider:Get()
    return self.Value
end

function Slider:SetVisible(value)
    self.Frame.Visible = not not value
end

function Slider:IsVisible()
    return self.Frame.Visible
end

return Slider

end)()
modules["src/components/Select.lua"] = (function()
local Select = {}
Select.__index = Select

local function popupPosition(deps, button, width, height)
    local scale = (deps.UIScale and deps.UIScale.Scale) or 1
    local shell = deps.WindowFrame
    local x = (button.AbsolutePosition.X - shell.AbsolutePosition.X) / scale
    local y = (button.AbsolutePosition.Y - shell.AbsolutePosition.Y) / scale
    local bw = button.AbsoluteSize.X / scale
    local bh = button.AbsoluteSize.Y / scale
    local maxW = shell.AbsoluteSize.X / scale
    local maxH = shell.AbsoluteSize.Y / scale
    return UDim2.fromOffset(
        math.clamp(x + bw - width, 8, math.max(8, maxW - width - 8)),
        math.clamp(y + bh + height + 12 <= maxH and (y + bh + 4) or (y - height - 4), 8, math.max(8, maxH - height - 8))
    )
end

function Select.new(parent, deps, props)
    local tokens = deps.Tokens
    props = props or {}
    local hasDescription = props.Description and props.Description ~= ""
    local height = math.max(hasDescription and 76 or 58,hasDescription and tokens.Size.ControlWithDescription or tokens.Size.Select)

    local row = Instance.new("CanvasGroup")
    row.Name = props.Id or "Select"
    row:SetAttribute("FeatureTitle", props.Title or "Select")
    row:SetAttribute("FeatureDescription", props.Description or "")
    row.Size = UDim2.new(1, 0, 0, height)
    row.Parent = parent
    deps.Material.Control(row, tokens)

    local titleY = 0
    local titleH = 24
    deps.Typography.Label(row, "Control", tokens, props.Title or "Select", UDim2.fromOffset(13, titleY), UDim2.new(1, -26, 0, titleH), tokens.Color.Text)
    if hasDescription then
        deps.Typography.Label(row, "Description", tokens, props.Description, UDim2.fromOffset(13, 27), UDim2.new(0.47, -12, 0, 15), tokens.Color.TextDim)
    end

    local button = Instance.new("TextButton")
    button.AnchorPoint = Vector2.new(1, 0.5)
    button.Position = UDim2.new(1, -12, 1, -19)
    button.Size = UDim2.new(1, -24, 0, 30)
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = row
    deps.Material.Inset(button, tokens)
    deps.Material.PixelSurface(button,2)

    local valueLabel = deps.Typography.Label(button, "Value", tokens, tostring(props.Default or "Select"), UDim2.fromOffset(10, 0), UDim2.new(1, -34, 1, 0), tokens.Color.TextMuted)
    local chevron = deps.Icons.Create(button, "chevron_down", 13, tokens.Color.TextDim)
    chevron.AnchorPoint = Vector2.new(1, 0.5)
    chevron.Position = UDim2.new(1, -9, 0.5, 0)

    local self = setmetatable({
        Frame = row,
        Button = button,
        Label = valueLabel,
        Value = props.Multi and (type(props.Default)=="table" and table.clone(props.Default) or {}) or props.Default,
        Multi = props.Multi == true,
        Options = props.Options or {},
        Enabled = props.Enabled ~= false,
        Callback = props.Callback,
        Deps = deps,
    }, Select)

    function self:_render()
        if self.Multi then
            local names={};for _,value in ipairs(self.Value) do table.insert(names,tostring(value)) end
            self.Label.Text=#names>0 and table.concat(names,", ") or "Select options"
            self.Label.TextTruncate=Enum.TextTruncate.AtEnd
        else self.Label.Text = tostring(self.Value or "Select") end
        if self.RefreshOpenChoices then self.RefreshOpenChoices() end
        self.Frame.GroupTransparency = self.Enabled and 0 or 0.45
    end

    button.MouseEnter:Connect(function() if serenityInputBlocked(button) then return end;
        if self.Enabled then button.BackgroundColor3 = tokens.Color.InsetHover end
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = tokens.Color.Inset
    end)

    button.MouseButton1Click:Connect(function() if serenityInputBlocked(button) then return end;
        if not self.Enabled then return end
        deps.PopupManager:Close()

        local width = math.max(180, math.floor(button.AbsoluteSize.X / math.max(0.001, (deps.UIScale and deps.UIScale.Scale) or 1)))
        local heightPopup = math.min(230, 12 + (#self.Options * 34))
        local popup = Instance.new("Frame")
        popup.Size = UDim2.fromOffset(width, heightPopup)
        popup.Position = popupPosition(deps, button, width, heightPopup)
        popup.ZIndex = 80
        popup.Parent = deps.PopupHost
        deps.Material.Popup(popup, tokens)

        local scroller = Instance.new("ScrollingFrame")
        scroller.BackgroundTransparency = 1
        scroller.BorderSizePixel = 0
        scroller.Position = UDim2.fromOffset(6, 6)
        scroller.Size = UDim2.new(1, -12, 1, -12)
        scroller.CanvasSize = UDim2.new()
        scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroller.ScrollBarThickness = 2
        scroller.ScrollBarImageColor3 = tokens.Color.Accent
        scroller.ScrollBarImageTransparency = 0.35
        scroller.ZIndex = 81
        scroller.Parent = popup

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 3)
        list.Parent = scroller

        local entries={}
        local hovered,focused
        local function isSelected(option)
            if self.Multi then return table.find(self.Value,option)~=nil end
            return option==self.Value
        end
        local function refreshChoices()
            if not popup.Parent then return end
            local target=hovered or focused
            for _,entry in ipairs(entries) do
                local selected=isSelected(entry.Option)
                local active=target==entry
                local emphasized=active or (selected and (self.Multi or not target))
                local show=self.Multi and selected or (not self.Multi and (target and active or (not target and selected)))
                -- Hide synchronously so a crossfade never leaves two single-select arrows.
                for _,part in ipairs(entry.Pixels) do part.BackgroundTransparency=show and 0.15 or 1 end
                entry.Button.BackgroundColor3=emphasized and tokens.Color.NavActive or tokens.Color.PanelSoft
                deps.Motion:Tween(entry.Button,0.1,{BackgroundTransparency=active and 0 or (emphasized and 0.12 or 0.55)})
                entry.Button.TextColor3=emphasized and tokens.Color.Text or tokens.Color.TextMuted
            end
        end
        self.RefreshOpenChoices=refreshChoices
        popup.Destroying:Connect(function()
            if self.RefreshOpenChoices==refreshChoices then self.RefreshOpenChoices=nil end
        end)
        for _, option in ipairs(self.Options) do
            local selected = isSelected(option)
            local item = Instance.new("TextButton")
            item.Size = UDim2.new(1, -2, 0, 31)
            item.BackgroundColor3 = selected and tokens.Color.NavActive or tokens.Color.PanelSoft
            item.BackgroundTransparency = selected and 0.08 or 0.55
            item.BorderSizePixel = 0
            item.Text = tostring(option)
            item.TextXAlignment=Enum.TextXAlignment.Left
            local padding=Instance.new("UIPadding");padding.PaddingLeft=UDim.new(0,26);padding.PaddingRight=UDim.new(0,10);padding.Parent=item
            item.TextColor3 = selected and tokens.Color.Text or tokens.Color.TextMuted
            item.TextSize = tokens.Type.Value
            item.Font = selected and deps.Typography.Font.Semibold or deps.Typography.Font.Medium
            item.AutoButtonColor = false
            item.ZIndex = 82
            item.Parent = scroller
            local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,3);c.Parent=item
            local pixels={}
            for _,segment in ipairs(self.Multi and {{0,0,2,2},{2,2,2,2},{4,0,2,2},{6,-2,2,2}} or {{0,-5,2,10},{2,-3,2,6},{4,-1,2,2}}) do
                local part=Instance.new("Frame");part.BorderSizePixel=0
                part.Position=UDim2.new(0,-18+segment[1],0.5,segment[2])
                part.Size=UDim2.fromOffset(segment[3],segment[4]);part.BackgroundColor3=tokens.Color.Accent
                part.BackgroundTransparency=selected and 0.15 or 1;part.ZIndex=83;part.Parent=item
                table.insert(pixels,part)
            end
            local entry={Button=item,Pixels=pixels,Option=option}
            table.insert(entries,entry)
            item.MouseEnter:Connect(function() if serenityInputBlocked(item) then return end; hovered=entry;refreshChoices() end)
            item.MouseLeave:Connect(function() if hovered==entry then hovered=nil end;refreshChoices() end)
            item.SelectionGained:Connect(function() if serenityInputBlocked(item) then return end; focused=entry;refreshChoices() end)
            item.SelectionLost:Connect(function() if focused==entry then focused=nil end;refreshChoices() end)
            item.MouseButton1Click:Connect(function() if serenityInputBlocked(item) then return end;
                if self.Multi then
                    local values=table.clone(self.Value);local index=table.find(values,option)
                    if index then table.remove(values,index) else table.insert(values,option) end
                    self:Set(values)
                else
                    self:Set(option);deps.PopupManager:Close()
                end
            end)
        end
        refreshChoices()

        deps.PopupManager:Set(popup)
    end)

    self:_render()
    return self
end

function Select:Set(value, silent)
    if self.Multi then
        if type(value)~="table" then return end
        local filtered={}
        for _,option in ipairs(self.Options) do
            if table.find(value,option) and not table.find(filtered,option) then table.insert(filtered,option) end
        end
        self.Value=filtered
    else
        local found=false
        for _,option in ipairs(self.Options) do if option==value then found=true break end end
        if not found and #self.Options>0 then return end
        self.Value=value
    end
    self:_render()
    if self.Callback and not silent then self.Callback(self:Get()) end
end

function Select:Refresh(options, preserve, silent)
    local previous=self:Get()
    self.Deps.PopupManager:Close()
    self.Options=options or {}
    if self.Multi then self:Set(preserve and previous or {},silent~=false);return end
    if preserve then
        for _,option in ipairs(self.Options) do
            if option==previous then self:Set(previous,true);return end
        end
    end
    self:Set(self.Options[1],silent~=false)
end

function Select:SetEnabled(value)
    self.Enabled = not not value
    self:_render()
end

function Select:Get()
    return self.Multi and table.clone(self.Value) or self.Value
end

function Select:SetVisible(value)
    self.Frame.Visible = not not value
end

function Select:IsVisible()
    return self.Frame.Visible
end

return Select

end)()
modules["src/components/ColumnLayout.lua"] = (function()
local ColumnLayout = {}
ColumnLayout.__index = ColumnLayout

function ColumnLayout.new(parent, deps, props)
    props = props or {}
    local gap = props.Gap or 12

    local frame = Instance.new("Frame")
    frame.Name = props.Id or "ColumnLayout"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.LayoutOrder = props.LayoutOrder or 1
    frame.Parent = parent

    local left = Instance.new("Frame")
    left.Name = "Left"
    left.BackgroundTransparency = 1
    left.Position = UDim2.fromOffset(0, 0)
    left.Size = UDim2.new(0.5, -(gap / 2), 0, 0)
    left.AutomaticSize = Enum.AutomaticSize.Y
    left.Parent = frame

    local right = Instance.new("Frame")
    right.Name = "Right"
    right.BackgroundTransparency = 1
    right.Position = UDim2.new(0.5, gap / 2, 0, 0)
    right.Size = UDim2.new(0.5, -(gap / 2), 0, 0)
    right.AutomaticSize = Enum.AutomaticSize.Y
    right.Parent = frame

    local leftList = Instance.new("UIListLayout")
    leftList.Padding = UDim.new(0, props.RowGap or 10)
    leftList.SortOrder = Enum.SortOrder.LayoutOrder
    leftList.Parent = left

    local rightList = Instance.new("UIListLayout")
    rightList.Padding = UDim.new(0, props.RowGap or 10)
    rightList.SortOrder = Enum.SortOrder.LayoutOrder
    rightList.Parent = right

    local self = setmetatable({
        Frame = frame,
        Left = left,
        Right = right,
        LeftList = leftList,
        RightList = rightList,
        Deps = deps,
    }, ColumnLayout)

    local function refresh()
        local scale = deps.UIScale and deps.UIScale.Scale or 1
        local logicalWidth=frame.AbsoluteSize.X/math.max(scale,0.001)
        local minColumnWidth=props.MinColumnWidth or (deps.Mobile and 224 or 250)
        local narrow=logicalWidth < minColumnWidth*2+gap
        left.Size = UDim2.new(narrow and 1 or 0.5, narrow and 0 or -(gap / 2), 0, 0)
        right.Size = left.Size
        local leftH = leftList.AbsoluteContentSize.Y / scale
        local rightH = rightList.AbsoluteContentSize.Y / scale
        right.Position = narrow and UDim2.fromOffset(0, leftH + gap) or UDim2.new(0.5, gap / 2, 0, 0)
        frame.Size = UDim2.new(1, 0, 0, narrow and (leftH + gap + rightH) or math.max(leftH, rightH))
    end

    -- Coalesce size/content signals into one layout pass per scheduler turn.
    local pending
    local function scheduleRefresh()
        if pending or (deps.Runtime and deps.Runtime.Destroyed) then return end
        pending=task.defer(function()
            pending=nil
            if not deps.Runtime or not deps.Runtime.Destroyed then refresh() end
        end)
    end
    local function observe(object,property)
        local connection=object:GetPropertyChangedSignal(property):Connect(scheduleRefresh)
        if deps.Runtime then deps.Runtime:TrackConnection(connection) end
    end
    observe(leftList,"AbsoluteContentSize")
    observe(rightList,"AbsoluteContentSize")
    local lastWidth
    local widthConnection=frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        local width=frame.AbsoluteSize.X
        if width~=lastWidth then lastWidth=width;scheduleRefresh() end
    end)
    if deps.Runtime then
        deps.Runtime:TrackConnection(widthConnection)
        deps.Runtime:TrackCleanup(function() if pending then pcall(task.cancel,pending);pending=nil end end)
    end
    if deps.UIScale then observe(deps.UIScale,"Scale") end
    scheduleRefresh()
    return self
end

return ColumnLayout

end)()
modules["src/renderers/Desktop.lua"] = (function()
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

local Desktop = {}

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function makeDraggable(runtime, frame, handles)
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local dragging, press, start, pointer, ghost, target, glide
    runtime.DragStyle = "Outline"
    local function stopTween()
        if glide then glide:Cancel(); glide=nil end
    end
    local function destroyGhost()
        if ghost then ghost:Destroy();ghost=nil end
    end
    local function begin(input)
        if dragging or not frame.Visible then return end
        if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
        stopTween();destroyGhost()
        dragging=true;pointer=input;press=input.Position;start=frame.Position;target=start
    end
    for _,handle in ipairs(handles) do runtime:TrackConnection(handle.InputBegan:Connect(begin)) end
    runtime:TrackConnection(UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if pointer.UserInputType==Enum.UserInputType.Touch then
            if input~=pointer then return end
        elseif input.UserInputType~=Enum.UserInputType.MouseMovement then return end
        local delta=input.Position-press
        if delta.Magnitude<4 then return end
        local parentSize,size=frame.Parent.AbsoluteSize,frame.AbsoluteSize
        local x=start.X.Scale*parentSize.X+start.X.Offset+delta.X
        local y=start.Y.Scale*parentSize.Y+start.Y.Offset+delta.Y
        target=UDim2.fromOffset(x,y)
        local style=runtime.ReducedMotion and "Direct" or runtime.DragStyle
        if style=="Outline" then
            if not ghost then
                ghost=Instance.new("Frame");ghost.Name="SerenityDragPreview"
                ghost.AnchorPoint=Vector2.new(0.5,0.5);ghost.Size=UDim2.fromOffset(size.X,size.Y)
                ghost.BackgroundColor3=Color3.fromRGB(32,100,140);ghost.BackgroundTransparency=0.93
                ghost.ZIndex=200;ghost.Parent=frame.Parent;ghost.Active=false
                local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,14);c.Parent=ghost
                local stroke=Instance.new("UIStroke");stroke.Color=Color3.fromRGB(93,190,243)
                stroke.Transparency=0.18;stroke.Thickness=1.5;stroke.Parent=ghost
            end
            ghost.Position=target
        elseif style=="Smooth" then
            stopTween();glide=TweenService:Create(frame,TweenInfo.new(0.09,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=target});glide:Play()
        else stopTween();frame.Position=target end
    end))
    local function finish()
        if not dragging then return end
        dragging=false;pointer=nil;destroyGhost();stopTween()
        if target and not runtime.Destroyed then
            if runtime.ReducedMotion or runtime.DragStyle=="Direct" then frame.Position=target
            else glide=TweenService:Create(frame,TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=target});glide:Play() end
        end
    end
    runtime:TrackConnection(UIS.InputEnded:Connect(function(input)
        if dragging and (input==pointer or pointer.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1) then finish() end
    end))
    runtime:TrackConnection(UIS.WindowFocusReleased:Connect(finish))
    runtime:TrackConnection(frame:GetPropertyChangedSignal("Visible"):Connect(function() if not frame.Visible then finish() end end))
    runtime:TrackCleanup(function() dragging=false;destroyGhost();stopTween() end)
end

function Desktop.Mount(deps, options)
    options = options or {}
    local tokens = deps.Tokens
    local runtime = deps.Runtime
    local localPlayer = Players.LocalPlayer

    local parentGui
    pcall(function() if gethui then parentGui = gethui() end end)
    if not parentGui then pcall(function() parentGui = game:GetService("CoreGui") end) end
    if not parentGui then parentGui = localPlayer:WaitForChild("PlayerGui") end

    local screen = runtime:TrackInstance(Instance.new("ScreenGui"))
    screen.Name = options.Name or "SerenityNextM3"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 999999
    screen.Parent = parentGui
    pcall(function() if protect_gui then protect_gui(screen) end end)

    local acrylic = deps.AcrylicEngine and deps.AcrylicEngine.new(runtime, {BasicBlur = options.BlurSize or 3}) or nil

    local holder = Instance.new("Frame")
    holder.AnchorPoint = Vector2.new(0.5, 0.5)
    holder.Position = UDim2.fromScale(0.5, 0.5)
    holder.Size = UDim2.fromOffset(tokens.Size.Window.X, tokens.Size.Window.Y)
    holder.BackgroundTransparency = 1
    holder.Parent = screen

    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 1
    uiScale.Parent = holder

    local function refreshScale()
        -- Keep an open picker stable while the mobile keyboard changes the viewport.
        local focused=UserInputService:GetFocusedTextBox()
        if focused and focused:IsDescendantOf(screen) then return end
        local camera = workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
        local inset = GuiService:GetGuiInset()
        local touchLayout=UserInputService.TouchEnabled and (not UserInputService.KeyboardEnabled or viewport.Y<600)
        if touchLayout then
            -- Keep a complete logical canvas, then fit all of it into the phone.
            -- Shrinking only the frame left desktop-size controls in a short viewport.
            local availableW=math.max(1,viewport.X-32)
            local availableH=math.max(1,viewport.Y-inset.Y-32)
            local scale=math.min(1.35,availableW*0.94/tokens.Size.Window.X,availableH*0.94/tokens.Size.Window.Y)
            local tablet=math.min(viewport.X,viewport.Y)>=600
            local width=tablet and 798 or (viewport.X<viewport.Y and 430 or 700)
            local height=tablet and 546 or 420
            scale=math.min(1.35,availableW*0.94/width,availableH*0.94/height)
            holder.Size=UDim2.fromOffset(width,height)
            uiScale.Scale=scale
        else
            uiScale.Scale = 1
            holder.Size = UDim2.fromOffset(math.min(tokens.Size.Window.X, math.max(320, viewport.X - 24)), math.min(tokens.Size.Window.Y, math.max(240, viewport.Y - inset.Y - 24)))
        end
        deps.PopupManager:Close()
    end
    local cameraConnection
    local function bindCamera()
        if cameraConnection then cameraConnection:Disconnect() end
        if workspace.CurrentCamera then
            cameraConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refreshScale)
        end
        refreshScale()
    end
    runtime:TrackConnection(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera))
    runtime:TrackCleanup(function() if cameraConnection then cameraConnection:Disconnect() end deps.PopupManager:Close() end)
    bindCamera()

    deps.Material.Shadow(holder, UDim2.fromScale(1, 1), tokens.Size.RadiusShell, tokens)

    local shell = Instance.new("Frame")
    shell.Name = "Shell"
    shell.Size = UDim2.fromScale(1, 1)
    shell.ClipsDescendants = true
    shell.ZIndex = 2
    shell.Parent = holder
    deps.Material.Shell(shell, tokens)

    deps.WindowFrame = shell
    deps.UIScale = uiScale

    -- LEFT SIDEBAR ------------------------------------------------------------
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Position = UDim2.fromOffset(0, tokens.Size.Topbar)
    sidebar.Size = UDim2.new(0, tokens.Size.Sidebar, 1, -tokens.Size.Topbar)
    sidebar.ZIndex = 3
    sidebar.Parent = shell
    deps.Material.Sidebar(sidebar, tokens)
    corner(sidebar,tokens.Size.RadiusShell)

    local brand = Instance.new("Frame")
    brand.BackgroundTransparency = 1
    brand.Size = UDim2.new(1, 0, 0, tokens.Size.SidebarBrand)
    brand.ZIndex = 4
    brand.Parent = sidebar
    brand.Visible = false

    local logoWrap = Instance.new("Frame")
    logoWrap.Position = UDim2.fromOffset(14, 14)
    logoWrap.Size = UDim2.fromOffset(38, 38)
    logoWrap.BackgroundColor3 = tokens.Color.Inset
    logoWrap.BackgroundTransparency = 0.05
    logoWrap.BorderSizePixel = 0
    logoWrap.ZIndex = 5
    logoWrap.Parent = brand
    corner(logoWrap, 9)

    local logo = Instance.new("ImageLabel")
    logo.BackgroundTransparency = 1
    logo.Position = UDim2.fromOffset(5, 5)
    logo.Size = UDim2.fromOffset(28, 28)
    logo.Image = "rbxthumb://type=Asset&id=89023606689629&w=420&h=420"
    logo.ScaleType = Enum.ScaleType.Fit
    logo.ZIndex = 6
    logo.Parent = logoWrap

    deps.Typography.Label(brand, "Brand", tokens, options.Title or "SERENITY HUB", UDim2.fromOffset(63, 12), UDim2.new(1, -70, 0, 21), tokens.Color.Text).ZIndex = 5
    local brandSub = deps.Typography.Label(brand, "BrandSub", tokens, options.Subtitle or "Interface Prototype", UDim2.fromOffset(63, 34), UDim2.new(1, -70, 0, 16), tokens.Color.TextDim)
    brandSub.ZIndex = 5

    local navHolder = Instance.new("ScrollingFrame")
    navHolder.Name = "Navigation"
    navHolder.BackgroundTransparency = 1
    navHolder.BorderSizePixel = 0
    navHolder.Position = UDim2.fromOffset(11, tokens.Size.SidebarBrand)
    navHolder.Size = UDim2.new(1, -22, 1, -(tokens.Size.SidebarBrand + tokens.Size.SidebarUser + 8))
    navHolder.CanvasSize = UDim2.new()
    navHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    navHolder.ScrollBarThickness = 0
    navHolder.ZIndex = 4
    navHolder.Parent = sidebar

    local navList = Instance.new("UIListLayout")
    navList.Padding = UDim.new(0, 2)
    navList.SortOrder = Enum.SortOrder.LayoutOrder
    navList.Parent = navHolder

    local userFrame = Instance.new("TextButton")
    userFrame.Name = "UserContext"
    userFrame.AnchorPoint = Vector2.new(0, 1)
    userFrame.Position = UDim2.new(0, 11, 1, -10)
    userFrame.Size = UDim2.new(1, -22, 0, tokens.Size.SidebarUser - 8)
    userFrame.BackgroundColor3 = tokens.Color.PanelSoft
    userFrame.BackgroundTransparency = 0.62
    userFrame.BorderSizePixel = 0
    userFrame.Text = ""
    userFrame.AutoButtonColor = false
    userFrame.ZIndex = 5
    userFrame.Parent = sidebar
    corner(userFrame, 8)

    local avatar = Instance.new("ImageLabel")
    avatar.BackgroundColor3 = tokens.Color.Inset
    avatar.BorderSizePixel = 0
    avatar.Position = UDim2.fromOffset(10, 13)
    avatar.Size = UDim2.fromOffset(34, 34)
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(localPlayer.UserId) .. "&w=150&h=150"
    avatar.ScaleType = Enum.ScaleType.Crop
    avatar.ZIndex = 6
    avatar.Parent = userFrame
    corner(avatar, 17)

    local userNameLabel=deps.Typography.Label(userFrame, "User", tokens, localPlayer.DisplayName, UDim2.fromOffset(54, 11), UDim2.new(1, -78, 0, 19), tokens.Color.Text)
    userNameLabel.ZIndex = 6
    deps.Typography.Label(userFrame, "UserSub", tokens, "UI TESTER", UDim2.fromOffset(54, 31), UDim2.new(1, -78, 0, 16), tokens.Color.TextDim).ZIndex = 6
    local userChevron = deps.Icons.Create(userFrame, "chevron_right", 13, tokens.Color.TextDim)
    userChevron.AnchorPoint = Vector2.new(1, 0.5)
    userChevron.Position = UDim2.new(1, -10, 0.5, 0)
    userChevron.ZIndex = 6

    -- RIGHT TOPBAR ------------------------------------------------------------
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Position = UDim2.fromOffset(0, 0)
    topbar.Size = UDim2.new(1, 0, 0, tokens.Size.Topbar)
    topbar.ZIndex = 3
    topbar.Parent = shell
    deps.Material.Topbar(topbar, tokens)
    corner(topbar,tokens.Size.RadiusShell)

    local saveTile = Instance.new("Frame")
    saveTile.Position = UDim2.fromOffset(15, 15)
    saveTile.Size = UDim2.fromOffset(32, 32)
    saveTile.BackgroundColor3 = tokens.Color.Inset
    saveTile.BackgroundTransparency = 0.10
    saveTile.BorderSizePixel = 0
    saveTile.ZIndex = 4
    saveTile.Parent = topbar
    corner(saveTile, 7)
    local saveIcon = deps.Icons.Create(saveTile, "save", 15, tokens.Color.TextMuted)
    saveIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    saveIcon.Position = UDim2.fromScale(0.5, 0.5)
    saveIcon.ZIndex = 5

    local function createTopSelect(x, width, initial)
        local button = Instance.new("TextButton")
        button.Position = UDim2.fromOffset(x, 13)
        button.Size = UDim2.fromOffset(width, 36)
        button.BackgroundColor3 = tokens.Color.Inset
        button.BackgroundTransparency = 0.34
        button.BorderSizePixel = 0
        button.Text = ""
        button.AutoButtonColor = false
        button.ZIndex = 4
        button.Parent = topbar
        corner(button, 7)

        local text = deps.Typography.Label(button, "TopSelect", tokens, initial, UDim2.fromOffset(12, 0), UDim2.new(1, -34, 1, 0), tokens.Color.TextMuted)
        text.ZIndex = 5
        local chevron = deps.Icons.Create(button, "chevron_down", 12, tokens.Color.TextDim)
        chevron.AnchorPoint = Vector2.new(1, 0.5)
        chevron.Position = UDim2.new(1, -10, 0.5, 0)
        chevron.ZIndex = 5
        return button, text
    end

    saveTile.Visible = false
    local pageButton, pageText = createTopSelect(252, 112, "Dashboard")
    local star = deps.Material.PixelStar(topbar, UDim2.fromOffset(20, 16), 5)
    local heading = deps.Typography.Label(topbar, "Brand", tokens, "SERENITY HUB", UDim2.fromOffset(62, 0), UDim2.fromOffset(182, tokens.Size.Topbar), tokens.Color.Text)
    heading.Font = Enum.Font.GothamBold
    heading.TextSize = 19
    heading.ZIndex = 5
    local scopeButton, scopeText = createTopSelect(170, 108, "Global")
    scopeButton.Visible = false

    local searchButton = Instance.new("TextButton")
    searchButton.AnchorPoint = Vector2.new(1, 0.5)
    searchButton.Position = UDim2.new(1, -51, 0.5, 0)
    searchButton.Size = UDim2.fromOffset(34, 34)
    searchButton.BackgroundTransparency = 1
    searchButton.Text = ""
    searchButton.AutoButtonColor = false
    searchButton.ZIndex = 4
    searchButton.Parent = topbar
    local searchIcon = deps.Icons.Create(searchButton, "search", 17, tokens.Color.TextMuted)
    searchIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    searchIcon.Position = UDim2.fromScale(0.5, 0.5)
    searchIcon.ZIndex = 5

    -- CONTENT -----------------------------------------------------------------
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Position = UDim2.fromOffset(tokens.Size.Sidebar + 14, tokens.Size.Topbar + 10)
    content.Size = UDim2.new(1, -(tokens.Size.Sidebar + 28), 1, -(tokens.Size.Topbar + 22))
    content.ZIndex = 3
    content.Parent = shell

    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.BackgroundTransparency = 1
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.ZIndex = 70
    overlay.Parent = shell
    deps.PopupHost = overlay
    local shield=Instance.new("TextButton")
    shield.Name="PopupInputShield";shield.Text="";shield.AutoButtonColor=false
    shield.BackgroundColor3=Color3.new(0,0,0);shield.BackgroundTransparency=0.75
    shield.Size=UDim2.fromScale(1,1);shield.ZIndex=71;shield.Visible=false
    shield.Active=true;shield.Parent=overlay
    shield.Activated:Connect(function() if serenityInputBlocked(shield) then return end; deps.PopupManager:Close() end)
    local lockedScrollers={}
    deps.PopupManager.OnChange=function(active)
        for frame,enabled in pairs(lockedScrollers) do
            if frame.Parent then frame.ScrollingEnabled=enabled end
        end
        table.clear(lockedScrollers)
        shield.Visible=active~=nil
        for _,child in ipairs(shell:GetChildren()) do
            if child:IsA("GuiObject") and child~=overlay then
                child:SetAttribute("SerenityPopupBlocked",active~=nil)
            end
        end
        if active then
            for _,frame in ipairs(shell:GetDescendants()) do
                if frame:IsA("ScrollingFrame") and not frame:IsDescendantOf(active) then
                    lockedScrollers[frame]=frame.ScrollingEnabled
                    frame.ScrollingEnabled=false
                end
            end
        end
    end
    -- Edge treatment sits above the surfaces, without a shadow image.
    local rim=Instance.new("Frame")
    rim.Name="GlassRim"
    rim.BackgroundTransparency=1
    rim.Size=UDim2.new(1,-4,1,-4)
    rim.Position=UDim2.fromOffset(2,2)
    rim.ZIndex=69
    rim.Parent=shell
    corner(rim,tokens.Size.RadiusShell-2)
    local edge=Instance.new("UIStroke")
    edge.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    edge.Color=tokens.Color.Stroke
    edge.Thickness=1.4
    edge.Transparency=0.22
    edge.Parent=rim
    local edgeFade=Instance.new("UIGradient")
    edgeFade.Rotation=65
    edgeFade.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.05),
        NumberSequenceKeypoint.new(0.45,0.65),
        NumberSequenceKeypoint.new(1,0.12)
    })
    edgeFade.Parent=edge

    makeDraggable(runtime, holder, {topbar, heading})

    local pages = {}
    local navItems = {}
    local groups = {}
    local currentPage

    local app = {
        ScreenGui = screen,
        Holder = holder,
        Shell = shell,
        Sidebar = sidebar,
        Content = content,
        Overlay = overlay,
        Pages = pages,
        SearchButton = searchButton,
        PageButton = pageButton,
        ScopeButton = scopeButton,
        Acrylic = acrylic,
        ProfileButton = userFrame,
        IdentityAvatar = avatar,
        IdentityName = userNameLabel,
    }

    local function addGroupLabel(name, order)
        if not name or name == "" or groups[name] then return end
        groups[name] = true
        local label = deps.Typography.Label(navHolder, "NavGroup", tokens, string.upper(name), UDim2.new(), UDim2.new(1, 0, 0, tokens.Size.NavGroup), tokens.Color.TextDim)
        label.LayoutOrder = order
        label.TextYAlignment = Enum.TextYAlignment.Bottom
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 8)
        pad.PaddingBottom = UDim.new(0, 3)
        pad.Parent = label
    end

    function app:AddPage(props)
        props = props or {}
        local id = props.Id or props.Title
        local accent = props.Accent or tokens.Color.Accent
        local order = (props.Order or (#navItems + 1)) + 4

        if props.Group then addGroupLabel(props.Group, order * 10 - 1) end

        local page = Instance.new("ScrollingFrame")
        page.Name = id
        page.Visible = false
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.Size = UDim2.fromScale(1, 1)
        page.CanvasSize = UDim2.new()
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = accent
        page.ScrollBarImageTransparency = 0.56
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.Parent = content
        runtime:TrackConnection(page:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            if app.OnViewChanged then app.OnViewChanged() end
        end))

        local padding = Instance.new("UIPadding")
        padding.PaddingRight = UDim.new(0, 5)
        padding.PaddingBottom = UDim.new(0, 8)
        padding.Parent = page

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 10)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Parent = page

        local navItem = deps.NavItem.new(navHolder, deps, {
            Id = id,
            Title = props.Title or id,
            Icon = props.Icon or "info",
            Accent = accent,
            Order = order * 10,
            Callback = function() app:SelectPage(id) end,
        })

        local entry = {Id = id, Page = page, NavItem = navItem, Accent = accent, Title = props.Title or id}
        pages[id] = entry
        table.insert(navItems, entry)

        if not currentPage then app:SelectPage(id) end
        return page
    end

    function app:SelectPage(id)
        local target = pages[id]
        if not target then return end
        deps.PopupManager:Close()
        local changed=currentPage~=id
        currentPage = id
        if app.OnViewChanged then app.OnViewChanged() end
        pageText.Text = target.Title
        for pageId, entry in pairs(pages) do
            local selected = pageId == id
            if entry.Transition then entry.Transition:Cancel();entry.Transition=nil end
            entry.Page.Position=UDim2.fromOffset(0,0)
            entry.Page.Visible = selected
            entry.NavItem:SetSelected(selected)
            if selected and changed and not deps.Motion.Reduced then
                entry.Page.Position=UDim2.fromOffset(0,4)
                entry.Transition=deps.Motion:Tween(entry.Page,"Select",{Position=UDim2.fromOffset(0,0)})
            end
        end
    end

    function app:GetViewState()
        local positions={}
        for id,entry in pairs(pages) do positions[id]=entry.Page.CanvasPosition.Y end
        return {Page=currentPage,Positions=positions}
    end
    function app:RestoreViewState(view)
        if type(view)~="table" then return end
        if type(view.Page)=="string" and pages[view.Page] then self:SelectPage(view.Page) end
        task.defer(function()
            if runtime.Destroyed then return end
            if type(view.Positions)~="table" then return end
            for id,y in pairs(view.Positions) do
                local entry=pages[id]
                if entry and type(y)=="number" and y==y and math.abs(y)<1000000 then
                    local maximum=math.max(0,entry.Page.AbsoluteCanvasSize.Y-entry.Page.AbsoluteWindowSize.Y)
                    entry.Page.CanvasPosition=Vector2.new(0,math.clamp(y,0,maximum))
                end
            end
        end)
    end
    runtime:TrackCleanup(function()
        deps.PopupManager:Close()
        for _,entry in pairs(pages) do if entry.Transition then entry.Transition:Cancel() end end
    end)
    function app:SetGlassQuality(quality)
        if acrylic then acrylic:SetQuality(quality) end
    end

    function app:SetBlur(enabled)
        if acrylic then acrylic:SetEnabled(enabled) end
    end

    function app:SetVisible(visible)
        deps.PopupManager:Close()
        holder.Visible = visible
        if acrylic then acrylic:SetVisible(visible) end
    end

    local minimize = Instance.new("TextButton")
    minimize.Size = UDim2.fromOffset(28, 28)
    minimize.Position = UDim2.new(1, -40, 0.5, -14)
    minimize.BackgroundTransparency = 1
    minimize.Text = "−"
    minimize.TextSize = 24
    minimize.TextColor3 = tokens.Color.TextMuted
    minimize.ZIndex = 5
    minimize.Parent = topbar
    local restore = Instance.new("TextButton")
    restore.Name = "SerenityRestore"
    restore.Size = UDim2.fromOffset(44, 44)
    restore.Position = UDim2.new(0, 12, 0.5, -25.41)
    restore.Text = ""
    restore.AutoButtonColor = false
    restore.BorderSizePixel = 0
    restore.BackgroundColor3 = tokens.Color.Inset
    restore.Visible = true
    restore.ZIndex = 90
    restore.Parent = screen
    local restoreScale=Instance.new("UIScale");restoreScale.Scale=1.155;restoreScale.Parent=restore
    corner(restore, 12)
    local restoreEdge=Instance.new("UIStroke");restoreEdge.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    restoreEdge.Color=tokens.Color.Lavender;restoreEdge.Transparency=0.65;restoreEdge.Thickness=1;restoreEdge.Parent=restore
    local tileSheen=Instance.new("UIGradient");tileSheen.Rotation=65
    tileSheen.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(165,165,165));tileSheen.Parent=restore
    local emblem=Instance.new("Frame");emblem.Name="CelestialEmblem"
    emblem.ZIndex=91;emblem.BackgroundTransparency=1;emblem.AnchorPoint=Vector2.new(0.5,0.5)
    emblem.Position=UDim2.fromScale(0.5,0.5);emblem.Size=UDim2.fromOffset(44,44);emblem.Parent=restore
    local emblemScale=Instance.new("UIScale");emblemScale.Parent=emblem
    local restoreStar=deps.Material.Star(emblem,UDim2.fromOffset(22,22),30,tokens.Color.Text,92)
    restoreStar.AnchorPoint=Vector2.new(0.5,0.5)
    local idleScale=Instance.new("UIScale");idleScale.Parent=restoreStar
    local idleTween
    function app:RefreshIconMotion()
        if self.RefreshBrandMotion then self:RefreshBrandMotion() end
        if idleTween then idleTween:Cancel();idleTween=nil end
        idleScale.Scale=1
        if not deps.Motion.Reduced and not runtime.Destroyed and not self.MotionSuspended then
            idleTween=game:GetService("TweenService"):Create(idleScale,TweenInfo.new(1.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Scale=1.045})
            idleTween:Play()
        end
    end
    runtime:TrackCleanup(function() if idleTween then idleTween:Cancel();idleTween=nil end end)
    app:RefreshIconMotion()
    local glint=Instance.new("Frame");glint.Name="TileHighlight"
    glint.Size=UDim2.new(1,-22,0,1);glint.Position=UDim2.fromOffset(11,2)
    glint.ZIndex=91;glint.BackgroundColor3=tokens.Color.Text;glint.BackgroundTransparency=0.82;glint.BorderSizePixel=0;glint.Parent=restore
    local statusDock=Instance.new("TextButton")
    statusDock.Name="SerenityStatusDock"
    statusDock.AnchorPoint=Vector2.new(0.5,0)
    statusDock.Position=UDim2.new(0.5,0,0,8)
    statusDock.Size=UDim2.fromOffset(0,52)
    statusDock.BackgroundColor3=tokens.Color.ShellDeep:Lerp(Color3.new(0,0,0),0.6)
    statusDock.BackgroundTransparency=0
    statusDock.BorderSizePixel=0;statusDock.Text=""
    statusDock.AutoButtonColor=false;statusDock.ClipsDescendants=true
    statusDock.Visible=false;statusDock.ZIndex=88;statusDock.Parent=screen
    corner(statusDock,24)
    local dockEdge=Instance.new("UIStroke");dockEdge.Color=tokens.Color.Stroke
    dockEdge.Transparency=0.72;dockEdge.Parent=statusDock
    -- Compact live activity: one title, one metric line, and a quiet activity glyph.
    local statusRow=Instance.new("Frame")
    statusRow.BackgroundTransparency=1;statusRow.Size=UDim2.fromScale(1,1)
    statusRow.ZIndex=89;statusRow.Parent=statusDock
    local activityTile=Instance.new("Frame")
    activityTile.BackgroundColor3=tokens.Color.Accent;activityTile.BackgroundTransparency=0.88
    activityTile.BorderSizePixel=0;activityTile.Size=UDim2.fromOffset(30,30)
    activityTile.Position=UDim2.fromOffset(10,9);activityTile.ZIndex=90;activityTile.Parent=statusRow
    corner(activityTile,10)
    local activityBars={}
    for i=1,4 do
        local bar=Instance.new("Frame");bar.BorderSizePixel=0
        bar.BackgroundColor3=tokens.Color.Accent;bar.AnchorPoint=Vector2.new(0,0.5)
        bar.Position=UDim2.new(0,6+(i-1)*5,0.5,0);bar.Size=UDim2.fromOffset(3,6+i*2)
        bar.ZIndex=91;bar.Parent=activityTile;corner(bar,2);activityBars[i]=bar
    end
    local dockActivity=deps.Typography.Label(statusRow,"Control",tokens,"Auto clicker",UDim2.fromOffset(50,6),UDim2.new(1,-108,0,19),tokens.Color.Text)
    dockActivity.TextSize=13;dockActivity.Font=Enum.Font.GothamSemibold
    dockActivity.TextTruncate=Enum.TextTruncate.AtEnd;dockActivity.ZIndex=90
    local dockMetrics=deps.Typography.Label(statusRow,"Control",tokens,"0 clicks  ·  0 rewards",UDim2.fromOffset(50,25),UDim2.new(1,-65,0,16),tokens.Color.TextMuted)
    dockMetrics.TextSize=11;dockMetrics.ZIndex=90;dockMetrics.TextTruncate=Enum.TextTruncate.AtEnd
    local dockTime=deps.Typography.Label(statusRow,"Control",tokens,"0s",UDim2.new(1,-52,0,8),UDim2.fromOffset(37,17),tokens.Color.Accent)
    dockTime.TextSize=11;dockTime.TextXAlignment=Enum.TextXAlignment.Right;dockTime.ZIndex=90
    local statusEvent=Instance.new("Frame");statusEvent.BackgroundTransparency=1
    statusEvent.Size=UDim2.fromScale(1,1);statusEvent.Visible=false;statusEvent.ZIndex=89;statusEvent.Parent=statusDock
    local eventIcon=deps.Icons.Create(statusEvent,"inventory",26,tokens.Color.Mint,UDim2.fromOffset(16,23));eventIcon.ZIndex=90
    local eventTitle=deps.Typography.Label(statusEvent,"Control",tokens,"",UDim2.fromOffset(54,15),UDim2.new(1,-68,0,21),tokens.Color.Text)
    eventTitle.Font=Enum.Font.GothamBold;eventTitle.TextSize=14;eventTitle.ZIndex=90
    local eventBody=deps.Typography.Label(statusEvent,"Control",tokens,"",UDim2.fromOffset(54,38),UDim2.new(1,-68,0,30),tokens.Color.TextMuted)
    eventBody.TextSize=12;eventBody.TextWrapped=true;eventBody.TextYAlignment=Enum.TextYAlignment.Top;eventBody.ZIndex=90
    local statusExpanded=false
    local statusDetails={"No active task", "Start a demo from Playground"}
    local details=Instance.new("Frame");details.BackgroundTransparency=1
    details.Position=UDim2.fromOffset(14,49);details.Size=UDim2.new(1,-28,0,60)
    details.Visible=false;details.ZIndex=90;details.Parent=statusRow
    local detailText=deps.Typography.Label(details,"Control",tokens,table.concat(statusDetails,"\n"),UDim2.fromOffset(0,0),UDim2.new(1,0,0,37),tokens.Color.TextMuted)
    detailText.TextSize=12;detailText.TextWrapped=true;detailText.TextYAlignment=Enum.TextYAlignment.Top;detailText.ZIndex=91
    local detailRestore=Instance.new("TextButton");detailRestore.Size=UDim2.fromOffset(96,23)
    detailRestore.Position=UDim2.new(1,-96,0,37);detailRestore.Text="Open main UI  ›";detailRestore.TextSize=11
    detailRestore.Font=Enum.Font.GothamMedium;detailRestore.TextColor3=tokens.Color.Accent
    detailRestore.BackgroundTransparency=1;detailRestore.AutoButtonColor=false
    detailRestore.ZIndex=92;detailRestore.Parent=details
    local detailToggle=Instance.new("TextButton");detailToggle.Text="";detailToggle.BackgroundTransparency=1
    detailToggle.Size=UDim2.fromOffset(30,25);detailToggle.Position=UDim2.new(1,-37,0,23)
    detailToggle.ZIndex=92;detailToggle.Parent=statusRow;detailToggle.AutoButtonColor=false
    local chevron=Instance.new("Frame");chevron.BackgroundTransparency=1;chevron.Size=UDim2.fromOffset(10,6)
    chevron.Position=UDim2.fromOffset(10,9);chevron.ZIndex=93;chevron.Parent=detailToggle
    for i=1,2 do
        local bar=Instance.new("Frame");bar.BorderSizePixel=0;bar.Size=UDim2.fromOffset(6,2)
        bar.Position=UDim2.fromOffset((i-1)*4,2);bar.Rotation=i==1 and 40 or -40
        bar.BackgroundColor3=tokens.Color.TextMuted;bar.ZIndex=93;bar.Parent=chevron
    end
    dockMetrics.Size=UDim2.new(1,-95,0,16)
    function app:SetStatusDetails(lines)
        assert(type(lines)=="table","SetStatusDetails expects an array of strings")
        statusDetails={}
        for i=1,math.min(2,#lines) do statusDetails[i]=tostring(lines[i]):sub(1,95) end
        detailText.Text=table.concat(statusDetails,"\n")
    end
    local statusNoticeActive=false
    local statusNoticeTimer
    local statusRunning=true
    function app:SetStatus(value,stage)
        local text=tostring(value or "Auto clicker")
        dockActivity.Text=text:gsub(" · DEMO", ""):sub(1,80)
        statusRunning=stage~=3 and not text:lower():find("paused",1,true)
        if not statusRunning then
            for _,bar in ipairs(activityBars) do deps.Motion:Tween(bar,0.15,{Size=UDim2.fromOffset(3,4)}) end
        end
    end
    function app:SetStatusMetrics(clicks,seconds,rewards)
        dockMetrics.Text=tostring(clicks or 0).." clicks  ·  "..tostring(rewards or 0).." rewards"
        dockTime.Text=tostring(seconds or 0).."s"
        -- Reuse the bounded demo's updates; no perpetual animation or render loop.
        if statusRunning and statusDock.Visible and not statusNoticeActive and not deps.Motion.Reduced then
            for i,bar in ipairs(activityBars) do
                deps.Motion:Tween(bar,0.18,{Size=UDim2.fromOffset(3,5+((math.floor(clicks or 0)+i*3)%12))})
            end
        end
    end
    function app:IsMinimized() return not holder.Visible or self._Minimizing==true end
    local windowTween,windowScaleTween,dockTween,transition= nil,nil,nil,0
    local expandedPosition,expandedScale=holder.Position,uiScale.Scale
    local function cancelTransition()
        if windowTween then windowTween:Cancel();windowTween=nil end
        if windowScaleTween then windowScaleTween:Cancel();windowScaleTween=nil end
        if dockTween then dockTween:Cancel();dockTween=nil end
    end
    local function iconCenter()
        return UDim2.fromOffset(statusDock.AbsolutePosition.X-screen.AbsolutePosition.X+statusDock.AbsoluteSize.X/2,statusDock.AbsolutePosition.Y-screen.AbsolutePosition.Y+statusDock.AbsoluteSize.Y/2)
    end
    local function dockSize()
        return UDim2.fromOffset(math.min((statusNoticeActive or statusExpanded) and 304 or 244,math.max(120,screen.AbsoluteSize.X-24)),statusNoticeActive and 78 or (statusExpanded and 112 or 52))
    end
    local function expandStatus(value)
        statusExpanded=value;details.Visible=value;deps.Motion:Tween(chevron,0.16,{Rotation=value and 180 or 0})
        if statusDock.Visible then
            if dockTween then dockTween:Cancel() end
            dockTween=deps.Motion:Tween(statusDock,0.22,{Size=dockSize()},Enum.EasingStyle.Quint)
        end
    end
    detailToggle.Activated:Connect(function() expandStatus(not statusExpanded) end)
    detailRestore.Activated:Connect(function() app:SetVisible(true) end)
    function app:StatusNotice(title,message,duration)
        if runtime.Destroyed then return end
        if statusNoticeTimer then pcall(task.cancel,statusNoticeTimer) end
        statusNoticeActive=true;statusRow.Visible=false;dockActivity.Visible=false;statusEvent.Visible=true
        eventTitle.Text=tostring(title or "Update"):sub(1,60)
        eventBody.Text=tostring(message or ""):sub(1,140)
        local function resize()
            if statusDock.Visible then
                if dockTween then dockTween:Cancel() end
                dockTween=deps.Motion:Tween(statusDock,0.24,{Size=dockSize()},Enum.EasingStyle.Quint)
            end
        end
        resize()
        statusNoticeTimer=task.delay(math.clamp(tonumber(duration) or 3,1,10),function()
            statusNoticeTimer=nil
            if runtime.Destroyed then return end
            statusNoticeActive=false;statusEvent.Visible=false;statusRow.Visible=true;dockActivity.Visible=true
            resize()
        end)
    end
    runtime:TrackCleanup(function() if statusNoticeTimer then pcall(task.cancel,statusNoticeTimer) end end)
    local function showDock()
        statusDock.Visible=true
        if app.OnMinimized then app.OnMinimized() end
        statusDock.Size=UDim2.fromOffset(0,52)
        if deps.Motion.Reduced then statusDock.Size=dockSize();return end
        dockTween=game:GetService("TweenService"):Create(statusDock,TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=dockSize()})
        dockTween:Play()
    end
    function app:SetVisible(visible)
        if runtime.Destroyed then return end
        visible=visible==true
        transition=transition+1
        local current=transition
        cancelTransition()
        expandStatus(false)
        deps.PopupManager:Close()
        if visible then
            self._Minimizing=false
            if not holder.Visible and math.abs(uiScale.Scale-expandedScale)>0.001 then
                -- An orientation or viewport change recalculated the hidden window size.
                expandedPosition=holder.Position;expandedScale=uiScale.Scale
            end
            if statusDock.Visible then
                if deps.Motion.Reduced then statusDock.Visible=false
                else
                    dockTween=game:GetService("TweenService"):Create(statusDock,TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.fromOffset(0,52)})
                    dockTween:Play()
                    dockTween.Completed:Once(function() if transition==current then statusDock.Visible=false end end)
                end
            end
            if not holder.Visible then
                holder.Position=iconCenter()
                uiScale.Scale=0.08
                holder.Visible=true
            end
            if acrylic then acrylic:SetVisible(true) end
            if deps.Motion.Reduced then
                holder.Position=expandedPosition;uiScale.Scale=expandedScale
            else
                windowTween=game:GetService("TweenService"):Create(holder,TweenInfo.new(0.34,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=expandedPosition})
                windowScaleTween=game:GetService("TweenService"):Create(uiScale,TweenInfo.new(0.34,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Scale=expandedScale})
                windowTween:Play();windowScaleTween:Play()
            end
        else
            if not self._Minimizing then
                expandedPosition=holder.Position;expandedScale=uiScale.Scale
            end
            self._Minimizing=true
            if acrylic then acrylic:SetVisible(false) end
            if deps.Motion.Reduced then
                holder.Visible=false;holder.Position=expandedPosition;uiScale.Scale=expandedScale
                showDock()
            else
                windowTween=game:GetService("TweenService"):Create(holder,TweenInfo.new(0.29,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Position=iconCenter()})
                windowScaleTween=game:GetService("TweenService"):Create(uiScale,TweenInfo.new(0.29,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Scale=0.08})
                windowTween.Completed:Once(function()
                    if runtime.Destroyed or transition~=current then return end
                    if windowScaleTween then windowScaleTween:Cancel();windowScaleTween=nil end
                    holder.Visible=false
                    holder.Position=expandedPosition;uiScale.Scale=expandedScale
                    showDock()
                end)
                windowTween:Play();windowScaleTween:Play()
            end
        end
    end
    runtime:TrackCleanup(cancelTransition)
    local statusDragHandle=Instance.new("TextButton")
    statusDragHandle.Name="StatusDragHandle";statusDragHandle.Text="";statusDragHandle.AutoButtonColor=false
    statusDragHandle.BackgroundTransparency=1;statusDragHandle.Size=UDim2.new(1,-38,0,52)
    statusDragHandle.Active=true;statusDragHandle.ZIndex=94;statusDragHandle.Parent=statusDock
    local statusRestoreGate=0
    local function activateStatus()
        if app.StatusClickSuppressed and app:StatusClickSuppressed() then return end
        if os.clock()<statusRestoreGate then return end
        statusRestoreGate=os.clock()+0.2
        if deps.PlayUISound then deps.PlayUISound() end
        app:SetVisible(true)
    end
    statusDock.Activated:Connect(activateStatus)
    statusDragHandle.Activated:Connect(activateStatus)
    statusDock.MouseEnter:Connect(function() if serenityInputBlocked(statusDock) then return end; deps.Motion:Tween(dockEdge,"Hover",{Transparency=0.3});if not UserInputService.TouchEnabled and not (app.StatusClickSuppressed and app:StatusClickSuppressed()) then expandStatus(true) end end)
    statusDock.MouseLeave:Connect(function() deps.Motion:Tween(dockEdge,"Hover",{Transparency=0.72});if not UserInputService.TouchEnabled then expandStatus(false) end end)
    do
        local pointer,press,holdTimer,follow,settle
        local dragging=false
        local suppressUntil=0
        local originX,originY,currentX,currentY,targetX,targetY
        function app:StatusClickSuppressed() return dragging or os.clock()<suppressUntil end
        local function cancelHold()
            if holdTimer then pcall(task.cancel,holdTimer);holdTimer=nil end
        end
        local function stopFollow()
            if follow then follow:Disconnect();follow=nil end
        end
        local function stopSettle()
            if settle then settle:Cancel();settle=nil end
        end
        local function finishStatusDrag()
            cancelHold();pointer=nil;stopFollow()
            if dragging then
                suppressUntil=os.clock()+0.4
                stopSettle()
                settle=deps.Motion:Tween(statusDock,0.1,{Position=UDim2.fromOffset(targetX,targetY)},Enum.EasingStyle.Quad)
            end
            dragging=false
            deps.Motion:Tween(dockEdge,0.15,{Transparency=0.72})
        end
        local function beginStatusDrag(input)
            if pointer or (input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch) then return end
            pointer=input;press=input.Position;dragging=false
            holdTimer=task.delay(0.35,function()
                holdTimer=nil
                if runtime.Destroyed or not pointer or not statusDock.Visible then return end
                stopSettle()
                local point=statusDock.AbsolutePosition-screen.AbsolutePosition
                -- Capture the anchor once; changing capsule width must not shift its drag origin.
                originX=point.X+statusDock.AbsoluteSize.X/2;originY=point.Y
                currentX,currentY=originX,originY;targetX,targetY=originX,originY
                dragging=true;suppressUntil=os.clock()+0.5
                expandStatus(false)
                deps.Motion:Tween(dockEdge,0.1,{Transparency=0.15})
                follow=game:GetService("RunService").RenderStepped:Connect(function(dt)
                    if runtime.Destroyed then stopFollow();return end
                    local alpha=deps.Motion.Reduced and 1 or (1-math.exp(-30*dt))
                    currentX=currentX+(targetX-currentX)*alpha
                    currentY=currentY+(targetY-currentY)*alpha
                    statusDock.Position=UDim2.fromOffset(currentX,currentY)
                end)
            end)
        end
        runtime:TrackConnection(statusDock.InputBegan:Connect(beginStatusDrag))
        runtime:TrackConnection(statusDragHandle.InputBegan:Connect(beginStatusDrag))
        runtime:TrackConnection(UserInputService.InputChanged:Connect(function(input)
            if not pointer or not dragging then return end
            if pointer.UserInputType==Enum.UserInputType.Touch and input~=pointer then return end
            if pointer.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.MouseMovement then return end
            local delta=input.Position-press
            targetX=originX+delta.X;targetY=originY+delta.Y
        end))
        runtime:TrackConnection(UserInputService.InputEnded:Connect(function(input)
            if input==pointer then finishStatusDrag() end
        end))
        runtime:TrackConnection(UserInputService.WindowFocusReleased:Connect(finishStatusDrag))
        runtime:TrackCleanup(function() cancelHold();stopFollow();stopSettle();pointer=nil;dragging=false end)
    end
    local function restoreFeedback(active)
        deps.Motion:Tween(restore,"Hover",{BackgroundColor3=active and tokens.Color.InsetHover or tokens.Color.Inset})
        deps.Motion:Tween(restoreEdge,"Hover",{Transparency=active and 0.25 or 0.65})
        deps.Motion:Tween(emblemScale,"Hover",{Scale=(active and not deps.Motion.Reduced) and 1.06 or 1})
    end
    runtime:TrackConnection(restore.MouseEnter:Connect(function() if serenityInputBlocked(restore) then return end; restoreFeedback(true) end))
    runtime:TrackConnection(restore.MouseLeave:Connect(function() restoreFeedback(false) end))
    runtime:TrackConnection(restore.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            restoreFeedback(true)
        end
    end))
    runtime:TrackConnection(restore.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            restoreFeedback(false)
        end
    end))
    local iconPointer,iconPress,iconStart
    local iconDragged=false
    local suppressIconClickUntil=0
    local function placeIcon(position)
        restore.Position=UDim2.fromOffset(position.X,position.Y)
    end
    runtime:TrackConnection(restore.InputBegan:Connect(function(input)
        if iconPointer or (input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch) then return end
        iconPointer=input;iconPress=input.Position;iconDragged=false
        iconStart=restore.AbsolutePosition-screen.AbsolutePosition
    end))
    runtime:TrackConnection(UserInputService.InputChanged:Connect(function(input)
        if not iconPointer then return end
        if iconPointer.UserInputType==Enum.UserInputType.Touch then
            if input~=iconPointer then return end
        elseif input.UserInputType~=Enum.UserInputType.MouseMovement then return end
        local delta=input.Position-iconPress
        if delta.Magnitude<6 then return end
        iconDragged=true
        suppressIconClickUntil=os.clock()+0.35
        placeIcon(iconStart+Vector2.new(delta.X,delta.Y))
    end))
    runtime:TrackConnection(UserInputService.InputEnded:Connect(function(input)
        if input~=iconPointer then return end
        iconPointer=nil;restoreFeedback(false)
        if iconDragged then suppressIconClickUntil=os.clock()+0.35 end
        iconDragged=false
    end))
    runtime:TrackConnection(screen:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        placeIcon(restore.AbsolutePosition-screen.AbsolutePosition)
        if statusDock.Visible and app:IsMinimized() then
            if dockTween then dockTween:Cancel();dockTween=nil end
            statusDock.Size=dockSize()
        end
    end))
    function app:ResetFloatingPositions()
        holder.Position=UDim2.fromScale(0.5,0.5)
        expandedPosition=holder.Position
        statusDock.Position=UDim2.new(0.5,0,0,8)
        restore.Position=UDim2.new(0,12,0.5,-25)
        if self.ResetQuickPanelPositions then self:ResetQuickPanelPositions() end
        if not holder.Visible then self:SetVisible(true) end
    end
    minimize.Activated:Connect(function() if serenityInputBlocked(minimize) then return end;
        if deps.PlayUISound then deps.PlayUISound() end
        app:SetVisible(false)
        emblemScale.Scale=deps.Motion.Reduced and 1 or 0.85
        emblem.Rotation=deps.Motion.Reduced and 0 or -8
        deps.Motion:Tween(emblemScale,0.24,{Scale=1})
        deps.Motion:Tween(emblem,0.24,{Rotation=0})
    end)
    local lastRestoreTap=0
    restore.Activated:Connect(function() if serenityInputBlocked(restore) then return end;
        if iconDragged or os.clock()<suppressIconClickUntil then return end
        local now=os.clock()
        if lastRestoreTap>0 and now-lastRestoreTap<0.4 then
            lastRestoreTap=0;app:ResetFloatingPositions();return
        end
        lastRestoreTap=now
        if deps.PlayUISound then deps.PlayUISound() end
        app:SetVisible(app:IsMinimized())
    end)

    do
        local actions,order,observers={},{},{}
        local capturing,captureTimer
        local function sizePanel(action)
            local width=action.Minimized and 170 or 272
            local height=action.Minimized and 36 or (action.PanelBuilder and 106 or 64)
            action.Panel.Size=UDim2.fromOffset(math.min(width,math.max(100,screen.AbsoluteSize.X-12)),height)
            action.Body.Visible=not action.Minimized;action.Caption.Visible=not action.Minimized;action.KeyButton.Visible=not action.Minimized
            action.Collapse.Text=action.Minimized and "+" or "−"
        end
        local function render(action)
            action.Panel.Visible=action.PanelEnabled
            action.Caption.Text=action.Busy and "Applying change…" or (action.Value and "On · drag to move" or "Off · ready to enable")
            action.KeyButton.Text=capturing==action and "Press key" or (action.KeyCode and action.KeyCode.Name or "Bind key")
            action.Switch.BackgroundColor3=action.Value and tokens.Color.Accent or tokens.Color.Inset
            action.Dot.Position=UDim2.fromOffset(action.Value and 16 or 3,3)
            action.Switch.Active=not action.Busy
            for _,fn in ipairs(observers[action.Id] or {}) do pcall(fn,action) end
        end
        function app:SetQuickPanelEnabled(id,value)
            local action=actions[id];if not action or action.Busy then return false end
            value=value==true
            if not value and action.Value then
                action.HideAfterDisable=true
                return self:SetQuickAction(id,false)
            end
            local changed=action.PanelEnabled~=value
            action.PanelEnabled=value;render(action)
            if changed and value and self.Notify then self:Notify(action.Title.." panel","Use its switch to turn the feature on or off.",2,"Info") end
            return true
        end
        local function setKey(action,key)
            if key~=nil then
                if typeof(key)~="EnumItem" or key.EnumType~=Enum.KeyCode or key==Enum.KeyCode.Unknown or key==Enum.KeyCode.RightControl or key==Enum.KeyCode.Escape then return false,"Reserved key" end
                for _,id in ipairs(order) do
                    if actions[id]~=action and actions[id].KeyCode==key then return false,"Already assigned" end
                end
            end
            action.KeyCode=key;render(action);return true
        end
        function app:SetQuickActionKey(id,key)
            local action=actions[id];if not action then return false,"Unknown action" end
            return setKey(action,key)
        end
        function app:SetQuickPanelMinimized(id,value)
            local action=actions[id];if not action then return false end
            action.Minimized=value==true;sizePanel(action);return true
        end
        function app:GetQuickAction(id) return actions[id] end
        function app:ObserveQuickAction(id,fn)
            assert(type(fn)=="function","ObserveQuickAction needs a callback")
            observers[id]=observers[id] or {};table.insert(observers[id],fn)
            if actions[id] then fn(actions[id]) end
        end
        function app:SetQuickAction(id,value,silent)
            local action=actions[id];if not action or action.Busy then return false end
            value=value==true
            if value and not action.PanelEnabled and not silent then return false end
            if action.Value==value then return true end
            if silent then action.Value=value;render(action);return true end
            action.Busy=true;render(action)
            task.spawn(function()
                local ok,result,reason=pcall(action.Callback,value)
                if runtime.Destroyed then return end
                action.Busy=false
                if ok and result~=false then
                    action.Value=value
                    if action.HideAfterDisable and not value then action.PanelEnabled=false end
                elseif app.Notify then app:Notify(action.Title,ok and tostring(reason or "Action unavailable") or "Could not apply this action.",4,"Info") end
                action.HideAfterDisable=nil
                render(action)
            end)
            return true
        end
        -- Register only supported game actions. Panel(body, app, action) adds optional feature controls.
        function app:RegisterQuickAction(options)
            assert(type(options)=="table" and type(options.Id)=="string" and type(options.Callback)=="function","Quick action needs Id and Callback")
            assert(not actions[options.Id],"Quick action already registered: "..options.Id)
            assert(options.Panel==nil or type(options.Panel)=="function","Panel must be a builder function")
            local action={Id=options.Id,Title=options.Title or options.Id,Value=options.Default==true,Callback=options.Callback,Busy=false,PanelEnabled=options.PanelEnabled==true,Minimized=false,PanelBuilder=options.Panel}
            local panel=Instance.new("Frame");panel.Name="FeaturePanel_"..action.Id
            panel.Position=UDim2.new(0,14,0.5,(#order)*72-110);panel.Size=UDim2.fromOffset(272,64)
            panel.BackgroundColor3=tokens.Color.ShellDeep;panel.BackgroundTransparency=0.02
            panel.BorderSizePixel=0;panel.Active=true;panel.ZIndex=100;panel.Parent=screen
            corner(panel,7)
            local edge=Instance.new("UIStroke");edge.Color=tokens.Color.Stroke;edge.Transparency=0.4;edge.Parent=panel
            local accent=Instance.new("Frame");accent.Size=UDim2.fromOffset(3,16);accent.Position=UDim2.fromOffset(0,10)
            accent.BorderSizePixel=0;accent.BackgroundColor3=tokens.Color.Accent;accent.ZIndex=101;accent.Parent=panel
            local title=deps.Typography.Label(panel,"Control",tokens,action.Title,UDim2.fromOffset(13,0),UDim2.new(1,-100,0,36),tokens.Color.Text)
            title.TextSize=13;title.Font=Enum.Font.GothamSemibold;title.Active=true;title.ZIndex=101;title.TextTruncate=Enum.TextTruncate.AtEnd
            local caption=deps.Typography.Label(panel,"Control",tokens,"Enabled · drag to move",UDim2.fromOffset(13,35),UDim2.new(1,-105,0,21),tokens.Color.TextMuted)
            caption.TextSize=11;caption.ZIndex=101
            local collapse=Instance.new("TextButton");collapse.Text="−";collapse.TextSize=19
            collapse.BackgroundTransparency=1;collapse.TextColor3=tokens.Color.TextMuted;collapse.AutoButtonColor=false
            collapse.Size=UDim2.fromOffset(28,30);collapse.Position=UDim2.new(1,-83,0,3);collapse.ZIndex=102;collapse.Parent=panel
            local switch=Instance.new("TextButton");switch.Text="";switch.AutoButtonColor=false
            switch.Size=UDim2.fromOffset(32,19);switch.Position=UDim2.new(1,-44,0,9)
            switch.BorderSizePixel=0;switch.ZIndex=102;switch.Parent=panel;corner(switch,4)
            local dot=Instance.new("Frame");dot.Size=UDim2.fromOffset(13,13);dot.BackgroundColor3=tokens.Color.Text
            dot.BorderSizePixel=0;dot.ZIndex=103;dot.Parent=switch;corner(dot,2)
            local body=Instance.new("Frame");body.BackgroundTransparency=1
            body.Position=UDim2.fromOffset(12,62);body.Size=UDim2.new(1,-24,0,36);body.ZIndex=101;body.Parent=panel
            local keyButton=Instance.new("TextButton");keyButton.Size=UDim2.fromOffset(76,22)
            keyButton.Position=UDim2.new(1,-88,0,35);keyButton.BackgroundColor3=tokens.Color.PanelSoft
            keyButton.BorderSizePixel=0;keyButton.TextSize=10;keyButton.Font=Enum.Font.GothamMedium
            keyButton.TextColor3=tokens.Color.TextMuted;keyButton.AutoButtonColor=false
            keyButton.ZIndex=102;keyButton.Parent=panel;corner(keyButton,4)
            action.KeyButton=keyButton
            keyButton.Activated:Connect(function()
                if captureTimer then pcall(task.cancel,captureTimer);captureTimer=nil end
                local previous=capturing;capturing=action
                if previous then render(previous) end
                render(action)
                captureTimer=task.delay(8,function() capturing=nil;captureTimer=nil;if not runtime.Destroyed then render(action) end end)
            end)
            action.Panel=panel;action.Body=body;action.Caption=caption;action.Collapse=collapse;action.Switch=switch;action.Dot=dot
            if options.Panel then
                local ok,err=pcall(options.Panel,body,self,action)
                if not ok then panel:Destroy();error("Quick action panel failed: "..tostring(err)) end
            end
            actions[action.Id]=action;table.insert(order,action.Id)
            switch.Activated:Connect(function() app:SetQuickAction(action.Id,not action.Value) end)
            collapse.Activated:Connect(function()
                app:SetQuickPanelMinimized(action.Id,not action.Minimized)
            end)
            local dragInput,origin,start
            runtime:TrackConnection(title.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                    dragInput=input;origin=input.Position;start=panel.AbsolutePosition-screen.AbsolutePosition
                end
            end))
            runtime:TrackConnection(UserInputService.InputChanged:Connect(function(input)
                if not dragInput then return end
                if dragInput.UserInputType==Enum.UserInputType.Touch and input~=dragInput then return end
                if dragInput.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.MouseMovement then return end
                local delta=input.Position-origin
                panel.Position=UDim2.fromOffset(start.X+delta.X,start.Y+delta.Y)
            end))
            runtime:TrackConnection(UserInputService.InputEnded:Connect(function(input) if input==dragInput then dragInput=nil end end))
            if options.KeyCode then
                local ok,reason=setKey(action,options.KeyCode);assert(ok,reason)
            end
            sizePanel(action);render(action);return action
        end
        function app:ResetQuickPanelPositions()
            for index,id in ipairs(order) do
                actions[id].Panel.Position=UDim2.new(0,14,0.5,(index-1)*72-110)
            end
        end
        runtime:TrackConnection(screen:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            for _,id in ipairs(order) do sizePanel(actions[id]) end
        end))
        runtime:TrackCleanup(function() if captureTimer then pcall(task.cancel,captureTimer) end end)
        runtime:TrackConnection(UserInputService.InputBegan:Connect(function(input,processed)
            if capturing then
                if input.UserInputType~=Enum.UserInputType.Keyboard then return end
                local action=capturing
                capturing=nil
                if captureTimer then pcall(task.cancel,captureTimer);captureTimer=nil end
                if input.KeyCode~=Enum.KeyCode.Escape then
                    local ok,reason=setKey(action,input.KeyCode~=Enum.KeyCode.Backspace and input.KeyCode or nil)
                    if not ok and app.Notify then app:Notify("Shortcut",reason,3,"Info") end
                end
                render(action);return
            end
            if processed or UserInputService:GetFocusedTextBox() or deps.PopupManager.Active then return end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) then return end
            for _,id in ipairs(order) do
                local action=actions[id]
                if action.PanelEnabled and action.KeyCode==input.KeyCode then app:SetQuickAction(id,not action.Value);return end
            end
        end))
    end

    local function createSearchPopup(categoriesOnly)
        if not holder.Visible then return end
        deps.PopupManager:Close()
        local popup = Instance.new("Frame")
        popup.AnchorPoint = Vector2.new(1, 0)
        popup.Position = UDim2.new(1, -16, 0, tokens.Size.Topbar - 2)
        local logicalWidth=holder.Size.X.Offset
        local popupWidth=math.min(deps.Mobile and 340 or 292,logicalWidth-24)
        local popupHeight=math.min(340,holder.Size.Y.Offset-tokens.Size.Topbar-14)
        popup.Size = UDim2.fromOffset(popupWidth,popupHeight)
        if categoriesOnly then
            popup.AnchorPoint=Vector2.new(0,0)
            popup.Position=UDim2.fromOffset(math.clamp(pageButton.Position.X.Offset,12,logicalWidth-popupWidth-12),tokens.Size.Topbar+2)
        end
        popup.ZIndex = 80
        popup.Parent = overlay
        deps.Material.Popup(popup, tokens)

        local caption=deps.Typography.Label(popup,"Value",tokens,categoriesOnly and "Categories" or "All features",UDim2.fromOffset(12,6),UDim2.new(1,-60,0,30),tokens.Color.Text)
        caption.ZIndex=81
        local close=Instance.new("TextButton")
        close.Text="×";close.TextSize=22;close.TextColor3=tokens.Color.TextMuted
        close.BackgroundTransparency=1;close.Size=UDim2.fromOffset(40,36)
        close.Position=UDim2.new(1,-44,0,2);close.ZIndex=82;close.Parent=popup
        close.Activated:Connect(function() if serenityInputBlocked(close) then return end; deps.PopupManager:Close() end)
        local input = Instance.new("TextBox")
        input.Position = UDim2.fromOffset(8, 42)
        input.Size = UDim2.new(1, -16, 0, 34)
        input.Text = ""
        input.PlaceholderText = categoriesOnly and "Filter categories..." or "Search all features..."
        input.PlaceholderColor3 = tokens.Color.TextDim
        input.TextColor3 = tokens.Color.Text
        input.TextSize = tokens.Type.Value
        input.Font = deps.Typography.Font.Medium
        input.TextXAlignment = Enum.TextXAlignment.Left
        input.ClearTextOnFocus = false
        input.ZIndex = 81
        input.Parent = popup
        deps.Material.Inset(input, tokens)
        local inputPad = Instance.new("UIPadding") inputPad.PaddingLeft = UDim.new(0, 10) inputPad.PaddingRight = UDim.new(0, 8) inputPad.Parent = input

        local listFrame = Instance.new("ScrollingFrame")
        listFrame.BackgroundTransparency = 1
        listFrame.BorderSizePixel = 0
        listFrame.Position = UDim2.fromOffset(8, 84)
        listFrame.Size = UDim2.new(1, -16, 1, -92)
        listFrame.CanvasSize = UDim2.new()
        listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        listFrame.ScrollBarThickness = deps.Mobile and 4 or 2
        listFrame.ScrollBarImageColor3 = tokens.Color.Accent
        listFrame.ZIndex = 81
        listFrame.Parent = popup
        local ll = Instance.new("UIListLayout") ll.Padding = UDim.new(0, 3) ll.Parent = listFrame

        local matches = {}
        for _, entry in ipairs(navItems) do
            if categoriesOnly then
                table.insert(matches,{Entry=entry,Title=entry.Title})
            else
                for _, target in ipairs(entry.Page:GetDescendants()) do
                    local title=target:GetAttribute("FeatureTitle")
                    if not title and target:IsA("TextButton") and target.Text~="" then title=target.Text end
                    if not title and target:IsA("TextBox") and target.PlaceholderText~="" then title=target.PlaceholderText end
                    if title then table.insert(matches,{Entry=entry,Title=title,Target=target,Description=target:GetAttribute("FeatureDescription") or ""}) end
                end
            end
        end
        table.sort(matches,function(a,b) return (a.Title..a.Entry.Title)<(b.Title..b.Entry.Title) end)
        local rows={}
        local function jump(match)
            app:SelectPage(match.Entry.Id)
            local target=match.Target
            if not target then return end
            local ancestor=target.Parent
            while ancestor and ancestor~=match.Entry.Page do
                if ancestor:IsA("GuiObject") then ancestor.Visible=true end
                ancestor=ancestor.Parent
            end
            task.defer(function()
                if runtime.Destroyed or not target.Parent then return end
                local page=match.Entry.Page
                local y=(target.AbsolutePosition.Y-page.AbsolutePosition.Y)/math.max(uiScale.Scale,0.01)+page.CanvasPosition.Y-18
                page.CanvasPosition=Vector2.new(0,math.clamp(y,0,math.max(0,page.AbsoluteCanvasSize.Y-page.AbsoluteWindowSize.Y)))
                local outline=Instance.new("UIStroke")
                outline.Name="SearchHighlight";outline.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
                outline.Color=tokens.Color.Accent;outline.Thickness=2;outline.Parent=target
                task.delay(1.5,function() if outline.Parent then outline:Destroy() end end)
            end)
        end
        for _,match in ipairs(matches) do
            local row=Instance.new("TextButton")
            row.Size=UDim2.new(1,-2,0,categoriesOnly and (deps.Mobile and 44 or 35) or 48)
            row.BackgroundColor3=(categoriesOnly and match.Entry.Id==currentPage) and tokens.Color.Accent or tokens.Color.PanelSoft;row.BackgroundTransparency=0.12
            row.BorderSizePixel=0;row.Text="";row.AutoButtonColor=false;row.ZIndex=82;row.Parent=listFrame
            corner(row,6)
            local title=deps.Typography.Label(row,"Value",tokens,match.Title,UDim2.fromOffset(10,4),UDim2.new(1,-20,0,25),tokens.Color.Text)
            title.ZIndex=83
            if not categoriesOnly then
                local subtitle=deps.Typography.Label(row,"Description",tokens,match.Entry.Title,UDim2.fromOffset(10,28),UDim2.new(1,-20,0,15),tokens.Color.TextMuted)
                subtitle.ZIndex=83
            end
            table.insert(rows,{Frame=row,Match=match,Search=string.lower(match.Title.." "..match.Entry.Title.." "..(match.Description or ""))})
            deps.Material.OptionHover(row, tokens, categoriesOnly and match.Entry.Id==currentPage, deps.Motion)
            row.Activated:Connect(function() if serenityInputBlocked(row) then return end; jump(match) end)
        end
        local empty=deps.Typography.Label(listFrame,"Value",tokens,categoriesOnly and "No matching categories" or "No matching features",UDim2.new(),UDim2.new(1,-10,0,40),tokens.Color.TextMuted)
        empty.ZIndex=83;empty.Visible=false
        input:GetPropertyChangedSignal("Text"):Connect(function()
            local q=string.lower(input.Text or "")
            local count=0
            for _,data in ipairs(rows) do
                local visible=true
                for word in q:gmatch("%S+") do if not string.find(data.Search,word,1,true) then visible=false break end end
                data.Frame.Visible=visible
                if visible then count=count+1 end
            end
            empty.Visible=count==0
            listFrame.CanvasPosition=Vector2.new()
        end)
        input.FocusLost:Connect(function(enter)
            if enter then for _,data in ipairs(rows) do if data.Frame.Visible then jump(data.Match) break end end end
        end)

        deps.PopupManager:Set(popup)
        -- TextBox receives focus only from an explicit click or tap.
    end

    local function createScopePopup()
        deps.PopupManager:Close()
        local popup = Instance.new("Frame")
        popup.Position = UDim2.fromOffset(tokens.Size.Sidebar + 198, tokens.Size.Topbar - 2)
        popup.Size = UDim2.fromOffset(108, 116)
        popup.ZIndex = 80
        popup.Parent = overlay
        deps.Material.Popup(popup, tokens)

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 3)
        list.Parent = popup
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 6)
        pad.PaddingRight = UDim.new(0, 6)
        pad.PaddingTop = UDim.new(0, 6)
        pad.Parent = popup

        for _, name in ipairs({"Global", "Session", "Safe"}) do
            local item = Instance.new("TextButton")
            item.Size = UDim2.new(1, 0, 0, 30)
            item.BackgroundColor3 = tokens.Color.PanelSoft
            item.BackgroundTransparency = name == scopeText.Text and 0.14 or 0.56
            item.BorderSizePixel = 0
            item.Text = name
            item.TextColor3 = name == scopeText.Text and tokens.Color.Text or tokens.Color.TextMuted
            item.TextSize = tokens.Type.Value
            item.Font = deps.Typography.Font.Medium
            item.AutoButtonColor = false
            item.ZIndex = 81
            item.Parent = popup
            corner(item, 6)
            deps.Material.OptionHover(item, tokens, name == scopeText.Text, deps.Motion)
            item.MouseButton1Click:Connect(function() if serenityInputBlocked(item) then return end;
                scopeText.Text = name
                deps.PopupManager:Close()
            end)
        end
        deps.PopupManager:Set(popup)
    end

    searchButton.Activated:Connect(function() if serenityInputBlocked(searchButton) then return end; createSearchPopup(false) end)
    pageButton.Activated:Connect(function() if serenityInputBlocked(pageButton) then return end; createSearchPopup(true) end)
    scopeButton.MouseButton1Click:Connect(createScopePopup)

    runtime:TrackConnection(UserInputService.InputBegan:Connect(function(input, processed)
        if input.KeyCode==Enum.KeyCode.Escape and deps.PopupManager.Active then
            deps.PopupManager:Close()
            return
        end
        if processed then return end
        if input.KeyCode == Enum.KeyCode.K and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            createSearchPopup()
        elseif input.KeyCode == Enum.KeyCode.RightControl then
            if deps.PlayUISound then deps.PlayUISound() end
            app:SetVisible(app:IsMinimized())
        elseif input.KeyCode == Enum.KeyCode.Escape then
            deps.PopupManager:Close()
        end
    end))

    task.spawn(function()
        local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
        if not runtime.Destroyed and ok and info and info.Name then
            brandSub.Text = info.Name
        end
    end)

    if deps.Mobile then
        sidebar.Visible=true
        -- Use the existing vertical categories and profile on mobile too.
        content.Position=UDim2.fromOffset(tokens.Size.Sidebar+14,tokens.Size.Topbar+8)
        content.Size=UDim2.new(1,-(tokens.Size.Sidebar+28),1,-(tokens.Size.Topbar+18))
        heading.Text="SERENITY HUB";heading.TextSize=16
        heading.Position=UDim2.fromOffset(47,0);heading.Size=UDim2.fromOffset(115,48)
        star.Position=UDim2.fromOffset(13,10);star.Size=UDim2.fromOffset(30,30)
        pageButton.Position=UDim2.fromOffset(165,5);pageButton.Size=UDim2.fromOffset(110,38)
    end
    sidebar.Position=UDim2.new();sidebar.Size=UDim2.new(0,tokens.Size.Sidebar,1,0)
    topbar.Position=UDim2.fromOffset(tokens.Size.Sidebar,0)
    topbar.Size=UDim2.new(1,-tokens.Size.Sidebar,0,tokens.Size.Topbar)
    heading.Parent=sidebar;heading.TextSize=13;heading.Position=UDim2.fromOffset(deps.Mobile and 44 or 54,15)
    heading.Size=UDim2.fromOffset(tokens.Size.Sidebar-(deps.Mobile and 50 or 64),22)
    star.Parent=sidebar;star.Position=UDim2.fromOffset(16,17);star.Size=UDim2.fromOffset(26,26)
    brandSub.Parent=sidebar;brandSub.Position=UDim2.fromOffset(54,37);brandSub.Text="Interface preview"
    brandSub.Size=UDim2.fromOffset(tokens.Size.Sidebar-64,16)
    heading.TextTruncate=Enum.TextTruncate.AtEnd
    brandSub.TextTruncate=Enum.TextTruncate.AtEnd
    if deps.Mobile then
        heading.Position=UDim2.fromOffset(46,12)
        heading.Size=UDim2.fromOffset(tokens.Size.Sidebar-50,24)
        brandSub.Position=UDim2.fromOffset(16,39)
        brandSub.Size=UDim2.fromOffset(tokens.Size.Sidebar-30,15)
        brandSub.TextSize=10
    end
    pageButton.Position=UDim2.fromOffset(18,8);pageButton.Size=UDim2.fromOffset(deps.Mobile and 160 or 190,40)
    pageButton.BackgroundTransparency=1;pageText.TextSize=17;pageText.TextColor3=tokens.Color.Text
    navHolder.Position=UDim2.fromOffset(10,66)
    navHolder.Size=UDim2.new(1,-20,1,-(66+tokens.Size.SidebarUser+8))
    content.Position=UDim2.fromOffset(tokens.Size.Sidebar+(deps.Mobile and 12 or 20),tokens.Size.Topbar+4)
    content.Size=UDim2.new(1,-(tokens.Size.Sidebar+(deps.Mobile and 24 or 40)),1,-(tokens.Size.Topbar+14))
    -- A static divider replaces the bright full-window glass rim.
    local divider=Instance.new("Frame");divider.BorderSizePixel=0
    divider.Position=UDim2.fromOffset(tokens.Size.Sidebar,0);divider.Size=UDim2.new(0,1,1,0)
    divider.BackgroundColor3=tokens.Color.Divider;divider.Parent=shell
    edge.Transparency=0.7;edge.Thickness=1
    -- Small branded motion, suspended with the window and cleaned up on reload.
    star.AnchorPoint=Vector2.new(0.5,0.5)
    star.Position=UDim2.fromOffset(29,30);star.Size=UDim2.fromOffset(30,30)
    local glow=Instance.new("Frame");glow.Name="StarGlow";glow.BorderSizePixel=0
    glow.AnchorPoint=Vector2.new(0.5,0.5);glow.Position=UDim2.fromScale(0.5,0.5)
    glow.Size=UDim2.fromOffset(18,18);glow.BackgroundColor3=Color3.fromRGB(166,145,103)
    glow.BackgroundTransparency=0.94;glow.ZIndex=star.ZIndex-1;glow:SetAttribute("FixedPresetColor",true);glow.Parent=star
    local glowCorner=Instance.new("UICorner");glowCorner.CornerRadius=UDim.new(0,6);glowCorner.Parent=glow
    local brandScale=Instance.new("UIScale");brandScale.Parent=star
    local echoA=heading:Clone();echoA.Name="BrandEchoA";echoA.Visible=false;echoA.Parent=sidebar
    local echoB=heading:Clone();echoB.Name="BrandEchoB";echoB.Visible=false;echoB.Parent=sidebar
    echoA.ZIndex=heading.ZIndex+1;echoB.ZIndex=heading.ZIndex+1
    local brandTweens={}
    local glitchThread
    function app:RefreshBrandMotion()
        for _,tween in ipairs(brandTweens) do tween:Cancel() end
        table.clear(brandTweens)
        if glitchThread then pcall(task.cancel,glitchThread);glitchThread=nil end
        echoA.Visible=false;echoB.Visible=false;star.Rotation=0;brandScale.Scale=1
        for _,pixel in ipairs(star:GetChildren()) do
            if pixel:IsA("Frame") then pixel.BackgroundTransparency=pixel==glow and 0.94 or 0 end
        end
        if runtime.Destroyed or deps.Motion.Reduced or self.MotionSuspended or not holder.Visible then return end
        local service=game:GetService("TweenService")
        local halo=service:Create(glow,TweenInfo.new(2.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{BackgroundTransparency=0.86})
        table.insert(brandTweens,halo);halo:Play()
        -- Keep pixel edges still; twinkle the small highlights instead of scaling the emblem.
        for _,pixel in ipairs(star:GetChildren()) do
            if pixel:IsA("Frame") and pixel.Name=="StarHighlight" then
                local twinkle=service:Create(pixel,TweenInfo.new(2.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{BackgroundTransparency=0.32})
                table.insert(brandTweens,twinkle);twinkle:Play()
            end
        end
        glitchThread=task.spawn(function()
            while not runtime.Destroyed and holder.Visible and not deps.Motion.Reduced do
                task.wait(9)
                if runtime.Destroyed or not holder.Visible or deps.Motion.Reduced then break end
                echoA.TextColor3=tokens.Color.Accent;echoB.TextColor3=tokens.Color.Lavender
                echoA.Position=heading.Position+UDim2.fromOffset(1,0)
                echoB.Position=heading.Position+UDim2.fromOffset(-1,1)
                echoA.TextTransparency=0.88;echoB.TextTransparency=0.93
                echoA.Visible=true;echoB.Visible=true
                task.wait(0.06)
                echoA.Position=heading.Position+UDim2.fromOffset(-1,0)
                echoB.Position=heading.Position+UDim2.fromOffset(1,0)
                task.wait(0.06)
                echoA.Visible=false;echoB.Visible=false
            end
        end)
    end
    runtime:TrackConnection(holder:GetPropertyChangedSignal("Visible"):Connect(function() app:RefreshBrandMotion() end))
    runtime:TrackCleanup(function()
        if glitchThread then pcall(task.cancel,glitchThread);glitchThread=nil end
        for _,tween in ipairs(brandTweens) do tween:Cancel() end
        table.clear(brandTweens)
    end)
    runtime:TrackConnection(UserInputService.WindowFocusReleased:Connect(function()
        app.MotionSuspended=true;app:RefreshIconMotion()
    end))
    runtime:TrackConnection(UserInputService.WindowFocused:Connect(function()
        app.MotionSuspended=false;app:RefreshIconMotion()
    end))
    app:RefreshBrandMotion()
    return app
end

return Desktop

end)()
-- SERENITY HUB // NEXT UI M4 COMPACT
-- Visual playground only. No game remotes or automation actions are executed.

local function loadModule(path) return assert(modules[path], "Missing bundled module: " .. path) end

local UserInputService = game:GetService("UserInputService")

local RuntimeClass = loadModule("src/core/Runtime.lua")
local Tokens = loadModule("src/core/Tokens.lua")
local Typography = loadModule("src/core/Typography.lua")
local Motion = loadModule("src/core/Motion.lua")
local Material = loadModule("src/core/Material.lua")
local AcrylicEngine = loadModule("src/core/AcrylicEngine.lua")
local Icons = loadModule("src/core/Icons.lua")
local PopupManagerClass = loadModule("src/core/PopupManager.lua")

local NavItem = loadModule("src/components/NavItem.lua")
local Section = loadModule("src/components/Section.lua")
local Toggle = loadModule("src/components/Toggle.lua")
local Slider = loadModule("src/components/Slider.lua")
local Select = loadModule("src/components/Select.lua")
local ColumnLayout = loadModule("src/components/ColumnLayout.lua")
local Desktop = loadModule("src/renderers/Desktop.lua")

local G = (getgenv and getgenv()) or _G
for _, oldKey in ipairs({"__SERENITY_NEW_UI_GLASS_LAB_M2", "__SERENITY_NEW_UI_PRECISION_M3", "__SERENITY_NEW_UI_COMPACT_M4"}) do
    if G[oldKey] and G[oldKey].Destroy then
        pcall(function() G[oldKey]:Destroy() end)
    end
end

local KEY = "__SERENITY_NEW_UI_COMPACT_M4"
local runtime = RuntimeClass.new(KEY)
G[KEY] = runtime
runtime:TrackCleanup(function()
    if G[KEY] == runtime then G[KEY] = nil end
end)

local deps = {
    Runtime = runtime,
    Tokens = Tokens,
    Typography = Typography,
    Motion = Motion,
    Material = Material,
    AcrylicEngine = AcrylicEngine,
    Icons = Icons,
    PopupManager = PopupManagerClass.new(),
    UserInputService = UserInputService,
    NavItem = NavItem,
}

local camera=workspace.CurrentCamera
local viewport=camera and camera.ViewportSize or Vector2.new(1280,720)
deps.Mobile=UserInputService.TouchEnabled and (not UserInputService.KeyboardEnabled or viewport.Y<600)
if deps.Mobile then
    Tokens.Size.Window=Vector2.new(viewport.X<viewport.Y and 430 or 700,420)
    Tokens.Size.Topbar=48
    Tokens.Size.Sidebar=156
    Tokens.Size.SectionLabel=28
    Tokens.Size.NavRow=34
    Tokens.Size.NavGroup=20
    Tokens.Size.Control=40
    Tokens.Size.Slider=55
    Tokens.Size.Select=58
end

local app = Desktop.Mount(deps, {
    Title = "SERENITY HUB",
    Subtitle = "UI PLAYGROUND",
    BlurSize = 3,
})

-- TEST ONLY: do not migrate production or legacy dashboards without explicit release approval.
-- Shared interaction layer: event-driven help and one confirmation at a time.
do
    local guiService = game:GetService("GuiService")
    local tweens = {}
    local activeDialog, activeTip
    local function animate(object, properties)
        if tweens[object] then tweens[object]:Cancel() end
        tweens[object] = Motion:Tween(object, "Modal", properties)
    end
    local function rounded(object, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius or 10)
        corner.Parent = object
    end
    local function hideTip()
        if activeTip then activeTip.Card:Destroy(); activeTip = nil end
    end
    local function showTip(target, message)
        hideTip()
        if runtime.Destroyed or not app.Holder.Visible or not target:IsDescendantOf(app.ScreenGui) then return end
        local scale = math.max(deps.UIScale.Scale, 0.01)
        local width = math.min(260, Tokens.Size.Window.X - 24)
        local textService = game:GetService("TextService")
        local bounds = textService:GetTextSize(message, 12, Enum.Font.Gotham, Vector2.new(width - 24, 1000))
        local height = bounds.Y + 24
        local card = Instance.new("Frame")
        card.Name = "SerenityHelp"
        card.Size = UDim2.fromOffset(width, height)
        card.BackgroundColor3 = Color3.fromRGB(15, 33, 51)
        card.ZIndex = 110
        card.Parent = app.Holder
        rounded(card)
        local stroke = Instance.new("UIStroke")
        stroke.Color = Tokens.Color.Accent; stroke.Transparency = 0.5; stroke.Parent = card
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1; label.Text = message
        label.Font = Enum.Font.Gotham; label.TextSize = 12
        label.TextColor3 = Tokens.Color.Text; label.TextWrapped = true
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Position = UDim2.fromOffset(12, 10)
        label.Size = UDim2.new(1, -24, 1, -20); label.Parent = card
        local x = (target.AbsolutePosition.X - app.Holder.AbsolutePosition.X) / scale
        local y = (target.AbsolutePosition.Y - app.Holder.AbsolutePosition.Y) / scale
        local below = y + target.AbsoluteSize.Y / scale + 7
        if below + height > Tokens.Size.Window.Y - 10 then below = y - height - 7 end
        card.Position = UDim2.fromOffset(math.clamp(x, 12, Tokens.Size.Window.X - width - 12),
            math.clamp(below, 8, math.max(8, Tokens.Size.Window.Y - height - 8)))
        activeTip = {Card = card, Target = target}
    end
    function app:Tooltip(target, message, tapToOpen)
        assert(type(message) == "string" and message ~= "", "Tooltip needs text")
        runtime:TrackConnection(target.MouseEnter:Connect(function() if serenityInputBlocked(target) then return end;
            if not UserInputService.TouchEnabled then showTip(target, message) end
        end))
        runtime:TrackConnection(target.MouseLeave:Connect(hideTip))
        runtime:TrackConnection(target.SelectionGained:Connect(function() if serenityInputBlocked(target) then return end; showTip(target, message) end))
        runtime:TrackConnection(target.SelectionLost:Connect(hideTip))
        if tapToOpen then
            runtime:TrackConnection(target.Activated:Connect(function() if serenityInputBlocked(target) then return end;
                if activeTip and activeTip.Target == target then hideTip() else showTip(target, message) end
            end))
        end
    end
    deps.Help = function(target, message) app:Tooltip(target, message, true) end
    runtime:TrackConnection(UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and activeTip then
            local p, s = activeTip.Target.AbsolutePosition, activeTip.Target.AbsoluteSize
            if input.Position.X < p.X or input.Position.X > p.X + s.X or
                input.Position.Y < p.Y or input.Position.Y > p.Y + s.Y then hideTip() end
        end
        if input.KeyCode == Enum.KeyCode.Escape and activeDialog then activeDialog(false) end
    end))
    runtime:TrackConnection(app.Holder:GetPropertyChangedSignal("Visible"):Connect(function()
        if not app.Holder.Visible then hideTip(); if activeDialog then activeDialog(false) end end
    end))
    runtime:TrackConnection(app.Holder:GetPropertyChangedSignal("Position"):Connect(hideTip))
    runtime:TrackConnection(deps.UIScale:GetPropertyChangedSignal("Scale"):Connect(hideTip))
    local selectPage = app.SelectPage
    function app:SelectPage(id)
        hideTip()
        if activeDialog then activeDialog(false) end
        return selectPage(self, id)
    end
    function app:Confirm(options)
        options = options or {}
        if runtime.Destroyed then return end
        if activeDialog then activeDialog(false) end
        hideTip()
        deps.PopupManager:Close()
        local overlay = Instance.new("TextButton")
        overlay.Name = "SerenityConfirmation"
        overlay.Text = ""; overlay.AutoButtonColor = false
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.fromRGB(5, 12, 24)
        overlay.BackgroundTransparency = 1; overlay.ZIndex = 100
        overlay.Parent = app.Holder; rounded(overlay, Tokens.Size.RadiusShell)
        local card = Instance.new("CanvasGroup")
        card.AnchorPoint = Vector2.new(0.5, 0.5)
        card.Position = UDim2.new(0.5, 0, 0.5, 12)
        card.Size = UDim2.fromOffset(math.min(330, Tokens.Size.Window.X - 32), 170)
        card.BackgroundColor3 = Tokens.Color.Panel
        card.GroupTransparency = 1; card.Parent = overlay; rounded(card, 9)
        local stroke = Instance.new("UIStroke")
        stroke.Color = Tokens.Color.Stroke; stroke.Transparency = 0.25; stroke.Parent = card
        local title = Typography.Label(card, "Control", Tokens, options.Title or "Confirm action",
            UDim2.fromOffset(16, 14), UDim2.new(1, -32, 0, 40), Tokens.Color.Text)
        title.TextSize = 16; title.Font = Enum.Font.GothamBold; title.TextWrapped = true
        local message = Typography.Label(card, "Control", Tokens, options.Message or "Continue with this action?",
            UDim2.fromOffset(16, 59), UDim2.new(1, -32, 0, 50), Tokens.Color.TextMuted)
        message.TextSize = 12; message.TextWrapped = true; message.TextYAlignment = Enum.TextYAlignment.Top
        local function action(text, primary, x)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0.5, -20, 0, 34)
            b.Position = UDim2.new(x, x == 0 and 16 or 4, 1, -48)
            b.Text = text; b.TextSize = 12; b.Font = Enum.Font.GothamBold
            b.AutoButtonColor = false
            b.BackgroundColor3 = primary and Tokens.Color.Accent or Tokens.Color.Inset
            b.TextColor3 = primary and Color3.fromRGB(8, 24, 38) or Tokens.Color.Text
            b.Parent = card; rounded(b, 8)
            local resting=b.BackgroundColor3
            b.MouseEnter:Connect(function() if serenityInputBlocked(b) then return end; animate(b,{BackgroundColor3=primary and Tokens.Color.AccentBright or Tokens.Color.InsetHover}) end)
            b.MouseLeave:Connect(function() animate(b,{BackgroundColor3=resting}) end)
            b.SelectionGained:Connect(function() if serenityInputBlocked(b) then return end; animate(b,{BackgroundColor3=primary and Tokens.Color.AccentBright or Tokens.Color.InsetHover}) end)
            b.SelectionLost:Connect(function() animate(b,{BackgroundColor3=resting}) end)
            return b
        end
        local cancel = action(options.CancelText or "Cancel", false, 0)
        local accept = action(options.ConfirmText or "Confirm", true, 0.5)
        local previousFocus = guiService.SelectedObject
        local settled = false
        local function resolve(confirmed)
            if settled then return end
            settled = true
            if activeDialog == resolve then activeDialog = nil end
            if guiService.SelectedObject == cancel or guiService.SelectedObject == accept then
                guiService.SelectedObject = previousFocus and previousFocus.Parent and previousFocus or nil
            end
            animate(card, {GroupTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 12)})
            animate(overlay, {BackgroundTransparency = 1})
            task.delay(Motion.Reduced and 0 or 0.21, function()
                for _,object in ipairs({card, overlay}) do
                    if tweens[object] then tweens[object]:Cancel(); tweens[object] = nil end
                end
                overlay:Destroy()
            end)
            if not runtime.Destroyed and options.Callback then options.Callback(confirmed) end
        end
        activeDialog = resolve
        if deps.PlayUISound then deps.PlayUISound() end
        cancel.Activated:Connect(function() if serenityInputBlocked(cancel) then return end;
            if deps.PlayUISound then deps.PlayUISound() end
            resolve(false)
        end)
        accept.Activated:Connect(function() if serenityInputBlocked(accept) then return end;
            if deps.PlayUISound then deps.PlayUISound() end
            resolve(true)
        end)
        overlay.Activated:Connect(function() if serenityInputBlocked(overlay) then return end; resolve(false) end)
        if previousFocus then guiService.SelectedObject = cancel end
        animate(overlay, {BackgroundTransparency = 0.55})
        animate(card, {GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.5)})
        return function() resolve(false) end
    end
    runtime:TrackCleanup(function()
        hideTip()
        if activeDialog then activeDialog(false) end
        for object,tween in pairs(tweens) do tween:Cancel(); tweens[object] = nil end
    end)
end

-- What's new · 2026-10-07: bottom-right notifications, queue, slide animation, reduced-motion fade.
do
    local tweenService=game:GetService("TweenService")
    local screen=runtime:TrackInstance(Instance.new("ScreenGui"))
    screen.Name="Serenity_Test_Notifications"
    app.NotificationScreenGui=screen
    screen.ResetOnSpawn=false;screen.IgnoreGuiInset=false
    screen.DisplayOrder=app.ScreenGui.DisplayOrder+20;screen.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    screen.Parent=app.ScreenGui.Parent
    local root=Instance.new("Frame");root.BackgroundTransparency=1
    root.Size=UDim2.fromScale(1,1);root.ClipsDescendants=true;root.Parent=screen
    local active,queue,timers={},{},{}
    local pump,arrange
    local function later(seconds,callback)
        local thread
        thread=task.delay(seconds,function() timers[thread]=nil;if not runtime.Destroyed then callback() end end)
        timers[thread]=true;return thread
    end
    local function toastScale()
        return deps.Mobile and math.clamp(deps.UIScale.Scale*0.94,0.72,1) or 1
    end
    local function capacity() return deps.Mobile and 2 or math.clamp(math.floor((root.AbsoluteSize.Y-32)/90),1,3) end
    local function animate(entry,properties,duration)
        if entry.Tween then entry.Tween:Cancel() end
        entry.Tween=tweenService:Create(entry.Frame,TweenInfo.new(duration,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),properties)
        entry.Tween:Play()
    end
    arrange=function()
        local scale=toastScale()
        local width=math.max(100,math.min(deps.Mobile and 286 or 306,(root.AbsoluteSize.X-24)/scale))
        for i,entry in ipairs(active) do
            entry.Scale.Scale=scale
            entry.Frame.Size=UDim2.fromOffset(width,78)
            if not entry.Closing then
                animate(entry,{Position=UDim2.new(1,-12,1,-12-(i-1)*90*scale),GroupTransparency=0},Motion.Reduced and 0.12 or 0.26)
            end
        end
    end
    local function close(entry)
        if entry.Closing or runtime.Destroyed then return end
        entry.Closing=true
        if entry.Timer then pcall(task.cancel,entry.Timer);timers[entry.Timer]=nil;entry.Timer=nil end
        if entry.Progress then entry.Progress:Cancel() end
        animate(entry,Motion.Reduced and {GroupTransparency=1} or {Position=UDim2.new(1,entry.Frame.Size.X.Offset+16,entry.Frame.Position.Y.Scale,entry.Frame.Position.Y.Offset),GroupTransparency=1},0.2)
        later(0.2,function()
            if entry.Connection then entry.Connection:Disconnect() end
            entry.Frame:Destroy()
            for i,v in ipairs(active) do if v==entry then table.remove(active,i);break end end
            arrange();pump()
        end)
    end
    pump=function()
        while #active<capacity() and #queue>0 do
            local data=table.remove(queue,1)
            local card=Instance.new("CanvasGroup");card.AnchorPoint=Vector2.new(1,1)
            card.Size=UDim2.fromOffset(306,78);card.Position=UDim2.new(1,330,1,-12)
            card.GroupTransparency=1;card.BackgroundColor3=Tokens.Color.PanelSoft
            card.BackgroundTransparency=0.02;card.BorderSizePixel=0;card.Parent=root
            local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,3);corner.Parent=card
            local color=({Success=Tokens.Color.Mint,Warning=Tokens.Color.Amber,Error=Tokens.Color.Red})[data.Kind] or Tokens.Color.Accent
            local stroke=Instance.new("UIStroke");stroke.Color=Tokens.Color.Stroke;stroke.Transparency=0.35;stroke.Thickness=1;stroke.Parent=card
            local mark=Instance.new("Frame");mark.Size=UDim2.fromOffset(13,2);mark.Position=UDim2.fromOffset(16,12)
            mark.BorderSizePixel=0;mark.BackgroundColor3=color;mark.Parent=card
            local notch=Instance.new("Frame");notch.Size=UDim2.fromOffset(3,3);notch.Position=UDim2.fromOffset(16,16)
            notch.BorderSizePixel=0;notch.BackgroundColor3=color;notch.BackgroundTransparency=0.3;notch.Parent=card
            local title=Typography.Label(card,"Control",Tokens,data.Title,UDim2.fromOffset(37,9),UDim2.new(1,-76,0,23),Tokens.Color.Text)
            title.Font=Enum.Font.GothamBold;title.TextSize=14;title.TextTruncate=Enum.TextTruncate.AtEnd
            local body=Typography.Label(card,"Control",Tokens,data.Message,UDim2.fromOffset(16,34),UDim2.new(1,-48,0,29),Tokens.Color.TextMuted)
            body.TextWrapped=true;body.TextYAlignment=Enum.TextYAlignment.Top;body.TextSize=12;body.TextTruncate=Enum.TextTruncate.AtEnd
            local dismiss=Instance.new("TextButton");dismiss.Size=UDim2.fromOffset(30,30)
            dismiss.Position=UDim2.new(1,-34,0,5);dismiss.BackgroundTransparency=1;dismiss.AutoButtonColor=false
            dismiss.Text="×";dismiss.Font=Enum.Font.GothamMedium;dismiss.TextColor3=Tokens.Color.TextMuted;dismiss.TextSize=18;dismiss.Parent=card
            dismiss.MouseEnter:Connect(function() if serenityInputBlocked(dismiss) then return end; dismiss.TextColor3=Tokens.Color.Text end)
            dismiss.MouseLeave:Connect(function() dismiss.TextColor3=Tokens.Color.TextMuted end)
            local track=Instance.new("Frame");track.Size=UDim2.new(1,-32,0,1);track.Position=UDim2.new(0,16,1,-7)
            track.BorderSizePixel=0;track.BackgroundTransparency=0.75;track.BackgroundColor3=color;track.Parent=card
            local fill=Instance.new("Frame");fill.Size=UDim2.fromScale(1,1);fill.BorderSizePixel=0;fill.BackgroundColor3=color;fill.Parent=track
            local cardScale=Instance.new("UIScale");cardScale.Scale=toastScale();cardScale.Parent=card
            local entry={Frame=card,Scale=cardScale};table.insert(active,entry)
            if Motion.Reduced then card.Position=UDim2.new(1,-12,1,-12-(#active-1)*90*toastScale()) end
            entry.Connection=dismiss.Activated:Connect(function() if serenityInputBlocked(dismiss) then return end; close(entry) end)
            entry.Progress=tweenService:Create(fill,TweenInfo.new(data.Duration,Enum.EasingStyle.Linear),{Size=UDim2.fromScale(0,1)})
            entry.Progress:Play();entry.Timer=later(data.Duration,function() entry.Timer=nil;close(entry) end)
            arrange()
        end
    end
    function app:Notify(title,message,duration,kind)
        local data=type(title)=="table" and title or {Title=title,Message=message,Duration=duration,Kind=kind}
        local seconds=tonumber(data.Duration) or 5
        if seconds~=seconds then seconds=5 end
        local item={Title=tostring(data.Title or "Serenity"):sub(1,100),Message=tostring(data.Message or data.Text or ""):sub(1,300),Duration=math.clamp(seconds,3,30),Kind=data.Kind or "Info"}
        if runtime.Destroyed then return false end
        if #queue>=20 then table.remove(queue,1) end
        table.insert(queue,item);pump();return true
    end
    runtime:TrackConnection(root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() arrange();pump() end))
    runtime:TrackCleanup(function()
        for thread in pairs(timers) do pcall(task.cancel,thread) end
        for _,entry in ipairs(active) do
            if entry.Tween then entry.Tween:Cancel() end
            if entry.Progress then entry.Progress:Cancel() end
            if entry.Connection then entry.Connection:Disconnect() end
        end
        table.clear(queue);table.clear(active)
    end)
end

-- Preview adapters demonstrate the shared API; game adapters supply real callbacks.
for _,entry in ipairs({{"fly","Fly",Enum.KeyCode.F},{"noclip","Noclip",Enum.KeyCode.N},{"esp","Player ESP",Enum.KeyCode.H}}) do
    local id,title,key=entry[1],entry[2],entry[3]
    app:RegisterQuickAction({Id=id,Title=title,KeyCode=key,Default=false,Callback=function(value)
        return true
    end})
end

local dashboard = app:AddPage({Id="Dashboard", Title="Dashboard", Icon="dashboard", Accent=Tokens.Color.Accent, Order=-2})
local about = app:AddPage({Id="About", Title="About", Icon="info", Accent=Tokens.Color.Cyan, Order=-3})
local automation = app:AddPage({Id="Automation", Title="Automation", Icon="automation", Accent=Tokens.Color.Accent, Group="Main", Order=1})
local progression = app:AddPage({Id="Progression", Title="Progression", Icon="progression", Accent=Tokens.Color.Lavender, Group="Main", Order=2})
local shop = app:AddPage({Id="Shop", Title="Shop", Icon="shop", Accent=Tokens.Color.Amber, Group="Common", Order=3})
local server = app:AddPage({Id="Server", Title="Server", Icon="server", Accent=Tokens.Color.Cyan, Group="Common", Order=4})
local webhook = app:AddPage({Id="Webhook", Title="Webhook", Icon="webhook", Accent=Tokens.Color.Pink, Group="Common", Order=5})
local misc = app:AddPage({Id="Misc", Title="Misc", Icon="misc", Accent=Tokens.Color.Mint, Group="Common", Order=6})
local settings = app:AddPage({Id="Settings", Title="Settings", Icon="settings", Accent=Tokens.Color.Pink, Group="System", Order=7})

-- AUTOMATION ---------------------------------------------------------------
local autoCols = ColumnLayout.new(automation, deps, {Gap=12, RowGap=12})

local main = Section.new(autoCols.Left, deps, {Title="Main"})
Toggle.new(main.Body, deps, {Title="Enabled", Default=true, Settings=true})
Toggle.new(main.Body, deps, {Title="Auto Roll", Default=true, Settings=true})
Toggle.new(main.Body, deps, {Title="Automatic Collect", Default=true})
Toggle.new(main.Body, deps, {Title="Fast Actions", Default=true})
Slider.new(main.Body, deps, {Title="Action Delay", Min=0, Max=2, Step=0.1, Default=0.2, Suffix="s"})

local selection = Section.new(autoCols.Left, deps, {Title="Selection"})
Select.new(selection.Body, deps, {Title="Target Priority", Options={"Highest Value","Nearest","Lowest HP","Newest"}, Default="Highest Value"})
Select.new(selection.Body, deps, {Title="Minimum Rarity", Options={"Common","Rare","Epic","Legendary","Mythic"}, Default="Epic"})
Select.new(selection.Body, deps, {Title="Target Set", Options={"All Valid","Selected Only","Whitelist"}, Default="Selected Only"})
Slider.new(selection.Body, deps, {Title="Priority Weight", Min=0, Max=100, Step=1, Default=68, Suffix="%", Settings=true})
Toggle.new(selection.Body, deps, {Title="Smart Priority", Default=true})

local other = Section.new(autoCols.Right, deps, {Title="Other"})
Select.new(other.Body, deps, {Title="History", Options={"Off","Low","Medium","High"}, Default="High"})
Toggle.new(other.Body, deps, {Title="Auto Sell", Default=true})
Toggle.new(other.Body, deps, {Title="Auto Upgrade", Default=true})
Toggle.new(other.Body, deps, {Title="Auto Restock", Default=true})
Toggle.new(other.Body, deps, {Title="Quick Retry", Default=false})
Slider.new(other.Body, deps, {Title="Retry Delay", Min=0, Max=10, Step=0.5, Default=1.5, Suffix="s"})

local routes = Section.new(autoCols.Right, deps, {Title="Routing"})
Toggle.new(routes.Body, deps, {Title="Story", Default=true, Settings=true})
Toggle.new(routes.Body, deps, {Title="Tower", Default=true, Settings=true})
Toggle.new(routes.Body, deps, {Title="Expedition", Default=false, Settings=true})
Select.new(routes.Body, deps, {Title="Route Mode", Options={"Balanced","Fastest","Safest"}, Default="Balanced"})

-- PROGRESSION --------------------------------------------------------------
local progCols = ColumnLayout.new(progression, deps, {Gap=12, RowGap=12})
local story = Section.new(progCols.Left, deps, {Title="Story"})
Toggle.new(story.Body, deps, {Title="Auto Story", Default=true, Settings=true})
Select.new(story.Body, deps, {Title="Mode", Options={"Auto Pick","Selected Stage"}, Default="Auto Pick"})
Select.new(story.Body, deps, {Title="Difficulty", Options={"Normal","Hard","Highest"}, Default="Highest"})
Slider.new(story.Body, deps, {Title="Retry Delay", Min=0, Max=15, Step=0.5, Default=1.5, Suffix="s"})

local upgrades = Section.new(progCols.Left, deps, {Title="Upgrades"})
Toggle.new(upgrades.Body, deps, {Title="Auto Trait", Default=false, Settings=true})
Toggle.new(upgrades.Body, deps, {Title="Auto Gem", Default=false, Settings=true})
Toggle.new(upgrades.Body, deps, {Title="Auto Skill", Default=true, Settings=true})
Select.new(upgrades.Body, deps, {Title="Priority", Options={"Damage","Speed","Balanced"}, Default="Balanced"})

local tower = Section.new(progCols.Right, deps, {Title="Tower"})
Toggle.new(tower.Body, deps, {Title="Auto Tower", Default=true, Settings=true})
Select.new(tower.Body, deps, {Title="Floor", Options={"Highest Available","25","50","75","100"}, Default="Highest Available"})
Slider.new(tower.Body, deps, {Title="Retry Delay", Min=1, Max=30, Step=1, Default=5, Suffix="s"})
Toggle.new(tower.Body, deps, {Title="Continue After Clear", Default=true})

local expedition = Section.new(progCols.Right, deps, {Title="Expedition"})
Toggle.new(expedition.Body, deps, {Title="Auto Expedition", Default=true, Settings=true})
Select.new(expedition.Body, deps, {Title="Location", Options={"Forest","Ruins","Abyss","Sanctum"}, Default="Ruins"})
Select.new(expedition.Body, deps, {Title="Aura Mode", Options={"Best","Whitelist","Any"}, Default="Best"})
Toggle.new(expedition.Body, deps, {Title="Auto Claim", Default=true})

-- SHOP ---------------------------------------------------------------------
local shopCols = ColumnLayout.new(shop, deps, {Gap=12, RowGap=12})
local petShop = Section.new(shopCols.Left, deps, {Title="Pet Shop"})
Toggle.new(petShop.Body, deps, {Title="Auto Buy", Default=false, Settings=true})
Select.new(petShop.Body, deps, {Title="Pet", Options={"Wolf","Fox","Swan","Turkey","Dragon"}, Default="Wolf"})
Slider.new(petShop.Body, deps, {Title="Amount", Min=1, Max=100, Step=1, Default=5})
Toggle.new(petShop.Body, deps, {Title="Equip Best", Default=true})

local gearShop = Section.new(shopCols.Left, deps, {Title="Gear"})
Toggle.new(gearShop.Body, deps, {Title="Auto Buy Gear", Default=false, Settings=true})
Select.new(gearShop.Body, deps, {Title="Quality", Options={"Any","Rare+","Epic+","Best"}, Default="Epic+"})
Toggle.new(gearShop.Body, deps, {Title="Auto Equip", Default=true})

local safety = Section.new(shopCols.Right, deps, {Title="Safety"})
Toggle.new(safety.Body, deps, {Title="Block Paid Routes", Default=true})
Toggle.new(safety.Body, deps, {Title="Require Confirmation", Default=true})
Toggle.new(safety.Body, deps, {Title="Affordability Check", Default=true})
Select.new(safety.Body, deps, {Title="Purchase Mode", Options={"Whitelist","Selected Only","Manual"}, Default="Selected Only"})

local limits = Section.new(shopCols.Right, deps, {Title="Limits"})
Slider.new(limits.Body, deps, {Title="Max Per Cycle", Min=1, Max=100, Step=1, Default=10})
Slider.new(limits.Body, deps, {Title="Reserve Currency", Min=0, Max=100000, Step=1000, Default=10000})
Toggle.new(limits.Body, deps, {Title="Pause When Low", Default=true})

-- SERVER -------------------------------------------------------------------
local serverCols = ColumnLayout.new(server, deps, {Gap=12, RowGap=12})
local session = Section.new(serverCols.Left, deps, {Title="Session"})
Toggle.new(session.Body, deps, {Title="Reconnect", Default=false})
Select.new(session.Body, deps, {Title="Join Mode", Options={"Current","Lowest Players","Private"}, Default="Current"})
Toggle.new(session.Body, deps, {Title="Server Hop", Default=false, Settings=true})

local diagnostics = Section.new(serverCols.Right, deps, {Title="Diagnostics"})
Toggle.new(diagnostics.Body, deps, {Title="Live Metrics", Default=true})
Toggle.new(diagnostics.Body, deps, {Title="Worker Status", Default=true})
Toggle.new(diagnostics.Body, deps, {Title="Route Status", Default=true})
Slider.new(diagnostics.Body, deps, {Title="Refresh Rate", Min=0.5, Max=5, Step=0.5, Default=1, Suffix="s"})

-- WEBHOOK ------------------------------------------------------------------
local hookCols = ColumnLayout.new(webhook, deps, {Gap=12, RowGap=12})
local delivery = Section.new(hookCols.Left, deps, {Title="Delivery"})
Toggle.new(delivery.Body, deps, {Title="Enabled", Default=false, Settings=true})
Select.new(delivery.Body, deps, {Title="Minimum Event", Options={"Any","Rare+","Legendary+","Errors"}, Default="Legendary+"})
Toggle.new(delivery.Body, deps, {Title="Include Session", Default=true})
Toggle.new(delivery.Body, deps, {Title="Include Screenshot", Default=false})

local alerts = Section.new(hookCols.Right, deps, {Title="Alerts"})
Toggle.new(alerts.Body, deps, {Title="Rare Finds", Default=true})
Toggle.new(alerts.Body, deps, {Title="Errors", Default=true})
Toggle.new(alerts.Body, deps, {Title="Disconnect", Default=true})
Toggle.new(alerts.Body, deps, {Title="Milestones", Default=false})

-- UI SETTINGS: only connected behavior is exposed.
local miscCols = ColumnLayout.new(misc, deps, {})
local utility = Section.new(miscCols.Left, deps, {Title="Interaction"})
Toggle.new(utility.Body, deps, {Title="Reduced Motion", Default=false, Callback=function(v) Motion.Reduced = v;app:RefreshIconMotion() end})
local settingsCols = ColumnLayout.new(settings, deps, {})

local themeBindings=setmetatable({}, {__mode="k"})
local refreshMaterials
local saveAppearance=function() end
local motionControls={}
local function reducedMotionToggle(parent)
    local control=Toggle.new(parent,deps,{Title="Reduced motion",Default=false,Callback=function(v)
        Motion.Reduced=v;runtime.ReducedMotion=v
        app:RefreshIconMotion()
        for _,other in ipairs(motionControls) do other:Set(v,true) end
        saveAppearance()
    end})
    table.insert(motionControls,control)
    return control
end
local hideDashboardName=false
local identityBindings={}
local function registerIdentity(object,property,shown,hidden)
    if not object then return end
    table.insert(identityBindings,{Object=object,Property=property,Shown=shown,Hidden=hidden})
    object[property]=hideDashboardName and hidden or shown
end
local function refreshIdentity()
    for _,binding in ipairs(identityBindings) do
        binding.Object[binding.Property]=hideDashboardName and binding.Hidden or binding.Shown
    end
end
local selectedTheme="Midnight"
local selectedPreset="Serenity Grimoire"
local presetControl
local dragControl
local presetNames={"Custom","Serenity Grimoire","Aurora","Deep Ocean","Moonstone","Violet","Rose Quartz","Jade","Ember","Frost","Graphite","Garnet","Antique Gold","Petrol","Dusk","Espresso"}
local restoringAppearance=false
local themeNames={"Aurora","Ocean","Lavender","Rose","Emerald","Slate","Amber","Crimson","Arctic","Amethyst","Midnight","Garnet","AntiqueGold","Petrol","Dusk","Espresso"}
local function markCustom()
    if restoringAppearance then return end
    selectedPreset="Custom"
    if presetControl then presetControl:Set("Custom",true) end
    if app.RefreshPresetGallery then app.RefreshPresetGallery() end
end
-- Complete low-saturation palettes: surfaces, typography, states and accents.
local themeSpecs={
    Garnet={{30,18,22},{241,225,220},{210,100,107},{158,119,110}},
    AntiqueGold={{23,23,21},{239,232,212},{192,168,107},{143,139,112}},
    Petrol={{14,29,31},{216,235,228},{78,179,168},{151,170,132}},
    Dusk={{25,24,35},{233,227,241},{147,137,207},{189,146,134}},
    Espresso={{30,24,20},{242,228,211},{193,145,108},{163,150,126}},
    Aurora={{21,30,35},{223,234,229},{115,172,164},{150,144,177}},
    Midnight={{17,28,43},{232,223,203},{112,151,186},{171,149,104}},
    Ocean={{15,29,37},{220,233,234},{92,166,177},{108,148,157}},
    Lavender={{29,29,39},{229,226,237},{157,151,192},{132,127,159}},
    Rose={{34,26,31},{237,224,226},{183,137,154},{147,117,128}},
    Emerald={{19,31,28},{223,233,224},{114,166,141},{112,141,119}},
    Slate={{24,26,30},{226,229,232},{155,167,183},{115,123,135}},
    Amber={{33,27,23},{239,228,208},{192,157,108},{155,128,90}},
    Crimson={{33,23,27},{237,222,223},{189,121,132},{151,106,113}},
    Arctic={{22,31,38},{224,235,238},{135,180,193},{124,151,163}},
    Amethyst={{29,24,38},{231,223,236},{166,139,192},{139,117,158}},
}
local function completePalette(name)
    local spec=themeSpecs[name] or themeSpecs.Midnight
    local base,text,accent,trim=spec[1],spec[2],spec[3],spec[4]
    local function rgb(v,offset)
        return Color3.fromRGB(math.clamp(v[1]+(offset or 0),0,255),math.clamp(v[2]+(offset or 0),0,255),math.clamp(v[3]+(offset or 0),0,255))
    end
    return {
        Shell=rgb(base),Topbar=rgb(base),ShellDeep=rgb(base,-5),ShellSoft=rgb(base,3),Sidebar=rgb(base,1),
        Panel=rgb(base,7),PanelSoft=rgb(base,14),Surface=rgb(base,2),SurfaceSoft=rgb(base,5),Control=rgb(base,5),
        ControlHover=rgb(base,20),RowHover=rgb(base,20),Inset=rgb(base,12),InsetHover=rgb(base,23),Popup=rgb(base,4),
        NavActive=rgb(base,26),NavHover=rgb(base,17),Text=rgb(text),TextMuted=rgb(text,-49),TextDim=rgb(text,-68),
        Divider=rgb(base,27),Stroke=rgb(base,43),StrokeBright=rgb(trim),Disabled=rgb(base,43),
        Accent=rgb(accent),Blue=rgb(accent),AccentBright=rgb(accent,15),Cyan=rgb(accent,8),Lavender=rgb(trim),
    }
end
local originalColors={}
for key,color in pairs(Tokens.Color) do originalColors[key]=color end
local function applyTheme(name)
    markCustom()
    selectedTheme=name
    local previousColors={}
    for key,color in pairs(Tokens.Color) do previousColors[key]=color end
    local palette=completePalette(name)
    for key,original in pairs(originalColors) do Tokens.Color[key]=palette[key] or original end
    local themedObjects=app.ScreenGui:GetDescendants()
    if app.NotificationScreenGui then
        for _,object in ipairs(app.NotificationScreenGui:GetDescendants()) do table.insert(themedObjects,object) end
    end
    for _,object in ipairs(themedObjects) do
        local props={}
        if object:GetAttribute("FixedPresetColor") then
            -- Gallery swatches preview their own preset, independent of the active theme.
        elseif object:IsA("GuiObject") then table.insert(props,"BackgroundColor3") end
        if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then table.insert(props,"TextColor3") end
        if object:IsA("UIStroke") then table.insert(props,"Color") end
        if object:IsA("ImageLabel") or object:IsA("ImageButton") then table.insert(props,"ImageColor3") end
        if object:GetAttribute("FixedPresetColor") then props={} end
        for _,prop in ipairs(props) do
            themeBindings[object]=themeBindings[object] or {}
            local binding=themeBindings[object][prop]
            if not binding then
                local original=object[prop]
                for key,color in pairs(previousColors) do
                    if original==color then binding=key break end
                end
                if not binding then binding=original end
                themeBindings[object][prop]=binding
            end
            if type(binding)=="string" then object[prop]=Tokens.Color[binding]

            end
        end
    end
    if refreshMaterials then refreshMaterials() end
    saveAppearance()
end

-- Event-driven materials: no heartbeat, textures or animated full-screen layers.
local materialState={Mode="Basic",Opacity=100,Edge=30,Palette="Match theme",Blur=0}
local appearancePath="Serenity_UI_Test_Appearance_v3.json"
local HttpService=game:GetService("HttpService")
local saveRevision=0
local uiSoundsEnabled=true
local uiSoundVolume=60
saveAppearance=function()
    saveRevision=saveRevision+1
    local revision=saveRevision
    task.delay(0.7,function()
        if revision~=saveRevision or type(writefile)~="function" then return end
        pcall(function()
            writefile(appearancePath,HttpService:JSONEncode({Version=1,MotionVersion=1,HideDashboardName=hideDashboardName,Theme=selectedTheme,Preset=selectedPreset,DragStyle=runtime.DragStyle,ReducedMotion=Motion.Reduced,Mode=materialState.Mode,Opacity=materialState.Opacity,Edge=materialState.Edge,Palette=materialState.Palette,Blur=materialState.Blur,UISoundsEnabled=uiSoundsEnabled,UISoundVolume=uiSoundVolume,View=app:GetViewState()}))
        end)
    end)
end
local savedAppearance
if type(readfile)=="function" then
    local ok,data=pcall(function() return HttpService:JSONDecode(readfile(appearancePath)) end)
    if ok and type(data)=="table" and data.Version==1 then savedAppearance=data end
end
if savedAppearance then
    uiSoundsEnabled=savedAppearance.UISoundsEnabled~=false
    local volume=tonumber(savedAppearance.UISoundVolume)
    if volume and volume==volume then uiSoundVolume=math.clamp(volume,0,100) end
end
-- A single local UI sound is reused; preload only this short, essential asset.
local uiClick=Instance.new("Sound")
uiClick.Name="SerenitySelectionClick"
uiClick.SoundId="rbxassetid://133196982070163"
uiClick.Volume=math.min(2,uiSoundVolume/50)
uiClick.Parent=game:GetService("SoundService")
runtime:TrackCleanup(function() uiClick:Destroy() end)
local lastUIClick=-math.huge
local uiSoundReady=uiClick.IsLoaded
local uiSoundFailed=false
local soundWaiting=false
local previewSound
local function updateSoundPreview()
    if previewSound then
        previewSound.Text=uiSoundFailed and "Sound unavailable · check asset access" or
            (uiSoundReady and "Play test sound  ›" or "Loading sound…")
    end
end
local function playReadySound()
    if runtime.Destroyed or not uiClick.Parent then return end
    uiClick.Volume=math.min(2,uiSoundVolume/50)
    uiClick.TimePosition=0
    uiClick:Play()
end
runtime:TrackConnection(uiClick.Loaded:Connect(function()
    uiSoundReady=true
    uiSoundFailed=false
    updateSoundPreview()
    if soundWaiting then soundWaiting=false;playReadySound() end
end))
task.spawn(function()
    local result
    local ok,preloadError=pcall(function()
        game:GetService("ContentProvider"):PreloadAsync({uiClick},function(_,status) result=status end)
    end)
    if runtime.Destroyed then return end
    uiSoundReady=uiClick.IsLoaded or (ok and result==Enum.AssetFetchStatus.Success)
    if not uiSoundReady and (not ok or (result and result~=Enum.AssetFetchStatus.Success)) then
        uiSoundFailed=true
        warn("[Serenity UI] Sound 133196982070163 could not load ("..tostring(result and result.Name or preloadError).."). Check Creator Store distribution or experience permissions.")
    end
    updateSoundPreview()
    if uiSoundReady and soundWaiting then soundWaiting=false;playReadySound() end
end)
deps.PlayUISound=function(force)
    if runtime.Destroyed or (not force and not uiSoundsEnabled) or uiSoundVolume<=0 then return end
    local now=os.clock()
    if not force and now-lastUIClick<0.11 then return end
    lastUIClick=now
    if uiSoundReady or uiClick.IsLoaded then
        playReadySound()
    elseif not uiSoundFailed then
        soundWaiting=true
    end
end
local glassSelectors={}
local edgePalettes={
    Aurora={Color3.fromRGB(107,224,255),Color3.fromRGB(174,153,255),Color3.fromRGB(255,206,163)},
    Ice={Color3.fromRGB(111,190,255),Color3.fromRGB(222,250,255),Color3.fromRGB(112,240,219)},
    Sunset={Color3.fromRGB(255,170,114),Color3.fromRGB(255,148,200),Color3.fromRGB(175,158,255)},
}
refreshMaterials=function()
    local enhanced=materialState.Mode=="Enhanced"
    local off=materialState.Mode=="Off"
    local colors=edgePalettes[materialState.Palette]
    if not colors then
        local h=select(1,Tokens.Color.Accent:ToHSV())
        colors={Color3.fromHSV(h,0.60,1),Color3.fromHSV((h+0.13)%1,0.32,1),Color3.fromHSV((h+0.28)%1,0.48,1)}
    end
    local spectrum=ColorSequence.new({ColorSequenceKeypoint.new(0,colors[1]),ColorSequenceKeypoint.new(0.48,colors[2]),ColorSequenceKeypoint.new(1,colors[3])})
    for _,object in ipairs(app.ScreenGui:GetDescendants()) do
        local role=object:GetAttribute("GlassRole")
        if role and object:IsA("GuiObject") then
            -- Do not give intentionally transparent heading containers a fill.
            if not (role=="Section" and not object:FindFirstChild("PanelStroke")) then
                local amount=(100-materialState.Opacity)/100
                if deps.Mobile then amount=math.min(amount,0.08) end
                object.BackgroundTransparency=off and 0 or (role=="Shell" and amount or role=="Sidebar" and amount*0.55 or amount*0.8)
                if object:GetAttribute("ReadingSurface") then
                    object.BackgroundTransparency=math.min(object.BackgroundTransparency,0.06)
                end
                local g=object:FindFirstChild("GlassSheen") or object:FindFirstChild("ShellTone")
                if not g then g=Instance.new("UIGradient");g.Name="GlassSheen";g.Parent=object end
                g.Rotation=115
                g.Color=ColorSequence.new(Color3.new(1,1,1))
                g.Transparency=NumberSequence.new(0)
                if not object:FindFirstChildOfClass("UIListLayout") and not object:FindFirstChildOfClass("UIGridLayout") then
                local lip=object:FindFirstChild("SpecularLip")
                if not lip then
                    lip=Instance.new("Frame");lip.Name="SpecularLip";lip.BorderSizePixel=0
                    lip.Position=UDim2.fromOffset(12,1);lip.Size=UDim2.new(1,-24,0,1)
                    lip.ZIndex=object.ZIndex+1;lip.Active=false;lip.Parent=object
                    local gl=Instance.new("UIGradient");gl.Name="Spectrum";gl.Parent=lip
                    gl.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.3,0.1),NumberSequenceKeypoint.new(0.7,0.35),NumberSequenceKeypoint.new(1,1)})
                end
                lip.Visible=enhanced;lip.BackgroundColor3=Color3.new(1,1,1);lip.BackgroundTransparency=0.24
                lip.Spectrum.Color=spectrum
                end
            end
        end
        if object:IsA("UIStroke") and (object.Name=="PanelStroke" or object.Name=="ShellEdge" or object.Parent.Name=="GlassRim") then
            local outer=object.Parent.Name=="GlassRim"
            object.Color=Tokens.Color.Stroke
            object.Thickness=outer and 1.7 or 1
            object.Transparency=1-(materialState.Edge/100)*(outer and 1 or 0.57)
            local g=object:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
            g.Parent=object;g.Color=ColorSequence.new(Tokens.Color.Stroke);g.Rotation=35
            g.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.52,0.25),NumberSequenceKeypoint.new(1,0)})
        end
    end
end
function app:SetGlassQuality(value)
    markCustom()
    materialState.Mode=value
    if self.Acrylic then self.Acrylic:SetQuality(value) end
    for _,control in ipairs(glassSelectors) do control:Set(value,true) end
    refreshMaterials()
    saveAppearance()
end
local function glassSelector(parent,title)
    local control=Select.new(parent,deps,{Title=title,Options={"Off","Basic","Enhanced"},Default=materialState.Mode,Callback=function(v) app:SetGlassQuality(v) end})
    table.insert(glassSelectors,control)
    return control
end
local appearance = Section.new(settingsCols.Left, deps, {Title="Appearance"})
local themeControl=Select.new(appearance.Body,deps,{Title="Color theme",Options=themeNames,Default="Midnight",Callback=applyTheme})
glassSelector(appearance.Body,"Glass material")
local paletteControl=Select.new(appearance.Body,deps,{Title="Border colors",Options={"Aurora","Ice","Sunset","Match theme"},Default="Aurora",Callback=function(v) markCustom();materialState.Palette=v;refreshMaterials();saveAppearance() end})
local edgeControl=Slider.new(appearance.Body,deps,{Title="Border intensity",Min=0,Max=100,Step=1,Default=54,Suffix="%",Callback=function(v) markCustom();materialState.Edge=v;refreshMaterials();saveAppearance() end})
local opacityControl=Slider.new(appearance.Body,deps,{Title="Material opacity",Min=50,Max=100,Step=1,Default=85,Suffix="%",Callback=function(v) markCustom();materialState.Opacity=v;refreshMaterials();saveAppearance() end})
local blurControl=Slider.new(appearance.Body, deps, {Title="Blur Amount", Min=0, Max=8, Step=1, Default=3, Callback=function(v) markCustom();materialState.Blur=v;if app.Acrylic then app.Acrylic:SetAmount(v) end;saveAppearance() end})
local function restoreAppearance(data)
    data=data or {}
    restoringAppearance=true
    if data.ReducedMotion~=nil then
        Motion.Reduced=data.ReducedMotion==true;runtime.ReducedMotion=Motion.Reduced
        app:RefreshIconMotion()
        for _,control in ipairs(motionControls) do control:Set(Motion.Reduced,true) end
    end
    local function choice(value,options,fallback)
        for _,v in ipairs(options) do if value==v then return value end end
        return fallback
    end
    local function number(value,low,high,fallback)
        if type(value)~="number" or value~=value or math.abs(value)==math.huge then return fallback end
        return math.clamp(value,low,high)
    end
    materialState.Mode=choice(data.Mode,{"Off","Basic","Enhanced"},"Basic")
    materialState.Palette=choice(data.Palette,{"Aurora","Ice","Sunset","Match theme"},"Match theme")
    materialState.Edge=number(data.Edge,0,100,54)
    materialState.Opacity=number(data.Opacity,50,100,100)
    materialState.Blur=number(data.Blur,0,8,0)
    local theme=choice(data.Theme,themeNames,"Midnight")
    themeControl:Set(theme,true);paletteControl:Set(materialState.Palette,true)
    edgeControl:Set(materialState.Edge,true);opacityControl:Set(materialState.Opacity,true);blurControl:Set(materialState.Blur,true)
    applyTheme(theme)
    if app.Acrylic then app.Acrylic:SetAmount(materialState.Blur) end
    app:SetGlassQuality(materialState.Mode)
    runtime.DragStyle=choice(data.DragStyle,{"Outline","Smooth","Direct"},"Outline")
    selectedPreset=choice(data.Preset,presetNames,data.Theme and "Custom" or "Serenity Grimoire")
    if dragControl then dragControl:Set(runtime.DragStyle,true) end
    if presetControl then presetControl:Set(selectedPreset,true) end
    restoringAppearance=false
    if app.RefreshPresetGallery then app.RefreshPresetGallery() end
end
local reset=Instance.new("TextButton")
reset.Size=UDim2.new(1,0,0,36);reset.Text="Restore preferred appearance"
reset.Font=Enum.Font.GothamMedium;reset.TextSize=12;reset.TextColor3=Tokens.Color.Text
reset.Parent=appearance.Body;Material.Inset(reset,Tokens)
reset.Activated:Connect(function() if serenityInputBlocked(reset) then return end; restoreAppearance(nil) end)
local presets={
    {Name="Serenity Grimoire",Theme="Midnight",Mode="Basic",Palette="Match theme",Opacity=100,Edge=45,Blur=0,Color=Color3.fromRGB(171,149,104)},
    {Name="Aurora",Theme="Aurora",Mode="Enhanced",Palette="Aurora",Opacity=92,Edge=72,Blur=4,Color=Color3.fromRGB(77,193,215)},
    {Name="Deep Ocean",Theme="Ocean",Mode="Basic",Palette="Ice",Opacity=98,Edge=38,Blur=2,Color=Color3.fromRGB(65,153,227)},
    {Name="Moonstone",Theme="Lavender",Mode="Enhanced",Palette="Match theme",Opacity=94,Edge=45,Blur=3,Color=Color3.fromRGB(154,158,230)},
    {Name="Violet",Theme="Amethyst",Mode="Enhanced",Palette="Match theme",Opacity=96,Edge=65,Blur=3,Color=Color3.fromRGB(186,117,240)},
    {Name="Rose Quartz",Theme="Rose",Mode="Enhanced",Palette="Match theme",Opacity=94,Edge=56,Blur=3,Color=Color3.fromRGB(229,122,182)},
    {Name="Jade",Theme="Emerald",Mode="Basic",Palette="Match theme",Opacity=97,Edge=46,Blur=2,Color=Color3.fromRGB(70,201,143)},
    {Name="Ember",Theme="Amber",Mode="Enhanced",Palette="Sunset",Opacity=97,Edge=58,Blur=2,Color=Color3.fromRGB(237,174,83)},
    {Name="Frost",Theme="Arctic",Mode="Enhanced",Palette="Ice",Opacity=93,Edge=65,Blur=4,Color=Color3.fromRGB(100,209,222)},
    {Name="Graphite",Theme="Slate",Mode="Off",Palette="Match theme",Opacity=100,Edge=30,Blur=0,Color=Color3.fromRGB(151,166,184)},
    {Name="Garnet",Theme="Garnet",Mode="Basic",Palette="Match theme",Opacity=100,Edge=40,Blur=0,Color=Color3.fromRGB(210,100,107)},
    {Name="Antique Gold",Theme="AntiqueGold",Mode="Basic",Palette="Match theme",Opacity=100,Edge=38,Blur=0,Color=Color3.fromRGB(192,168,107)},
    {Name="Petrol",Theme="Petrol",Mode="Basic",Palette="Match theme",Opacity=100,Edge=42,Blur=0,Color=Color3.fromRGB(78,179,168)},
    {Name="Dusk",Theme="Dusk",Mode="Basic",Palette="Match theme",Opacity=100,Edge=38,Blur=0,Color=Color3.fromRGB(147,137,207)},
    {Name="Espresso",Theme="Espresso",Mode="Basic",Palette="Match theme",Opacity=100,Edge=36,Blur=0,Color=Color3.fromRGB(193,145,108)},
}
local presetTiles={}
local function highlightPreset()
    for name,tile in pairs(presetTiles) do
        tile.Badge.Text=selectedPreset==name and "✓" or ""
        tile.Stroke.Transparency=selectedPreset==name and 0.12 or 0.72
    end
end
local function usePreset(name)
    for _,preset in ipairs(presets) do
        if preset.Name==name then
            local data={};for k,v in pairs(preset) do data[k]=v end
            data.Preset=name;data.DragStyle=runtime.DragStyle
            restoreAppearance(data)
            highlightPreset();saveAppearance()
            return
        end
    end
end
local presetSection=Section.new(settingsCols.Left,deps,{Title="Style presets",Description="Fifteen coordinated looks. Your settings save automatically."})
presetSection.Frame.LayoutOrder=-1
presetControl=Select.new(presetSection.Body,deps,{Title="Choose a preset",Options=presetNames,Default="Custom",Callback=function(v)
    if v=="Custom" then selectedPreset=v;highlightPreset();saveAppearance() else usePreset(v) end
end})
runtime:TrackConnection(presetControl.Frame:GetPropertyChangedSignal("Visible"):Connect(highlightPreset))
local dragSection=Section.new(settingsCols.Left,deps,{Title="Window movement",Tooltip="Drag freely beyond the screen edges. Double-tap the floating star or use Reset all floating positions to recover. Outline previews movement; Smooth glides; Direct follows immediately."})
dragControl=Select.new(dragSection.Body,deps,{Title="Drag style",Options={"Outline","Smooth","Direct"},Default="Outline",Callback=function(v) runtime.DragStyle=v;saveAppearance() end})
reducedMotionToggle(dragSection.Body)
do
    local reset=Instance.new("TextButton");reset.Size=UDim2.new(1,0,0,34)
    reset.Text="Reset all floating positions";reset.TextSize=12;reset.Font=Enum.Font.GothamMedium
    reset.TextColor3=Tokens.Color.Text;reset.BackgroundColor3=Tokens.Color.PanelSoft
    reset.BorderSizePixel=0;reset.AutoButtonColor=false;reset.Parent=dragSection.Body
    reset.Activated:Connect(function() app:ResetFloatingPositions() end)
end
local soundSection=Section.new(settingsCols.Left,deps,{Title="Interface sounds",Description="Gentle cues for categories, confirmations and window controls."})
Toggle.new(soundSection.Body,deps,{Title="Interface sounds",Default=uiSoundsEnabled,Callback=function(v) uiSoundsEnabled=v;saveAppearance() end})
Slider.new(soundSection.Body,deps,{Title="Sound volume",Min=0,Max=100,Step=5,Default=uiSoundVolume,Suffix="%",Callback=function(v) uiSoundVolume=v;saveAppearance() end})
previewSound=Instance.new("TextButton")
previewSound.Name="PreviewSound"
previewSound.Size=UDim2.new(1,0,0,36)
updateSoundPreview()
previewSound.Font=Enum.Font.GothamMedium
previewSound.TextSize=12
previewSound.TextColor3=Tokens.Color.Text
previewSound.AutoButtonColor=true
previewSound.Parent=soundSection.Body
Material.Inset(previewSound,Tokens)
previewSound.Activated:Connect(function() if serenityInputBlocked(previewSound) then return end; deps.PlayUISound(true) end)
local gallery=Section.new(settingsCols.Right,deps,{Title="Preset gallery",Description="Click a swatch to apply the complete look."})
local grid=Instance.new("Frame");grid.Size=UDim2.new(1,0,0,math.ceil(#presets/2)*73-8);grid.BackgroundTransparency=1;grid.Parent=gallery.Body
local layout=Instance.new("UIGridLayout");layout.CellSize=UDim2.new(0.5,-5,0,65);layout.CellPadding=UDim2.fromOffset(10,8)
layout.SortOrder=Enum.SortOrder.LayoutOrder;layout.FillDirectionMaxCells=2;layout.Parent=grid
for i,preset in ipairs(presets) do
    local tile=Instance.new("TextButton");tile.Name=preset.Name;tile.Text="";tile.AutoButtonColor=false
    tile.BackgroundColor3=Tokens.Color.PanelSoft;tile.BackgroundTransparency=0.05;tile.LayoutOrder=i;tile.Parent=grid
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,8);corner.Parent=tile
    local stroke=Instance.new("UIStroke");stroke.Color=preset.Color;stroke.Transparency=0.72;stroke:SetAttribute("FixedPresetColor",true);stroke.Parent=tile
    local strip=Instance.new("Frame");strip.BorderSizePixel=0;strip.BackgroundColor3=preset.Color;strip:SetAttribute("FixedPresetColor",true)
    strip.Position=UDim2.fromOffset(10,11);strip.Size=UDim2.new(1,-20,0,5);strip.Parent=tile
    local round=Instance.new("UICorner");round.CornerRadius=UDim.new(1,0);round.Parent=strip
    local name=Typography.Label(tile,"Control",Tokens,preset.Name,UDim2.fromOffset(10,24),UDim2.new(1,-31,0,20),Tokens.Color.Text)
    name.TextSize=11;name.TextTruncate=Enum.TextTruncate.AtEnd
    local badge=Typography.Label(tile,"Control",Tokens,"",UDim2.new(1,-21,0,24),UDim2.fromOffset(16,20),preset.Color)
    badge:SetAttribute("FixedPresetColor",true)
    presetTiles[preset.Name]={Badge=badge,Stroke=stroke}
    Material.OptionHover(tile,Tokens,false,Motion)
    runtime:TrackConnection(tile.Activated:Connect(function() if serenityInputBlocked(tile) then return end; usePreset(preset.Name) end))
end

-- Selection changes are reflected through the stored preset value, including custom edits.
app.RefreshPresetGallery=highlightPreset


-- Dashboard: local preview with real player/session context; services stay disconnected.
do
    local player=game:GetService("Players").LocalPlayer
    local started=os.clock()
    local function logicalWidth(frame)
        return frame.AbsoluteSize.X/math.max(deps.UIScale.Scale,0.01)
    end
    local function card(parent,height,order)
        local f=Instance.new("Frame");f.Size=UDim2.new(1,-4,0,height)
        f.LayoutOrder=order or 1;f.Parent=parent;Material.Section(f,Tokens)
        f:SetAttribute("ReadingSurface",true)
        local _,brackets=Material.PixelCorners(f,Tokens,5)
        local function feedback(active)
            for _,part in ipairs(brackets) do
                Motion:Tween(part,"Hover",{BackgroundTransparency=active and 0.38 or 0.72})
            end
        end
        runtime:TrackConnection(f.MouseEnter:Connect(function() if serenityInputBlocked(f) then return end; feedback(true) end))
        runtime:TrackConnection(f.MouseLeave:Connect(function() feedback(false) end))
        return f
    end
    local function label(parent,message,x,y,w,h,size,color)
        local l=Typography.Label(parent,"Control",Tokens,message,UDim2.fromOffset(x,y),UDim2.new(1,w,0,h),color or Tokens.Color.Text)
        l.TextSize=size or 13;l.Font=(size or 13)>=14 and Enum.Font.GothamBold or Enum.Font.Gotham
        return l
    end
    local function button(parent,message,callback)
        local b=Instance.new("TextButton");b.Text=message;b.AutoButtonColor=false
        b.Font=Enum.Font.GothamMedium;b.TextSize=12;b.TextColor3=Tokens.Color.Text
        b.Parent=parent;Material.Inset(b,Tokens)
        runtime:TrackConnection(b.Activated:Connect(callback))
        local normal=b.BackgroundTransparency
        runtime:TrackConnection(b.MouseEnter:Connect(function() if serenityInputBlocked(b) then return end; Motion:Tween(b,"Hover",{BackgroundTransparency=0.05}) end))
        runtime:TrackConnection(b.MouseLeave:Connect(function() Motion:Tween(b,"Hover",{BackgroundTransparency=normal}) end))
        return b
    end
    local heading=Instance.new("Frame");heading.Size=UDim2.new(1,-4,0,48)
    heading.BackgroundTransparency=1;heading.LayoutOrder=1;heading.Parent=dashboard
    local dashboardTitle=label(heading,"Dashboard",0,0,-112,27,23)
    local dashboardSubtitle=label(heading,"Your Serenity grimoire",0,28,-112,18,12,Tokens.Color.TextMuted)
    local badge=Instance.new("TextLabel");badge.AnchorPoint=Vector2.new(1,0)
    badge.Position=UDim2.new(1,0,0,8);badge.Size=UDim2.fromOffset(92,25)
    badge.Text="UI TEST  ·  M4.71";badge.TextSize=10;badge.Font=Enum.Font.GothamBold
    badge.TextColor3=Tokens.Color.Accent;badge.Parent=heading;Material.Inset(badge,Tokens)
    local function arrangeHeading()
        local wide=logicalWidth(heading)>=350
        badge.Visible=wide
        dashboardTitle.Size=UDim2.new(1,wide and -112 or 0,0,27)
        dashboardSubtitle.Size=UDim2.new(1,wide and -112 or 0,0,18)
    end
    runtime:TrackConnection(heading:GetPropertyChangedSignal("AbsoluteSize"):Connect(arrangeHeading));arrangeHeading()

    local hero=card(dashboard,142,2);hero.Name="DashboardHero";hero.ClipsDescendants=true
    hideDashboardName=savedAppearance and savedAppearance.HideDashboardName==true or false
    local greeting=label(hero,hideDashboardName and "Welcome back" or "Welcome back, "..player.DisplayName,18,15,-125,28,20)
    registerIdentity(greeting,"Text","Welcome back, "..player.DisplayName,"Welcome back")
    registerIdentity(app.IdentityName,"Text",player.DisplayName,"Hidden profile")
    registerIdentity(app.IdentityAvatar,"ImageTransparency",0,1)
    greeting.TextTruncate=Enum.TextTruncate.AtEnd
    local note=label(hero,"Choose a workspace below. Make Serenity yours.",18,48,-125,34,12,Tokens.Color.TextMuted)
    note.TextWrapped=true;note.TextYAlignment=Enum.TextYAlignment.Top
    local portrait=Instance.new("ImageLabel");portrait.Name="DashboardAvatar"
    portrait.AnchorPoint=Vector2.new(1,0);portrait.Position=UDim2.new(1,-18,0,19)
    portrait.Size=UDim2.fromOffset(68,68);portrait.BackgroundTransparency=0.2
    portrait.BackgroundColor3=Tokens.Color.PanelSoft;portrait.ScaleType=Enum.ScaleType.Fit
    portrait.ImageTransparency=0
    portrait.Image="rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=420&h=420";portrait.Parent=hero
    local curve=Instance.new("UICorner");curve.CornerRadius=UDim.new(1,0);curve.Parent=portrait
    local ring=Instance.new("UIStroke");ring.Color=Tokens.Color.Accent;ring.Transparency=0.5;ring.Parent=portrait
    registerIdentity(portrait,"ImageTransparency",0,1)
    -- Show the thumbnail directly; executor load flags can remain false after rendering.
    local explore=button(hero,"Explore components  ›",function() app:SelectPage("Playground") end)
    explore.Position=UDim2.fromOffset(18,94);explore.Size=UDim2.fromOffset(166,34)
    local customize=button(hero,"Customize",function() app:SelectPage("Settings") end)
    customize.Position=UDim2.fromOffset(192,94);customize.Size=UDim2.fromOffset(104,34)
    local function arrangeHero()
        local wide=logicalWidth(hero)>=390
        explore.Size=UDim2.fromOffset(math.max(80,math.min(166,logicalWidth(hero)-36)),34)
        portrait.Visible=wide
        greeting.Size=UDim2.new(1,wide and -125 or -36,0,28)
        note.Size=UDim2.new(1,wide and -125 or -36,0,34)
        customize.Visible=logicalWidth(hero)>=320
    end
    runtime:TrackConnection(hero:GetPropertyChangedSignal("AbsoluteSize"):Connect(arrangeHero));arrangeHero()

    local metrics=Instance.new("Frame");metrics.Size=UDim2.new(1,-4,0,60)
    metrics.BackgroundTransparency=1;metrics.LayoutOrder=3;metrics.Parent=dashboard
    local tiles,values={},{}
    for i,data in ipairs({{"SESSION","00:00","activity"},{"CURRENT PLACE",tostring(game.PlaceId),"server"},{"CONNECTION","Preview only","info"}}) do
        local tile=card(metrics,60);tiles[i]=tile
        local icon=Icons.Create(tile,data[3],15,Tokens.Color.Accent,UDim2.fromOffset(12,11))
        label(tile,data[1],34,9,-42,18,10,Tokens.Color.TextMuted)
        values[i]=label(tile,data[2],12,30,-24,22,i==2 and 13 or 15)
        values[i].TextTruncate=Enum.TextTruncate.AtEnd
    end
    local function arrangeMetrics()
        local width=logicalWidth(metrics);if width<=0 then return end
        local count=width>=480 and 3 or (width>=310 and 2 or 1)
        local gap=8;local w=(width-gap*(count-1))/count
        for i,tile in ipairs(tiles) do
            tile.Size=UDim2.fromOffset(w,60)
            tile.Position=UDim2.fromOffset(((i-1)%count)*(w+gap),math.floor((i-1)/count)*68)
        end
        metrics.Size=UDim2.new(1,-4,0,math.ceil(#tiles/count)*68-8)
    end
    runtime:TrackConnection(metrics:GetPropertyChangedSignal("AbsoluteSize"):Connect(arrangeMetrics));arrangeMetrics()
    app:Tooltip(tiles[3],"This preview does not connect game automation, authentication or active-user services.")
    local timer
    local function updateSession()
        timer=nil
        if runtime.Destroyed or not dashboard.Visible or not app.Holder.Visible then return end
        local elapsed=math.floor(os.clock()-started)
        values[1].Text=string.format("%02d:%02d",math.floor(elapsed/60),elapsed%60)
        timer=task.delay(1,updateSession)
    end
    local function refreshSession()
        if timer then pcall(task.cancel,timer);timer=nil end
        updateSession()
    end
    runtime:TrackConnection(dashboard:GetPropertyChangedSignal("Visible"):Connect(refreshSession))
    runtime:TrackConnection(app.Holder:GetPropertyChangedSignal("Visible"):Connect(refreshSession))
    refreshSession()
    runtime:TrackCleanup(function() if timer then pcall(task.cancel,timer);timer=nil end end)

    local workspaces=card(dashboard,118,4);workspaces.Name="DashboardWorkspaces"
    label(workspaces,"Quick Menu",14,9,-28,24,15)
    local destinations={
        {"Fly","Disabled","automation","fly"},
        {"Noclip","Disabled","progression","noclip"},
        {"Player ESP","Disabled","settings","esp"},
    }
    local shortcuts={}
    for i,data in ipairs(destinations) do
        local b=button(workspaces,"",function() local action=app:GetQuickAction(data[4]);if action then app:SetQuickPanelEnabled(data[4],not action.PanelEnabled) end end);shortcuts[i]=b
        Icons.Create(b,data[3],20,Tokens.Color.Accent,UDim2.fromOffset(10,11))
        local title=label(b,data[1],38,8,-90,22,13)
        title.Font=Enum.Font.GothamMedium
        local sub=label(b,data[2],10,38,-20,18,11,Tokens.Color.TextMuted)
        sub.TextTruncate=Enum.TextTruncate.AtEnd
        local switch=Instance.new("Frame");switch.Size=UDim2.fromOffset(32,19)
        switch.Position=UDim2.new(1,-42,0,12);switch.BorderSizePixel=0;switch.Parent=b
        local round=Instance.new("UICorner");round.CornerRadius=UDim.new(0,4);round.Parent=switch
        local dot=Instance.new("Frame");dot.Size=UDim2.fromOffset(13,13);dot.BorderSizePixel=0
        dot.BackgroundColor3=Tokens.Color.Text;dot.Parent=switch
        local dotCorner=Instance.new("UICorner");dotCorner.CornerRadius=UDim.new(0,2);dotCorner.Parent=dot
        app:ObserveQuickAction(data[4],function(action)
            sub.Text=action.Busy and "Applying…" or (action.PanelEnabled and "Panel enabled" or "Panel disabled")
            sub.TextColor3=action.PanelEnabled and Tokens.Color.Accent or Tokens.Color.TextMuted
            switch.BackgroundColor3=action.PanelEnabled and Tokens.Color.Accent or Tokens.Color.Inset
            dot.Position=UDim2.fromOffset(action.PanelEnabled and 16 or 3,3)
        end)
    end
    local function arrangeShortcuts()
        local width=logicalWidth(workspaces);if width<=0 then return end
        local count=width>=480 and 3 or 1
        local w=(width-28-8*(count-1))/count
        for i,b in ipairs(shortcuts) do
            b.Size=UDim2.fromOffset(w,64)
            b.Position=UDim2.fromOffset(14+((i-1)%count)*(w+8),41+math.floor((i-1)/count)*72)
        end
        workspaces.Size=UDim2.new(1,-4,0,41+math.ceil(#shortcuts/count)*72+5)
    end
    runtime:TrackConnection(workspaces:GetPropertyChangedSignal("AbsoluteSize"):Connect(arrangeShortcuts));arrangeShortcuts()

    local cols=ColumnLayout.new(dashboard,deps,{LayoutOrder=5,Gap=10})
    local quick=Section.new(cols.Left,deps,{Title="Make it yours",Tooltip="These preferences change the UI. Game rendering and FPS controls belong in Misc."})
    Toggle.new(quick.Body,deps,{Title="Hide my name",Default=hideDashboardName,Callback=function(value)
        hideDashboardName=value==true
        refreshIdentity()
        saveAppearance()
    end})
    reducedMotionToggle(quick.Body)
    glassSelector(quick.Body,"Glass material")
    local openSettings=button(quick.Body,"Appearance & preferences  ›",function() app:SelectPage("Settings") end)
    openSettings.Size=UDim2.new(1,0,0,38)
    local news=Section.new(cols.Right,deps,{Title="What's new · M4.71"})
    for i,data in ipairs({{"Quieter background work","Dashboard timing sleeps while hidden and catches up when reopened."},{"Batched responsive layout","Size changes share a layout pass; compact sections stay responsive."},{"Focus-aware animation","Decorative motion pauses outside Roblox and resumes on return."}}) do
        local row=Instance.new("Frame");row.Size=UDim2.new(1,0,0,55)
        row.BackgroundTransparency=1;row.LayoutOrder=i;row.Parent=news.Body
        local dot=Instance.new("Frame");dot.Size=UDim2.fromOffset(3,15);dot.Position=UDim2.fromOffset(12,9)
        dot.BorderSizePixel=0;dot.BackgroundColor3=i==2 and Tokens.Color.Lavender or Tokens.Color.Accent;dot.Parent=row
        label(row,data[1],24,5,-36,22,12)
        local sub=label(row,data[2],24,27,-36,26,11,Tokens.Color.TextMuted)
        sub.TextWrapped=true;sub.TextYAlignment=Enum.TextYAlignment.Top
    end
    local community=card(dashboard,88,6)
    Icons.Create(community,"discord",25,Tokens.Color.Accent,UDim2.fromOffset(14,16))
    local communityTitle=label(community,"Serenity Hub Discord",48,10,-180,23,15)
    local communityText=label(community,"Help with keys, updates and premium.",48,36,-180,30,12,Tokens.Color.TextMuted)
    communityText.TextWrapped=true
    local join=button(community,"Join Discord  ↗",function()
        app:Confirm({Title="Join Serenity on Discord",
            Message="Get help with keys, updates and premium. Confirm to copy the community invite.",
            ConfirmText="Copy invite",Callback=function(confirmed)
                if not confirmed then return end
                local copy=setclipboard or toclipboard
                local ok=type(copy)=="function" and pcall(copy,"https://discord.gg/pWPs7428wE")
                app:Notify(ok and "Invite copied" or "Community invite",ok and "Paste the invite into your browser or Discord." or "discord.gg/pWPs7428wE",6,ok and "Success" or "Info")
            end})
    end)
    join.Size=UDim2.fromOffset(130,36)
    local function arrangeCommunity()
        local wide=logicalWidth(community)>=440
        community.Size=UDim2.new(1,-4,0,wide and 82 or 130)
        communityTitle.Size=UDim2.new(1,wide and -190 or -62,0,23)
        communityText.Size=UDim2.new(1,wide and -190 or -62,0,32)
        join.Position=wide and UDim2.new(1,-144,0.5,-18) or UDim2.fromOffset(14,80)
    end
    runtime:TrackConnection(community:GetPropertyChangedSignal("AbsoluteSize"):Connect(arrangeCommunity));arrangeCommunity()
    local info=card(about,110)
    label(info,"Serenity preview · M4.71",14,12,-28,26,18)
    local body=label(info,"Gameplay controls are demonstrations. This UI test is separate from the production library and key window.",14,43,-28,54,12,Tokens.Color.TextMuted)
    body.TextWrapped=true
end


-- Interactive component laboratory. All actions remain local to this preview.
do
    local player=game:GetService("Players").LocalPlayer
    local profile=app:AddPage({Id="Profile",Title="Profile",Icon="info",Group="System",Order=8})
    app.ProfileButton.Activated:Connect(function() if serenityInputBlocked(ProfileButton) then return end; app:SelectPage("Profile") end)
    local lab=app:AddPage({Id="Playground",Title="Playground",Icon="settings",Group="System",Order=9})
    local function text(parent,message,height)
        local label=Typography.Label(parent,"Control",Tokens,message,UDim2.new(),UDim2.new(1,-20,0,height or 32),Tokens.Color.Text)
        label.TextWrapped=true
        return label
    end
    local function button(parent,title,callback)
        local b=Instance.new("TextButton")
        b.Size=UDim2.new(1,0,0,34)
        b.Text=title;b.TextSize=12;b.Font=Enum.Font.GothamMedium
        b.TextColor3=Tokens.Color.Text;b.Parent=parent
        Material.Inset(b,Tokens)
        b.AutoButtonColor=false
        Material.OptionHover(b,Tokens,false,Motion)
        b.Activated:Connect(callback)
        return b
    end
    local profileSection=Section.new(profile,deps,{Title="Your profile"})
    registerIdentity(text(profileSection.Body,player.DisplayName,32),"Text",player.DisplayName,"Hidden profile")
    registerIdentity(text(profileSection.Body,"@"..player.Name,28),"Text","@"..player.Name,"Username hidden")
    registerIdentity(text(profileSection.Body,"User ID: "..player.UserId,28),"Text","User ID: "..player.UserId,"User ID hidden")
    text(profileSection.Body,"Local UI preview — no account changes.",32)
    button(profileSection.Body,"Open component playground",function() app:SelectPage("Playground") end)
    local columns=ColumnLayout.new(lab,deps,{Gap=10})
    local status=Section.new(columns.Left,deps,{Title="Interaction result"})
    local result=text(status.Body,"Ready — try a control.",48)
    local function report(value) result.Text=tostring(value) end
    local actions=Section.new(columns.Left,deps,{Title="Buttons & toggles",Collapsible=true,
        Description="Simple actions with immediate feedback.",
        Tooltip="These controls only update this playground. Tap the ? on touch, or hover with a mouse."})
    local count=0
    local counterButton=button(actions.Body,"Click counter",function() count=count+1;report("Button clicks: "..count) end)
    app:Tooltip(counterButton,"Counts your clicks for this test session.")
    local disabled=button(actions.Body,"Disabled button",function() end)
    disabled.Active=false;disabled.AutoButtonColor=false;disabled.TextTransparency=0.6
    local apiToggle=Toggle.new(actions.Body,deps,{Title="Enabled toggle",Default=true,Callback=function(v) report("Toggle: "..tostring(v)) end})
    button(actions.Body,"Show / hide test toggle",function() apiToggle:SetVisible(not apiToggle:IsVisible());report("Toggle visible: "..tostring(apiToggle:IsVisible()).." · value: "..tostring(apiToggle:Get())) end)
    Toggle.new(actions.Body,deps,{Title="Disabled toggle",Enabled=false,Default=false})
    local numbers=Section.new(columns.Left,deps,{Title="Values & precision",
        Description="Drag a slider or type an exact value.",Accent=Tokens.Color.Lavender,
        Tooltip="Drag the track to adjust a value. The value field accepts typed input; steps keep values consistent."})
    Slider.new(numbers.Body,deps,{Title="Amount (1–100)",Min=1,Max=100,Step=1,Default=5,Callback=report})
    Slider.new(numbers.Body,deps,{Title="Delay (0–2 seconds)",Min=0,Max=2,Step=0.1,Default=0.5,Suffix="s",Callback=report})
    Slider.new(numbers.Body,deps,{Title="Signed (-50–50)",Min=-50,Max=50,Step=5,Default=0,Callback=report})
    local choices=Section.new(columns.Right,deps,{Title="Choices & filters",Collapsible=true,
        Tooltip="Dropdown options scroll inside their popup. Rare, Epic and Legendary can be selected together."})
    local options={};for i=1,30 do options[i]="Option "..i end
    local apiSelect=Select.new(choices.Body,deps,{Title="Scrollable options",Options=options,Default=options[1],Callback=report})
    Select.new(choices.Body,deps,{Title="Multiple choices",Multi=true,Options={"Rare","Epic","Legendary","Mythic"},Default={"Epic","Legendary"}})
    local expanded=true
    button(choices.Body,"Refresh options (preserve selection)",function()
        expanded=not expanded
        local updated={};for i=1,(expanded and 30 or 10) do updated[i]="Option "..i end
        apiSelect:Refresh(updated,true)
        report("Options: "..#updated.." · selected: "..tostring(apiSelect:Get()))
    end)
    local selected={}
    for _,name in ipairs({"Rare","Epic","Legendary"}) do
        Toggle.new(choices.Body,deps,{Title=name,Default=false,Callback=function(v)
            selected[name]=v
            local names={};for _,n in ipairs({"Rare","Epic","Legendary"}) do if selected[n] then table.insert(names,n) end end
            report("Selected: "..(#names>0 and table.concat(names,", ") or "none"))
        end})
    end
    local inputs=Section.new(columns.Right,deps,{Title="Text input"})
    local input=Instance.new("TextBox")
    input.Size=UDim2.new(1,0,0,34);input.Text="";input.PlaceholderText="Type here, then press Enter"
    input.ClearTextOnFocus=false;input.TextSize=12;input.Font=Enum.Font.GothamMedium
    input.TextColor3=Tokens.Color.Text;input.PlaceholderColor3=Tokens.Color.TextMuted
    input.Parent=inputs.Body;Material.Inset(input,Tokens)
    input.FocusLost:Connect(function(enter) if enter then report("Submitted: "..input.Text:sub(1,100)) end end)
    local list=Section.new(columns.Right,deps,{Title="Searchable scrolling list"})
    local search=input:Clone();search.PlaceholderText="Filter items";search.Parent=list.Body
    local scroller=Instance.new("ScrollingFrame")
    scroller.Size=UDim2.new(1,0,0,140);scroller.BackgroundTransparency=1;scroller.BorderSizePixel=0
    scroller.CanvasSize=UDim2.new();scroller.AutomaticCanvasSize=Enum.AutomaticSize.Y
    scroller.ScrollBarThickness=3;scroller.Parent=list.Body
    local layout=Instance.new("UIListLayout");layout.Padding=UDim.new(0,3);layout.Parent=scroller
    local rows={}
    for i=1,25 do
        local name=string.format("Test item %02d",i)
        rows[i]=button(scroller,name,function() report("Picked "..name) end)
    end
    search:GetPropertyChangedSignal("Text"):Connect(function()
        for _,row in ipairs(rows) do row.Visible=string.find(string.lower(row.Text),string.lower(search.Text),1,true)~=nil end
        scroller.CanvasPosition=Vector2.new()
    end)
    local confirm=Section.new(columns.Left,deps,{Title="Safe actions",
        Description="Review an action before continuing.",Accent=Tokens.Color.Lavender,
        Tooltip="Cancel, tap outside the card, or press Escape to dismiss. Confirm runs the callback once."})
    button(confirm.Body,"Preview confirmation",function()
        report("Awaiting confirmation")
        app:Confirm({Title="Reset the click counter?",
            Message="This clears only your playground counter. Your game and saved appearance stay unchanged.",
            ConfirmText="Reset counter",Callback=function(confirmed)
                if confirmed then count=0;report("Counter reset to 0");app:Notify("Counter reset","Your playground counter is ready.",4,"Success")
                else report("Cancelled — counter kept at "..count) end
            end})
    end)
    local notifications=Section.new(columns.Left,deps,{Title="Notifications & status"})
    text(notifications.Body,"The first minimize starts a simulated clicker: clicks, elapsed seconds and rewards. No game actions are sent.",48)
    button(notifications.Body,"Show success notification",function() app:Notify("Saved","Your test notification is outside the main window.",5,"Success") end)
    button(notifications.Body,"Test queue (5 messages)",function() for i=1,5 do app:Notify("Queued message "..i,"At most three cards display at once.",4,"Info") end end)
    local demoThread
    local demoStarted=false
    local function stopStatusDemo()
        if demoThread then pcall(task.cancel,demoThread);demoThread=nil end
    end
    runtime:TrackCleanup(stopStatusDemo)
    function app:StartStatusDemo()
        stopStatusDemo();demoStarted=true
        app:SetStatus("Auto clicker · DEMO",1)
        app:SetStatusMetrics(0,0,0)
        app:SetStatusDetails({"Preview clicker · 20 clicks per second","Reward at 5s · finishes at 12s"})
        if not app:IsMinimized() then app:SetVisible(false) end
        demoThread=task.spawn(function()
            local started=os.clock()
            local reward=false
            while not runtime.Destroyed do
                local elapsed=math.min(12,os.clock()-started)
                local clicks=math.floor(elapsed*20)
                app:SetStatusMetrics(clicks,math.floor(elapsed),reward and 1 or 0)
                if elapsed>=5 and not reward then
                    reward=true
                    app:SetStatusMetrics(clicks,math.floor(elapsed),1)
                    app:StatusNotice("Bonus found!","+1 test reward · clicker continues",2.5)
                end
                if elapsed>=12 then break end
                task.wait(0.25)
            end
            if runtime.Destroyed then return end
            app:SetStatus("Test complete",3)
            app:SetStatusDetails({"240 simulated clicks · 1 test reward","Demo finished · all rewards collected"})
            app:StatusNotice("Test complete","240 simulated clicks · 1 test reward",3)
            demoThread=nil
        end)
    end
    app.OnMinimized=function() if not demoStarted then app:StartStatusDemo() end end
    button(notifications.Body,"Run auto-clicker demo · 12 seconds",function() app:StartStatusDemo() end)
    button(notifications.Body,"Stop activity demo",function() stopStatusDemo();app:SetStatus("Demo paused") end)


end

-- Media components use actual game/player content, without continuous rendering callbacks.
do
    local media=app:AddPage({Id="Media",Title="Image & Viewport",Icon="inventory",Group="System",Order=10})
    local imageSection=Section.new(media,deps,{Title="Image",Description="Current experience artwork with a readable fallback."})
    local image=Instance.new("ImageLabel");image.Size=UDim2.new(1,0,0,150)
    image.BackgroundColor3=Tokens.Color.PanelSoft;image.ScaleType=Enum.ScaleType.Crop
    image.Image="rbxthumb://type=GameIcon&id="..game.GameId.."&w=512&h=512";image.Parent=imageSection.Body
    local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,8);c.Parent=image
    local fallback=Typography.Label(image,"Control",Tokens,"Experience artwork",UDim2.new(),UDim2.fromScale(1,1),Tokens.Color.TextMuted)
    fallback.TextXAlignment=Enum.TextXAlignment.Center
    runtime:TrackConnection(image:GetPropertyChangedSignal("IsLoaded"):Connect(function() fallback.Visible=not image.IsLoaded end))
    fallback.Visible=not image.IsLoaded
    local section=Section.new(media,deps,{Title="Viewport",Description="Your avatar · drag to rotate"})
    local viewport=Instance.new("ViewportFrame");viewport.Size=UDim2.new(1,0,0,245)
    viewport.BackgroundColor3=Tokens.Color.PanelSoft;viewport.BorderSizePixel=0;viewport.Active=true
    viewport.Ambient=Color3.fromRGB(190,190,200);viewport.LightColor=Color3.fromRGB(255,255,255)
    viewport.Parent=section.Body
    local world=Instance.new("WorldModel");world.Parent=viewport
    local camera=Instance.new("Camera");camera.Parent=viewport;viewport.CurrentCamera=camera
    local model,basePivot,yaw
    local player=game:GetService("Players").LocalPlayer
    local function refreshAvatar(character)
        if model then model:Destroy();model=nil end
        if not character or runtime.Destroyed then return end
        local archivable=character.Archivable;character.Archivable=true
        local ok,clone=pcall(function() return character:Clone() end)
        character.Archivable=archivable
        if not ok or not clone then return end
        for _,object in ipairs(clone:GetDescendants()) do
            if object:IsA("BaseScript") then object:Destroy()
            elseif object:IsA("BasePart") then object.Anchored=true end
        end
        model=clone;clone.Parent=world;basePivot=clone:GetPivot();yaw=0
        local bounds,size=clone:GetBoundingBox()
        local distance=math.max(size.X,size.Y,size.Z)*1.35
        camera.CFrame=CFrame.lookAt(bounds.Position+Vector3.new(0,size.Y*0.08,distance),bounds.Position)
    end
    refreshAvatar(player.Character)
    runtime:TrackConnection(player.CharacterAdded:Connect(function(character)
        task.defer(function() if not runtime.Destroyed then refreshAvatar(character) end end)
    end))
    local dragging,lastX,inputOwner
    runtime:TrackConnection(viewport.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true;lastX=input.Position.X;inputOwner=input;media.ScrollingEnabled=false
        end
    end))
    runtime:TrackConnection(UserInputService.InputChanged:Connect(function(input)
        if not dragging or not model then return end
        if inputOwner.UserInputType==Enum.UserInputType.Touch and input~=inputOwner then return end
        if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseMovement then return end
        yaw=yaw+(input.Position.X-lastX)*0.012;lastX=input.Position.X
        model:PivotTo(basePivot*CFrame.Angles(0,yaw,0))
    end))
    local function release() dragging=false;inputOwner=nil;media.ScrollingEnabled=true end
    runtime:TrackConnection(UserInputService.InputEnded:Connect(function(input)
        if input==inputOwner then release() end
    end))
    runtime:TrackConnection(UserInputService.WindowFocusReleased:Connect(release))
    runtime:TrackConnection(media:GetPropertyChangedSignal("Visible"):Connect(function() if not media.Visible then release() end end))
    runtime:TrackConnection(app.Holder:GetPropertyChangedSignal("Visible"):Connect(function() if not app.Holder.Visible then release() end end))
    runtime:TrackCleanup(release)
end

-- Brief branded reveal; the temporary compositing group is removed afterwards.
do
    local group=Instance.new("CanvasGroup");group.Name="SerenityOpening"
    group.BackgroundTransparency=1;group.Size=UDim2.fromScale(1,1);group.GroupTransparency=1
    group.ZIndex=2;group.Parent=app.Holder;app.Shell.Parent=group
    local intro=Instance.new("TextLabel");intro.AnchorPoint=Vector2.new(0.5,0.5)
    intro.Position=UDim2.fromScale(0.5,0.5);intro.Size=UDim2.fromOffset(230,65)
    intro.Text="SERENITY HUB";intro.Font=Enum.Font.GothamBold;intro.TextSize=18
    intro.TextColor3=Tokens.Color.Text;intro.BackgroundColor3=Tokens.Color.Panel;intro.ZIndex=90
    intro.Parent=app.Holder
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,12);corner.Parent=intro
    local finished=false
    local function finish()
        if finished then return end;finished=true
        if app.Shell.Parent==group then app.Shell.Parent=app.Holder end
        group:Destroy();intro:Destroy()
    end
    local tween,timer
    timer=task.delay(0.25,function()
        if runtime.Destroyed then return end
        intro:Destroy()
        tween=Motion:Tween(group,0.3,{GroupTransparency=0})
        runtime:TrackConnection(tween.Completed:Connect(finish))
        if Motion.Reduced then finish() end
    end)
    runtime:TrackCleanup(function() if timer then pcall(task.cancel,timer) end;if tween then tween:Cancel() end;finish() end)
end

app:SelectPage("Dashboard")
if savedAppearance and savedAppearance.MotionVersion~=1 then savedAppearance.DragStyle="Outline" end
restoreAppearance(savedAppearance)
if savedAppearance then app:RestoreViewState(savedAppearance.View) end
app.OnViewChanged=saveAppearance
-- One pair of input handlers per button; no heartbeat or idle work for ordinary icons.
do
    local groups={}
    for _,icon in ipairs(app.ScreenGui:GetDescendants()) do
        if icon:IsA("ImageLabel") and icon.Name:sub(1,5)=="Icon_" then
            local target=icon.Parent
            while target and target~=app.ScreenGui and not target:IsA("GuiButton") do target=target.Parent end
            if target and target:IsA("GuiButton") then
                groups[target]=groups[target] or {};table.insert(groups[target],icon)
            end
        end
    end
    local pending={}
    for target,icons in pairs(groups) do
        local function feedback(active)
            for _,icon in ipairs(icons) do
                if pending[icon] then pending[icon]:Cancel() end
                pending[icon]=Motion:Tween(icon,0.12,{Rotation=(active and not Motion.Reduced) and 3 or 0})
            end
        end
        runtime:TrackConnection(target.MouseEnter:Connect(function() if serenityInputBlocked(target) then return end; feedback(true) end))
        runtime:TrackConnection(target.MouseLeave:Connect(function() feedback(false) end))
        runtime:TrackConnection(target.SelectionGained:Connect(function() if serenityInputBlocked(target) then return end; feedback(true) end))
        runtime:TrackConnection(target.SelectionLost:Connect(function() feedback(false) end))
        runtime:TrackConnection(target.Activated:Connect(function() if serenityInputBlocked(target) then return end; feedback(false) end))
    end
    runtime:TrackCleanup(function() for _,tween in pairs(pending) do tween:Cancel() end end)
end

print("SERENITY M4.71 STATUS + NOTIFICATION TEST | Playground: status & confirmation | RightCtrl: toggle | Ctrl+K: search")

return app








