-- Serenity v2 key-window test. Production scripts are not loaded.
local url = "https://raw.githubusercontent.com/MUshihara/v2serenity/main/dist/bootstrap.lua"
local source = game:HttpGet(url)
local run, compileError = loadstring(source, "Serenity v2 key-window test")
assert(run, compileError)
return run()
