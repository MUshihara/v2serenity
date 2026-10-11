-- Serenity v2 key-window test. Production scripts are not loaded.
local url = "https://raw.githubusercontent.com/MUshihara/v2serenity/2b539a7b9c15a17f3a8ed3958521d76f05c6b72e/dist/bootstrap.lua"
local source = game:HttpGet(url .. "?v=" .. tostring(os.time()))
local run, compileError = loadstring(source, "Serenity v2 key-window test")
assert(run, compileError)
return run()
