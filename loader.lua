-- Serenity v2 key-window test. Production scripts are not loaded.
local url = "https://raw.githubusercontent.com/MUshihara/v2serenity/70f3967a8baa9fc1a7906863749558c5de3ca8cc/dist/bootstrap.lua"
local source = game:HttpGet(url .. "?v=" .. tostring(os.time()))
local run, compileError = loadstring(source, "Serenity v2 key-window test")
assert(run, compileError)
return run()
