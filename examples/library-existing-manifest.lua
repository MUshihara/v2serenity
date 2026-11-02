-- Serenity Official Test 1.0.0-test.3: bridge for the common V3 manifest shape.
-- Keep existing CFG, remotes, controllers and callbacks; replace only UI construction.
local Library=loadstring(game:HttpGet("https://raw.githubusercontent.com/MUshihara/v2serenity/386c2fb2c9906da323bf88749d459bed3c9ebad5/dist/ui/serenity-test.lua"))()
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
local ui=Library.Build(manifest,{Key="Serenity_MyGame_Manifest_Test",Subtitle="My Game"})
ui:SetLive("Automation.Farm.State","Ready")
-- Silent UI sync does not invoke Changed:
ui.Controls["Automation.Farm.Enabled"]:Set(CFG.AutoFarm,true)
ui:OnCleanup(function()CFG.AutoFarm=false end)
ui:SelectPage("Automation")
return ui

