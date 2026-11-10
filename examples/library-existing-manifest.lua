-- Serenity V2 2.0.2: bridge for the common V3 manifest shape.
-- Keep existing CFG, remotes, controllers and callbacks; replace only UI construction.
local Library=loadstring(game:HttpGet("https://raw.githubusercontent.com/MUshihara/v2serenity/ba1653704c0c7784491fd04591b23d0b2c086ad6/dist/ui/serenity-v2.lua"))()
-- Important game releases must supply dated WhatsNew entries; see the integration guide.
local CFG={AutoFarm=false,Target="Nearest"}
local manifest={SerenityAPIVersion=3,Pages={{
    Id="Automation",Title="Automation",Icon="automation",Order=1,Features={{
        Id="Farm",Title="Farming",Controls={
            {Id="Enabled",Type="Switch",Title="Auto farm",Default=CFG.AutoFarm,Changed=function(v)CFG.AutoFarm=v end},
            {Id="Target",Type="Select",Title="Target priority",Options={"Nearest","Highest Value"},Default=CFG.Target,Changed=function(v)CFG.Target=v end},
            {Id="State",Type="Live",Title="State",Default="Idle"},
        },
    }},
}}}
local ui=Library.Build(manifest,{Key="Serenity_MyGame_Manifest_Test",KeyStatus={State="Keyless"},Subtitle="My Game"})
ui:SetLive("Automation.Farm.State","Ready")
-- Silent UI sync does not invoke Changed:
ui.Controls["Automation.Farm.Enabled"]:Set(CFG.AutoFarm,true)
ui:OnCleanup(function()CFG.AutoFarm=false end)
ui:SelectPage("Automation")
return ui

