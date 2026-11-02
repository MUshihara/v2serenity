-- Serenity Official Test 1.0.0-test.4: UI integration example; no gameplay actions.
local Library=loadstring(game:HttpGet("https://raw.githubusercontent.com/MUshihara/v2serenity/c5dc896b067b1eaac139d763f696ea8c1d2624ef/dist/ui/serenity-test.lua"))()
-- Important game releases must supply dated WhatsNew entries; see the integration guide.
local CFG={Enabled=false,Delay=1,Target="Nearest",Rarities={}}
local ui=Library.Create({Key="Serenity_MyGame_Test",Subtitle="My Game",AppearancePath="Serenity_MyGame_Test_Appearance.json"})
local page=ui:AddPage({Id="Automation",Title="Automation",Icon="automation",Order=1})
local section=ui:AddSection(page,{Id="Main",Title="Main"})
local toggle=ui:AddToggle(section,{Id="Enabled",Title="Enabled",Default=CFG.Enabled,Callback=function(v)CFG.Enabled=v end})
ui:AddSlider(section,{Id="Delay",Title="Action delay",Min=0.1,Max=5,Step=0.1,Default=CFG.Delay,Callback=function(v)CFG.Delay=v end})
ui:AddSelect(section,{Id="Target",Title="Target priority",Options={"Nearest","Highest Value"},Default=CFG.Target,Callback=function(v)CFG.Target=v end})
ui:AddMultiSelect(section,{Id="Rarities",Title="Rarities",Options={"Common","Rare","Legendary"},Default=CFG.Rarities,Callback=function(v)CFG.Rarities=v end})
local state=ui:AddLive(section,{Title="State",Default="Idle"})
ui:AddButton(section,{Title="Show current state",Callback=function()state:Set(CFG.Enabled and "Enabled" or "Idle")end})
ui:AddParagraph(section,{Title="Integration example",Text="Connect these callbacks to your existing game controller."})
ui:SetStatus("Idle");ui:SetStatusProgress(nil)
ui:OnCleanup(function()CFG.Enabled=false end)
ui:SelectPage("Automation")
return ui

