-- Serenity v2 key-window test. Production scripts are not loaded.
local url = "https://raw.githubusercontent.com/MUshihara/v2serenity/79e22c0d17fca82550dfa57c69865aae16581fdf/dist/bootstrap.lua"
local source = game:HttpGet(url .. "?v=" .. tostring(os.time()))
local run, compileError = loadstring(source, "Serenity v2 key-window test")
assert(run, compileError)
return run()
