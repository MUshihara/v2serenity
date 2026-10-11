-- Serenity v2 key-window test. Production scripts are not loaded.
local url = "https://raw.githubusercontent.com/MUshihara/v2serenity/2a4594cc0eb608533cfde4102068129d87969e57/dist/bootstrap.lua"
local source = game:HttpGet(url .. "?v=" .. tostring(os.time()))
local run, compileError = loadstring(source, "Serenity v2 key-window test")
assert(run, compileError)
return run()
